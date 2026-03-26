package org.study.brewcrm.customer.service;

import org.study.brewcrm.customer.vo.CustomerVO;
import java.util.List;

public interface CustomerService {
    int getCount();
    int getCountByGrade(String grade);
    int getCountThisMonth();

    // 등급 필터 추가 (버그 수정)
    List<CustomerVO> getCustomerList(int numPerPage, int offset, String grade);

    CustomerVO getCustomerDetail(String c_idx);
    int insertCustomer(CustomerVO customerVO);
    int updateCustomer(CustomerVO customerVO);
    int deleteCustomer(String c_idx);

    // 방문 기록 + 자동 등급 업데이트
    int addVisitAndUpdateGrade(String c_idx);

    // 검색 (grade 필터 추가)
    List<CustomerVO> searchCustomer(String keyword, int numPerPage, int offset, String grade);
    int getSearchCount(String keyword, String grade);
}
