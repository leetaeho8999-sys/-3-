package org.study.cafe.member.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MemberVO {
    private String m_idx, username, email, password, phone, regDate, active;
}
