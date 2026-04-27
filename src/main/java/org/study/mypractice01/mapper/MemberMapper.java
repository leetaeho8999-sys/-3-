package org.study.mypractice01.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.mypractice01.vo.MemberVO;

@Mapper
public interface MemberMapper {
    // ⚠️ 중요: @Insert, @Select 같은 "요리법"은 다 지우고 "이름"만 남깁니다.
    // 진짜 요리법은 사용자님이 올려주신 XML에 이미 들어있으니까요!

    int join(MemberVO vo);

    MemberVO login(String m_id);

    // XML에서 파라미터가 2개 이상일 때는 @Param을 붙여주는 게 안전합니다.
    String findMemberId(@Param("m_name") String m_name, @Param("m_phone") String m_phone);

    String findMemberPw(@Param("m_id") String m_id, @Param("m_phone") String m_phone);

    void updatePw(@Param("m_id") String m_id, @Param("m_pw") String m_pw);

    // 드디어 완성된 중복 체크!
    int idCheck(String m_id);
}