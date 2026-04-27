-- ================================================================
-- menu_t.image_url : 외부 unsplash URL → 로컬 영문 파일명 경로로 교체
-- ----------------------------------------------------------------
-- 적용 일자 : 2026-04-24
-- 사유      : 한글 파일명 URL 서빙 이슈 방지, 로컬 이미지 활용
-- 대상      : 로컬 이미지 파일이 존재하는 11개 메뉴만 UPDATE
--             나머지 메뉴(바닐라라떼, 카페모카, 돌체라떼, 티/에이드/
--             스무디/프라페/디저트 등)는 외부 unsplash URL 그대로 유지
-- ================================================================
USE project;

UPDATE menu_t SET image_url = '/resources/images/espresso.jpg'          WHERE name = '에스프레소';
UPDATE menu_t SET image_url = '/resources/images/americano.jpg'         WHERE name = '아메리카노';
UPDATE menu_t SET image_url = '/resources/images/cafe-latte.jpg'        WHERE name = '카페라떼';
UPDATE menu_t SET image_url = '/resources/images/cappuccino.jpg'        WHERE name = '카푸치노';
UPDATE menu_t SET image_url = '/resources/images/caramel-macchiato.jpg' WHERE name = '카라멜마키아토';
UPDATE menu_t SET image_url = '/resources/images/hazelnut-latte.png'    WHERE name = '헤이즐넛라떼';
UPDATE menu_t SET image_url = '/resources/images/affogato.png'          WHERE name = '아포가토';
UPDATE menu_t SET image_url = '/resources/images/cold-brew.jpg'         WHERE name = '콜드브루';
UPDATE menu_t SET image_url = '/resources/images/cold-brew-latte.png'   WHERE name = '콜드브루라떼';
UPDATE menu_t SET image_url = '/resources/images/drip-coffee.png'       WHERE name = '드립커피';
UPDATE menu_t SET image_url = '/resources/images/green-tea-latte.png'   WHERE name = '녹차라떼';

-- 검증: 11행이 로컬 경로로 나오면 성공
SELECT m_idx, name, image_url
  FROM menu_t
 WHERE image_url LIKE '/resources/%'
 ORDER BY m_idx;
