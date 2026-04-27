package org.study.brewcrm.order.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * cafe-spring 의 order_t 를 CRM 에서 읽기 위한 VO.
 * order_t 는 cafe-spring 이 INSERT 하고, brew-crm 은 READ 전용.
 * m_id(VARCHAR) 은 cafe-spring 의 member.m_id 로, email 경유하여 member_t → customer_t 와 연결된다.
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class OrderVO {
    private String orderId;        // order_t.order_id (PK, VARCHAR)
    private String m_id;           // order_t.m_id — cafe-spring member 식별자
    private int    totalAmount;    // order_t.total_amount
    private String status;         // READY / PAID / CANCELLED / FAILED
    private String paymentKey;
    private String regDate;
    private String paidDate;
    // JOIN 결과 (customer_t 연결)
    private String c_idx;          // customer_t.c_idx (null 가능 — 비회원·미연결 주문)
    private String customerName;   // customer_t.name 또는 member.m_name
    private String customerGrade;  // customer_t.grade
    private String memberEmail;    // member.m_email (JOIN 경유)
}
