package org.study.brewcrm.customer.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.common.Paging;
import org.study.brewcrm.customer.mapper.CouponMapper;
import org.study.brewcrm.customer.service.CustomerService;
import org.study.brewcrm.customer.vo.CustomerVO;
import org.study.brewcrm.order.mapper.OrderMapper;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired private CustomerService customerService;
    @Autowired private CouponMapper    couponMapper;
    @Autowired private OrderMapper     orderMapper;

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

        // ── 웹사이트 주문(order_t) 실시간 반영 ─────────────────
        // cafe-spring 이 같은 team3_db 의 order_t 에 PAID 로 저장하면 즉시 반영됨.
        // order_t / order_item_t 가 미생성된 환경에서도 페이지 로드 보장.
        try {
            model.addAttribute("webMonthlyAmount", orderMapper.getPaidTotalThisMonth());
            model.addAttribute("webMonthlyCount",  orderMapper.getPaidCountThisMonth());
            model.addAttribute("recentWebOrders",  orderMapper.getRecentPaidOrders(8));
        } catch (Exception e) {
            model.addAttribute("webMonthlyAmount", 0L);
            model.addAttribute("webMonthlyCount",  0);
            model.addAttribute("recentWebOrders",  new ArrayList<>());
        }
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
        // 웹 주문 내역 (order_t 미생성 환경에서도 페이지 로드 보장)
        try { model.addAttribute("webOrders", orderMapper.getOrdersByCustomer(c_idx)); }
        catch (Exception e) { model.addAttribute("webOrders", new java.util.ArrayList<>()); }
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
               ? "redirect:/customer/detail?c_idx=" + customerVO.getC_idx() + "&edited=true"
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

    // ── CSV 내보내기 ────────────────────────────────────────────
    @GetMapping("/export")
    public void export(HttpServletResponse response) throws Exception {
        String filename = URLEncoder.encode("고객목록_" +
                java.time.LocalDate.now() + ".csv", StandardCharsets.UTF_8);
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        List<CustomerVO> list = customerService.getAllCustomersForExport();

        // BOM: Excel에서 한글 깨짐 방지
        PrintWriter pw = new PrintWriter(
                new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8));
        pw.print('﻿');
        pw.println("번호,이름,연락처,등급,총방문,이번달방문,이번달매출,생일,최근방문일,등록일,메모");
        for (CustomerVO c : list) {
            pw.printf("%s,%s,%s,%s,%d,%d,%d,%s,%s,%s,\"%s\"%n",
                    esc(c.getC_idx()),
                    esc(c.getName()),
                    esc(c.getPhone()),
                    esc(c.getGrade()),
                    c.getVisitCount(),
                    c.getMonthlyVisit(),
                    c.getMonthlyAmount(),
                    esc(c.getBirthday()),
                    esc(c.getLastVisitDate()),
                    esc(c.getRegDate()),
                    esc(c.getMemo()));
        }
        pw.flush();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\"", "\"\"");
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
