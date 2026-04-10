package org.study.mypractice01.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import jakarta.servlet.http.HttpSession;

import org.study.mypractice01.service.MemberService;
import org.study.mypractice01.vo.MemberVO;

@Controller
public class MemberController {

    @Autowired
    private MemberService service;

    // ========================================================
    // 🚪 1. 화면(방)으로 안내하는 길잡이 역할 (@GetMapping)
    // ========================================================

    // 메인(로그인) 화면 띄우기
    @GetMapping("/")
    public String showMainPage() {
        return "index";
    }

    // 회원가입 화면 띄우기
    @GetMapping("/member/joinForm")
    public String showJoinForm() {
        return "joinForm";
    }

    // 로그아웃 처리 (세션 비우기)
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ========================================================
    // 🧑‍🍳 2. 데이터를 처리하는 진짜 업무 역할 (@PostMapping)
    // ========================================================

    // [회원가입] 진짜 데이터 저장하기
    @PostMapping("/member/join")
    public String join(MemberVO vo, Model model) {
        try {
            service.join(vo);
            return "redirect:/";
        } catch (Exception e) {
            model.addAttribute("errorMsg", "회원가입 중 문제가 발생했어요.");
            return "joinForm";
        }
    }

    // [로그인] 아이디/비번 확인 및 세션 저장
    @PostMapping("/member/loginOk")
    public String loginOk(MemberVO vo, HttpSession session, Model model) {
        MemberVO loginMember = service.login(vo);
        if(loginMember != null) {
            session.setAttribute("m_id", loginMember.getM_id());
            session.setAttribute("m_name", loginMember.getM_name());
            return "redirect:/";
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
            return "index";
        }
    }

    // ========================================================
    // ⚡ 3. 화면 새로고침 없이 '글자'만 주고받는 창구 (@ResponseBody)
    // ========================================================

    // [NEW] 아이디 중복 확인 (0: 사용가능, 1: 중복)
    @PostMapping("/member/idCheck")
    @ResponseBody
    public int idCheck(String m_id) {
        return service.idCheck(m_id);
    }

    // [NEW] 아이디 찾기 (이름, 전화번호 필요)
    @PostMapping("/member/findId")
    @ResponseBody
    public String findId(String m_name, String m_phone) {
        String foundId = service.findMemberId(m_name, m_phone);
        return (foundId != null) ? foundId : "fail";
    }

    // [기존] 비밀번호 찾기 (아이디, 전화번호 필요)
    @PostMapping("/member/findPw")
    @ResponseBody
    public String findPw(String m_id, String m_phone) {
        String foundPw = service.findMemberPw(m_id, m_phone);
        return (foundPw != null) ? foundPw : "fail";
    }

    // [기존] 비밀번호 재설정 (아이디, 새 비번 필요)
    @PostMapping("/member/updatePw")
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