package org.study.cafe.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.cafe.member.mapper.MemberMapper;
import org.study.cafe.member.vo.MemberVO;
import org.study.cafe.membership.mapper.MembershipMapper;
import org.study.cafe.membership.vo.MembershipVO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired private MemberMapper          memberMapper;
    @Autowired private MembershipMapper      membershipMapper;
    @Autowired private BCryptPasswordEncoder enc;

    /**
     * 회원가입 + CRM 고객 동시 생성
     * ① customer_t INSERT → useGeneratedKeys로 linkedCustomer(c_idx) 획득
     * ② 획득한 c_idx를 linked_customer로 설정 후 member_t INSERT
     */
    @Override
    @Transactional
    public int register(MemberVO vo, String confirm) {
        if (!vo.getPassword().equals(confirm))              return -1; // 비밀번호 불일치
        if (vo.getPassword().length() < 8)                  return -2; // 비밀번호 짧음
        if (memberMapper.checkEmail(vo.getEmail()) > 0)     return -3; // 이메일 중복
        if (memberMapper.checkUsername(vo.getUsername()) > 0) return -4; // 닉네임 중복
        // ① customer_t 먼저 INSERT (c_idx 자동 생성 → vo.linkedCustomer에 주입)
        memberMapper.insertCustomerForMember(vo);
        // ② member_t INSERT (linked_customer 포함)
        vo.setPassword(enc.encode(vo.getPassword()));
        int result = memberMapper.insertMember(vo);
        // ③ 가입 즉시 membership_t 생성 (포인트 0, 등급 일반)
        if (result > 0) {
            MemberVO newMember = memberMapper.findByEmail(vo.getEmail());
            if (newMember != null) {
                MembershipVO ms = new MembershipVO();
                ms.setUserId(newMember.getM_idx());
                ms.setGrade("일반");
                ms.setPoints(0);
                membershipMapper.insertMembership(ms);
            }
        }
        return result;
    }

    @Override public MemberVO login(String email, String password) {
        MemberVO m = memberMapper.findByEmail(email);
        if (m == null || !enc.matches(password, m.getPassword())) return null;
        return m;
    }

    @Override public int      checkEmail(String email)       { return memberMapper.checkEmail(email); }
    @Override public int      checkUsername(String username) { return memberMapper.checkUsername(username); }
    @Override public MemberVO findByIdx(String m_idx)        { return memberMapper.findByIdx(m_idx); }
    @Override public MemberVO findMyPageInfo(String m_idx)   { return memberMapper.findMyPageInfo(m_idx); }

    /** 회원 정보 수정 + CRM 고객 동기화 */
    @Override
    @Transactional
    public int updateMember(MemberVO vo) {
        int result = memberMapper.updateMember(vo);
        if (vo.getLinkedCustomer() != null && !vo.getLinkedCustomer().isEmpty()) {
            memberMapper.updateLinkedCustomer(vo);
        }
        return result;
    }

    @Override public int deleteMember(String m_idx) { return memberMapper.deleteMember(m_idx); }
}
