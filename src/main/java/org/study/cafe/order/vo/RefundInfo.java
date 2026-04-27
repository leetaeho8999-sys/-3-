package org.study.cafe.order.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 환불 계산 결과 — cancelOrder 와 getRefundPreview 의 Single Source of Truth.
 * {@link org.study.cafe.order.service.OrderService#calculateRefund} 가 반환.
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class RefundInfo {
    private boolean cancelable;   // 취소 가능 여부
    private int     rate;         // 100 / 50 / 0
    private int     amount;       // 환불 예정 금액 (원)
    private long    elapsedSec;   // 디버깅용: paidDate 로부터 경과 초
    private String  reason;       // "FULL" / "HALF" / "TOO_LATE" / "NEGATIVE_CLOCK_SKEW" / "INVALID_STATE"
}
