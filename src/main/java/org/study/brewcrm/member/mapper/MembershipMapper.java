package org.study.brewcrm.member.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.Map;

/**
 * membership_t — 포인트·등급 동기화 Mapper
 * brew-crm 방문 기록 시 CustomerServiceImpl에서 호출
 */
@Mapper
public interface MembershipMapper {
    /**
     * INSERT ... ON DUPLICATE KEY UPDATE
     * 처음 방문이면 신규 행 삽입, 이후에는 포인트 누적 + 등급 갱신
     * params: userId, grade, pointsToAdd
     */
    int upsertMembership(Map<String, Object> params);
}
