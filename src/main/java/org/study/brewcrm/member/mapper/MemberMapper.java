package org.study.brewcrm.member.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.member.vo.MemberVO;

@Mapper
public interface MemberMapper {
    int      insertMember(MemberVO memberVO);
    int      checkEmail(String email);
    MemberVO findByEmail(String email);
    MemberVO findMyPageInfo(String m_idx);        // customer_t JOIN 포함
    int      updateMember(MemberVO memberVO);
    int      updateLinkedCustomer(MemberVO memberVO); // 연결된 customer_t.phone, memo 동기화
}
