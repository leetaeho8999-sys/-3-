package org.study.cafe.member.mapper;
import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.member.vo.MemberVO;

@Mapper
public interface MemberMapper {
    int    insertMember(MemberVO vo);
    MemberVO findByEmail(String email);
    int    checkEmail(String email);
    int    checkUsername(String username);
    MemberVO findByIdx(String m_idx);
    int    updateMember(MemberVO vo);
    int    deleteMember(String m_idx);
    int    verifyPassword(String m_idx);
}
