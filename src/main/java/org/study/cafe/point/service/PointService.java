package org.study.cafe.point.service;

import org.study.cafe.point.vo.PointHistoryVO;

import java.util.List;

public interface PointService {

    /** 현재 보유 포인트 (행 없으면 0) */
    int getBalance(String mId);

    /** 등급별 적립률 적용한 적립 예상액 (Math.floor) */
    int calcEarnAmount(String grade, int paymentBase);

    /** 결제 성공 시 호출 — 적립 + history INSERT + order_t.points_earned 갱신 */
    void earn(String mId, String orderId, int paymentBase, String grade);

    /** 결제 시 사용 — 1,000P 이상 + 100P 단위 검증 + 조건부 차감 + history + order_t.points_used 갱신 */
    void use(String mId, String orderId, int amount);

    /** 결제 취소 시 적립 회수 (환불율 비례) */
    void cancelEarn(String mId, String orderId, int refundRate);

    /** 결제 취소 시 사용 포인트 복원 (환불율 비례) */
    void restoreUse(String mId, String orderId, int refundRate);

    /** 가입 축하 1,000P 즉시 지급 (membership_t 행이 이미 존재해야 함) */
    void grantSignupBonus(String mId);

    /** 마이페이지 내역 (페이징) */
    List<PointHistoryVO> getHistory(String mId, int page, int pageSize);

    /** 마이페이지 내역 총 건수 */
    int getHistoryCount(String mId);
}
