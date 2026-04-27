package org.study.cafe.member.controller;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.cafe.board.service.BoardService;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.member.service.MemberService;
import org.study.cafe.member.vo.MemberVO;
import org.study.cafe.membership.service.MembershipService;
import org.study.cafe.order.service.OrderService;
import org.study.cafe.order.vo.OrderVO;
import org.study.cafe.point.service.PointService;
import org.study.cafe.point.vo.PointHistoryVO;

import java.util.List;

@Controller
@RequestMapping("/member")
public class MemberController {

    private static final Logger log = LoggerFactory.getLogger(MemberController.class);

    @Autowired
    private MemberService service;

    @Autowired
    private BoardService boardService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private MembershipService membershipService;

    @Autowired
    private PointService pointService;

    // ── /member → /member/login 리다이렉트 ───────────────────────────────
    @GetMapping({"", "/"})
    public String root() {
        return "redirect:/member/login";
    }

    // ── 로그인 폼 ─────────────────────────────────────────────────────────
    @GetMapping("/login")
    public String loginForm(@RequestParam(required = false) String redirect, Model model) {
        model.addAttribute("redirect", redirect);
        return "member/login";
    }

    // ── 로그인 처리 ───────────────────────────────────────────────────────
    @PostMapping("/loginOk")
    public String loginOk(MemberVO vo,
                          @RequestParam(required = false) String redirect,
                          HttpSession session,
                          Model model) {
        MemberVO loginMember = service.login(vo);
        if (loginMember != null) {
            session.setAttribute("m_id", loginMember.getM_id());
            session.setAttribute("m_name", loginMember.getM_name());
            if (isSafeRedirect(redirect)) {
                return "redirect:" + redirect;
            }
            return "redirect:/";
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
            model.addAttribute("redirect", redirect);   // 실패 시에도 폼에 유지
            return "member/login";
        }
    }

    // ── 오픈 리다이렉트 방지 — 내부 경로만 허용 ───────────────────────────
    private boolean isSafeRedirect(String target) {
        if (target == null || target.isBlank()) return false;
        // '/' 로 시작하되 '//' 나 '/\' 는 차단 (프로토콜 상대 URL 방지)
        if (!target.startsWith("/")) return false;
        if (target.startsWith("//") || target.startsWith("/\\")) return false;
        return true;
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
            // 가입 축하: membership_t 행 생성(있으면 그대로) → 1,000P 즉시 지급
            try {
                membershipService.getOrCreate(vo.getM_id(), "일반", 0);
                pointService.grantSignupBonus(vo.getM_id());
            } catch (Exception bonusEx) {
                // 가입 자체는 성공했으므로 보너스 실패는 로그만 남기고 흐름 유지
                log.warn("가입 축하 포인트 지급 실패 mId={}: {}", vo.getM_id(), bonusEx.getMessage());
            }
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

    // ════════════════════════════════════════════════════════════════
    // 마이페이지
    // ════════════════════════════════════════════════════════════════

    // ── 비밀번호 확인 폼 ──────────────────────────────────────────────────
    @GetMapping("/mypage")
    public String mypageConfirmForm(HttpSession session) {
        if (session.getAttribute("m_id") == null) return "redirect:/member/login";
        return "member/mypage_confirm";
    }

    // ── 비밀번호 확인 처리 ────────────────────────────────────────────────
    @PostMapping("/mypageConfirm")
    public String mypageConfirm(@RequestParam("m_pw") String m_pw,
                                HttpSession session,
                                RedirectAttributes rttr) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";

        MemberVO loginVO = new MemberVO();
        loginVO.setM_id(mId);
        loginVO.setM_pw(m_pw);

        if (service.login(loginVO) != null) {
            session.setAttribute("mypageAuth", true);
            return "redirect:/member/mypageMain";
        } else {
            rttr.addFlashAttribute("errorMsg", "비밀번호가 올바르지 않습니다.");
            return "redirect:/member/mypage";
        }
    }

    // ── 마이페이지 메인 ───────────────────────────────────────────────────
    @GetMapping("/mypageMain")
    public String mypageMain(HttpSession session, Model model) {
        if (session.getAttribute("m_id") == null) return "redirect:/member/login";
        if (session.getAttribute("mypageAuth") == null) return "redirect:/member/mypage";

        String mId = (String) session.getAttribute("m_id");
        MemberVO member = service.getMember(mId);
        List<BoardVO> myPosts = boardService.getMyPosts(mId);
        List<OrderVO> myOrders = orderService.getMyOrdersSummary(mId, 20);
        log.debug("마이페이지 주문 조회 - mId: {}, 결과 건수: {}", mId, myOrders.size());

        // 포인트 잔액 + 최근 10건 내역 (실패 시 0/빈 리스트로 폴백)
        int pointBalance = 0;
        List<PointHistoryVO> pointHistory = java.util.Collections.emptyList();
        int pointHistoryCount = 0;
        try {
            pointBalance      = pointService.getBalance(mId);
            pointHistory      = pointService.getHistory(mId, 0, 10);
            pointHistoryCount = pointService.getHistoryCount(mId);
        } catch (Exception e) {
            log.warn("포인트 정보 조회 실패 mId={}: {}", mId, e.getMessage());
        }

        model.addAttribute("member", member);
        model.addAttribute("myPosts", myPosts);
        model.addAttribute("myOrders", myOrders);
        model.addAttribute("pointBalance", pointBalance);
        model.addAttribute("pointHistory", pointHistory);
        model.addAttribute("pointHistoryCount", pointHistoryCount);
        return "member/mypage";
    }

    // ── 기본 정보 수정 ────────────────────────────────────────────────────
    @PostMapping("/updateInfo")
    public String updateInfo(MemberVO vo, HttpSession session, RedirectAttributes rttr) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";
        if (session.getAttribute("mypageAuth") == null) return "redirect:/member/mypage";

        vo.setM_id(mId);
        service.updateMember(vo);
        session.setAttribute("m_name", vo.getM_name());

        rttr.addFlashAttribute("successMsg", "정보가 성공적으로 수정되었습니다.");
        rttr.addFlashAttribute("activeTab", "info");
        return "redirect:/member/mypageMain";
    }

    // ── 비밀번호 변경 ─────────────────────────────────────────────────────
    @PostMapping("/changePw")
    public String changePw(@RequestParam("currentPw") String currentPw,
                           @RequestParam("newPw") String newPw,
                           @RequestParam("confirmPw") String confirmPw,
                           HttpSession session, RedirectAttributes rttr) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";
        if (session.getAttribute("mypageAuth") == null) return "redirect:/member/mypage";

        MemberVO loginVO = new MemberVO();
        loginVO.setM_id(mId);
        loginVO.setM_pw(currentPw);

        if (service.login(loginVO) == null) {
            rttr.addFlashAttribute("errorMsg", "현재 비밀번호가 올바르지 않습니다.");
            rttr.addFlashAttribute("activeTab", "security");
            return "redirect:/member/mypageMain";
        }
        if (!newPw.equals(confirmPw)) {
            rttr.addFlashAttribute("errorMsg", "새 비밀번호가 일치하지 않습니다.");
            rttr.addFlashAttribute("activeTab", "security");
            return "redirect:/member/mypageMain";
        }
        if (newPw.length() < 4) {
            rttr.addFlashAttribute("errorMsg", "비밀번호는 4자 이상이어야 합니다.");
            rttr.addFlashAttribute("activeTab", "security");
            return "redirect:/member/mypageMain";
        }

        service.updatePw(mId, newPw);
        rttr.addFlashAttribute("successMsg", "비밀번호가 성공적으로 변경되었습니다.");
        rttr.addFlashAttribute("activeTab", "security");
        return "redirect:/member/mypageMain";
    }

    // ── 마이페이지 보안 잠금 (인증 초기화) ───────────────────────────────────
    @GetMapping("/mypageLock")
    public String mypageLock(HttpSession session) {
        session.removeAttribute("mypageAuth");
        return "redirect:/member/mypage";
    }

    // ── 회원 탈퇴 ─────────────────────────────────────────────────────────
    @PostMapping("/withdraw")
    public String withdraw(@RequestParam("withdrawPw") String withdrawPw,
                           HttpSession session, RedirectAttributes rttr) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";

        MemberVO loginVO = new MemberVO();
        loginVO.setM_id(mId);
        loginVO.setM_pw(withdrawPw);

        if (service.login(loginVO) == null) {
            rttr.addFlashAttribute("errorMsg", "비밀번호가 올바르지 않습니다.");
            rttr.addFlashAttribute("activeTab", "account");
            return "redirect:/member/mypageMain";
        }

        service.deleteMember(mId);
        session.invalidate();
        rttr.addFlashAttribute("msg", "그동안 로운을 이용해 주셔서 감사합니다.");
        return "redirect:/";
    }
}
