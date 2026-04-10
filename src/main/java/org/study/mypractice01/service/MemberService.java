package org.study.mypractice01.service;

import org.study.mypractice01.vo.MemberVO;

// 💡 인터페이스는 "우리 카페에서 이런 일들을 할 수 있음"라고 적어두는 '메뉴판' 역할
public interface MemberService {

    // 1. 회원가입 업무
    void join(MemberVO vo);

    // 2. 로그인 업무
    MemberVO login(MemberVO vo);

    // 3. 아이디 찾기 업무
    String findMemberId(String m_name, String m_phone);

    // ========================================================
    // 💡 아래부터 이번에 새로 추가된 '비밀번호' 관련 메뉴입니다!
    // ========================================================

    // 4. [비밀번호 찾기] 아이디와 전화번호를 받아서 기존 비밀번호를 찾아주는 업무
    String findMemberPw(String m_id, String m_phone);

    // 5. [비밀번호 재설정] 아이디와 새 비밀번호를 받아서 창고의 비밀번호를 교체하는 업무
    void updatePw(String m_id, String m_pw);

    // 6. [NEW] 아이디 중복 확인: 똑같은 아이디가 있는지 창고를 뒤져봅니다.
    int idCheck(String m_id);
}