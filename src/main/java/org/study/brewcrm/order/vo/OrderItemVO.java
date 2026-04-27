package org.study.brewcrm.order.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * cafe-spring 의 order_item_t 1행에 대응하는 VO (READ 전용).
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class OrderItemVO {
    private int    oiIdx;
    private String orderId;
    private String menuName;
    private String temperature;  // HOT / ICE / NONE
    private int    quantity;
    private int    unitPrice;
    private int    subtotal;
}
