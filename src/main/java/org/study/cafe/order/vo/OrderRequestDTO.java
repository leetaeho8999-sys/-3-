package org.study.cafe.order.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter @Setter @NoArgsConstructor
public class OrderRequestDTO {
    private List<OrderItemDTO> items;
    private int                pointsToUse = 0;   // 결제 시 사용할 포인트

    @Getter @Setter @NoArgsConstructor
    public static class OrderItemDTO {
        private String menuName;
        private String temperature; // HOT / ICE / NONE
        private String size;        // TALL / GRANDE / VENTI / NONE
        private int    quantity;
        private int    unitPrice;
    }
}
