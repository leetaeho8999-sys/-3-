-- ================================================================
-- 포인트 적립/사용 시스템 도입 — 2026-04-26
-- ----------------------------------------------------------------
-- 운영 DB 에서 한 번만 실행. 적용 후에는 init_schema.sql 만 사용.
-- ================================================================

USE project;

-- ────────────────────────────────────────────────────────────
-- 1) 포인트 적립/사용 내역 테이블 신규 생성
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS point_history_t (
    ph_idx        INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    m_id          VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    type          ENUM('EARN','USE','CANCEL_EARN','RESTORE_USE','SIGNUP_BONUS')
                  NOT NULL COMMENT '적립/사용/적립취소/사용복원/가입보너스',
    amount        INT          NOT NULL COMMENT '+ 적립/복원/보너스, - 사용/적립취소',
    balance_after INT          NOT NULL COMMENT '거래 후 잔액 (감사용)',
    order_id      VARCHAR(64)  NULL COLLATE utf8mb4_0900_ai_ci COMMENT '관련 주문 (가입보너스는 NULL)',
    description   VARCHAR(200) NULL,
    reg_date      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_ph_member_date (m_id, reg_date DESC),
    INDEX idx_ph_order (order_id),
    CONSTRAINT fk_ph_member FOREIGN KEY (m_id)
        REFERENCES member(m_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ────────────────────────────────────────────────────────────
-- 2) order_t 에 포인트 사용액 / 적립액 컬럼 추가
--    (취소 시 비례 환원을 위해 주문별로 기록)
-- ────────────────────────────────────────────────────────────
ALTER TABLE order_t
    ADD COLUMN points_used    INT NOT NULL DEFAULT 0 COMMENT '주문 시 사용한 포인트',
    ADD COLUMN points_earned  INT NOT NULL DEFAULT 0 COMMENT '결제 승인 시 적립된 포인트';
