package org.study.cafe.order.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.study.cafe.membership.service.MembershipService;
import org.study.cafe.membership.vo.MembershipVO;
import org.study.cafe.menu.mapper.MenuMapper;
import org.study.cafe.menu.vo.MenuVO;
import org.study.cafe.order.mapper.OrderMapper;
import org.study.cafe.order.vo.CancelResult;
import org.study.cafe.order.vo.OrderItemVO;
import org.study.cafe.order.vo.OrderRequestDTO;
import org.study.cafe.order.vo.OrderVO;
import org.study.cafe.order.vo.RefundInfo;
import org.study.cafe.point.service.PointService;
import org.study.cafe.visit.service.VisitService;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class OrderServiceImpl implements OrderService {

    private static final Logger log = LoggerFactory.getLogger(OrderServiceImpl.class);
    private static final String TOSS_CONFIRM_URL =
            "https://api.tosspayments.com/v1/payments/confirm";

    // ════════════════════════════════════════════════════════════════
    // 환불 정책 윈도우 (운영값 적용)
    // ────────────────────────────────────────────────────────────────
    //     FULL_REFUND_WINDOW_SEC:  180   (3분  — 전액 환불)
    //     HALF_REFUND_WINDOW_SEC:  600   (10분 — 50% 부분 환불)
    // ════════════════════════════════════════════════════════════════
    private static final int FULL_REFUND_WINDOW_SEC = 180;   // 운영값
    private static final int HALF_REFUND_WINDOW_SEC = 600;   // 운영값

    private static final Set<String> VALID_CANCEL_REASONS =
            Set.of("CHANGE_MIND", "WRONG_ORDER", "TOO_SLOW", "ETC");

    @Value("${toss.secret-key:test_sk_docs_OaPz8L5KdmQXkzRz3y47BMw6}")
    private String tossSecretKey;

    @Autowired private OrderMapper orderMapper;
    @Autowired private MenuMapper  menuMapper;
    @Autowired private RestTemplate restTemplate;
    @Autowired private PointService pointService;
    @Autowired private MembershipService membershipService;
    @Autowired private VisitService visitService;

    @Override
    public Map<String, Object> createOrder(String mId, OrderRequestDTO dto) {
        int total = 0;

        // order_t INSERT
        String orderId = UUID.randomUUID().toString();
        OrderVO order = new OrderVO();
        order.setOrderId(orderId);
        order.setMId(mId);
        order.setStatus("READY");

        // order_item_t INSERT — 서버에서 가격 재검증
        List<OrderItemVO> itemVOs = new ArrayList<>();
        for (OrderRequestDTO.OrderItemDTO item : dto.getItems()) {
            // DB 에서 실제 가격 조회 (클라이언트 조작 방지)
            MenuVO menuInfo = menuMapper.findByName(item.getMenuName());
            int basePrice    = (menuInfo != null) ? menuInfo.getPrice()              : item.getUnitPrice();
            int iceExtra     = (menuInfo != null) ? menuInfo.getIcePrice()           : 0;
            int grandeExtra  = (menuInfo != null) ? menuInfo.getSizeUpchargeGrande() : 0;
            int ventiExtra   = (menuInfo != null) ? menuInfo.getSizeUpchargeVenti()  : 0;

            String size = (item.getSize() != null && !item.getSize().isBlank())
                          ? item.getSize().toUpperCase() : "NONE";
            int sizeExtra = "GRANDE".equals(size) ? grandeExtra
                          : "VENTI".equals(size)  ? ventiExtra
                          : 0;
            int serverPrice = basePrice
                            + ("ICE".equals(item.getTemperature()) ? iceExtra : 0)
                            + sizeExtra;

            if (menuInfo != null && serverPrice != item.getUnitPrice()) {
                log.warn("가격 불일치 감지 menu={} temp={} size={} client={} server={}",
                         item.getMenuName(), item.getTemperature(), size,
                         item.getUnitPrice(), serverPrice);
            }

            int subtotal = serverPrice * item.getQuantity();
            total += subtotal;

            OrderItemVO oi = new OrderItemVO();
            oi.setOrderId(orderId);
            oi.setMenuName(item.getMenuName());
            oi.setTemperature(item.getTemperature() != null ? item.getTemperature() : "NONE");
            oi.setSize(size);
            oi.setQuantity(item.getQuantity());
            oi.setUnitPrice(serverPrice);   // 서버 계산값으로 저장
            oi.setSubtotal(subtotal);
            itemVOs.add(oi);
        }

        // ── 포인트 사용 검증 (READY 시점 — 차감은 결제 성공 시) ─────
        int useP = Math.max(0, dto.getPointsToUse());
        if (useP > 0 && useP < 1000) {
            throw new IllegalArgumentException("포인트는 1,000P 이상부터 사용 가능합니다.");
        }
        if (useP > 0 && useP % 100 != 0) {
            throw new IllegalArgumentException("포인트는 100P 단위로 사용해야 합니다.");
        }
        if (useP > total) {
            throw new IllegalArgumentException("사용 포인트가 결제 금액을 초과할 수 없습니다.");
        }
        if (useP > 0 && useP > pointService.getBalance(mId)) {
            throw new IllegalArgumentException("포인트 잔액이 부족합니다.");
        }

        int payAmount = total - useP;   // 토스에 청구할 실 결제액
        order.setTotalAmount(payAmount);
        order.setPointsUsed(useP);      // insertOrder 시 컬럼에 함께 기록

        orderMapper.insertOrder(order);
        for (OrderItemVO oi : itemVOs) {
            orderMapper.insertOrderItem(oi);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("amount", payAmount);
        return result;
    }

    @Override
    public OrderVO confirmPayment(String orderId, String paymentKey, int amount) {
        OrderVO order = orderMapper.findByOrderId(orderId);
        if (order == null) {
            throw new IllegalArgumentException("주문을 찾을 수 없습니다: " + orderId);
        }

        // 금액 위변조 검증
        if (order.getTotalAmount() != amount) {
            log.warn("금액 불일치 orderId={} db={} req={}", orderId, order.getTotalAmount(), amount);
            orderMapper.updateOrderFailed(orderId);
            throw new IllegalStateException("결제 금액이 일치하지 않습니다.");
        }

        // TossPayments 승인 API 호출
        try {
            HttpHeaders headers = new HttpHeaders();
            String encoded = Base64.getEncoder()
                    .encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));
            headers.set("Authorization", "Basic " + encoded);
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, Object> body = new HashMap<>();
            body.put("paymentKey", paymentKey);
            body.put("orderId", orderId);
            body.put("amount", amount);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<Map<String, Object>> response = restTemplate.postForEntity(
                    TOSS_CONFIRM_URL, entity, (Class<Map<String, Object>>) (Class<?>) Map.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                orderMapper.updateOrderPaid(orderId, paymentKey);
                order.setStatus("PAID");
                order.setPaymentKey(paymentKey);

                // ── 포인트 처리: 사용 차감 → 적립 ──────────────────
                // 결제 자체는 PAID 확정이므로 포인트 처리 실패는 ERROR 로그만 남기고
                // 사용자에게는 결제 성공 화면을 보여준다.
                try {
                    OrderVO refreshed = orderMapper.findByOrderId(orderId);
                    String mId = refreshed.getMId();
                    int useP   = refreshed.getPointsUsed();
                    if (useP > 0) {
                        pointService.use(mId, orderId, useP);
                    }
                    int paymentBase = refreshed.getTotalAmount();   // 사용 포인트 차감된 실 결제액
                    String grade = "일반";
                    try {
                        MembershipVO ms = membershipService.getByUserId(mId);
                        if (ms != null && ms.getGrade() != null && !ms.getGrade().isBlank()) {
                            grade = ms.getGrade();
                        }
                    } catch (Exception ignore) { /* 등급 조회 실패 시 일반 폴백 */ }
                    pointService.earn(mId, orderId, paymentBase, grade);
                } catch (Exception pointEx) {
                    log.error("결제 성공 후 포인트 처리 실패 orderId={} (결제는 PAID 유지)",
                              orderId, pointEx);
                }

                // ── 방문 기록: 결제 1건 = 1회 (잔 수 무관) ─────────
                // 실패해도 결제는 PAID 유지 (try-catch 격리, ERROR 로그만)
                try {
                    visitService.recordVisit(order.getMId(), orderId);
                } catch (Exception e) {
                    log.error("방문 기록 실패 (결제는 성공) orderId={}", orderId, e);
                }
            } else {
                orderMapper.updateOrderFailed(orderId);
                order.setStatus("FAILED");
            }
        } catch (HttpClientErrorException e) {
            log.error("토스 승인 실패 orderId={} status={} body={}",
                    orderId, e.getStatusCode(), e.getResponseBodyAsString());
            orderMapper.updateOrderFailed(orderId);
            throw new RuntimeException("결제 승인에 실패했습니다: " + e.getMessage());
        } catch (Exception e) {
            log.error("토스 승인 예외 orderId={}", orderId, e);
            orderMapper.updateOrderFailed(orderId);
            throw new RuntimeException("결제 처리 중 오류가 발생했습니다.");
        }

        return order;
    }

    @Override
    public List<OrderVO> getMyOrders(String mId) {
        return orderMapper.findByMemberId(mId);
    }

    @Override
    public List<OrderVO> getMyOrdersSummary(String mId, int limit) {
        return orderMapper.findRecentByMemberId(mId, limit);
    }

    @Override
    public OrderVO getOrderById(String orderId) {
        return orderMapper.findByOrderId(orderId);
    }

    @Override
    public List<OrderItemVO> getOrderItems(String orderId) {
        return orderMapper.findItemsByOrderId(orderId);
    }

    // ════════════════════════════════════════════════════════════════
    // 주문 취소 — 시간 기반 3단계 환불 정책
    // ════════════════════════════════════════════════════════════════
    @Override
    public CancelResult cancelOrder(String orderId, String mId, String reason, String memo) {
        // 1) 취소 사유 화이트리스트 검증
        if (reason == null || !VALID_CANCEL_REASONS.contains(reason)) {
            return new CancelResult(false, 0, 0, "유효하지 않은 취소 사유입니다.");
        }

        // 2) 주문 조회 + 본인 주문 검증
        OrderVO order = orderMapper.findByOrderId(orderId);
        if (order == null) {
            return new CancelResult(false, 0, 0, "주문을 찾을 수 없습니다.");
        }
        if (!mId.equals(order.getMId())) {
            log.warn("타인 주문 취소 시도 차단 orderId={} requester={} owner={}",
                     orderId, mId, order.getMId());
            return new CancelResult(false, 0, 0, "본인 주문만 취소할 수 있습니다.");
        }

        // 3) 결제 완료 상태만 취소 가능
        if (!"PAID".equals(order.getStatus())) {
            return new CancelResult(false, 0, 0,
                    "취소 불가: 현재 상태(" + order.getStatus() + ")에서는 취소할 수 없습니다.");
        }
        if (order.getPaymentKey() == null || order.getPaymentKey().isBlank()) {
            return new CancelResult(false, 0, 0, "결제키가 없어 취소할 수 없습니다.");
        }
        if (order.getPaidDate() == null) {
            return new CancelResult(false, 0, 0, "결제 완료 일시를 확인할 수 없습니다.");
        }

        // 4) 경과 시간 기반 환불 비율 결정 — 단일 진원 calculateRefund() 호출
        RefundInfo refund = calculateRefund(order);
        if (!refund.isCancelable()) {
            return new CancelResult(false, 0, 0, "취소 가능 시간이 지났습니다.");
        }
        int refundRate   = refund.getRate();
        int refundAmount = refund.getAmount();

        // 5) 토스 cancel API 호출
        String tossReason = buildTossReason(reason, memo);
        try {
            cancelPayment(order.getPaymentKey(), tossReason,
                          refundRate == 100 ? null : refundAmount);
        } catch (HttpClientErrorException e) {
            log.error("토스 취소 실패 orderId={} status={} body={}",
                      orderId, e.getStatusCode(), e.getResponseBodyAsString());
            return new CancelResult(false, 0, 0,
                    "결제 취소 요청 실패: " + e.getStatusCode());
        } catch (Exception e) {
            log.error("토스 취소 예외 orderId={}", orderId, e);
            return new CancelResult(false, 0, 0, "결제 취소 처리 중 오류가 발생했습니다.");
        }

        // 6) 토스 200 OK 면 DB 업데이트 (동시성 안전: WHERE status='PAID')
        int updated = orderMapper.cancelOrder(orderId, mId, reason, memo,
                                              refundAmount, refundRate);
        if (updated != 1) {
            log.warn("토스는 취소 성공했으나 DB 업데이트 실패 orderId={} updated={}",
                     orderId, updated);
            return new CancelResult(false, 0, 0,
                    "취소 처리 중 DB 업데이트에 실패했습니다. 고객센터로 문의해주세요.");
        }

        // ── 포인트 처리: 사용 복원 → 적립 회수 ────────────────────────
        // 취소 자체는 이미 토스+DB 양쪽 다 성공이므로 포인트 처리 실패는
        // ERROR 로그만 남기고 사용자에게는 취소 성공으로 보고.
        try {
            pointService.restoreUse(mId, orderId, refundRate);
            pointService.cancelEarn(mId, orderId, refundRate);
        } catch (Exception pointEx) {
            log.error("주문 취소 후 포인트 처리 실패 orderId={} (취소는 정상 처리됨)",
                      orderId, pointEx);
        }

        // ── 방문 취소 처리: 환불율 무관 무조건 cancelled=1 ────────────
        try {
            visitService.cancelVisit(orderId);
        } catch (Exception e) {
            log.error("방문 취소 처리 실패 (결제 취소는 성공) orderId={}", orderId, e);
        }

        return new CancelResult(true, refundAmount, refundRate,
                "취소가 완료되었습니다. 영업일 기준 2~5일 내 카드사로 환불됩니다.");
    }

    /** 토스페이먼츠 취소 API 호출 — 전액 취소는 cancelAmount=null, 부분취소는 금액 지정 */
    private Map<String, Object> cancelPayment(String paymentKey, String reason, Integer cancelAmount) {
        String url = "https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel";

        HttpHeaders headers = new HttpHeaders();
        String encoded = Base64.getEncoder()
                .encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));
        headers.set("Authorization", "Basic " + encoded);
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> body = new HashMap<>();
        body.put("cancelReason", reason);
        if (cancelAmount != null) body.put("cancelAmount", cancelAmount);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
        ResponseEntity<Map<String, Object>> response = restTemplate.postForEntity(
                url, entity, (Class<Map<String, Object>>) (Class<?>) Map.class);

        log.debug("토스 취소 성공 paymentKey={}... amount={} status={}",
                  paymentKey.substring(0, Math.min(12, paymentKey.length())),
                  cancelAmount, response.getStatusCode());
        return response.getBody();
    }

    /** 주문 상세 모달용 환불 미리보기 — calculateRefund() 결과를 Map 으로 어댑팅 */
    @Override
    public Map<String, Object> getRefundPreview(OrderVO order) {
        RefundInfo info = calculateRefund(order);
        // 경로 식별 로그 — /order/detail 과 /order/cancel 응답을 비교 디버깅할 때
        // grep 으로 "Cancel check [detail]" 찾으면 모달 렌더용 호출만 필터 가능
        log.debug("Cancel check [detail] - orderId={} elapsedSec={} cancelable={} rate={} amount={} reason={}",
                  order == null ? null : order.getOrderId(),
                  info.getElapsedSec(), info.isCancelable(),
                  info.getRate(), info.getAmount(), info.getReason());
        Map<String, Object> preview = new HashMap<>();
        preview.put("cancelable",          info.isCancelable());
        preview.put("currentRefundRate",   info.getRate());
        preview.put("currentRefundAmount", info.getAmount());
        return preview;
    }

    /**
     * 환불 계산 단일 진원지.
     * · paidDate 기준 경과 초 → 3단계 분기 (FULL_REFUND_WINDOW_SEC / HALF_REFUND_WINDOW_SEC)
     * · 시계 오차로 음수 경과 발생 시 안전하게 100% (NTP 재동기화 직후 밀리초 역전 대응)
     * · order 가 null / PAID 아님 / paidDate 없음 → 모두 cancelable=false 로 표준화
     * · 시간 기반 디버깅을 위해 항상 debug 레벨로 계산 내역 로깅
     */
    @Override
    public RefundInfo calculateRefund(OrderVO order) {
        if (order == null
            || !"PAID".equals(order.getStatus())
            || order.getPaidDate() == null) {
            log.debug("Cancel check - INVALID_STATE order={} status={} paidAt={}",
                      order == null ? null : order.getOrderId(),
                      order == null ? null : order.getStatus(),
                      order == null ? null : order.getPaidDate());
            return new RefundInfo(false, 0, 0, 0L, "INVALID_STATE");
        }

        LocalDateTime now    = LocalDateTime.now();
        LocalDateTime paidAt = order.getPaidDate();
        long elapsedSec      = Duration.between(paidAt, now).getSeconds();

        log.debug("Cancel check - orderId={} paidAt={} now={} elapsedSec={} FULL<={} HALF<={}",
                  order.getOrderId(), paidAt, now, elapsedSec,
                  FULL_REFUND_WINDOW_SEC, HALF_REFUND_WINDOW_SEC);

        // 시계 오차 방어: 음수 경과 = 미래 결제 시각 → 안전하게 100%
        if (elapsedSec < 0) {
            log.warn("Cancel check - NEGATIVE_CLOCK_SKEW orderId={} elapsedSec={} (100% 로 안전 처리)",
                     order.getOrderId(), elapsedSec);
            return new RefundInfo(true, 100, order.getTotalAmount(), elapsedSec, "NEGATIVE_CLOCK_SKEW");
        }
        if (elapsedSec <= FULL_REFUND_WINDOW_SEC) {
            return new RefundInfo(true, 100, order.getTotalAmount(), elapsedSec, "FULL");
        }
        if (elapsedSec <= HALF_REFUND_WINDOW_SEC) {
            return new RefundInfo(true, 50, order.getTotalAmount() / 2, elapsedSec, "HALF");
        }
        return new RefundInfo(false, 0, 0, elapsedSec, "TOO_LATE");
    }

    /** 취소 사유 코드 + 사용자 비고 → 토스에 전달할 한국어 사유 문자열 */
    private String buildTossReason(String reason, String memo) {
        String label = switch (reason) {
            case "CHANGE_MIND" -> "단순 변심";
            case "WRONG_ORDER" -> "주문 실수";
            case "TOO_SLOW"    -> "조리 지연";
            case "ETC"         -> "기타";
            default            -> "사용자 요청";
        };
        return (memo != null && !memo.isBlank())
               ? "사용자 요청 - " + label + " (" + memo + ")"
               : "사용자 요청 - " + label;
    }
}
