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

    @Autowired private MemberService memberService;

    // 로그인 폼
    @GetMapping("/login")
    public String loginForm() { return "member/login"; }

    // 로그인 처리
    @PostMapping("/loginOk")
    public String loginOk(@RequestParam String email,
                          @RequestParam String password,
                          HttpSession session, Model model) {
        MemberVO m = memberService.login(email, password);
        if (m == null) {
            model.addAttribute("error", "이메일 또는 비밀번호가 올바르지 않습니다.");
            return "member/login";
        }
        session.setAttribute("loginMember", m);
        return "redirect:/";
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // 회원가입 폼
    @GetMapping("/register")
    public String registerForm() { return "member/register"; }

    // 회원가입 처리
    @PostMapping("/registerOk")
    public String registerOk(MemberVO vo,
                             @RequestParam String confirmPassword,
                             @RequestParam(defaultValue="false") boolean agreeTerms,
                             @RequestParam(defaultValue="false") boolean agreePrivacy,
                             Model model) {
        if (!agreeTerms || !agreePrivacy) {
            model.addAttribute("error", "필수 약관에 동의해주세요."); return "member/register";
        }
        int r = memberService.register(vo, confirmPassword);
        if      (r == -1) { model.addAttribute("error", "비밀번호가 일치하지 않습니다."); return "member/register"; }
        else if (r == -2) { model.addAttribute("error", "비밀번호는 최소 8자 이상이어야 합니다."); return "member/register"; }
        else if (r == -3) { model.addAttribute("error", "이미 사용 중인 이메일입니다."); return "member/register"; }
        else if (r == -4) { model.addAttribute("error", "이미 사용 중인 닉네임입니다."); return "member/register"; }
        else if (r <= 0)  { model.addAttribute("error", "회원가입에 실패했습니다."); return "member/register"; }
        return "redirect:/member/login?registered=true";
    }

    // 마이페이지
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        // customer_t JOIN으로 grade, visitCount 포함한 최신 정보 조회
        MemberVO info = memberService.findMyPageInfo(loginMember.getM_idx());
        if (info != null) model.addAttribute("memberInfo", info);
        return "member/mypage";
    }

    // 정보 수정
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

    // 회원탈퇴
    @PostMapping("/deleteOk")
    public String deleteOk(@RequestParam String m_idx, HttpSession session) {
        memberService.deleteMember(m_idx);
        session.invalidate();
        return "redirect:/";
    }
}
