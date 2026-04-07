package org.study.brewcrm.customer.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.study.brewcrm.customer.mapper.CustomerMapper;
import org.study.brewcrm.customer.mapper.SchedulerLogMapper;

import java.util.HashMap;
import java.util.Map;

/**
 * 매월 1일 00:00 에 monthly_visit, monthly_amount 를 0으로 초기화
 * → 등급 산정이 당월 누적 기준으로 유지되도록 보장
 * 실행 결과는 scheduler_log_t 에 기록
 */
@Component
public class MonthlyResetScheduler {

    private static final Logger log = LoggerFactory.getLogger(MonthlyResetScheduler.class);

    @Autowired private CustomerMapper     customerMapper;
    @Autowired private SchedulerLogMapper schedulerLogMapper;

    // 매월 1일 00:00:00 실행 (cron: 초 분 시 일 월 요일)
    @Scheduled(cron = "0 0 0 1 * *")
    public void resetMonthlyStats() {
        String status  = "SUCCESS";
        String message = null;
        int    affected = 0;
        try {
            affected = customerMapper.resetMonthlyStats();
            log.info("[MonthlyReset] 이번 달 방문/결제 통계 초기화 완료 — {}건", affected);
        } catch (Exception e) {
            status  = "FAILED";
            message = e.getMessage();
            log.error("[MonthlyReset] 초기화 실패: {}", e.getMessage(), e);
        }
        saveLog("MONTHLY_RESET", status, affected, message);
    }

    private void saveLog(String jobName, String status, int affected, String message) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("jobName",  jobName);
            params.put("status",   status);
            params.put("affected", affected);
            params.put("message",  message != null ? message : "정상 처리");
            schedulerLogMapper.insertLog(params);
        } catch (Exception e) {
            log.warn("[SchedulerLog] 로그 저장 실패 — jobName={}: {}", jobName, e.getMessage());
        }
    }
}
