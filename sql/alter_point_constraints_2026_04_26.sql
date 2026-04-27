-- ────────────────────────────────────────────────────────────
-- 포인트 시스템 데이터 무결성 보강
-- 전제: alter_point_system_2026_04_26.sql 가 이미 적용된 상태
-- (point_history_t 존재 + order_t.points_used / points_earned 컬럼 존재)
-- ────────────────────────────────────────────────────────────

USE project;

-- ────────────────────────────────────────────────────────────
-- (1) [필수] membership_t.user_id 에 UNIQUE 추가
--     동시 INSERT 로 인한 중복 행 방지.
--     적용 전 중복 데이터가 있으면 ALTER 가 실패하므로 사전 정리 쿼리 포함.
-- ────────────────────────────────────────────────────────────

-- 1-a. 중복 진단 (수동 확인용 — 실행 결과가 0행이어야 함)
-- SELECT user_id, COUNT(*) c FROM membership_t GROUP BY user_id HAVING c > 1;

-- 1-b. 중복 정리: 같은 user_id 가 여러 행이면 points 가 가장 큰 행만 남기고 나머지 삭제
--      (보수적으로 큰 값 보존. 운영 환경에서 정말 중복이 있다면 수동 확인 후 적용 권장)
DELETE m1 FROM membership_t m1
INNER JOIN membership_t m2
   ON m1.user_id = m2.user_id
  AND ( m1.points < m2.points
        OR (m1.points = m2.points AND m1.ms_idx > m2.ms_idx) );

-- 1-c. UNIQUE 추가
ALTER TABLE membership_t
    ADD CONSTRAINT uk_membership_user UNIQUE (user_id);

-- ────────────────────────────────────────────────────────────
-- (2) [선택, 안전망] CHECK 제약 — MySQL 8.0.16+ 부터 실제 강제
-- ────────────────────────────────────────────────────────────
ALTER TABLE membership_t
    ADD CONSTRAINT chk_membership_points_nonneg CHECK (points >= 0);

ALTER TABLE order_t
    ADD CONSTRAINT chk_order_points_used_nonneg   CHECK (points_used   >= 0),
    ADD CONSTRAINT chk_order_points_earned_nonneg CHECK (points_earned >= 0);

ALTER TABLE point_history_t
    ADD CONSTRAINT chk_ph_balance_nonneg CHECK (balance_after >= 0);

-- ────────────────────────────────────────────────────────────
-- (3) [선택] point_history_t.order_id → order_t.order_id FK (ON DELETE SET NULL)
--     order 가 물리 삭제될 때 history 는 보존하되 참조만 끊음.
--     (이 앱은 소프트 캔슬이라 order 물리 삭제 흐름은 없지만 안전망.)
-- ────────────────────────────────────────────────────────────
ALTER TABLE point_history_t
    ADD CONSTRAINT fk_ph_order
        FOREIGN KEY (order_id) REFERENCES order_t(order_id)
        ON DELETE SET NULL ON UPDATE CASCADE;
