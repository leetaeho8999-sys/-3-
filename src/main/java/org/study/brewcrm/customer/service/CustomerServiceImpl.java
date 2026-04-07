package org.study.brewcrm.customer.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.brewcrm.customer.mapper.CustomerMapper;
import org.study.brewcrm.customer.vo.CustomerVO;
import org.study.brewcrm.customer.vo.VisitLogVO;
import org.study.brewcrm.member.mapper.MemberMapper;
import org.study.brewcrm.member.mapper.MembershipMapper;
import org.study.brewcrm.member.vo.MemberVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired private CustomerMapper   customerMapper;
    @Autowired private MemberMapper     memberMapper;
    @Autowired private MembershipMapper membershipMapper;

    @Override public int  getCount()                      { return customerMapper.getCount(); }
    @Override public int  getCountByGrade(String grade)   { return customerMapper.getCountByGrade(grade); }
    @Override public int  getCountThisMonth()             { return customerMapper.getCountThisMonth(); }
    @Override public long getTotalMonthlyAmount()         { return customerMapper.getTotalMonthlyAmount(); }
    @Override public int  getTotalMonthlyVisit()          { return customerMapper.getTotalMonthlyVisit(); }

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
    @Override
    public int deleteCustomer(String c_idx) {
        int result = customerMapper.deleteCustomer(c_idx);
        // 연결된 회원 계정이 MEMBER 역할이면 함께 비활성화 (직원 계정은 유지)
        try {
            MemberVO linked = memberMapper.findByLinkedCustomer(c_idx);
            if (linked != null && "MEMBER".equals(linked.getRole())) {
                memberMapper.deactivateMember(linked.getM_idx());
            }
        } catch (Exception ignored) {}
        return result;
    }

    /**
     * 방문 기록 + 결제액 반영 후 자동 등급 산정 + 포인트 적립 + 방문 이력 저장
     *
     * 등급 기준 (이번 달 누적 기준):
     *   VIP  : 월 결제액 150,000원 이상  → 결제액의 10% 적립
     *   골드  : 월 10회+ 방문 OR 7만원+   →  결제액의  7% 적립
     *   실버  : 월  3회+ 방문 OR 3만원+   →  결제액의  5% 적립
     *   일반  : 위 조건 미충족             →  결제액의  2% 적립
     */
    @Override
    public int addVisitAndUpdateGrade(String c_idx, int amount, String menuItem, String note) {
        // monthly_visit / monthly_amount 컬럼이 없으면 visit_count 만 증가하는 레거시 방식으로 폴백
        Map<String, Object> params = new HashMap<>();
        params.put("c_idx",  c_idx);
        params.put("amount", amount);
        int result;
        try {
            result = customerMapper.addVisitWithAmount(params);
        } catch (Exception e) {
            result = customerMapper.addVisit(c_idx);
        }
        if (result > 0) {
            CustomerVO customer = customerMapper.getCustomerDetail(c_idx);
            int mv = customer.getMonthlyVisit();  // 컬럼 없으면 0 (resultMap 기본값)
            int ma = customer.getMonthlyAmount(); // 컬럼 없으면 0 (resultMap 기본값)

            // ── 등급 산정 ──────────────────────────────────────────
            String newGrade;
            if      (mv >= 30)                   newGrade = "VIP";
            else if (mv >= 15 || ma >= 70_000)   newGrade = "골드";
            else if (mv >= 5  || ma >= 30_000)   newGrade = "실버";
            else                                 newGrade = "일반";

            if (!newGrade.equals(customer.getGrade())) {
                customer.setGrade(newGrade);
                customerMapper.updateGrade(customer);
            }

            // ── 방문 이력 저장 (visit_log_t) ───────────────────────
            // visit_log_t 테이블 또는 last_visit_date 컬럼이 아직 생성되지 않은 경우에도
            // 기본 방문 기록(visit_count, monthly_visit, grade)은 이미 완료됐으므로 무시
            try {
                VisitLogVO log = new VisitLogVO();
                log.setC_idx(c_idx);
                log.setAmount(amount);
                log.setMenuItem(menuItem != null ? menuItem : "");
                log.setNote(note != null ? note : "");
                customerMapper.insertVisitLog(log);

                Map<String, Object> lvParams = new HashMap<>();
                lvParams.put("c_idx", c_idx);
                customerMapper.updateLastVisitDate(lvParams);
            } catch (Exception ignored) {
                // DB 마이그레이션 전 또는 테이블 미생성 시 방문 기록 자체는 정상 완료
            }

            // ── 포인트 적립 (결제액이 있을 때만) ──────────────────
            if (amount > 0) {
                int rate = switch (newGrade) {
                    case "VIP"  -> 10;
                    case "골드"  ->  7;
                    case "실버"  ->  5;
                    default      ->  2;
                };
                int pointsToAdd = (int) Math.round(amount * rate / 100.0);

                // 이 고객과 연결된 member_t 회원이 있으면 membership_t 포인트 적립
                try {
                    MemberVO linked = memberMapper.findByLinkedCustomer(c_idx);
                    if (linked != null) {
                        Map<String, Object> msParams = new HashMap<>();
                        msParams.put("userId",      Integer.parseInt(linked.getM_idx()));
                        msParams.put("grade",       newGrade);
                        msParams.put("pointsToAdd", pointsToAdd);
                        membershipMapper.upsertMembership(msParams);
                    }
                } catch (Exception ignored) {
                    // membership_t 미존재 시 포인트 적립 생략
                }
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
        map.put("keyword", "%" + keyword + "%");
        map.put("grade",   "전체".equals(grade) ? null : grade);
        return customerMapper.getSearchCount(map);
    }

    // ── 방문 이력 ──────────────────────────────────────────────
    @Override public List<VisitLogVO> getVisitLogs(String c_idx) { return customerMapper.getVisitLogs(c_idx); }

    // ── 태그 ───────────────────────────────────────────────────
    @Override public List<String> getTags(String c_idx) { return customerMapper.getTags(c_idx); }

    @Override
    public int addTag(String c_idx, String tag) {
        if (tag == null || tag.isBlank()) return 0;
        Map<String, Object> map = new HashMap<>();
        map.put("c_idx", c_idx);
        map.put("tag",   tag.trim());
        return customerMapper.insertTag(map);
    }

    @Override
    public int deleteTag(String c_idx, String tag) {
        Map<String, Object> map = new HashMap<>();
        map.put("c_idx", c_idx);
        map.put("tag",   tag);
        return customerMapper.deleteTag(map);
    }

    // ── 마케팅용 ───────────────────────────────────────────────
    @Override public List<CustomerVO> getInactiveCustomers(int days) { return customerMapper.getInactiveCustomers(days); }
    @Override public List<CustomerVO> getBirthdayCustomers()         { return customerMapper.getBirthdayCustomers(); }

    // ── 통계 ───────────────────────────────────────────────────
    @Override public List<Map<String, Object>> getGradeDistribution()   { return customerMapper.getGradeDistribution(); }
    @Override public List<Map<String, Object>> getMonthlyNewCustomers() { return customerMapper.getMonthlyNewCustomers(); }
    @Override public List<Map<String, Object>> getVisitDistribution()   { return customerMapper.getVisitDistribution(); }
    @Override public List<CustomerVO>          getTopByVisit(int limit) { return customerMapper.getTopByVisit(limit); }
    @Override public double                    getAvgVisitCount()       { return customerMapper.getAvgVisitCount(); }
    @Override public List<CustomerVO>          getCustomerProgress()    { return customerMapper.getCustomerProgress(); }
    @Override public List<Map<String, Object>> getHourlyStats()         { return customerMapper.getHourlyStats(); }
    @Override public List<Map<String, Object>> getWeekdayStats()        { return customerMapper.getWeekdayStats(); }
    @Override public List<Map<String, Object>> getTopMenuItems(int lim) { return customerMapper.getTopMenuItems(lim); }
    @Override public List<Map<String, Object>> getGradeAvgSpend()       { return customerMapper.getGradeAvgSpend(); }
}
