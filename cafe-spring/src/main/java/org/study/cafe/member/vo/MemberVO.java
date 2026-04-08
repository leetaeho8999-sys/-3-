package org.study.cafe.member.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MemberVO {
    private String m_idx, username, email, password, phone, regDate, active;
    private String name;            // CRM 고객 이름 (customer_t.name)
    private String linkedCustomer;  // customer_t.c_idx FK
    private String grade;           // customer_t에서 JOIN
    private int    visitCount;      // customer_t에서 JOIN
}
