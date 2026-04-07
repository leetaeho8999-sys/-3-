package org.study.brewcrm.customer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.customer.mapper.CouponMapper;
import org.study.brewcrm.customer.service.CustomerService;
import org.study.brewcrm.member.mapper.MemberMapper;
import org.study.brewcrm.member.vo.MemberVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/customer/marketing")
public class MarketingController {

    @Autowired private CustomerService customerService;
    @Autowired private CouponMapper    couponMapper;
    @Autowired private MemberMapper    memberMapper;

    // ── 마케팅 메인 ──────────────────────────────────────────
    @GetMapping
    public String marketing(Model model) {
        // last_visit_date 컬럼 또는 customer_coupon_t 미존재 시 빈 목록으로 대체
        try { model.addAttribute("inactiveCustomers", customerService.getInactiveCustomers(28)); }
        catch (Exception e) { model.addAttribute("inactiveCustomers", new ArrayList<>()); }

        try { model.addAttribute("birthdayCustomers", customerService.getBirthdayCustomers()); }
        catch (Exception e) { model.addAttribute("birthdayCustomers", new ArrayList<>()); }

        try { model.addAttribute("activeCoupons", couponMapper.getActiveCoupons()); }
        catch (Exception e) { model.addAttribute("activeCoupons", new ArrayList<>()); }

        try { model.addAttribute("recentIssued", couponMapper.getRecentIssuedCoupons(30)); }
        catch (Exception e) { model.addAttribute("recentIssued", new ArrayList<>()); }

        return "customer/marketing";
    }

    // ── 쿠폰 수동 발급 ────────────────────────────────────────
    @PostMapping("/issueCoupon")
    public String issueCoupon(@RequestParam String  c_idx,
                              @RequestParam int     couponIdx,
                              @RequestParam int     expireDays) {
        Map<String, Object> params = new HashMap<>();
        params.put("c_idx",      c_idx);
        params.put("couponIdx",  couponIdx);
        params.put("expireDays", expireDays);
        couponMapper.issueCoupon(params);
        return "redirect:/customer/marketing?issued=true";
    }

    // ── 쿠폰 회수 ────────────────────────────────────────────
    @PostMapping("/revokeCoupon")
    public String revokeCoupon(@RequestParam int cc_idx) {
        couponMapper.revokeCoupon(cc_idx);
        return "redirect:/customer/marketing?revoked=true";
    }

    // ── 포인트 조정 (회원 연동 고객만) ─────────────────────
    @PostMapping("/adjustPoints")
    public String adjustPoints(@RequestParam String c_idx,
                               @RequestParam int    delta) {
        MemberVO linked = memberMapper.findByLinkedCustomer(c_idx);
        if (linked != null) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", Integer.parseInt(linked.getM_idx()));
            params.put("delta",  delta);
            couponMapper.adjustPoints(params);
        }
        return "redirect:/customer/detail?c_idx=" + c_idx + "&pointsAdjusted=true";
    }
}
