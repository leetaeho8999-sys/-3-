package org.study.cafe.membership.controller;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.study.cafe.membership.service.MembershipService;
import org.study.cafe.membership.vo.MembershipVO;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/membership")
public class MembershipController {

    private static final Logger log = LoggerFactory.getLogger(MembershipController.class);

    @Autowired private MembershipService membershipService;

    @GetMapping({"", "list"})
    public String membership(HttpSession session, Model model) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";

        // 1. 이름 조회 (실패 시 세션 m_name 폴백)
        String memberName = null;
        try { memberName = membershipService.getMemberName(mId); }
        catch (Exception e) { log.warn("member 이름 조회 실패 (m_id={}): {}", mId, e.getMessage()); }
        if (memberName == null || memberName.isBlank()) {
            memberName = (String) session.getAttribute("m_name");
        }
        if (memberName == null) memberName = mId;

        // 2. 방문 횟수 조회 (실패 시 0)
        int visitCount = 0;
        try { visitCount = membershipService.getVisitCount(mId); }
        catch (Exception e) { log.warn("방문 횟수 조회 실패 (m_id={}): {}", mId, e.getMessage()); }

        // 3. 등급 실시간 재계산
        String grade = calcGrade(visitCount);

        // 4. membership_t getOrCreate → grade·points 업데이트
        int points = visitCount * 100;
        MembershipVO ms = new MembershipVO();
        ms.setGrade(grade);
        ms.setPoints(points);
        try {
            ms = membershipService.getOrCreate(mId, grade, points);
            membershipService.updateGradeAndPoints(mId, grade, points);
            ms.setGrade(grade);
            ms.setPoints(points);
        } catch (Exception e) {
            log.warn("membership_t upsert 실패 (m_id={}): {}", mId, e.getMessage());
        }

        // 5. 진행도 계산
        int progressPct  = calcProgressPct(grade, visitCount);
        int remainCount  = calcRemainCount(grade, visitCount);
        String nextGrade = calcNextGrade(grade);

        // 6. memberInfo 맵 구성
        Map<String, Object> memberInfo = new HashMap<>();
        memberInfo.put("username",    memberName);
        memberInfo.put("grade",       grade);
        memberInfo.put("visitCount",  visitCount);
        memberInfo.put("progressPct", progressPct);
        memberInfo.put("remainCount", remainCount);
        memberInfo.put("nextGrade",   nextGrade);

        model.addAttribute("memberInfo", memberInfo);
        model.addAttribute("membership", ms);
        return "membership/list";
    }

    private String calcGrade(int v) {
        if (v >= 30) return "VIP";
        if (v >= 10) return "골드";
        if (v >= 3)  return "실버";
        return "일반";
    }

    private int calcProgressPct(String grade, int v) {
        return switch (grade) {
            case "일반" -> (int) Math.min(100, (v / 3.0) * 100);
            case "실버" -> (int) Math.min(100, ((v - 3) / 7.0) * 100);
            case "골드" -> (int) Math.min(100, ((v - 10) / 20.0) * 100);
            default -> 100; // VIP
        };
    }

    private int calcRemainCount(String grade, int v) {
        return switch (grade) {
            case "일반" -> Math.max(0, 3 - v);
            case "실버" -> Math.max(0, 10 - v);
            case "골드" -> Math.max(0, 30 - v);
            default -> 0;
        };
    }

    private String calcNextGrade(String grade) {
        return switch (grade) {
            case "일반" -> "실버";
            case "실버" -> "골드";
            case "골드" -> "VIP";
            default -> "VIP";
        };
    }
}
