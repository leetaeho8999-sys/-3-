package org.study.cafe.point.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.cafe.point.vo.PointHistoryVO;

import java.util.List;

@Mapper
public interface PointMapper {

    /** 현재 잔액 조회. membership_t 행이 없으면 null 반환 → 서비스단에서 0 처리 */
    Integer getPoints(@Param("mId") String mId);

    /**
     * 잔액 가산 — 음수 amount 는 차감으로 동작.
     * GREATEST(0, ...) 클램프로 결과 잔액이 음수가 되지 않도록 방어.
     */
    int addPoints(@Param("mId") String mId, @Param("amount") int amount);

    /**
     * 조건부 차감 — 잔액이 amount 이상일 때만 성공 (동시성 안전).
     * 반환값이 1 이면 성공, 0 이면 잔액 부족.
     */
    int usePoints(@Param("mId") String mId, @Param("amount") int amount);

    int insertHistory(PointHistoryVO vo);

    List<PointHistoryVO> findHistoryByMember(@Param("mId") String mId,
                                             @Param("limit") int limit,
                                             @Param("offset") int offset);

    int countHistoryByMember(@Param("mId") String mId);

    /** 취소 시 회수액 계산용 — 해당 주문의 적립 포인트 */
    Integer findEarnedByOrder(@Param("orderId") String orderId);

    /** 취소 시 복원액 계산용 — 해당 주문에서 사용한 포인트 */
    Integer findUsedByOrder(@Param("orderId") String orderId);
}
