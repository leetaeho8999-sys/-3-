package org.study.cafe.cart.controller;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.cart.service.CartService;

import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    private static final Logger log = LoggerFactory.getLogger(CartController.class);

    @Autowired private CartService cartService;

    /** 내 장바구니 조회 — 사이드 패널 로드용 */
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> list(HttpSession session) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        return ResponseEntity.ok(cartService.getMyCart(mId));
    }

    /** 장바구니 담기 */
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> add(
            @RequestParam String menuName,
            @RequestParam(defaultValue = "NONE") String temperature,
            @RequestParam(defaultValue = "NONE") String size,
            @RequestParam(defaultValue = "1") int quantity,
            HttpSession session) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }
        try {
            cartService.addToCart(mId, menuName, temperature, size, quantity);
            int count = cartService.countByMemberId(mId);
            return ResponseEntity.ok(Map.of("success", true, "count", count));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            log.error("장바구니 담기 실패 mId={} menuName={}", mId, menuName, e);
            return ResponseEntity.internalServerError().body(Map.of("error", "장바구니 담기 중 오류가 발생했습니다."));
        }
    }

    /** 수량 변경 (0 이하면 서비스 단에서 삭제 처리) */
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> update(
            @RequestParam int cartIdx,
            @RequestParam int quantity,
            HttpSession session) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }
        cartService.updateQuantity(mId, cartIdx, quantity);
        return ResponseEntity.ok(Map.of("success", true));
    }

    /** 개별 삭제 */
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(
            @RequestParam int cartIdx,
            HttpSession session) {

        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }
        cartService.removeItem(mId, cartIdx);
        return ResponseEntity.ok(Map.of("success", true));
    }

    /** 전체 비우기 */
    @PostMapping("/clear")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> clear(HttpSession session) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }
        cartService.clearCart(mId);
        return ResponseEntity.ok(Map.of("success", true));
    }

    /** 헤더 뱃지용 숫자만 */
    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> count(HttpSession session) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return ResponseEntity.ok(Map.of("count", 0));
        return ResponseEntity.ok(Map.of("count", cartService.countByMemberId(mId)));
    }

    /** 장바구니 → 주문 이관 후 결제창 호출용 orderId/amount 반환 */
    @PostMapping("/checkout")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkout(
            @RequestParam(name = "pointsToUse", required = false, defaultValue = "0") int pointsToUse,
            HttpSession session) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }
        try {
            return ResponseEntity.ok(cartService.checkoutToOrder(mId, pointsToUse));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            log.error("장바구니 결제 이관 실패 mId={}", mId, e);
            return ResponseEntity.internalServerError().body(Map.of("error", "결제 준비 중 오류가 발생했습니다."));
        }
    }
}
