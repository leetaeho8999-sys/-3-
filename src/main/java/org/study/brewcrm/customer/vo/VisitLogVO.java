package org.study.brewcrm.customer.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor
public class VisitLogVO {
    private int    logIdx;
    private String c_idx;
    private int    amount;
    private String menuItem;
    private String note;
    private String regDate;
}
