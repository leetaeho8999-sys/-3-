package org.study.brewcrm.customer.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.customer.mapper.SchedulerLogMapper;
import org.study.brewcrm.member.mapper.MemberMapper;
import org.study.brewcrm.member.vo.MemberVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/customer/admin")
public class AdminController {

    @Autowired private SchedulerLogMapper schedulerLogMapper;
    @Autowired private MemberMapper       memberMapper;

    // ── 시스템 관리 메인 ─────────────────────────────────────
    @GetMapping
    public String admin(Model model) {
        // scheduler_log_t 미존재 시 빈 목록으로 대체
        try { model.addAttribute("schedulerLogs", schedulerLogMapper.getRecentLogs(50)); }
        catch (Exception e) { model.addAttribute("schedulerLogs", new ArrayList<>()); }

        model.addAttribute("members", memberMapper.getAllMembers());
        return "customer/admin";
    }

    // ── 직원 권한 변경 ────────────────────────────────────────
    @PostMapping("/updateRole")
    public String updateRole(@RequestParam String m_idx,
                             @RequestParam String role,
                             HttpSession session) {
        // 허용 권한 값만 설정 가능
        if (!role.matches("ADMIN|MANAGER|STAFF|MEMBER")) {
            return "redirect:/customer/admin?invalidRole=true";
        }
        // 자기 자신의 권한 변경 불가 (실수로 ADMIN 해제 방지)
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember != null && loginMember.getM_idx().equals(m_idx)) {
            return "redirect:/customer/admin?selfEdit=true";
        }
        Map<String, Object> params = new HashMap<>();
        params.put("m_idx", m_idx);
        params.put("role",  role);
        memberMapper.updateMemberRole(params);
        return "redirect:/customer/admin?roleUpdated=true";
    }

    // ── 직원 계정 삭제 (논리 삭제) ───────────────────────────
    @PostMapping("/deleteMember")
    public String deleteMember(@RequestParam String m_idx,
                               HttpSession session) {
        // 자기 자신은 삭제 불가
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember != null && loginMember.getM_idx().equals(m_idx)) {
            return "redirect:/customer/admin?selfDelete=true";
        }
        memberMapper.deactivateMember(m_idx);
        return "redirect:/customer/admin?memberDeleted=true";
    }
}
