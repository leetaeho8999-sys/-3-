package org.study.mypractice01.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.mypractice01.mapper.MemberMapper;
import org.study.mypractice01.vo.MemberVO;

@Service // 💡 "제가 바로 메뉴판을 보고 진짜 요리하는 사람입니다!"
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper mapper; // 든든한 창고지기(Mapper) 호출

    // 1. 회원가입: 손님 정보를 창고에 저장해요.
    @Override
    public void join(MemberVO vo) {
        mapper.join(vo);
    }

    // 2. 로그인: 아이디와 비번을 대조해서 손님을 확인해요.
    @Override
    public MemberVO login(MemberVO vo) {
        MemberVO dbMember = mapper.login(vo.getM_id());

        // 창고에 아이디가 있고, 비밀번호까지 딱 맞으면 통과!
        if (dbMember != null && dbMember.getM_pw().equals(vo.getM_pw())) {
            return dbMember;
        }
        return null;
    }

    // 3. 아이디 찾기: 이름과 전화번호로 잃어버린 아이디를 찾아드려요.
    @Override
    public String findMemberId(String m_name, String m_phone) {
        return mapper.findMemberId(m_name, m_phone);
    }

    // 4. 비밀번호 찾기: 아이디와 전화번호로 기존 비밀번호를 알려드려요.
    @Override
    public String findMemberPw(String m_id, String m_phone) {
        return mapper.findMemberPw(m_id, m_phone);
    }

    // 5. 비밀번호 재설정: 잊어버린 비번을 새 비번으로 싹 고쳐드려요.
    @Override
    public void updatePw(String m_id, String m_pw) {
        mapper.updatePw(m_id, m_pw);
    }

    // 6. [NEW] 아이디 중복 확인: 똑같은 아이디가 있는지 창고를 뒤져봅니다.
    @Override
    public int idCheck(String m_id) {
        // 창고지기에게 "이 아이디 몇 개나 있어?" 라고 물어보고 그 숫자를 돌려줍니다.
        return mapper.idCheck(m_id);
    }
}