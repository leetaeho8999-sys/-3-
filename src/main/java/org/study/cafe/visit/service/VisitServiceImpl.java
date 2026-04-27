package org.study.cafe.visit.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.study.cafe.visit.mapper.VisitMapper;

@Service
public class VisitServiceImpl implements VisitService {

    private static final Logger log = LoggerFactory.getLogger(VisitServiceImpl.class);

    @Autowired private VisitMapper visitMapper;

    @Override
    public void recordVisit(String mId, String orderId) {
        try {
            visitMapper.insertVisit(mId, orderId);
            log.debug("방문 기록 mId={} orderId={}", mId, orderId);
        } catch (DuplicateKeyException e) {
            // UNIQUE(order_id) 위반 — 같은 주문에 대한 재시도. 무시 후 WARN.
            log.warn("이미 기록된 방문 (UNIQUE 위반 무시) orderId={}", orderId);
        }
    }

    @Override
    public void cancelVisit(String orderId) {
        int affected = visitMapper.cancelVisitByOrder(orderId);
        if (affected == 0) {
            log.debug("취소할 방문 행 없음 (이미 cancelled=1 또는 미존재) orderId={}", orderId);
        } else {
            log.debug("방문 취소 처리 orderId={}", orderId);
        }
    }

    @Override
    public int getThisMonthCount(String mId) {
        return visitMapper.countThisMonthByMember(mId);
    }

    @Override
    public int getTotalCount(String mId) {
        return visitMapper.countTotalByMember(mId);
    }
}
