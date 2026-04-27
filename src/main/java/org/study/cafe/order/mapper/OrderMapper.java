package org.study.cafe.order.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.cafe.order.vo.OrderItemVO;
import org.study.cafe.order.vo.OrderVO;

import java.util.List;

@Mapper
public interface OrderMapper {
    int insertOrder(OrderVO order);
    int insertOrderItem(OrderItemVO item);
    int updateOrderPaid(@Param("orderId") String orderId,
                        @Param("paymentKey") String paymentKey);
    int updateOrderFailed(@Param("orderId") String orderId);

    /** 주문 취소 — m_id + status='PAID' 조건으로 이중취소/남 주문 방지 */
    int cancelOrder(@Param("orderId") String orderId,
                    @Param("mId") String mId,
                    @Param("cancelReason") String cancelReason,
                    @Param("cancelMemo") String cancelMemo,
                    @Param("refundAmount") int refundAmount,
                    @Param("refundRate") int refundRate);
    OrderVO findByOrderId(@Param("orderId") String orderId);
    List<OrderVO> findByMemberId(@Param("mId") String mId);
    List<OrderVO> findRecentByMemberId(@Param("mId") String mId, @Param("limit") int limit);
    List<OrderItemVO> findItemsByOrderId(@Param("orderId") String orderId);

    /** 결제 적립 동기화 — order_t.points_earned 기록 (취소 시 회수 기준) */
    int updatePointsEarned(@Param("orderId") String orderId,
                           @Param("amount") int amount);

    /** 결제 사용 동기화 — order_t.points_used 기록 (취소 시 복원 기준) */
    int updatePointsUsed(@Param("orderId") String orderId,
                         @Param("amount") int amount);
}
