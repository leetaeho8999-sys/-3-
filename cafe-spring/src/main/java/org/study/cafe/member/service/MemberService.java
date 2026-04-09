package org.study.cafe.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.cafe.member.mapper.MemberMapper;
import org.study.cafe.member.vo.MemberVO;
import org.study.cafe.membership.mapper.MembershipMapper;
import org.study.cafe.membership.vo.MembershipVO;

/**
 * 회원 서비스 — mypractice01 방식으로 재구성
 * 인터페이스+구현체 구조를 단일 클래스로 통합
 */
@Service
public class MemberService {

    @Autowired private MemberMapper     memberMapper;
    @Autowired private MembershipMapper membershipMapper;

    /**
     * 회원가입 — mypractice01의 join() 방식
     * 평문 비밀번호 저장, customer_t·membership_t 동시 생성 (멤버십 시스템 연동)
     */
    @Transactional
    public void register(MemberVO vo) {
        // ① customer_t INSERT (멤버십 등급 연동용, linkedCustomer에 c_idx 주입)
        memberMapper.insertCustomerForMember(vo);
        // ② member_t INSERT (평문 비밀번호 그대로 저장)
        memberMapper.insertMember(vo);
        // ③ membership_t INSERT (가입 즉시 일반 등급 생성)
        MemberVO newMember = memberMapper.findByEmail(vo.getEmail());
        if (newMember != null) {
            MembershipVO ms = new MembershipVO();
            ms.setUserId(newMember.getM_idx());
            ms.setGrade("일반");
            ms.setPoints(0);
            membershipMapper.insertMembership(ms);
        }
    }

    /**
     * 로그인 — mypractice01의 login() 방식
     * DB에서 이메일로 회원 조회 후 평문 비밀번호 비교
     */
    public MemberVO login(String email, String password) {
        MemberVO dbMember = memberMapper.findByEmail(email);
        if (dbMember != null && dbMember.getPassword().equals(password)) {
            return dbMember;
        }
        return null;
    }

    public int      checkEmail(String email)         { return memberMapper.checkEmail(email); }
    public int      checkUsername(String username)   { return memberMapper.checkUsername(username); }
    public MemberVO findByIdx(String m_idx)          { return memberMapper.findByIdx(m_idx); }
    public MemberVO findMyPageInfo(String m_idx)     { return memberMapper.findMyPageInfo(m_idx); }

    /** 회원 정보 수정 + CRM 고객 동기화 */
    @Transactional
    public int updateMember(MemberVO vo) {
        int result = memberMapper.updateMember(vo);
        if (vo.getLinkedCustomer() != null && !vo.getLinkedCustomer().isEmpty()) {
            memberMapper.updateLinkedCustomer(vo);
        }
        return result;
    }

    public int deleteMember(String m_idx) { return memberMapper.deleteMember(m_idx); }
}
