package org.study.cafe.visit.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.cafe.visit.vo.VisitVO;

@Mapper
public interface VisitMapper {

    /** 결제 PAID 시 호출 — UNIQUE(order_id) 위반 시 DuplicateKeyException 발생 (서비스단에서 catch) */
    int insertVisit(@Param("mId") String mId, @Param("orderId") String orderId);

    /** 결제 CANCELLED 시 호출 — 멱등 (이미 cancelled=1 이면 0행 영향) */
    int cancelVisitByOrder(@Param("orderId") String orderId);

    /** 멤버십 페이지의 "이번 달 방문 횟수" — cancelled=0 만 카운트 */
    int countThisMonthByMember(@Param("mId") String mId);

    /** 누적 유효 방문 (cancelled=0) */
    int countTotalByMember(@Param("mId") String mId);

    VisitVO findByOrderId(@Param("orderId") String orderId);
}
