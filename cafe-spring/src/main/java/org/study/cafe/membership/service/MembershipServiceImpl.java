package org.study.cafe.membership.service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.membership.mapper.MembershipMapper;
import org.study.cafe.membership.vo.MembershipVO;

@Service
public class MembershipServiceImpl implements MembershipService {

    private static final Logger log = LoggerFactory.getLogger(MembershipServiceImpl.class);

    @Autowired private MembershipMapper mapper;

    @Override public MembershipVO getByUserId(String userId) { return mapper.getByUserId(userId); }

    @Override public int upsert(MembershipVO vo) {
        MembershipVO existing = mapper.getByUserId(vo.getUserId());
        return existing == null ? mapper.insertMembership(vo) : mapper.updateMembership(vo);
    }

    @Override
    public String getMemberName(String mId) {
        return mapper.getMemberName(mId);
    }

    @Override
    public int getVisitCount(String mId) {
        try {
            Integer vc = mapper.getVisitCountByMId(mId);
            return vc != null ? vc : 0;
        } catch (Exception e) {
            log.warn("방문 횟수 조회 실패 (m_id={}): {}", mId, e.getMessage());
            return 0;
        }
    }

    @Override
    public MembershipVO getOrCreate(String mId, String grade, int points) {
        MembershipVO ms = mapper.getByUserId(mId);
        if (ms == null) {
            ms = new MembershipVO();
            ms.setUserId(mId);
            ms.setGrade(grade);
            ms.setPoints(points);
            try { mapper.insertMembership(ms); }
            catch (Exception e) { log.warn("membership_t INSERT 실패 (m_id={}): {}", mId, e.getMessage()); }
        }
        return ms;
    }

    @Override
    public void updateGradeAndPoints(String mId, String grade, int points) {
        try {
            MembershipVO vo = new MembershipVO();
            vo.setUserId(mId);
            vo.setGrade(grade);
            vo.setPoints(points);
            mapper.updateMembership(vo);
        } catch (Exception e) {
            log.warn("membership_t UPDATE 실패 (m_id={}): {}", mId, e.getMessage());
        }
    }
}
