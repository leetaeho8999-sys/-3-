package org.study.cafe.member.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.cafe.member.vo.MemberVO;

@Mapper
public interface MemberMapper {

    // 1. 회원가입: 새로운 손님 정보 장부에 적기
    int join(MemberVO vo);

    // 2. 로그인: 아이디로 손님 정보 찾아오기
    MemberVO login(String m_id);

    // 3. 아이디 찾기: 이름과 전화번호로 아이디 검색
    String findMemberId(@Param("m_name") String m_name, @Param("m_phone") String m_phone);

    // 4. 비밀번호 찾기: 아이디와 전화번호로 기존 비번 검색
    String findMemberPw(@Param("m_id") String m_id, @Param("m_phone") String m_phone);

    // 5. 비밀번호 재설정: 새 비밀번호로 덮어쓰기
    void updatePw(@Param("m_id") String m_id, @Param("m_pw") String m_pw);

    // 6. 아이디 중복 확인: 같은 아이디가 몇 개 있는지 확인 (0이면 사용 가능)
    int idCheck(String m_id);
}
