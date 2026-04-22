package org.study.brewcrm.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.study.brewcrm.board.mapper.BoardAdminMapper;
import org.study.brewcrm.member.vo.MemberVO;

@ControllerAdvice
public class BadgeAdvice {

    @Autowired private BoardAdminMapper boardAdminMapper;

    @ModelAttribute("pendingReportCount")
    public int pendingReportCount(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return 0;
        MemberVO m = (MemberVO) session.getAttribute("loginMember");
        if (m == null) return 0;
        String role = m.getRole();
        if (!"ADMIN".equals(role) && !"MANAGER".equals(role)) return 0;
        try { return boardAdminMapper.getPendingReportCount(); }
        catch (Exception e) { return 0; }
    }
}
