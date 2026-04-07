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

    @Override public int checkEmail(String email) { return memberMapper.checkEmail(email); }

    /**
     * 마이페이지 조회 — 연결된 customer_t 의 monthly_visit/monthly_amount 기준으로
     * 등급을 실시간 재계산하여 반환한다.
     * ① monthly_visit 컬럼이 없거나 0이면 visit_count(누적)로 대체 추정한다.
     * ② 계산된 등급이 customer_t 와 다르면 customer_t 도 동기화한다.
     */
    @Override
    public MemberVO findMyPageInfo(String m_idx) {
        MemberVO info = memberMapper.findMyPageInfo(m_idx);
        if (info == null) return null;
        if (info.getLinkedCustomer() == null || info.getLinkedCustomer().isEmpty()) return info;
        try {
            org.study.brewcrm.customer.vo.CustomerVO customer =
                    customerMapper.getCustomerDetail(info.getLinkedCustomer());
            if (customer == null) return info;
            int mv = customer.getMonthlyVisit();
            int ma = customer.getMonthlyAmount();
            // monthly_visit 컬럼 미존재 또는 이번 달 방문 없음 → visit_count 기반 대체 추정
            if (mv == 0 && ma == 0) mv = customer.getVisitCount();
            String grade;
            if      (mv >= 30)                   grade = "VIP";
            else if (mv >= 15 || ma >= 70_000)   grade = "골드";
            else if (mv >= 5  || ma >= 30_000)   grade = "실버";
            else                                 grade = "일반";
            info.setGrade(grade);
            // customer_t 도 최신 등급으로 동기화
            if (!grade.equals(customer.getGrade())) {
                customer.setGrade(grade);
                customerMapper.updateGrade(customer);
            }
        } catch (Exception ignored) {}
        return info;
    }

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
