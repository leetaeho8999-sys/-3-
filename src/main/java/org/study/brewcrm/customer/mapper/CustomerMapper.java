package org.study.brewcrm.customer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.customer.vo.CustomerVO;
import org.study.brewcrm.customer.vo.VisitLogVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface CustomerMapper {
    int  getCount();
    int  getCountByGrade(String grade);
    int  getCountThisMonth();
    long getTotalMonthlyAmount();
    int  getTotalMonthlyVisit();
    List<CustomerVO> getCustomerList(Map<String, Object> map);
    CustomerVO getCustomerDetail(String c_idx);
    CustomerVO findCustomerByName(String name);
    int insertCustomer(CustomerVO customerVO);
    int updateCustomer(CustomerVO customerVO);
    int updateGrade(CustomerVO customerVO);
    int deleteCustomer(String c_idx);
    int addVisit(String c_idx);
    int addVisitWithAmount(Map<String, Object> map);
    int resetMonthlyStats();
    List<CustomerVO> searchCustomer(Map<String, Object> map);
    int getSearchCount(Map<String, Object> map);

    // ── 방문 이력 (visit_log_t) ───────────────────────────────
    int insertVisitLog(VisitLogVO log);
    List<VisitLogVO> getVisitLogs(String c_idx);
    int updateLastVisitDate(Map<String, Object> map);

    // ── 고객 태그 (customer_tag_t) ────────────────────────────
    List<String> getTags(String c_idx);
    int insertTag(Map<String, Object> map);
    int deleteTag(Map<String, Object> map);

    // ── 마케팅용 ──────────────────────────────────────────────
    List<CustomerVO> getInactiveCustomers(int days);   // N일 이상 미방문
    List<CustomerVO> getBirthdayCustomers();           // 이번 달 생일 고객

    // ── 통계용 ────────────────────────────────────────────────
    List<Map<String, Object>> getGradeDistribution();
    List<Map<String, Object>> getMonthlyNewCustomers();
    List<Map<String, Object>> getVisitDistribution();
    List<CustomerVO> getTopByVisit(int limit);
    double getAvgVisitCount();
    List<CustomerVO> getCustomerProgress();

    // ── 시간대별·요일별·메뉴별 통계 (visit_log_t 기반) ───────
    List<Map<String, Object>> getHourlyStats();
    List<Map<String, Object>> getWeekdayStats();
    List<Map<String, Object>> getTopMenuItems(int limit);
    List<Map<String, Object>> getGradeAvgSpend();
}
