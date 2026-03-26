package org.study.cafe.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.cafe.member.mapper.MemberMapper;
import org.study.cafe.member.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired private MemberMapper     memberMapper;
    @Autowired private BCryptPasswordEncoder enc;

    @Override public int register(MemberVO vo, String confirm) {
        if (!vo.getPassword().equals(confirm))         return -1; // 비밀번호 불일치
        if (vo.getPassword().length() < 8)             return -2; // 비밀번호 짧음
        if (memberMapper.checkEmail(vo.getEmail()) > 0) return -3; // 이메일 중복
        if (memberMapper.checkUsername(vo.getUsername()) > 0) return -4; // 닉네임 중복
        vo.setPassword(enc.encode(vo.getPassword()));
        return memberMapper.insertMember(vo);
    }

    @Override public MemberVO login(String email, String password) {
        MemberVO m = memberMapper.findByEmail(email);
        if (m == null || !enc.matches(password, m.getPassword())) return null;
        return m;
    }

    @Override public int    checkEmail(String email)         { return memberMapper.checkEmail(email); }
    @Override public int    checkUsername(String username)   { return memberMapper.checkUsername(username); }
    @Override public MemberVO findByIdx(String m_idx)        { return memberMapper.findByIdx(m_idx); }
    @Override public int    updateMember(MemberVO vo)        { return memberMapper.updateMember(vo); }
    @Override public int    deleteMember(String m_idx)       { return memberMapper.deleteMember(m_idx); }
}
