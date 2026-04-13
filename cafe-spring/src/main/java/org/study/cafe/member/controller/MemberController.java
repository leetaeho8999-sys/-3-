package org.study.cafe.member.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.member.service.MemberService;
import org.study.cafe.member.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService service;

    // ── /member → /member/login 리다이렉트 ───────────────────────────────
    @GetMapping({"", "/"})
    public String root() {
        return "redirect:/member/login";
    }

    // ── 로그인 폼 ─────────────────────────────────────────────────────────
    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    // ── 로그인 처리 ───────────────────────────────────────────────────────
    @PostMapping("/loginOk")
    public String loginOk(MemberVO vo, HttpSession session, Model model) {
        MemberVO loginMember = service.login(vo);
        if (loginMember != null) {
            session.setAttribute("m_id", loginMember.getM_id());
            session.setAttribute("m_name", loginMember.getM_name());
            return "redirect:/";
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
            return "member/login";
        }
    }

    // ── 로그아웃 ──────────────────────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ── 회원가입 폼 ───────────────────────────────────────────────────────
    @GetMapping("/register")
    public String registerForm() {
        return "member/register";
    }

    // ── 회원가입 처리 ─────────────────────────────────────────────────────
    @PostMapping("/registerOk")
    public String registerOk(MemberVO vo, Model model) {
        try {
            service.join(vo);
            return "redirect:/member/login";
        } catch (Exception e) {
            model.addAttribute("errorMsg", "회원가입 중 문제가 발생했어요.");
            return "member/register";
        }
    }

    // ── 아이디 중복 확인 ──────────────────────────────────────────────────
    @PostMapping("/idCheck")
    @ResponseBody
    public int idCheck(String m_id) {
        return service.idCheck(m_id);
    }

    // ── 아이디 찾기 ───────────────────────────────────────────────────────
    @PostMapping("/findId")
    @ResponseBody
    public String findId(String m_name, String m_phone) {
        String foundId = service.findMemberId(m_name, m_phone);
        return (foundId != null) ? foundId : "fail";
    }

    // ── 비밀번호 찾기 ─────────────────────────────────────────────────────
    @PostMapping("/findPw")
    @ResponseBody
    public String findPw(String m_id, String m_phone) {
        String foundPw = service.findMemberPw(m_id, m_phone);
        return (foundPw != null) ? foundPw : "fail";
    }

    // ── 비밀번호 재설정 ───────────────────────────────────────────────────
    @PostMapping("/updatePw")
    @ResponseBody
    public String updatePw(String m_id, String m_pw) {
        try {
            service.updatePw(m_id, m_pw);
            return "success";
        } catch (Exception e) {
            return "fail";
        }
    }
}
