-- ================================================================
-- order_t : 주문 취소/환불 관련 컬럼 추가 (5개)
-- ----------------------------------------------------------------
-- 적용 일자 : 2026-04-24
-- 사유      : 결제 취소/환불 기능 (시간 기반 3단계 정책) 도입
--             · 3분 이내     : 전액 환불 (100%)
--             · 3 ~ 10분     : 부분 환불 (50%)
--             · 10분 초과    : 취소 불가
-- ----------------------------------------------------------------
-- 주의: 이 파일은 최초 1회만 실행 가능. 중복 실행 시 1060 (Duplicate column) 오류.
--        이미 실행된 경우 SELECT * FROM order_t LIMIT 1; 로 컬럼 존재 여부 확인 후 건너뛸 것.
-- ================================================================
USE project;

-- ──────────────────────────────────────────────────────────────
-- 1) order_t 에 취소 관련 컬럼 5개 추가
-- ──────────────────────────────────────────────────────────────
ALTER TABLE order_t
  ADD COLUMN cancel_reason VARCHAR(20) NULL
  COMMENT '취소 사유: CHANGE_MIND/WRONG_ORDER/TOO_SLOW/ETC'
  AFTER paid_date;

ALTER TABLE order_t
  ADD COLUMN cancel_memo VARCHAR(200) NULL
  COMMENT '취소 비고 (기타 사유 시 사용자 입력)'
  AFTER cancel_reason;

ALTER TABLE order_t
  ADD COLUMN cancel_date DATETIME NULL
  COMMENT '취소 처리 일시'
  AFTER cancel_memo;

ALTER TABLE order_t
  ADD COLUMN refund_amount INT NOT NULL DEFAULT 0
  COMMENT '환불 금액 (100% 또는 50%)'
  AFTER cancel_date;

ALTER TABLE order_t
  ADD COLUMN refund_rate INT NOT NULL DEFAULT 0
  COMMENT '환불 비율 (100 또는 50)'
  AFTER refund_amount;

-- ──────────────────────────────────────────────────────────────
-- 2) status ENUM 에 CANCELLED 포함 여부 확인
-- ──────────────────────────────────────────────────────────────
-- 현재 스키마는 ENUM('READY','PAID','CANCELLED','FAILED') 로 정의되어 있음.
-- 만약 어떤 이유로 누락됐다면 아래 한 줄 주석 해제 후 실행:
-- ALTER TABLE order_t MODIFY COLUMN status ENUM('READY','PAID','CANCELLED','FAILED') NOT NULL DEFAULT 'READY';

-- ──────────────────────────────────────────────────────────────
-- 3) (선택) 취소 이력 테이블 — 단순화 위해 미추가. order_t 컬럼만으로 충분.
--    재취소/부분환불 이력 필요 시 별도 cancel_history 테이블 추가
-- ──────────────────────────────────────────────────────────────

-- ──────────────────────────────────────────────────────────────
-- 검증
-- ──────────────────────────────────────────────────────────────
-- 추가된 5개 컬럼 확인 (5행 반환되어야 성공)
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'order_t'
   AND COLUMN_NAME IN ('cancel_reason','cancel_memo','cancel_date','refund_amount','refund_rate')
 ORDER BY ORDINAL_POSITION;

-- status ENUM 확인 (CANCELLED 포함 여부)
SELECT COLUMN_NAME, COLUMN_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'order_t'
   AND COLUMN_NAME  = 'status';
