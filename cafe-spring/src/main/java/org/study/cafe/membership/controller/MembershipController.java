package org.study.cafe.membership.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.study.cafe.membership.service.MembershipService;
import org.study.cafe.membership.vo.MembershipVO;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/membership")
public class MembershipController {

    @Autowired private MembershipService membershipService;

    @GetMapping({"", "list"})
    public String membership(HttpSession session, Model model) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";

        // 새로운 member 테이블은 membership_t와 연동되지 않으므로 빈 상태 표시
        MembershipVO ms = new MembershipVO();
        ms.setGrade("일반");
        ms.setPoints(0);
        model.addAttribute("membership", ms);
        model.addAttribute("memberName", session.getAttribute("m_name"));
        return "membership/list";
    }
}
