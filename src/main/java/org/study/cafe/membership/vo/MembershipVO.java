package org.study.cafe.membership.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MembershipVO {
    private String ms_idx, userId, grade, regDate;
    private int    points;
}
