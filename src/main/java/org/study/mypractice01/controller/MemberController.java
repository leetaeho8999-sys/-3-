package org.study.mypractice01.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.mypractice01.service.MemberService;
import org.study.mypractice01.vo.MemberVO;

@Controller
public class MemberController {

    @Autowired
    private MemberService service;

    /**
     * 1. 메인 페이지 (index.jsp) 길잡이
     * 로그인 성공 후 "/" 주소로 올 때 404 에러를 방지합니다.
     */
    @GetMapping("/")
    public String home() {
        return "index";
    }

    /**
     * 2. 로그인/회원가입 폼 화면 (join.jsp)
     */
    @GetMapping("/join")
    public String showJoinForm() {
        return "join";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "join";
    }

    /**
     * 3. 로그인 처리 (POST)
     */
    @PostMapping("/member/loginOk")
    public String loginOk(String m_id, String m_pw, HttpSession session, Model model) {
        MemberVO vo = service.login(m_id);

        if (vo != null && vo.getM_pw().equals(m_pw)) {
            // 로그인 성공 시 세션에 정보 저장
            session.setAttribute("m_id", vo.getM_id());
            session.setAttribute("m_name", vo.getM_name());
            // 메인 페이지("/")로 이동
            return "redirect:/";
        } else {
            // 로그인 실패 시 에러 메시지와 함께 다시 로그인 페이지로
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
            return "join";
        }
    }

    /**
     * 4. 로그아웃 처리
     * index.jsp의 로그아웃 버튼 주소가 "/member/logout"일 때 작동합니다.
     */
    @GetMapping("/member/logout")
    public String logout(HttpSession session) {
        // 세션 정보 삭제
        session.invalidate();
        // 로그아웃 후 다시 로그인 페이지로 이동
        return "redirect:/join";
    }

    /**
     * 5. 회원가입 처리
     */
    @PostMapping("/member/join")
    public String join(MemberVO vo) {
        service.join(vo);
        return "redirect:/join";
    }

    /**
     * 6. 아이디 중복 체크 (AJAX)
     */
    @PostMapping("/member/idCheck")
    @ResponseBody
    public int idCheck(@RequestParam("m_id") String m_id) {
        return service.idCheck(m_id);
    }

    /**
     * 7. 아이디 찾기 (AJAX)
     */
    @PostMapping("/member/findId")
    @ResponseBody
    public String findId(String m_name, String m_phone) {
        String id = service.findMemberId(m_name, m_phone);
        return (id != null) ? id : "fail";
    }

    /**
     * 8. 비밀번호 찾기 (AJAX)
     */
    @PostMapping("/member/findPw")
    @ResponseBody
    public String findPw(String m_id, String m_phone) {
        String pw = service.findMemberPw(m_id, m_phone);
        return (pw != null) ? pw : "fail";
    }

    /**
     * 9. 비밀번호 재설정 (AJAX)
     */
    @PostMapping("/member/updatePw")
    @ResponseBody
    public String updatePw(String m_id, String m_pw) {
        service.updatePw(m_id, m_pw);
        return "success";
    }
}