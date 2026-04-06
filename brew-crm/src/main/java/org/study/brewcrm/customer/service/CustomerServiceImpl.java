package org.study.brewcrm.customer.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.brewcrm.customer.mapper.CustomerMapper;
import org.study.brewcrm.customer.vo.CustomerVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired private CustomerMapper customerMapper;

    @Override public int getCount()                      { return customerMapper.getCount(); }
    @Override public int getCountByGrade(String grade)   { return customerMapper.getCountByGrade(grade); }
    @Override public int getCountThisMonth()             { return customerMapper.getCountThisMonth(); }

    @Override
    public List<CustomerVO> getCustomerList(int numPerPage, int offset, String grade) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        map.put("grade", "전체".equals(grade) ? null : grade);  // 전체면 null → 필터 없음
        return customerMapper.getCustomerList(map);
    }

    @Override public CustomerVO getCustomerDetail(String c_idx) { return customerMapper.getCustomerDetail(c_idx); }
    @Override public int insertCustomer(CustomerVO vo)          { return customerMapper.insertCustomer(vo); }
    @Override public int updateCustomer(CustomerVO vo)          { return customerMapper.updateCustomer(vo); }
    @Override public int deleteCustomer(String c_idx)           { return customerMapper.deleteCustomer(c_idx); }

    /**
     * 방문 횟수 증가 후 자동 등급 업데이트
     * 1~5회: 일반, 6~15회: 실버, 16~30회: 골드, 31회+: VIP
     */
    @Override
    public int addVisitAndUpdateGrade(String c_idx) {
        int result = customerMapper.addVisit(c_idx);
        if (result > 0) {
            CustomerVO customer = customerMapper.getCustomerDetail(c_idx);
            int visits = customer.getVisitCount();
            String newGrade;
            if      (visits >= 31) newGrade = "VIP";
            else if (visits >= 16) newGrade = "골드";
            else if (visits >= 6)  newGrade = "실버";
            else                   newGrade = "일반";
            // 등급 변경이 있을 때만 업데이트
            if (!newGrade.equals(customer.getGrade())) {
                customer.setGrade(newGrade);
                customerMapper.updateGrade(customer);
            }
        }
        return result;
    }

    @Override
    public List<CustomerVO> searchCustomer(String keyword, int numPerPage, int offset, String grade) {
        Map<String, Object> map = new HashMap<>();
        map.put("keyword",    "%" + keyword + "%");   // % 는 여기서만 추가
        map.put("numPerPage", numPerPage);
        map.put("offset",     offset);
        map.put("grade",      "전체".equals(grade) ? null : grade);
        return customerMapper.searchCustomer(map);
    }

    @Override
    public int getSearchCount(String keyword, String grade) {
        Map<String, Object> map = new HashMap<>();
        map.put("keyword", "%" + keyword + "%");       // % 는 여기서만 추가
        map.put("grade",   "전체".equals(grade) ? null : grade);
        return customerMapper.getSearchCount(map);
    }
}
