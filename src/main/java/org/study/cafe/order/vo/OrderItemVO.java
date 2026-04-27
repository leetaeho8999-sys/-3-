package org.study.cafe.order.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter @Setter @NoArgsConstructor
public class OrderItemVO {
    private int    oiIdx;
    private String orderId;
    private String menuName;
    private String temperature; // HOT / ICE / NONE
    private String size;        // TALL / GRANDE / VENTI / NONE
    private int    quantity;
    private int    unitPrice;
    private int    subtotal;
}
