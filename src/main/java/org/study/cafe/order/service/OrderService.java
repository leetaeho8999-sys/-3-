package org.study.cafe.order.service;

import org.study.cafe.order.vo.CancelResult;
import org.study.cafe.order.vo.OrderItemVO;
import org.study.cafe.order.vo.OrderRequestDTO;
import org.study.cafe.order.vo.OrderVO;
import org.study.cafe.order.vo.RefundInfo;

import java.util.List;
import java.util.Map;

public interface OrderService {
    /** 주문 생성 — order_t + order_item_t INSERT, orderId·amount 반환 */
    Map<String, Object> createOrder(String mId, OrderRequestDTO dto);

    /** 토스페이먼츠 결제 승인 API 호출 후 DB 갱신 */
    OrderVO confirmPayment(String orderId, String paymentKey, int amount);

    /** 회원 주문 목록 (전체) */
    List<OrderVO> getMyOrders(String mId);

    /** 회원 주문 최근 N건 + 첫 메뉴명/건수 (마이페이지용) */
    List<OrderVO> getMyOrdersSummary(String mId, int limit);

    /** 주문 단건 조회 */
    OrderVO getOrderById(String orderId);

    /** 주문 상세 아이템 */
    List<OrderItemVO> getOrderItems(String orderId);

    /** 주문 취소 — 시간 기반 3단계 환불 정책 + 토스 cancel API 연동 */
    CancelResult cancelOrder(String orderId, String mId, String reason, String memo);

    /** 주문 상세 모달용 환불 미리보기 계산 (cancelable / currentRefundRate / currentRefundAmount) */
    Map<String, Object> getRefundPreview(OrderVO order);

    /**
     * 환불 계산 단일 진원지 (Single Source of Truth).
     * cancelOrder 와 getRefundPreview 가 동일 로직을 공유하도록 공용 추출.
     * paidDate 기준 경과 초로 {@link RefundInfo#cancelable}, rate, amount 결정.
     */
    RefundInfo calculateRefund(OrderVO order);
}
