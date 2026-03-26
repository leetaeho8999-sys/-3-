package org.study.cafe.member.service;
import org.study.cafe.member.vo.MemberVO;

public interface MemberService {
    int      register(MemberVO vo, String confirm);
    MemberVO login(String email, String password);
    int      checkEmail(String email);
    int      checkUsername(String username);
    MemberVO findByIdx(String m_idx);
    int      updateMember(MemberVO vo);
    int      deleteMember(String m_idx);
}
