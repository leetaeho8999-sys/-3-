package org.study.cafe.order.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class CancelResult {
    private boolean success;
    private int     refundAmount;
    private int     refundRate;   // 100 또는 50
    private String  message;
}
