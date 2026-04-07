package org.study.brewcrm.customer.service;

import org.study.brewcrm.customer.vo.CustomerVO;
import org.study.brewcrm.customer.vo.VisitLogVO;
import java.util.List;
import java.util.Map;

public interface CustomerService {
    int  getCount();
    int  getCountByGrade(String grade);
    int  getCountThisMonth();
    long getTotalMonthlyAmount();
    int  getTotalMonthlyVisit();
    List<CustomerVO> getCustomerList(int numPerPage, int offset, String grade);
    CustomerVO getCustomerDetail(String c_idx);
    int insertCustomer(CustomerVO customerVO);
    int updateCustomer(CustomerVO customerVO);
    int deleteCustomer(String c_idx);
    int addVisitAndUpdateGrade(String c_idx, int amount, String menuItem, String note);
    List<CustomerVO> searchCustomer(String keyword, int numPerPage, int offset, String grade);
    int getSearchCount(String keyword, String grade);

    // 방문 이력
    List<VisitLogVO> getVisitLogs(String c_idx);

    // 태그
    List<String> getTags(String c_idx);
    int addTag(String c_idx, String tag);
    int deleteTag(String c_idx, String tag);

    // 마케팅용
    List<CustomerVO> getInactiveCustomers(int days);
    List<CustomerVO> getBirthdayCustomers();

    // 통계용
    List<Map<String, Object>> getGradeDistribution();
    List<Map<String, Object>> getMonthlyNewCustomers();
    List<Map<String, Object>> getVisitDistribution();
    List<CustomerVO> getTopByVisit(int limit);
    double getAvgVisitCount();
    List<CustomerVO> getCustomerProgress();
    List<Map<String, Object>> getHourlyStats();
    List<Map<String, Object>> getWeekdayStats();
    List<Map<String, Object>> getTopMenuItems(int limit);
    List<Map<String, Object>> getGradeAvgSpend();
}
