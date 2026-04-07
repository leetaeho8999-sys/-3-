package org.study.brewcrm.member.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.member.service.MemberService;
import org.study.brewcrm.member.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired private MemberService memberService;

    // ── 로그인 폼 ──────────────────────────────────────────
    @GetMapping("/login")
    public String loginForm() { return "member/login"; }

    // ── 로그인 처리 ─────────────────────────────────────────
    @PostMapping("/loginOk")
    public String loginOk(@RequestParam String email,
                          @RequestParam String password,
                          @RequestParam(defaultValue = "") String redirect,
                          HttpSession session, Model model) {
        MemberVO member = memberService.login(email, password);
        if (member == null) {
            model.addAttribute("error", "이메일 또는 비밀번호가 올바르지 않습니다.");
            return "member/login";
        }
        session.setAttribute("loginMember", member);
        // 인터셉터가 보내준 원래 페이지로 복귀 (오픈 리다이렉트 방지: 내부 경로만 허용)
        if (!redirect.isEmpty() && redirect.startsWith("/")) {
            return "redirect:" + redirect;
        }
        // 역할별 기본 이동: 고객(MEMBER) → 마이페이지, 직원/관리자 → CRM 대시보드
        String role = member.getRole();
        if (role == null || "MEMBER".equals(role)) {
            return "redirect:/member/mypage";
        }
        return "redirect:/customer/dashboard";
    }

    // ── 로그아웃 ───────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/member/login";
    }

    // ── 회원가입 폼 ─────────────────────────────────────────
    @GetMapping("/register")
    public String registerForm() { return "member/register"; }

    // ── 회원가입 처리 ───────────────────────────────────────
    @PostMapping("/registerOk")
    public String registerOk(MemberVO memberVO,
                             @RequestParam String confirmPassword,
                             Model model) {
        int result = memberService.register(memberVO, confirmPassword);
        if (result == -1) { model.addAttribute("error", "비밀번호가 일치하지 않습니다.");        return "member/register"; }
        if (result == -2) { model.addAttribute("error", "비밀번호는 최소 6자 이상이어야 합니다."); return "member/register"; }
        if (result == -3) { model.addAttribute("error", "이미 사용 중인 이메일입니다.");          return "member/register"; }
        if (result <= 0)  { model.addAttribute("error", "회원가입에 실패했습니다.");              return "member/register"; }
        return "redirect:/member/login?registered=true";
    }

    // ── 마이페이지 (등급 표시) ───────────────────────────────
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        // 최신 등급/방문횟수 포함하여 재조회
        MemberVO info = memberService.findMyPageInfo(loginMember.getM_idx());
        if (info == null) { // 탈퇴 계정 등 비정상 상태 방어
            session.invalidate();
            return "redirect:/member/login";
        }
        model.addAttribute("myInfo", info);
        return "member/mypage";
    }

    // ── 정보 수정 처리 ──────────────────────────────────────
    @PostMapping("/updateOk")
    public String updateOk(MemberVO memberVO, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        // 폼 hidden 값 변조 방어: m_idx는 반드시 세션에서 적용
        memberVO.setM_idx(loginMember.getM_idx());
        memberService.updateMember(memberVO);
        MemberVO updated = memberService.findMyPageInfo(loginMember.getM_idx());
        session.setAttribute("loginMember", updated);
        return "redirect:/member/mypage?updated=true";
    }
}
