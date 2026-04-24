package org.study.cafe.membership.service;
import org.study.cafe.membership.vo.MembershipVO;
public interface MembershipService {
    MembershipVO getByUserId(String userId);
    int upsert(MembershipVO vo);

    String getMemberName(String mId);
    int getVisitCount(String mId);
    MembershipVO getOrCreate(String mId, String grade, int points);
    void updateGradeAndPoints(String mId, String grade, int points);
}
