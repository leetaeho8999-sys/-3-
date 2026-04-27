package org.study.cafe.cart.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.cafe.cart.vo.CartVO;

import java.util.List;

@Mapper
public interface CartMapper {

    /** 같은 (m_id, menu_name, temperature, size) 조합 존재 여부 — 존재하면 기존 row 반환 */
    CartVO findExact(@Param("mId") String mId,
                     @Param("menuName") String menuName,
                     @Param("temperature") String temperature,
                     @Param("size") String size);

    /** 신규 INSERT */
    int insertItem(CartVO item);

    /** 기존 행 수량 누적 (cart_idx + m_id 둘 다 조건) */
    int addQuantity(@Param("cartIdx") int cartIdx,
                    @Param("mId") String mId,
                    @Param("delta") int delta);

    /** 특정 회원의 장바구니 전체 */
    List<CartVO> findByMemberId(@Param("mId") String mId);

    /** 수량 절대값으로 세팅 — m_id 검증 포함 */
    int updateQuantity(@Param("cartIdx") int cartIdx,
                       @Param("mId") String mId,
                       @Param("quantity") int quantity);

    /** 개별 삭제 — m_id 검증 포함 */
    int deleteByIdx(@Param("cartIdx") int cartIdx,
                    @Param("mId") String mId);

    /** 전체 비우기 (결제 완료 시 호출) */
    int deleteAllByMemberId(@Param("mId") String mId);

    /** 헤더 뱃지 숫자 (distinct row 수, 수량 합 아님) */
    int countByMemberId(@Param("mId") String mId);
}
