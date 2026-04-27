package org.study.cafe.membership.service;
import org.study.cafe.membership.vo.MembershipVO;
public interface MembershipService {
    MembershipVO getByUserId(String userId);
    int upsert(MembershipVO vo);

    String getMemberName(String mId);
    int getVisitCount(String mId);
    MembershipVO getOrCreate(String mId, String grade, int points);
    void updateGradeAndPoints(String mId, String grade, int points);
    /** 등급만 갱신 — 포인트 시스템 도입 후 멤버십 페이지가 포인트를 덮어쓰지 않도록 분리 */
    void updateGrade(String mId, String grade);
}
