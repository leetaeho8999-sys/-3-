package org.study.cafe.membership.service;
import org.study.cafe.membership.vo.MembershipVO;
public interface MembershipService {
    MembershipVO getByUserId(String userId);
    int upsert(MembershipVO vo);
}
