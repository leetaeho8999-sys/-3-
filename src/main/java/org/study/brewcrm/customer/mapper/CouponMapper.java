package org.study.brewcrm.customer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.customer.vo.CouponVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface CouponMapper {

    // 쿠폰 템플릿 목록 (활성 쿠폰만)
    List<CouponVO> getActiveCoupons();

    // 고객에게 쿠폰 발급
    int issueCoupon(Map<String, Object> params);

    // 고객별 보유 쿠폰 목록 (미사용)
    List<Map<String, Object>> getCustomerCoupons(String c_idx);

    // 쿠폰 사용 처리
    int useCoupon(int cc_idx);

    // 쿠폰 회수 (발급 취소)
    int revokeCoupon(int cc_idx);

    // 포인트 조정 (membership_t)
    int adjustPoints(Map<String, Object> params);

    // 최근 발급 내역 (관리자 화면용)
    List<Map<String, Object>> getRecentIssuedCoupons(int limit);
}
