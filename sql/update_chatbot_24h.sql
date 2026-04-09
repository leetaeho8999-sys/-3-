-- ================================================================
-- 챗봇 키워드 업데이트 스크립트 (24시간 강조 + 링크 포함)
-- 대상 DB : project
-- 용도    : 이미 DB가 생성된 경우 이 파일만 실행하면 됩니다.
-- ================================================================
USE project;

-- ── 기존 키워드 업데이트 ─────────────────────────────────────────

UPDATE chat_keyword SET response =
    '저희 로운카페 메뉴는 에스프레소(3,600원), 아메리카노(4,200원), 카페라떼(4,700원) 등 다양합니다. 자세한 내용은 [메뉴 페이지](/menu/list)에서 확인하세요! ☕'
WHERE keyword = '메뉴';

UPDATE chat_keyword SET response =
    '처음 오셨다면 콜드브루 라떼나 바닐라라떼를 추천드려요! [메뉴 페이지](/menu/list)에서 스토리와 원산지도 확인해 보세요. 😊'
WHERE keyword = '추천';

UPDATE chat_keyword SET response =
    '아메리카노 4,200원 / 라떼류 4,700~5,300원 / 스페셜 5,600원대입니다. 텀블러 지참 시 1,000원 할인! [전체 메뉴 보기](/menu/list) ☕'
WHERE keyword = '가격';

UPDATE chat_keyword SET response =
    '저희 로운카페는 서울시 마포구 백범로 23, 20층에 위치해 있습니다. 365일 24시간 운영 중입니다! 더 궁금하신 점은 [문의 페이지](/contact)에서 남겨주세요. ✨'
WHERE keyword = '매장';

UPDATE chat_keyword SET response =
    '로운카페는 365일 24시간 운영합니다! 직원은 오전 9시~오후 10시 상주, 그 외 시간엔 셀프 이용 가능합니다. [자주 묻는 질문](/faq)도 참고해 주세요. ✨'
WHERE keyword = '영업';

UPDATE chat_keyword SET response =
    '멤버십은 일반 → 실버 → 골드 → VIP 등급으로 방문 횟수에 따라 자동 승급됩니다! 자세한 내용은 [멤버십 페이지](/membership/list)에서 확인하세요. ⭐'
WHERE keyword = '멤버십';

UPDATE chat_keyword SET response =
    '현재 이벤트 진행 중입니다! 최신 소식은 [게시판](/board/list)에서 확인하세요. 🎁'
WHERE keyword = '이벤트';

UPDATE chat_keyword SET response =
    '개인 텀블러 지참 시 1,000원 할인해 드립니다. 더 많은 혜택은 [멤버십 페이지](/membership/list)를 확인해 보세요. 🍃'
WHERE keyword = '텀블러';

UPDATE chat_keyword SET response =
    '기계식 주차장 이용 가능합니다. 주차 중 문제 발생 시 카페에서 전적으로 책임집니다. 기타 문의는 [문의하기](/contact)로 남겨주세요. 😊'
WHERE keyword = '주차';

-- ── 새 키워드 추가 (없는 경우에만 삽입) ───────────────────────────

INSERT INTO chat_keyword (keyword, response)
SELECT '영업시간', '로운카페는 24시간 365일 연중무휴로 운영합니다! [자주 묻는 질문](/faq)에서 더 많은 정보를 확인하세요. ☕'
WHERE NOT EXISTS (SELECT 1 FROM chat_keyword WHERE keyword = '영업시간');

INSERT INTO chat_keyword (keyword, response)
SELECT '몇시', '로운카페는 24시간 운영합니다! 직원 상주는 오전 9시~오후 10시. 추가 문의는 [문의하기](/contact)를 이용해 주세요. 😊'
WHERE NOT EXISTS (SELECT 1 FROM chat_keyword WHERE keyword = '몇시');

INSERT INTO chat_keyword (keyword, response)
SELECT '휴무', '로운카페는 연중무휴입니다! 365일 24시간 운영합니다. [FAQ 바로가기](/faq) ✨'
WHERE NOT EXISTS (SELECT 1 FROM chat_keyword WHERE keyword = '휴무');

INSERT INTO chat_keyword (keyword, response)
SELECT '쉬는날', '로운카페는 쉬는 날이 없습니다! 365일 24시간 연중무휴. [FAQ 바로가기](/faq) ☕'
WHERE NOT EXISTS (SELECT 1 FROM chat_keyword WHERE keyword = '쉬는날');

INSERT INTO chat_keyword (keyword, response)
SELECT '24시간', '네, 로운카페는 24시간 연중무휴 운영합니다! [문의하기](/contact) 🍃'
WHERE NOT EXISTS (SELECT 1 FROM chat_keyword WHERE keyword = '24시간');

-- ── 결과 확인 ──────────────────────────────────────────────────
SELECT id, keyword, LEFT(response, 60) AS response_preview
FROM chat_keyword
ORDER BY id;
