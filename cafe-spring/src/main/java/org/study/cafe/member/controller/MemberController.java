package org.study.cafe.member.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.cafe.member.service.MemberService;
import org.study.cafe.member.vo.MemberVO;

/**
 * 회원 컨트롤러 — mypractice01 방식으로 재구성
 * RedirectAttributes 플래시 메시지, MemberVO 통합 파라미터 사용
 */
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired private MemberService memberService;

    // ── 로그인 폼 ─────────────────────────────────────────────────────────
    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    // ── 로그인 처리 — mypractice01의 loginOk() 방식 ───────────────────────
    @PostMapping("/loginOk")
    public String loginOk(MemberVO vo, HttpSession session, RedirectAttributes rttr) {
        MemberVO result = memberService.login(vo.getEmail(), vo.getPassword());

        if (result != null) {
            session.setAttribute("loginMember", result);
            rttr.addFlashAttribute("msg", "환영합니다, " + result.getUsername() + "님! ☕");
            return "redirect:/";
        } else {
            rttr.addFlashAttribute("errorMsg", "이메일 또는 비밀번호가 올바르지 않습니다.");
            return "redirect:/member/login";
        }
    }

    // ── 로그아웃 — mypractice01의 logout() 방식 ─────────────────────────
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

    // ── 회원가입 처리 — mypractice01의 joinOk() 방식 ─────────────────────
    @PostMapping("/registerOk")
    public String registerOk(MemberVO vo, RedirectAttributes rttr) {
        if (memberService.checkEmail(vo.getEmail()) > 0) {
            rttr.addFlashAttribute("errorMsg", "이미 사용 중인 이메일입니다.");
            return "redirect:/member/register";
        }
        memberService.register(vo);
        rttr.addFlashAttribute("msg", "회원가입이 성공적으로 완료되었습니다!");
        return "redirect:/member/login";
    }

    // ── 마이페이지 ────────────────────────────────────────────────────────
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        MemberVO info = memberService.findMyPageInfo(loginMember.getM_idx());
        if (info != null) model.addAttribute("memberInfo", info);
        return "member/mypage";
    }

    // ── 정보 수정 ─────────────────────────────────────────────────────────
    @PostMapping("/updateOk")
    public String updateOk(MemberVO vo, HttpSession session, Model model) {
        int r = memberService.updateMember(vo);
        if (r > 0) {
            MemberVO updated = memberService.findMyPageInfo(vo.getM_idx());
            session.setAttribute("loginMember", updated);
            model.addAttribute("memberInfo", updated);
            model.addAttribute("success", "정보가 업데이트되었습니다.");
        }
        return "member/mypage";
    }

    // ── 회원탈퇴 ──────────────────────────────────────────────────────────
    @PostMapping("/deleteOk")
    public String deleteOk(@RequestParam String m_idx, HttpSession session) {
        memberService.deleteMember(m_idx);
        session.invalidate();
        return "redirect:/";
    }
}
