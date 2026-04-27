package org.study.cafe.visit.service;

public interface VisitService {

    /** 결제 PAID 확정 시 호출 — visit_t 에 1행 INSERT (이미 있으면 무시) */
    void recordVisit(String mId, String orderId);

    /** 결제 CANCELLED 확정 시 호출 — 환불율 무관 무조건 cancelled=1 */
    void cancelVisit(String orderId);

    /** 멤버십 페이지 진원지 — 이번 달 1일 0시 이후 유효 방문 건수 */
    int getThisMonthCount(String mId);

    /** 누적 유효 방문 건수 (참고용) */
    int getTotalCount(String mId);
}
