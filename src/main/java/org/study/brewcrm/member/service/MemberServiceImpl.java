package org.study.brewcrm.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.brewcrm.customer.mapper.CustomerMapper;
import org.study.brewcrm.customer.vo.CustomerVO;
import org.study.brewcrm.member.mapper.MemberMapper;
import org.study.brewcrm.member.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired private MemberMapper          memberMapper;
    @Autowired private CustomerMapper        customerMapper;
    @Autowired private BCryptPasswordEncoder enc;

    /**
     * [1] 회원가입 + CRM 고객 동시 생성
     * ① customer_t INSERT → useGeneratedKeys로 c_idx 획득
     * ② 획득한 c_idx를 linked_customer로 설정 후 member_t INSERT
     */
    @Override
    @Transactional
    public int register(MemberVO memberVO, String confirmPassword) {
        if (!memberVO.getPassword().equals(confirmPassword))  return -1; // 비밀번호 불일치
        if (memberVO.getPassword().length() < 6)              return -2; // 비밀번호 짧음
        if (memberMapper.checkEmail(memberVO.getEmail()) > 0) return -3; // 이메일 중복

        // ① customer_t 먼저 INSERT (c_idx 자동 생성)
        CustomerVO customer = new CustomerVO();
        customer.setName(memberVO.getName());
        customer.setPhone(memberVO.getPhone() != null && !memberVO.getPhone().isEmpty()
                ? memberVO.getPhone() : "-");
        customer.setGrade("일반");
        customer.setMemo("");
        customerMapper.insertCustomer(customer); // useGeneratedKeys → customer.getC_idx() 에 PK 주입

        // ② 생성된 c_idx를 linked_customer 로 설정 후 member_t INSERT
        memberVO.setLinkedCustomer(customer.getC_idx());
        memberVO.setPassword(enc.encode(memberVO.getPassword()));
        return memberMapper.insertMember(memberVO);
    }

    @Override
    public MemberVO login(String email, String password) {
        MemberVO m = memberMapper.findByEmail(email);
        if (m == null) return null;
        return enc.matches(password, m.getPassword()) ? m : null;
    }

    @Override public int      checkEmail(String email)     { return memberMapper.checkEmail(email); }
    @Override public MemberVO findMyPageInfo(String m_idx) { return memberMapper.findMyPageInfo(m_idx); }

    /**
     * [2] 마이페이지 수정 시 member_t + customer_t 동시 업데이트
     * ① member_t.name UPDATE
     * ② linked_customer가 있으면 customer_t.phone, memo 도 UPDATE
     */
    @Override
    @Transactional
    public int updateMember(MemberVO memberVO) {
        int result = memberMapper.updateMember(memberVO);
        if (memberVO.getLinkedCustomer() != null && !memberVO.getLinkedCustomer().isEmpty()) {
            memberMapper.updateLinkedCustomer(memberVO);
        }
        return result;
    }
}
