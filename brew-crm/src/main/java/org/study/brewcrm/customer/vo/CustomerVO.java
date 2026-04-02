package org.study.brewcrm.customer.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// 기존 프로젝트의 BBSVO.java와 동일한 패턴
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CustomerVO {

    private String c_idx;       // 고객 번호 (PK, AUTO_INCREMENT)
    private String name;        // 고객 이름
    private String phone;       // 연락처
    private String grade;       // 등급 (일반/실버/골드/VIP)
    private int    visitCount;  // 방문 횟수
    private String memo;        // 메모 (알레르기, 선호 음료 등)
    private String regDate;     // 등록일 (DB: CURRENT_TIMESTAMP)
    private String active;      // 삭제 여부 (0=정상, 1=삭제)

}
