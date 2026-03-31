package org.study.cafe.membership.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.study.cafe.member.service.MemberService;
import org.study.cafe.member.vo.MemberVO;
import org.study.cafe.membership.service.MembershipService;
import org.study.cafe.membership.vo.MembershipVO;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/membership")
public class MembershipController {
    @Autowired private MembershipService membershipService;
    @Autowired private MemberService     memberService;

    @GetMapping({"","list"})
    public String membership(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // customer_t JOIN으로 grade, visitCount 조회 (CRM과 동기화된 값)
        MemberVO info = memberService.findMyPageInfo(loginMember.getM_idx());

        if (info != null) {
            // MembershipVO에 CRM 등급 데이터를 담아서 전달 (기존 JSP 호환)
            MembershipVO ms = membershipService.getByUserId(loginMember.getM_idx());
            if (ms == null) ms = new MembershipVO();
            ms.setGrade(info.getGrade());
            ms.setUserId(loginMember.getM_idx());
            model.addAttribute("membership", ms);
            model.addAttribute("memberInfo", info);
        }
        return "membership/list";
    }
}
