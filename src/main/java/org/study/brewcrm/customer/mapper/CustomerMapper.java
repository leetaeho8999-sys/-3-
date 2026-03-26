package org.study.brewcrm.customer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.customer.vo.CustomerVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface CustomerMapper {
    int getCount();
    int getCountByGrade(String grade);
    int getCountThisMonth();
    List<CustomerVO> getCustomerList(Map<String, Object> map);   // grade 포함
    CustomerVO getCustomerDetail(String c_idx);
    int insertCustomer(CustomerVO customerVO);
    int updateCustomer(CustomerVO customerVO);
    int updateGrade(CustomerVO customerVO);                      // 등급 단독 업데이트 (신규)
    int deleteCustomer(String c_idx);
    int addVisit(String c_idx);
    List<CustomerVO> searchCustomer(Map<String, Object> map);   // grade 포함
    int getSearchCount(Map<String, Object> map);                 // Map으로 변경 (grade 포함)
}
