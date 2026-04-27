package org.study.cafe.config;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.study.cafe.point.service.PointService;

/**
 * 모든 @Controller 핸들러의 Model 에 공통 속성을 자동 주입한다.
 * common/cart-panel.jsp 가 header.jsp 를 통해 모든 페이지에 include 되므로,
 * 페이지별 컨트롤러에서 model.addAttribute 를 반복할 필요가 없다.
 *
 * annotations = Controller.class 로 한정해 @RestController 의 JSON 응답에는 영향 주지 않음.
 *
 * 주입되는 속성:
 *   tossClientKey       — 토스페이먼츠 클라이언트 키
 *   userPointBalance    — 로그인 회원의 포인트 잔액 (비로그인 시 null)
 */
@ControllerAdvice(annotations = Controller.class)
public class GlobalModelAdvice {

    @Value("${toss.client-key:test_ck_docs_Ovk5rk1EwkEbP0W43n07xlzm}")
    private String tossClientKey;

    @Autowired private PointService pointService;

    @ModelAttribute("tossClientKey")
    public String tossClientKey() {
        return tossClientKey;
    }

    /**
     * 사이드 장바구니 패널의 포인트 사용 UI 가 잔액을 표시하기 위해 전역 주입.
     * 비로그인 시 null 반환 → JSP 에서 ${userPointBalance != null ? userPointBalance : 0} 처리.
     */
    @ModelAttribute("userPointBalance")
    public Integer userPointBalance(HttpSession session) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return null;
        try { return pointService.getBalance(mId); }
        catch (Exception e) { return 0; }
    }
}
