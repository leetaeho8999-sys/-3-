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
     * [1] 회원가입
     * ① 이름(+전화번호)으로 기존 CRM 고객 검색 → 있으면 연결 (등급·방문이력 유지)
     * ② 없으면 신규 customer_t 생성 후 연결
     * ③ 생성/조회한 c_idx를 linked_customer로 설정 후 member_t INSERT
     */
    @Override
    @Transactional
    public int register(MemberVO memberVO, String confirmPassword) {
        if (!memberVO.getPassword().equals(confirmPassword))  return -1; // 비밀번호 불일치
        if (memberVO.getPassword().length() < 6)              return -2; // 비밀번호 짧음
        if (memberMapper.checkEmail(memberVO.getEmail()) > 0) return -3; // 이메일 중복

        // ① 기존 CRM 고객 찾기 (이름 일치 + 전화번호 교차 검증)
        String linkedCIdx = null;
        try {
            CustomerVO existing = customerMapper.findCustomerByName(memberVO.getName());
            if (existing != null) {
                String regPhone = memberVO.getPhone() != null ? memberVO.getPhone().replaceAll("[^0-9]", "") : "";
                String crmPhone = existing.getPhone() != null ? existing.getPhone().replaceAll("[^0-9]", "") : "";
                // 전화번호가 한쪽이라도 없으면 이름만으로 연결, 둘 다 있으면 일치해야 연결
                if (regPhone.isEmpty() || crmPhone.isEmpty() || regPhone.equals(crmPhone)) {
                    linkedCIdx = existing.getC_idx();
                }
            }
        } catch (Exception ignored) {}

        if (linkedCIdx == null) {
            // ② 기존 고객 없음 → 신규 customer_t 생성
            CustomerVO customer = new CustomerVO();
            customer.setName(memberVO.getName());
            customer.setPhone(memberVO.getPhone() != null && !memberVO.getPhone().isEmpty()
                    ? memberVO.getPhone() : "-");
            customer.setGrade("일반");
            customer.setMemo("");
            customerMapper.insertCustomer(customer); // useGeneratedKeys → customer.getC_idx() 에 PK 주입
            linkedCIdx = customer.getC_idx();
        }

        // ③ linked_customer 설정 후 member_t INSERT
        memberVO.setLinkedCustomer(linkedCIdx);
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
     * linked_customer 가 NULL 인 계정(관리자 등 직접 INSERT된 계정)은
     * 이름으로 customer_t 를 찾아 자동 연결 후 등급/방문수를 반환한다.
     */
    @Override
    public MemberVO findMyPageInfo(String m_idx) {
        MemberVO info = memberMapper.findMyPageInfo(m_idx);
        if (info == null) return null;
        if (info.getLinkedCustomer() != null && !info.getLinkedCustomer().isEmpty()) return info;
        // linked_customer 가 없는 경우 — 이름으로 customer_t 조회 후 자동 연결
        try {
            CustomerVO customer = customerMapper.findCustomerByName(info.getName());
            if (customer != null) {
                info.setGrade(customer.getGrade());
                info.setVisitCount(customer.getVisitCount());
                info.setMonthlyVisit(customer.getMonthlyVisit());
                info.setLinkedCustomer(customer.getC_idx());
                // member_t.linked_customer 영구 연결
                java.util.Map<String, Object> params = new java.util.HashMap<>();
                params.put("m_idx", info.getM_idx());
                params.put("c_idx", customer.getC_idx());
                memberMapper.setLinkedCustomer(params);
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
