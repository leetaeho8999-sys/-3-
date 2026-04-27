package org.study.cafe.order.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor
public class OrderVO {
    private String        orderId;
    private String        mId;
    private int           totalAmount;
    private String        status;       // READY / PAID / CANCELLED / FAILED
    private String        paymentKey;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDate;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime paidDate;
    // ── 취소/환불 관련 (2026-04-24 추가) ─────────────────────────
    private String        cancelReason; // CHANGE_MIND / WRONG_ORDER / TOO_SLOW / ETC
    private String        cancelMemo;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime cancelDate;
    private int           refundAmount;
    private int           refundRate;   // 100 또는 50
    // ── 포인트 (2026-04-26 추가) ───────────────────────────────
    private int           pointsUsed;     // 주문 시 사용한 포인트
    private int           pointsEarned;   // 결제 승인 시 적립된 포인트
    // ── 마이페이지 요약용 ───────────────────────────────────────
    private String        firstMenuName;
    private int           itemCount;
}
