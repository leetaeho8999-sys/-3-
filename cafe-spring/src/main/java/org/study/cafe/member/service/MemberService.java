package org.study.cafe.member.service;

import org.study.cafe.member.vo.MemberVO;

public interface MemberService {

    // 1. 회원가입 업무
    void join(MemberVO vo);

    // 2. 로그인 업무
    MemberVO login(MemberVO vo);

    // 3. 아이디 찾기 업무
    String findMemberId(String m_name, String m_phone);

    // 4. 비밀번호 찾기: 아이디와 전화번호를 받아서 기존 비밀번호를 찾아주는 업무
    String findMemberPw(String m_id, String m_phone);

    // 5. 비밀번호 재설정: 아이디와 새 비밀번호를 받아서 비밀번호를 교체하는 업무
    void updatePw(String m_id, String m_pw);

    // 6. 아이디 중복 확인: 똑같은 아이디가 있는지 확인
    int idCheck(String m_id);

    // 7. 회원 정보 단건 조회
    MemberVO getMember(String m_id);

    // 8. 회원 기본 정보 수정 (이름·전화·이메일)
    void updateMember(MemberVO vo);

    // 9. 회원 탈퇴
    void deleteMember(String m_id);
}
