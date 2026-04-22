package org.study.brewcrm.member.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.member.vo.MemberVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {
    int      insertMember(MemberVO memberVO);
    int      checkEmail(String email);
    MemberVO findByEmail(String email);
    MemberVO findMyPageInfo(String m_idx);            // customer_t JOIN 포함
    int      updateMember(MemberVO memberVO);
    int      setLinkedCustomer(Map<String, Object> params); // linked_customer 연결
    int      updateLinkedCustomer(MemberVO memberVO); // 연결된 customer_t.phone, memo 동기화
    MemberVO findByLinkedCustomer(String c_idx);      // 고객 번호로 연결된 회원 조회 (포인트 동기화용)
    int      updateMemberRole(Map<String, Object> params); // 권한 변경 (관리자 전용)
    int      deactivateMember(String m_idx);               // 계정 비활성화 (논리 삭제)
    List<MemberVO> getAllMembers();                         // 직원 계정 목록 (MEMBER 제외)
    int updatePassword(Map<String, Object> params);        // 비밀번호 변경
}
