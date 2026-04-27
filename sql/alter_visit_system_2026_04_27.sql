-- ────────────────────────────────────────────────────────────
-- 방문 이벤트 로그 테이블 신규 생성
-- 결제 PAID = INSERT, 결제 CANCELLED = UPDATE cancelled=1
-- 멤버십 페이지의 "이번 달 방문 횟수" 의 단일 진원지
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS visit_t (
    v_idx       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    m_id        VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    order_id    VARCHAR(64)  NULL     COLLATE utf8mb4_0900_ai_ci COMMENT '관련 주문, order_t 물리 삭제 시 NULL 로 초기화',
    visit_date  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cancelled   TINYINT      NOT NULL DEFAULT 0 COMMENT '1=결제 취소되어 방문 무효',
    cancel_date DATETIME     NULL,
    INDEX idx_visit_member_month (m_id, visit_date, cancelled),
    INDEX idx_visit_order (order_id),
    CONSTRAINT uk_visit_order UNIQUE (order_id),
    CONSTRAINT fk_visit_member FOREIGN KEY (m_id)
        REFERENCES member(m_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_visit_order  FOREIGN KEY (order_id)
        REFERENCES order_t(order_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_visit_cancelled CHECK (cancelled IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
