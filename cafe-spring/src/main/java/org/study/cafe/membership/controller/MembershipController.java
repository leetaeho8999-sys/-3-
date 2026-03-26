package org.study.cafe.membership.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.study.cafe.member.vo.MemberVO;
import org.study.cafe.membership.service.MembershipService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/membership")
public class MembershipController {
    @Autowired private MembershipService membershipService;

    @GetMapping({"","list"})
    public String membership(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember != null) {
            model.addAttribute("membership", membershipService.getByUserId(loginMember.getM_idx()));
        }
        return "membership/list";
    }
}
