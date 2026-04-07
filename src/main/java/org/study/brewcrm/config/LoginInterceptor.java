package org.study.brewcrm.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.HandlerInterceptor;
import org.study.brewcrm.member.vo.MemberVO;

/**
 * 비로그인 → 로그인 페이지로 리다이렉트.
 * 권한 부족 → 403 에러 페이지로 이동.
 *
 * 권한 규칙:
 *   /customer/admin/**   → ADMIN만
 *   /customer/marketing  → ADMIN, MANAGER
 *   /customer/stats      → ADMIN, MANAGER
 *   /customer/**         → 로그인한 모든 사용자 (STAFF 이상)
 *
 *   MEMBER 역할 계정은 CRM 접근 자체를 막음 (고객용 계정)
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(@NonNull HttpServletRequest request,
                             @NonNull HttpServletResponse response,
                             @NonNull Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        MemberVO loginMember = (session != null)
                ? (MemberVO) session.getAttribute("loginMember")
                : null;

        // ── 1. 미로그인 → 로그인 페이지 ──────────────────────────
        if (loginMember == null) {
            String uri   = request.getRequestURI();
            String ctxP  = request.getContextPath();
            // Spring MVC의 redirect: 는 '/'로 시작하는 URL에 context path를 자동으로 붙임.
            // getRequestURI()는 context path 포함 전체 경로를 반환하므로,
            // 저장 전에 context path를 제거해야 이중으로 붙는 것을 방지할 수 있음.
            // 예) /brew-crm/customer/dashboard → /customer/dashboard 로 저장
            String bare  = uri.startsWith(ctxP) ? uri.substring(ctxP.length()) : uri;
            String query = request.getQueryString();
            String back  = (query != null) ? bare + "?" + query : bare;
            response.sendRedirect(ctxP + "/member/login?redirect=" +
                    java.net.URLEncoder.encode(back, "UTF-8"));
            return false;
        }

        // ── 2. 고객용 MEMBER 계정은 CRM 접근 불가 ─────────────────
        String role = loginMember.getRole();
        if ("MEMBER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/member/mypage");
            return false;
        }

        // ── 3. 경로별 최소 권한 체크 ──────────────────────────────
        String path = request.getRequestURI();
        String ctx  = request.getContextPath();

        if (path.startsWith(ctx + "/customer/admin")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/customer/dashboard?accessDenied=true");
                return false;
            }
        } else if (path.startsWith(ctx + "/customer/marketing")
                || path.startsWith(ctx + "/customer/stats")) {
            if (!"ADMIN".equals(role) && !"MANAGER".equals(role)) {
                response.sendRedirect(ctx + "/customer/dashboard?accessDenied=true");
                return false;
            }
        }

        return true;
    }
}
