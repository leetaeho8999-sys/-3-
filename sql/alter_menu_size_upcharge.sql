-- ================================================================
-- menu_t : 사이즈(TALL/GRANDE/VENTI) 추가금 컬럼 추가
-- order_item_t : 주문된 사이즈 기록 컬럼 추가
-- ----------------------------------------------------------------
-- 적용 일자 : 2026-04-24
-- 사유      : 스타벅스 기준 사이즈 체계 도입 — Grande +500, Venti +1000
--             ESPRESSO(샷 기반), DESSERT(음식) 는 사이즈 개념 없음
-- ----------------------------------------------------------------
-- 주의: 이 파일은 최초 1회만 실행 가능. 중복 실행 시 1060 (Duplicate column) 오류 발생.
--        이미 실행된 경우 SELECT * FROM menu_t LIMIT 1; 로 컬럼 존재 여부 확인 후 건너뛸 것.
-- ================================================================
USE project;

-- ──────────────────────────────────────────────────────────────
-- 1. menu_t 에 사이즈 추가금 컬럼 2개 추가
-- ──────────────────────────────────────────────────────────────
ALTER TABLE menu_t
  ADD COLUMN size_upcharge_grande INT NOT NULL DEFAULT 500
  COMMENT 'Grande 추가금(원)'
  AFTER ice_extra_price;

ALTER TABLE menu_t
  ADD COLUMN size_upcharge_venti INT NOT NULL DEFAULT 1000
  COMMENT 'Venti 추가금(원)'
  AFTER size_upcharge_grande;

-- 사이즈 개념 없는 카테고리는 0 으로 보정
UPDATE menu_t
   SET size_upcharge_grande = 0, size_upcharge_venti = 0
 WHERE category IN ('ESPRESSO', 'DESSERT');

-- ──────────────────────────────────────────────────────────────
-- 2. order_item_t 에 size 컬럼 추가
-- ──────────────────────────────────────────────────────────────
ALTER TABLE order_item_t
  ADD COLUMN size VARCHAR(10) NOT NULL DEFAULT 'TALL'
  COMMENT '사이즈: TALL/GRANDE/VENTI/NONE'
  AFTER temperature;

-- ──────────────────────────────────────────────────────────────
-- 검증
-- ──────────────────────────────────────────────────────────────
-- menu_t : 카테고리별 사이즈 추가금 분포
SELECT category,
       MIN(size_upcharge_grande) AS min_g, MAX(size_upcharge_grande) AS max_g,
       MIN(size_upcharge_venti)  AS min_v, MAX(size_upcharge_venti)  AS max_v,
       COUNT(*) AS cnt
  FROM menu_t
 GROUP BY category
 ORDER BY category;

-- order_item_t : size 컬럼 확인
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, COLUMN_DEFAULT
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'order_item_t'
   AND COLUMN_NAME  = 'size';
