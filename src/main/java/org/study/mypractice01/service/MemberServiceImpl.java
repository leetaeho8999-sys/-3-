package org.study.mypractice01.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.mypractice01.mapper.MemberMapper;
import org.study.mypractice01.vo.MemberVO;

@Service // "나는 서비스 기능을 담당하는 클래스다!"라고 스프링에게 알려주는 이름표
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper mapper; // DB 창고지기(Mapper)를 불러옵니다.

    // 1. 회원가입
    @Override
    public int join(MemberVO vo) {
        return mapper.join(vo);
    }

    // 2. 로그인
    @Override
    public MemberVO login(String m_id) {
        return mapper.login(m_id);
    }

    // 3. 아이디 찾기
    @Override
    public String findMemberId(String m_name, String m_phone) {
        return mapper.findMemberId(m_name, m_phone);
    }

    // 4. 비밀번호 찾기
    @Override
    public String findMemberPw(String m_id, String m_phone) {
        return mapper.findMemberPw(m_id, m_phone);
    }

    // 5. 비밀번호 업데이트
    @Override
    public void updatePw(String m_id, String m_pw) {
        mapper.updatePw(m_id, m_pw);
    }

    // 🔥 6. [중요] 아이디 중복 확인
    @Override
    public int idCheck(String m_id) {
        // 이제 엉뚱한 곳이 아닌, 진짜 MemberMapper.java에 있는 idCheck를 실행합니다!
        return mapper.idCheck(m_id);
    }
}