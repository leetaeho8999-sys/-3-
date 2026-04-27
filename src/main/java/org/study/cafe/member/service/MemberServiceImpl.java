package org.study.cafe.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.member.mapper.MemberMapper;
import org.study.cafe.member.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper mapper;

    @Override
    public void join(MemberVO vo) {
        mapper.join(vo);
    }

    @Override
    public MemberVO login(MemberVO vo) {
        MemberVO dbMember = mapper.login(vo.getM_id());
        if (dbMember != null && dbMember.getM_pw().equals(vo.getM_pw())) {
            return dbMember;
        }
        return null;
    }

    @Override
    public String findMemberId(String m_name, String m_phone) {
        return mapper.findMemberId(m_name, m_phone);
    }

    @Override
    public String findMemberPw(String m_id, String m_phone) {
        return mapper.findMemberPw(m_id, m_phone);
    }

    @Override
    public void updatePw(String m_id, String m_pw) {
        mapper.updatePw(m_id, m_pw);
    }

    @Override
    public int idCheck(String m_id) {
        return mapper.idCheck(m_id);
    }

    @Override
    public MemberVO getMember(String m_id) {
        return mapper.getMember(m_id);
    }

    @Override
    public void updateMember(MemberVO vo) {
        mapper.updateMember(vo);
    }

    @Override
    public void deleteMember(String m_id) {
        mapper.deleteMember(m_id);
    }
}
