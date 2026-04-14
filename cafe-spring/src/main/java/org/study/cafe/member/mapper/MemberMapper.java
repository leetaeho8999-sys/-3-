package org.study.cafe.member.mapper;
import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.member.vo.MemberVO;

@Mapper
public interface MemberMapper {
    int      insertCustomerForMember(MemberVO vo); // customer_t INSERT (useGeneratedKeys → linkedCustomer)
    int      insertMember(MemberVO vo);
    MemberVO findByEmail(String email);
    int      checkEmail(String email);
    int      checkUsername(String username);
    MemberVO findByIdx(String m_idx);
    MemberVO findMyPageInfo(String m_idx);         // customer_t LEFT JOIN (grade, visitCount 포함)
    int      updateMember(MemberVO vo);
    int      updateLinkedCustomer(MemberVO vo);    // customer_t.phone 동기화
    int      deleteMember(String m_idx);
}
