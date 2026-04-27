package org.study.cafe.point.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.cafe.order.mapper.OrderMapper;
import org.study.cafe.point.mapper.PointMapper;
import org.study.cafe.point.vo.PointHistoryVO;

import java.util.List;
import java.util.Map;

@Service
public class PointServiceImpl implements PointService {

    private static final Logger log = LoggerFactory.getLogger(PointServiceImpl.class);

    /** 등급별 적립률 — 정책 변경 시 이 한 곳만 수정 */
    private static final Map<String, Double> RATE = Map.of(
            "일반", 0.03,
            "실버", 0.05,
            "골드", 0.07,
            "VIP",  0.10
    );

    private static final int SIGNUP_BONUS_AMOUNT = 1000;
    private static final int MIN_USE_AMOUNT      = 1000;
    private static final int USE_UNIT            = 100;

    @Autowired private PointMapper pointMapper;
    @Autowired private OrderMapper orderMapper;

    // ────────────────────────────────────────────────────────────
    // 잔액 조회
    // ────────────────────────────────────────────────────────────
    @Override
    public int getBalance(String mId) {
        Integer p = pointMapper.getPoints(mId);
        return p != null ? p : 0;
    }

    // ────────────────────────────────────────────────────────────
    // 적립 예상액 계산
    // ────────────────────────────────────────────────────────────
    @Override
    public int calcEarnAmount(String grade, int paymentBase) {
        if (paymentBase <= 0) return 0;
        double rate = RATE.getOrDefault(grade != null ? grade : "일반", 0.03);
        return (int) Math.floor(paymentBase * rate);
    }

    // ────────────────────────────────────────────────────────────
    // 결제 성공 시 적립
    // ────────────────────────────────────────────────────────────
    @Override
    @Transactional
    public void earn(String mId, String orderId, int paymentBase, String grade) {
        int amount = calcEarnAmount(grade, paymentBase);
        if (amount <= 0) return;

        pointMapper.addPoints(mId, amount);
        int newBalance = getBalance(mId);

        double rate = RATE.getOrDefault(grade != null ? grade : "일반", 0.03);
        String desc = String.format("결제 적립 (%s %.0f%%)",
                grade != null ? grade : "일반", rate * 100);

        PointHistoryVO h = new PointHistoryVO();
        h.setMId(mId);
        h.setType("EARN");
        h.setAmount(amount);
        h.setBalanceAfter(newBalance);
        h.setOrderId(orderId);
        h.setDescription(desc);
        pointMapper.insertHistory(h);

        // order_t.points_earned 동기화 — 취소 시 회수 기준
        orderMapper.updatePointsEarned(orderId, amount);

        log.debug("EARN mId={} orderId={} grade={} base={} +{}P → {}P",
                mId, orderId, grade, paymentBase, amount, newBalance);
    }

    // ────────────────────────────────────────────────────────────
    // 결제 시 사용 (차감)
    // ────────────────────────────────────────────────────────────
    @Override
    @Transactional
    public void use(String mId, String orderId, int amount) {
        if (amount <= 0) return;
        if (amount < MIN_USE_AMOUNT) {
            throw new IllegalArgumentException("포인트는 " + MIN_USE_AMOUNT + "P 이상부터 사용 가능합니다.");
        }
        if (amount % USE_UNIT != 0) {
            throw new IllegalArgumentException("포인트는 " + USE_UNIT + "P 단위로 사용해야 합니다.");
        }

        int affected = pointMapper.usePoints(mId, amount);
        if (affected != 1) {
            throw new IllegalStateException("포인트 잔액 부족");
        }

        int newBalance = getBalance(mId);

        PointHistoryVO h = new PointHistoryVO();
        h.setMId(mId);
        h.setType("USE");
        h.setAmount(-amount);
        h.setBalanceAfter(newBalance);
        h.setOrderId(orderId);
        h.setDescription("결제 시 사용");
        pointMapper.insertHistory(h);

        // order_t.points_used 동기화 — 취소 시 복원 기준
        orderMapper.updatePointsUsed(orderId, amount);

        log.debug("USE mId={} orderId={} -{}P → {}P", mId, orderId, amount, newBalance);
    }

    // ────────────────────────────────────────────────────────────
    // 결제 취소 시 적립 회수
    // ────────────────────────────────────────────────────────────
    @Override
    @Transactional
    public void cancelEarn(String mId, String orderId, int refundRate) {
        Integer earned = pointMapper.findEarnedByOrder(orderId);
        if (earned == null || earned <= 0) return;

        int reclaim = (int) Math.floor(earned * refundRate / 100.0);
        if (reclaim <= 0) return;

        pointMapper.addPoints(mId, -reclaim);
        int newBalance = getBalance(mId);

        if (newBalance == 0 && reclaim > 0) {
            log.warn("CANCEL_EARN — 잔액 부족 클램프 발생 mId={} orderId={} earned={} reclaim={} (다른 주문에서 이미 사용됐을 가능성)",
                    mId, orderId, earned, reclaim);
        }

        PointHistoryVO h = new PointHistoryVO();
        h.setMId(mId);
        h.setType("CANCEL_EARN");
        h.setAmount(-reclaim);
        h.setBalanceAfter(newBalance);
        h.setOrderId(orderId);
        h.setDescription("결제 취소 적립 회수 (" + refundRate + "%)");
        pointMapper.insertHistory(h);

        log.debug("CANCEL_EARN mId={} orderId={} rate={}% earned={} -{}P → {}P",
                mId, orderId, refundRate, earned, reclaim, newBalance);
    }

    // ────────────────────────────────────────────────────────────
    // 결제 취소 시 사용 포인트 복원
    // ────────────────────────────────────────────────────────────
    @Override
    @Transactional
    public void restoreUse(String mId, String orderId, int refundRate) {
        Integer used = pointMapper.findUsedByOrder(orderId);
        if (used == null || used <= 0) return;

        int restore = (int) Math.floor(used * refundRate / 100.0);
        if (restore <= 0) return;

        pointMapper.addPoints(mId, restore);
        int newBalance = getBalance(mId);

        PointHistoryVO h = new PointHistoryVO();
        h.setMId(mId);
        h.setType("RESTORE_USE");
        h.setAmount(restore);
        h.setBalanceAfter(newBalance);
        h.setOrderId(orderId);
        h.setDescription("결제 취소 사용 복원 (" + refundRate + "%)");
        pointMapper.insertHistory(h);

        log.debug("RESTORE_USE mId={} orderId={} rate={}% used={} +{}P → {}P",
                mId, orderId, refundRate, used, restore, newBalance);
    }

    // ────────────────────────────────────────────────────────────
    // 가입 축하 보너스
    // ────────────────────────────────────────────────────────────
    @Override
    @Transactional
    public void grantSignupBonus(String mId) {
        pointMapper.addPoints(mId, SIGNUP_BONUS_AMOUNT);
        int newBalance = getBalance(mId);

        PointHistoryVO h = new PointHistoryVO();
        h.setMId(mId);
        h.setType("SIGNUP_BONUS");
        h.setAmount(SIGNUP_BONUS_AMOUNT);
        h.setBalanceAfter(newBalance);
        h.setOrderId(null);
        h.setDescription("가입 축하 포인트");
        pointMapper.insertHistory(h);

        log.info("SIGNUP_BONUS mId={} +{}P → {}P", mId, SIGNUP_BONUS_AMOUNT, newBalance);
    }

    // ────────────────────────────────────────────────────────────
    // 마이페이지 내역
    // ────────────────────────────────────────────────────────────
    @Override
    public List<PointHistoryVO> getHistory(String mId, int page, int pageSize) {
        int p = Math.max(0, page);
        int s = Math.max(1, pageSize);
        return pointMapper.findHistoryByMember(mId, s, p * s);
    }

    @Override
    public int getHistoryCount(String mId) {
        return pointMapper.countHistoryByMember(mId);
    }
}
