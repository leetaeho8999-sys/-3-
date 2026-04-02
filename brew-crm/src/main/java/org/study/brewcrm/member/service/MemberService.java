package org.study.brewcrm.member.service;

import org.study.brewcrm.member.vo.MemberVO;

public interface MemberService {
    int      register(MemberVO memberVO, String confirmPassword);
    MemberVO login(String email, String password);
    int      checkEmail(String email);
    MemberVO findMyPageInfo(String m_idx);
    int      updateMember(MemberVO memberVO);
}
