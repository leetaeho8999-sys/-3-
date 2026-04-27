package org.study.cafe.order.controller;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.cart.service.CartService;
import org.study.cafe.order.service.OrderService;
import org.study.cafe.order.vo.CancelResult;
import org.study.cafe.order.vo.OrderItemVO;
import org.study.cafe.order.vo.OrderRequestDTO;
import org.study.cafe.order.vo.OrderVO;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/order")
public class OrderController {

    private static final Logger log = LoggerFactory.getLogger(OrderController.class);

    @Value("${toss.client-key:test_ck_docs_Ovk5rk1EwkEbP0W43n07xlzm}")
    private String tossClientKey;

    @Autowired private OrderService orderService;
    @Autowired private CartService cartService;

    @jakarta.annotation.PostConstruct
    void logClientKey() {
        if (tossClientKey == null || tossClientKey.isBlank()) {
            log.warn("toss.client-key 가 비어 있습니다. TossPayments 결제가 동작하지 않을 수 있습니다.");
        } else {
            log.debug("toss.client-key 로드 완료: {}...", tossClientKey.substring(0, Math.min(12, tossClientKey.length())));
        }
    }

    /** 주문 생성 — JSON POST */
    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> create(
            @RequestBody OrderRequestDTO dto,
            HttpSession session) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "로그인이 필요합니다."));
        }
        if (dto.getItems() == null || dto.getItems().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "주문 항목이 없습니다."));
        }

        try {
            Map<String, Object> result = orderService.createOrder(mId, dto);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("주문 생성 실패 mId={}", mId, e);
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "주문 생성 중 오류가 발생했습니다."));
        }
    }

    /** 결제 성공 콜백 */
    @GetMapping("/success")
    public String success(@RequestParam String paymentKey,
                          @RequestParam String orderId,
                          @RequestParam int amount,
                          HttpSession session,
                          Model model) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";

        try {
            OrderVO order = orderService.confirmPayment(orderId, paymentKey, amount);
            List<OrderItemVO> items = orderService.getOrderItems(orderId);
            // cart → order 이관 결제 흐름 대응: 결제 성공 시 해당 회원의 장바구니 비우기
            // (단일 "바로 결제" 흐름에서도 장바구니에 잔여 아이템이 없으면 no-op 이라 안전)
            cartService.clearCart(mId);
            model.addAttribute("order", order);
            model.addAttribute("items", items);
            return "order/success";
        } catch (Exception e) {
            log.error("결제 승인 실패 orderId={}", orderId, e);
            return "redirect:/order/fail?message=" +
                    java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8);
        }
    }

    /** 결제 실패 콜백 */
    @GetMapping("/fail")
    public String fail(@RequestParam(defaultValue = "결제가 취소되었습니다.") String message,
                       HttpSession session,
                       Model model) {

        if (session.getAttribute("m_id") == null) return "redirect:/member/login";
        model.addAttribute("message", message);
        return "order/fail";
    }

    /** 내 주문 목록 */
    @GetMapping("/my")
    public String myOrders(HttpSession session, Model model) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";
        model.addAttribute("orders", orderService.getMyOrders(mId));
        return "order/my";
    }

    /** 주문 상세 조회 — 모달용 AJAX (본인 주문만) */
    @GetMapping("/detail/{orderId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> detail(
            @PathVariable String orderId,
            HttpSession session) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return ResponseEntity.status(401).build();

        OrderVO order = orderService.getOrderById(orderId);
        if (order == null || !mId.equals(order.getMId())) {
            return ResponseEntity.status(403).build();
        }

        List<OrderItemVO> items = orderService.getOrderItems(orderId);
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("order", order);
        result.put("items", items);
        // 취소 가능 여부 + 현재 환불 예상액 (시간 기반 계산)
        result.putAll(orderService.getRefundPreview(order));
        return ResponseEntity.ok(result);
    }

    /** 주문 취소 — 폼 POST (로그인 필요, 본인 주문만, status=PAID 만) */
    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<CancelResult> cancelOrder(
            @RequestParam String orderId,
            @RequestParam String reason,
            @RequestParam(required = false) String memo,
            HttpSession session) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401)
                    .body(new CancelResult(false, 0, 0, "로그인이 필요합니다."));
        }
        CancelResult result = orderService.cancelOrder(orderId, mId, reason, memo);
        return ResponseEntity.ok(result);
    }
}
