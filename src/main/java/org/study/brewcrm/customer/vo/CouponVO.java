package org.study.brewcrm.customer.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor
public class CouponVO {
    private int    couponIdx;
    private String name;
    private String description;
    private String type;        // DISCOUNT / FREE / UPGRADE
    private int    value;
    private int    expireDays;
    private int    active;
    private String regDate;
}
