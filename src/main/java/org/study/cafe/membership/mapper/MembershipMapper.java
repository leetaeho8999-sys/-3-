package org.study.cafe.membership.mapper;
import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.membership.vo.MembershipVO;
@Mapper
public interface MembershipMapper {
    MembershipVO getByUserId(String userId);
    int insertMembership(MembershipVO vo);
    int updateMembership(MembershipVO vo);
}
