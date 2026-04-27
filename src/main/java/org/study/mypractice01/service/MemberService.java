package org.study.mypractice01.service;

import org.study.mypractice01.vo.MemberVO; // MemberVO가 아니라 Member임을 꼭 확인!

public interface MemberService {

    // 1. 회원가입 계획
    int join(MemberVO vo);

    // 2. 로그인 계획
    MemberVO login(String m_id);

    // 3. 아이디 찾기 계획
    String findMemberId(String m_name, String m_phone);

    // 4. 비밀번호 찾기 계획
    String findMemberPw(String m_id, String m_phone);

    // 5. 비밀번호 재설정 계획
    void updatePw(String m_id, String m_pw);

    // 🔥 6. 아이디 중복 확인 계획 (이 줄이 있어야 Impl의 빨간 줄이 사라집니다!)
    int idCheck(String m_id);
}