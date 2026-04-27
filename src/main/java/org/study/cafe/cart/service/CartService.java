package org.study.cafe.cart.service;

import org.study.cafe.cart.vo.CartVO;

import java.util.List;
import java.util.Map;

public interface CartService {

    /** 장바구니 담기 — 서버에서 unit_price 재계산, 같은 옵션이면 수량 누적 */
    void addToCart(String mId, String menuName, String temperature, String size, int quantity);

    /** 내 장바구니 조회 — 아이템별 subtotal 채운 리스트 + 전체 합계/건수 */
    Map<String, Object> getMyCart(String mId);

    /** 수량 변경 — quantity<=0 이면 삭제 처리 */
    void updateQuantity(String mId, int cartIdx, int quantity);

    /** 개별 삭제 */
    void removeItem(String mId, int cartIdx);

    /** 전체 비우기 */
    void clearCart(String mId);

    /** 헤더 뱃지용 카운트 */
    int countByMemberId(String mId);

    /** 장바구니 아이템 전체를 조회 (결제 이관용 내부 API) */
    List<CartVO> listItemsForCheckout(String mId);

    /**
     * 장바구니 전체 → order_t + order_item_t 로 이관 (cart → order).
     * 주문은 READY 상태로 생성되고 장바구니는 아직 비우지 않음 (결제 성공 후 비움).
     * pointsToUse 가 있으면 검증 후 order_t.points_used 컬럼에 기록 (실 차감은 결제 성공 시).
     * @return orderId, amount 를 담은 Map (OrderServiceImpl.createOrder 반환과 동일 포맷)
     */
    Map<String, Object> checkoutToOrder(String mId, int pointsToUse);
}
