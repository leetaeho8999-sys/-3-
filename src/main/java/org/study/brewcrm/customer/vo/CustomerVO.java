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

    private String c_idx;         // 고객 번호 (PK, AUTO_INCREMENT)
    private String name;          // 고객 이름
    private String phone;         // 연락처
    private String grade;         // 등급 (일반/실버/골드/VIP)
    private int    visitCount;    // 누적 방문 횟수
    private int    monthlyVisit;  // 이번 달 방문 횟수 (등급 산정 기준)
    private int    monthlyAmount; // 이번 달 누적 결제액(원) (등급 산정 기준)
    private String memo;           // 메모 (알레르기, 선호 음료 등)
    private String birthday;      // 생일 (마케팅 자동화용)
    private String lastVisitDate; // 마지막 방문 일시
    private String regDate;       // 등록일 (DB: CURRENT_TIMESTAMP)
    private String active;        // 삭제 여부 (0=정상, 1=삭제)

    // 통계용 (JOIN 결과)
    private int    couponCount;   // 보유 미사용 쿠폰 수
    private int    totalAmount;   // 누적 결제액 (visit_log_t SUM)

}
