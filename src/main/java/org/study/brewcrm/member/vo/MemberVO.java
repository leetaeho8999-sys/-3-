package org.study.brewcrm.member.vo;

import lombok.*;

/**
 * 회원 VO — customer_t 와 1:1 연결
 * 등급/방문횟수는 customer_t 에서 JOIN으로 가져옴
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MemberVO {
    private String m_idx;           // 회원 번호 (PK)
    private String email;           // 이메일 (로그인 ID)
    private String password;        // 비밀번호 (BCrypt)
    private String name;            // 이름
    private String linkedCustomer;  // 연결된 customer_t.c_idx
    private String regDate;         // 가입일
    private String active;          // 0=정상, 1=탈퇴
    // ── 마이페이지용 (customer_t JOIN) ──
    private String grade;           // 등급 (일반/실버/골드/VIP)
    private int    visitCount;      // 누적 방문 횟수
    private int    monthlyVisit;    // 이번 달 방문 횟수 (등급 기준)
    private String phone;           // 전화번호
    private String memo;            // 메모
    private String role;            // 권한 (ADMIN/MANAGER/STAFF/MEMBER)
}
