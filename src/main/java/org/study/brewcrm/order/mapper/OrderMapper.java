package org.study.brewcrm.order.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.order.vo.OrderItemVO;
import org.study.brewcrm.order.vo.OrderVO;

import java.util.List;

/**
 * cafe-spring 의 order_t / order_item_t 를 CRM 에서 읽기 위한 Mapper.
 * READ 전용 — brew-crm 은 쓰지 않는다.
 */
@Mapper
public interface OrderMapper {

    // ── 대시보드용 집계 (PAID 만 계산) ─────────────────────────
    long getPaidTotalThisMonth();      // 이번달 누적 매출(원)
    int  getPaidCountThisMonth();      // 이번달 주문 건수

    // ── 최근 결제 완료 주문 목록 ──────────────────────────────
    List<OrderVO> getRecentPaidOrders(int limit);

    // ── 특정 CRM 고객(c_idx) 의 웹 주문 내역 ──────────────────
    //    member_t.linked_customer = #{c_idx} 로 연결된 계정의 주문 전체 (최신 20건)
    List<OrderVO> getOrdersByCustomer(String c_idx);

    // ── 주문 상세 아이템 ───────────────────────────────────────
    List<OrderItemVO> getOrderItems(String orderId);
}
