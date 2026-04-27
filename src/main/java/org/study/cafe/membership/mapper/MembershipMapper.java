package org.study.cafe.membership.mapper;
import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.membership.vo.MembershipVO;
@Mapper
public interface MembershipMapper {
    MembershipVO getByUserId(String userId);
    int insertMembership(MembershipVO vo);
    int updateMembership(MembershipVO vo);
    /** 등급만 갱신 (포인트는 손대지 않음) */
    int updateGrade(MembershipVO vo);

    String getMemberName(String mId);
    Integer getVisitCountByMId(String mId);
}
