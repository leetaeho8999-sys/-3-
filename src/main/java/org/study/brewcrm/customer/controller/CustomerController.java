package org.study.brewcrm.customer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.common.Paging;
import org.study.brewcrm.customer.mapper.CouponMapper;
import org.study.brewcrm.customer.service.CustomerService;
import org.study.brewcrm.customer.vo.CustomerVO;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired private CustomerService customerService;
    @Autowired private CouponMapper    couponMapper;

    // ── 대시보드 ────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalCount",        customerService.getCount());
        model.addAttribute("vipCount",          customerService.getCountByGrade("VIP"));
        model.addAttribute("goldCount",         customerService.getCountByGrade("골드"));
        model.addAttribute("silverCount",       customerService.getCountByGrade("실버"));
        model.addAttribute("newCount",          customerService.getCountThisMonth());
        model.addAttribute("totalMonthlyAmount",customerService.getTotalMonthlyAmount());
        model.addAttribute("totalMonthlyVisit", customerService.getTotalMonthlyVisit());
        List<CustomerVO> recentList = customerService.getCustomerList(5, 0, "전체");
        model.addAttribute("recentList", recentList);
        return "customer/dashboard";
    }

    // ── 고객 목록 (등급 필터 버그 수정) ────────────────────
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue="1")   int    nowPage,
                       @RequestParam(defaultValue="")    String keyword,
                       @RequestParam(defaultValue="전체") String grade,
                       Model model) {
        Paging paging = new Paging();
        paging.setNowPage(nowPage);

        int count;
        if (!keyword.isEmpty()) {
            count = customerService.getSearchCount(keyword, grade);
        } else if (!"전체".equals(grade)) {
            count = customerService.getCountByGrade(grade);
        } else {
            count = customerService.getCount();
        }

        paging.setTotalRecord(count);
        int tp = count <= paging.getNumPerPage() ? 1
               : count / paging.getNumPerPage() + (count % paging.getNumPerPage() != 0 ? 1 : 0);
        paging.setTotalPage(tp);
        paging.setOffset((nowPage - 1) * paging.getNumPerPage());

        int bb = (int)(((nowPage - 1) / paging.getPagePerBlock()) * paging.getPagePerBlock() + 1);
        int eb = Math.min(bb + paging.getPagePerBlock() - 1, paging.getTotalPage());
        paging.setBeginBlock(bb);
        paging.setEndBlock(eb);

        List<CustomerVO> list = keyword.isEmpty()
                ? customerService.getCustomerList(paging.getNumPerPage(), paging.getOffset(), grade)
                : customerService.searchCustomer(keyword, paging.getNumPerPage(), paging.getOffset(), grade);

        model.addAttribute("list",    list);
        model.addAttribute("paging",  paging);
        model.addAttribute("keyword", keyword);
        model.addAttribute("grade",   grade);
        return "customer/list";
    }

    // ── 고객 등록 폼 ────────────────────────────────────────
    @GetMapping("/register")
    public String registerForm() { return "customer/register"; }

    // ── 고객 등록 처리 ──────────────────────────────────────
    @PostMapping("/registerOk")
    public String registerOk(CustomerVO customerVO) {
        return customerService.insertCustomer(customerVO) > 0
               ? "redirect:/customer/list"
               : "customer/error";
    }

    // ── 고객 상세 ───────────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam String c_idx, Model model) {
        CustomerVO customer = customerService.getCustomerDetail(c_idx);
        if (customer == null) return "customer/error";
        model.addAttribute("customer",  customer);
        model.addAttribute("visitLogs", customerService.getVisitLogs(c_idx));
        model.addAttribute("tags",      customerService.getTags(c_idx));
        // 보유 쿠폰 목록 (coupon_t, customer_coupon_t 미존재 시 빈 목록)
        try { model.addAttribute("customerCoupons", couponMapper.getCustomerCoupons(c_idx)); }
        catch (Exception e) { model.addAttribute("customerCoupons", new java.util.ArrayList<>()); }
        return "customer/detail";
    }

    // ── 태그 추가 ────────────────────────────────────────────
    @PostMapping("/addTag")
    public String addTag(@RequestParam String c_idx, @RequestParam String tag) {
        customerService.addTag(c_idx, tag);
        return "redirect:/customer/detail?c_idx=" + c_idx + "#tags";
    }

    // ── 태그 삭제 ────────────────────────────────────────────
    @PostMapping("/deleteTag")
    public String deleteTag(@RequestParam String c_idx, @RequestParam String tag) {
        customerService.deleteTag(c_idx, tag);
        return "redirect:/customer/detail?c_idx=" + c_idx + "#tags";
    }

    // ── 수정 폼 ─────────────────────────────────────────────
    @GetMapping("/edit")
    public String editForm(@RequestParam String c_idx, Model model) {
        CustomerVO customer = customerService.getCustomerDetail(c_idx);
        if (customer == null) return "customer/error";
        model.addAttribute("customer", customer);
        return "customer/edit";
    }

    // ── 수정 처리 ───────────────────────────────────────────
    @PostMapping("/editOk")
    public String editOk(CustomerVO customerVO) {
        return customerService.updateCustomer(customerVO) > 0
               ? "redirect:/customer/detail?c_idx=" + customerVO.getC_idx()
               : "customer/error";
    }

    // ── 삭제 ────────────────────────────────────────────────
    @GetMapping("/delete")
    public String delete(@RequestParam String c_idx) {
        customerService.deleteCustomer(c_idx);
        return "redirect:/customer/list";
    }

    // ── 통계 페이지 ─────────────────────────────────────────────
    @GetMapping("/stats")
    public String stats(Model model) {
        model.addAttribute("totalCount",          customerService.getCount());
        model.addAttribute("vipCount",            customerService.getCountByGrade("VIP"));
        model.addAttribute("newCount",            customerService.getCountThisMonth());
        model.addAttribute("avgVisit",            Math.round(customerService.getAvgVisitCount() * 10) / 10.0);
        model.addAttribute("gradeDistribution",   customerService.getGradeDistribution());
        model.addAttribute("monthlyNewCustomers", customerService.getMonthlyNewCustomers());
        model.addAttribute("visitDistribution",   customerService.getVisitDistribution());
        model.addAttribute("topCustomers",        customerService.getTopByVisit(10));

        // monthly_visit·monthly_amount 컬럼 마이그레이션 전에도 페이지 로드 보장
        try { model.addAttribute("customerProgress", customerService.getCustomerProgress()); }
        catch (Exception e) { model.addAttribute("customerProgress", new ArrayList<>()); }

        // visit_log_t 기반 통계 — 테이블 미존재 시 빈 목록으로 대체
        try { model.addAttribute("hourlyStats",   customerService.getHourlyStats()); }
        catch (Exception e) { model.addAttribute("hourlyStats", new ArrayList<>()); }

        try { model.addAttribute("weekdayStats",  customerService.getWeekdayStats()); }
        catch (Exception e) { model.addAttribute("weekdayStats", new ArrayList<>()); }

        try { model.addAttribute("topMenuItems",  customerService.getTopMenuItems(10)); }
        catch (Exception e) { model.addAttribute("topMenuItems", new ArrayList<>()); }

        try { model.addAttribute("gradeAvgSpend", customerService.getGradeAvgSpend()); }
        catch (Exception e) { model.addAttribute("gradeAvgSpend", new ArrayList<>()); }

        return "customer/stats";
    }

    // ── 방문 기록 (결제액 + 메뉴 + 메모, 자동 등급 업데이트) ─
    @PostMapping("/addVisit")
    public String addVisit(@RequestParam String c_idx,
                           @RequestParam(defaultValue="0")    int    amount,
                           @RequestParam(defaultValue="")     String menuItem,
                           @RequestParam(defaultValue="")     String note,
                           @RequestParam(defaultValue="list") String redirect,
                           @RequestParam(defaultValue="1")    int    nowPage,
                           @RequestParam(defaultValue="")     String keyword,
                           @RequestParam(defaultValue="전체")  String grade) {
        customerService.addVisitAndUpdateGrade(c_idx, amount, menuItem, note);
        if ("detail".equals(redirect)) {
            return "redirect:/customer/detail?c_idx=" + c_idx;
        }
        String encKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);
        String encGrade   = URLEncoder.encode(grade,   StandardCharsets.UTF_8);
        return "redirect:/customer/list?nowPage=" + nowPage
             + "&keyword=" + encKeyword
             + "&grade="   + encGrade;
    }
}
