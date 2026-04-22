package org.study.brewcrm.member.service;

import org.study.brewcrm.member.vo.MemberVO;

public interface MemberService {
    int      register(MemberVO memberVO, String confirmPassword);
    MemberVO login(String email, String password);
    int      checkEmail(String email);
    MemberVO findMyPageInfo(String m_idx);
    int      updateMember(MemberVO memberVO);
    // 반환: 0=성공, -1=현재비번틀림, -2=새비번불일치, -3=비번짧음
    int      changePassword(String m_idx, String currentPw, String newPw, String confirmPw);
}
