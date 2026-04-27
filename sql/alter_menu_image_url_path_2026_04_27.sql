-- ================================================================
-- alter_menu_image_url_path_2026_04_27.sql
-- 정적 자원 classpath 이전에 따른 image_url 경로 단축
-- ----------------------------------------------------------------
-- 적용 일자 : 2026-04-27
-- 사유      : webapp/resources → resources/static 이전. URL 도 단축됨
--             (/resources/images/foo.jpg → /images/foo.jpg)
-- 영향 행   : image_url 이 '/resources/images/' 로 시작하는 행만
-- 외부 URL : http(s):// 시작 행은 영향 없음
-- ================================================================
USE project;

-- 변경 전 미리보기
SELECT m_idx, name, image_url
  FROM menu_t
 WHERE image_url LIKE '/resources/images/%'
 ORDER BY m_idx;

-- 일괄 갱신
UPDATE menu_t
   SET image_url = REPLACE(image_url, '/resources/images/', '/images/')
 WHERE image_url LIKE '/resources/images/%';

-- 검증 (0 이어야 성공)
SELECT COUNT(*) AS remaining_old_path
  FROM menu_t
 WHERE image_url LIKE '/resources/images/%';

-- 변경 후 확인
SELECT m_idx, name, image_url
  FROM menu_t
 WHERE image_url LIKE '/images/%'
 ORDER BY m_idx;
