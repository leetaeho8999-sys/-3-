package org.study.cafe.cart.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.cart.mapper.CartMapper;
import org.study.cafe.cart.vo.CartVO;
import org.study.cafe.menu.mapper.MenuMapper;
import org.study.cafe.menu.vo.MenuVO;
import org.study.cafe.order.mapper.OrderMapper;
import org.study.cafe.order.vo.OrderItemVO;
import org.study.cafe.order.vo.OrderVO;
import org.study.cafe.point.service.PointService;

import java.util.*;

@Service
public class CartServiceImpl implements CartService {

    private static final Logger log = LoggerFactory.getLogger(CartServiceImpl.class);

    @Autowired private CartMapper cartMapper;
    @Autowired private MenuMapper menuMapper;
    @Autowired private OrderMapper orderMapper;
    @Autowired private PointService pointService;

    /** 장바구니 담기 — unit_price 는 DB 기준 재계산 (HOT/ICE + 사이즈 추가금 반영) */
    @Override
    public void addToCart(String mId, String menuName, String temperature, String size, int quantity) {
        if (quantity <= 0) quantity = 1;
        String tempNorm = (temperature == null || temperature.isBlank()) ? "NONE" : temperature.toUpperCase();
        String sizeNorm = (size == null || size.isBlank()) ? "NONE" : size.toUpperCase();

        MenuVO menu = menuMapper.findByName(menuName);
        if (menu == null) {
            log.warn("addToCart - 존재하지 않는 메뉴 mId={} menuName={}", mId, menuName);
            throw new IllegalArgumentException("존재하지 않는 메뉴입니다.");
        }

        int base   = menu.getPrice();
        int iceEx  = menu.getIcePrice();
        int grande = menu.getSizeUpchargeGrande();
        int venti  = menu.getSizeUpchargeVenti();
        int unitPrice = base
                      + ("ICE".equals(tempNorm) ? iceEx : 0)
                      + ("GRANDE".equals(sizeNorm) ? grande
                         : "VENTI".equals(sizeNorm) ? venti : 0);

        CartVO existing = cartMapper.findExact(mId, menuName, tempNorm, sizeNorm);
        if (existing != null) {
            cartMapper.addQuantity(existing.getCartIdx(), mId, quantity);
            return;
        }
        CartVO item = new CartVO();
        item.setMId(mId);
        item.setMenuName(menuName);
        item.setTemperature(tempNorm);
        item.setSize(sizeNorm);
        item.setQuantity(quantity);
        item.setUnitPrice(unitPrice);
        cartMapper.insertItem(item);
    }

    @Override
    public Map<String, Object> getMyCart(String mId) {
        List<CartVO> items = cartMapper.findByMemberId(mId);
        int total = 0;
        for (CartVO c : items) {
            int sub = c.getUnitPrice() * c.getQuantity();
            c.setSubtotal(sub);
            total += sub;
        }
        Map<String, Object> result = new HashMap<>();
        result.put("items", items);
        result.put("totalAmount", total);
        result.put("totalCount", items.size());
        return result;
    }

    @Override
    public void updateQuantity(String mId, int cartIdx, int quantity) {
        if (quantity <= 0) {
            cartMapper.deleteByIdx(cartIdx, mId);
            return;
        }
        cartMapper.updateQuantity(cartIdx, mId, quantity);
    }

    @Override
    public void removeItem(String mId, int cartIdx) {
        cartMapper.deleteByIdx(cartIdx, mId);
    }

    @Override
    public void clearCart(String mId) {
        cartMapper.deleteAllByMemberId(mId);
    }

    @Override
    public int countByMemberId(String mId) {
        return cartMapper.countByMemberId(mId);
    }

    @Override
    public List<CartVO> listItemsForCheckout(String mId) {
        return cartMapper.findByMemberId(mId);
    }

    /**
     * 장바구니 전체를 order_t + order_item_t 로 이관 (READY 상태, 장바구니는 아직 비우지 않음).
     * pointsToUse 가 있으면 검증 + order_t.points_used 컬럼에 기록 (실 차감은 결제 성공 시).
     */
    @Override
    public Map<String, Object> checkoutToOrder(String mId, int pointsToUse) {
        List<CartVO> items = cartMapper.findByMemberId(mId);
        if (items.isEmpty()) {
            throw new IllegalStateException("장바구니가 비어있습니다.");
        }

        // 총액 서버 재계산 (cart_t.unit_price 는 이미 서버가 저장한 값이지만 한번 더 합산)
        int total = 0;
        for (CartVO c : items) {
            total += c.getUnitPrice() * c.getQuantity();
        }

        // ── 포인트 사용 검증 (READY 시점 — 차감은 결제 성공 시) ─────
        int useP = Math.max(0, pointsToUse);
        if (useP > 0 && useP < 1000) {
            throw new IllegalArgumentException("포인트는 1,000P 이상부터 사용 가능합니다.");
        }
        if (useP > 0 && useP % 100 != 0) {
            throw new IllegalArgumentException("포인트는 100P 단위로 사용해야 합니다.");
        }
        if (useP > total) {
            throw new IllegalArgumentException("사용 포인트가 결제 금액을 초과할 수 없습니다.");
        }
        if (useP > 0 && useP > pointService.getBalance(mId)) {
            throw new IllegalArgumentException("포인트 잔액이 부족합니다.");
        }
        int payAmount = total - useP;

        String orderId = UUID.randomUUID().toString();
        OrderVO order = new OrderVO();
        order.setOrderId(orderId);
        order.setMId(mId);
        order.setTotalAmount(payAmount);   // 토스에 청구할 실 결제액
        order.setStatus("READY");
        order.setPointsUsed(useP);
        orderMapper.insertOrder(order);

        for (CartVO c : items) {
            OrderItemVO oi = new OrderItemVO();
            oi.setOrderId(orderId);
            oi.setMenuName(c.getMenuName());
            oi.setTemperature(c.getTemperature() != null ? c.getTemperature() : "NONE");
            oi.setSize(c.getSize() != null ? c.getSize() : "NONE");
            oi.setQuantity(c.getQuantity());
            oi.setUnitPrice(c.getUnitPrice());
            oi.setSubtotal(c.getUnitPrice() * c.getQuantity());
            orderMapper.insertOrderItem(oi);
        }

        log.debug("Cart → Order 이관 완료 mId={} orderId={} items={} total={} useP={} pay={}",
                  mId, orderId, items.size(), total, useP, payAmount);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("amount", payAmount);
        return result;
    }
}
