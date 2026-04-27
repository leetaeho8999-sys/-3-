-- ================================================================
-- fix_menu_image_korean_filenames_2026_04_27.sql
-- DB의 image_url 한글 파일명을 영문 파일명으로 매핑 정렬 (최종)
-- ----------------------------------------------------------------
-- 배경 : classpath 이전 후 URL 가 /images/ 로 단축됐고 정적 자원
--        서빙은 정상이나, DB 의 image_url 일부 행이 여전히
--        한글 파일명을 보유하고 있어 404 발생.
--        (예: /images/에스프레소.jpg → 디스크엔 espresso.jpg 뿐)
-- 적용 : HeidiSQL 등에서 STEP 단위로 결과 확인하며 실행
-- ================================================================
USE project;

-- ================================================================
-- STEP 1. 진단 — 어떤 행이 한글 파일명을 갖고 있는지 확인
-- ================================================================

-- 1-1. 한글이 들어간 image_url 전체 (이걸 영문으로 바꿔야 함)
SELECT m_idx, name, price, image_url
  FROM menu_t
 WHERE image_url REGEXP '[가-힣]'
 ORDER BY name, m_idx;

-- 1-2. 메뉴명 분포 확인 (중복 행 파악용)
SELECT name, COUNT(*) AS cnt, GROUP_CONCAT(m_idx) AS idx_list
  FROM menu_t
 WHERE image_url REGEXP '[가-힣]'
 GROUP BY name
 ORDER BY name;


-- ================================================================
-- STEP 2. 일괄 매핑 갱신 (메뉴명 → 영문 파일 경로)
-- ----------------------------------------------------------------
-- 디스크에 실존하는 파일은 src/main/resources/static/images/ 아래
--   espresso.jpg, americano.jpg, cafe-latte.jpg, cappuccino.jpg,
--   caramel-macchiato.jpg, hazelnut-latte.png, affogato.png,
--   cold-brew.jpg, cold-brew-latte.png, drip-coffee.png,
--   green-tea-latte.png, einspanner.jpg, latte-s.jpg, latte-swan.jpg
-- ================================================================
UPDATE menu_t SET image_url = '/images/espresso.jpg'          WHERE name = '에스프레소';
UPDATE menu_t SET image_url = '/images/americano.jpg'         WHERE name = '아메리카노';
UPDATE menu_t SET image_url = '/images/cafe-latte.jpg'        WHERE name = '카페라떼';
UPDATE menu_t SET image_url = '/images/cappuccino.jpg'        WHERE name = '카푸치노';
UPDATE menu_t SET image_url = '/images/caramel-macchiato.jpg' WHERE name = '카라멜마키아토';
UPDATE menu_t SET image_url = '/images/hazelnut-latte.png'    WHERE name = '헤이즐넛라떼';
UPDATE menu_t SET image_url = '/images/affogato.png'          WHERE name = '아포가토';
UPDATE menu_t SET image_url = '/images/cold-brew.jpg'         WHERE name = '콜드브루';
UPDATE menu_t SET image_url = '/images/cold-brew-latte.png'   WHERE name = '콜드브루라떼';
UPDATE menu_t SET image_url = '/images/drip-coffee.png'       WHERE name = '드립커피';
UPDATE menu_t SET image_url = '/images/green-tea-latte.png'   WHERE name = '녹차라떼';
UPDATE menu_t SET image_url = '/images/einspanner.jpg'        WHERE name = '아인슈페너';


-- ================================================================
-- STEP 3. 라떼 계열 (latte-s.jpg / latte-swan.jpg) 매핑
-- ----------------------------------------------------------------
-- 로그에 /images/라떼-에스.jpg 가 보였으므로 해당 메뉴명이 있음.
-- STEP 1-1 SELECT 결과에서 정확한 name 을 확인 후 아래 둘 중
-- 맞는 쪽 주석 해제하거나 직접 채워서 실행하세요.
-- ================================================================

-- 후보 (메뉴명에 '라떼' 가 들어가고 image_url 에 한글이 남아있는 행)
SELECT m_idx, name, price, image_url
  FROM menu_t
 WHERE name LIKE '%라떼%'
   AND image_url REGEXP '[가-힣]'
 ORDER BY name, m_idx;

-- 위 결과에서 어떤 메뉴가 latte-s 이고 어떤 게 latte-swan 인지 식별 후 적용:
-- UPDATE menu_t SET image_url = '/images/latte-s.jpg'    WHERE name = '<해당 메뉴명>';
-- UPDATE menu_t SET image_url = '/images/latte-swan.jpg' WHERE name = '<해당 메뉴명>';


-- ================================================================
-- STEP 4. 잔여 한글 image_url 확인 — 0 이어야 성공
-- ================================================================
SELECT COUNT(*) AS remaining_korean_filenames
  FROM menu_t
 WHERE image_url REGEXP '[가-힣]';

-- 만약 0이 아니면 어떤 메뉴가 남았는지 확인 (수동 매핑 필요)
SELECT m_idx, name, image_url
  FROM menu_t
 WHERE image_url REGEXP '[가-힣]';


-- ================================================================
-- STEP 5. 최종 확인 — 모든 로컬 이미지 행이 /images/ 영문 경로인지
-- ================================================================
SELECT m_idx, name, category, price, image_url
  FROM menu_t
 WHERE image_url LIKE '/images/%'
 ORDER BY FIELD(category,'ESPRESSO','COFFEE','LATTE','NONCOFFEE','TEA','ADE','SMOOTHIE','FRAPPE','SPECIAL','DESSERT'),
          name, m_idx;


-- ================================================================
-- 롤백 (필요 시)
-- ================================================================
-- 이 마이그레이션은 한글 → 영문 단방향이라 자동 롤백이 어려움.
-- 작업 전 백업 권장:
--   CREATE TABLE menu_t_backup_20260427 AS SELECT * FROM menu_t;
-- 롤백 시: UPDATE menu_t m JOIN menu_t_backup_20260427 b USING(m_idx) SET m.image_url = b.image_url;
