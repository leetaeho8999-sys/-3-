package org.study.brewcrm.customer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.common.Paging;
import org.study.brewcrm.customer.service.CustomerService;
import org.study.brewcrm.customer.vo.CustomerVO;

import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired private CustomerService customerService;

    // ── 대시보드 ────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalCount", customerService.getCount());
        model.addAttribute("vipCount",   customerService.getCountByGrade("VIP"));
        model.addAttribute("goldCount",  customerService.getCountByGrade("골드"));
        model.addAttribute("newCount",   customerService.getCountThisMonth());
        model.addAttribute("silverCount",customerService.getCountByGrade("실버"));
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
        model.addAttribute("customer", customer);
        return "customer/detail";
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

    // ── 방문 횟수 추가 (POST로 변경, 자동 등급 업데이트) ────
    @PostMapping("/addVisit")
    public String addVisit(@RequestParam String c_idx,
                           @RequestParam(defaultValue="1")  int    nowPage,
                           @RequestParam(defaultValue="")   String keyword,
                           @RequestParam(defaultValue="전체") String grade) {
        customerService.addVisitAndUpdateGrade(c_idx);
        return "redirect:/customer/list?nowPage=" + nowPage
             + "&keyword=" + keyword
             + "&grade="   + grade;
    }
}
