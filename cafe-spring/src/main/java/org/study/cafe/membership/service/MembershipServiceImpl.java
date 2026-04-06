package org.study.cafe.membership.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.membership.mapper.MembershipMapper;
import org.study.cafe.membership.vo.MembershipVO;

@Service
public class MembershipServiceImpl implements MembershipService {
    @Autowired private MembershipMapper mapper;
    @Override public MembershipVO getByUserId(String userId) { return mapper.getByUserId(userId); }
    @Override public int upsert(MembershipVO vo) {
        MembershipVO existing = mapper.getByUserId(vo.getUserId());
        return existing == null ? mapper.insertMembership(vo) : mapper.updateMembership(vo);
    }
}
