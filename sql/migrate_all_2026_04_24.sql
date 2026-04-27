-- ================================================================
-- ROWNCafe — 통합 마이그레이션 스크립트
-- ----------------------------------------------------------------
-- 실행 일자 : 2026-04-24
-- 대상 환경 : 로컬 개발 DB (project)
-- ----------------------------------------------------------------
-- 통합 대상 (실행 순서대로)
--   1) alter_chat_log_t_midx.sql
--   2) fix_membership_fk.sql
--   3) alter_board_content_mediumtext.sql
--   4) alter_menu_ice_extra_price.sql
--   5) create_order_tables.sql
-- ----------------------------------------------------------------
-- 실행 전 진단 결과 (2026-04-24 기준)
--   [1] chat_log_t.m_idx        = INT            → VARCHAR(50) 필요
--   [2] membership_t.user_id    = INT, UNIQUE    → VARCHAR(50) 필요
--   [3] membership_t FK         = member_t.m_idx → member.m_id 로 교체
--        · 기존 FK 이름: membership_t_ibfk_1
--   [4] board_t.content         = TEXT           → MEDIUMTEXT 필요
--   [5] menu_t.ice_extra_price  = (컬럼 없음)    → 추가 필요
--   [6] order_t, order_item_t   = (테이블 없음)  → 생성 필요
--   [7] membership_t            = 1행 존재       → TRUNCATE 전 백업 필수
-- ----------------------------------------------------------------
-- 제약 사항
--   · COLLATE 는 utf8mb4_0900_ai_ci 로 통일 (member.m_id 와 일치)
--   · ADD COLUMN IF NOT EXISTS 는 사용 금지 (MySQL 8 호환성 이슈)
--   · CREATE 문은 IF NOT EXISTS 유지
-- ================================================================

-- ────────────────────────────────────────────────────────────────
-- [0] 대상 DB 선택
-- ────────────────────────────────────────────────────────────────
USE project;


-- ════════════════════════════════════════════════════════════════
-- [1] 백업 — membership_t 기존 1행 보존
-- ----------------------------------------------------------------
-- 이 스크립트의 [3] 단계에서 TRUNCATE 를 수행하므로,
-- 실행 전 `SELECT * FROM membership_t;` 결과를 아래 주석에
-- 직접 붙여넣어 보관하세요. 필요 시 하단 복원 INSERT 템플릿 사용.
-- ════════════════════════════════════════════════════════════════
-- ▼▼▼ 실행 전 붙여넣기 자리 (ms_idx | user_id | grade | points | reg_date) ▼▼▼
--
--  예) 1 | 3 | 일반 | 0 | 2026-04-21 10:22:15
--
-- (여기에 실제 1행 데이터 기록)
--
-- ▲▲▲ 붙여넣기 자리 끝 ▲▲▲
--
-- 복원이 필요하면 [3] 단계 이후 다음 INSERT 를 사용 (user_id 는 member.m_id 의
-- 실제 문자열 아이디로 치환해야 FK 제약을 통과함):
--
--   INSERT INTO membership_t (user_id, grade, points, reg_date)
--   VALUES ('<member.m_id>', '일반', 0, '2026-04-21 10:22:15');
-- ════════════════════════════════════════════════════════════════


-- ════════════════════════════════════════════════════════════════
-- [2] chat_log_t.m_idx  INT → VARCHAR(50)
-- ----------------------------------------------------------------
-- 사유: 로그인 ID(member.m_id)가 VARCHAR 이므로 INT 컬럼에
--       저장 시 타입 불일치 오류 발생
-- 출처: alter_chat_log_t_midx.sql
-- ════════════════════════════════════════════════════════════════
ALTER TABLE chat_log_t
    MODIFY COLUMN m_idx VARCHAR(50)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL
    COMMENT '로그인 회원 아이디 (member.m_id) — 비로그인 시 NULL';


-- ════════════════════════════════════════════════════════════════
-- [3] membership_t  FK 드롭 → TRUNCATE → user_id 타입 변경 → FK 재생성
-- ----------------------------------------------------------------
-- 사유: user_id(INT) → VARCHAR(50) 로 전환하고, 잘못된 FK 대상
--       (member_t.m_idx) 을 member.m_id 로 교체
-- 출처: fix_membership_fk.sql
-- ════════════════════════════════════════════════════════════════

-- 3-1. 기존 FK 삭제 (진단상 membership_t_ibfk_1 존재)
ALTER TABLE membership_t DROP FOREIGN KEY membership_t_ibfk_1;

-- 3-2. 기존 INT user_id 데이터 제거 (VARCHAR 변환 시 쓰레기 데이터 방지)
--      ※ 1행 데이터는 상단 [1] 백업 섹션에 보존해 둘 것
TRUNCATE TABLE membership_t;

-- 3-3. user_id 컬럼 타입/COLLATE 변경
ALTER TABLE membership_t
    MODIFY COLUMN user_id VARCHAR(50)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
    COMMENT '회원 아이디 (FK → member.m_id)';

-- 3-4. 신규 FK 생성 (member.m_id 참조, CASCADE)
ALTER TABLE membership_t
    ADD CONSTRAINT fk_membership_member
    FOREIGN KEY (user_id) REFERENCES member(m_id)
    ON DELETE CASCADE ON UPDATE CASCADE;


-- ════════════════════════════════════════════════════════════════
-- [4] board_t.content  TEXT → MEDIUMTEXT
-- ----------------------------------------------------------------
-- 사유: Quill 에디터 이미지 URL 포함 장문 게시글 저장 시
--       TEXT(64KB) 초과 가능성 대비
-- 출처: alter_board_content_mediumtext.sql
-- ════════════════════════════════════════════════════════════════
ALTER TABLE board_t
    MODIFY COLUMN content MEDIUMTEXT NOT NULL;


-- ════════════════════════════════════════════════════════════════
-- [5] menu_t.ice_extra_price  신규 컬럼 추가
-- ----------------------------------------------------------------
-- 사유: HOT/ICE 가격 차등 (ICE 선택 시 +500원) 서버 보정용 컬럼
-- 주의: ADD COLUMN IF NOT EXISTS 미사용 (MySQL 8 호환성 이슈)
--       → 이미 컬럼이 있으면 본 ALTER 는 에러를 발생시키므로,
--         진단상 "없음" 확인된 환경에서만 실행
-- 출처: alter_menu_ice_extra_price.sql
-- ════════════════════════════════════════════════════════════════
ALTER TABLE menu_t
    ADD COLUMN ice_extra_price INT NOT NULL DEFAULT 500
    COMMENT 'ICE 추가금(원). 음식류/콜드전용=0'
    AFTER price;

-- 음식/콜드 전용 카테고리는 ICE 추가금 0 으로 보정
UPDATE menu_t
   SET ice_extra_price = 0
 WHERE category IN ('ADE', 'SMOOTHIE', 'FRAPPE', 'DESSERT');


-- ════════════════════════════════════════════════════════════════
-- [6] order_t  신규 테이블 생성
-- ----------------------------------------------------------------
-- 사유: 토스페이먼츠 결제 연동 — 주문 헤더
-- 출처: create_order_tables.sql
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS order_t (
    order_id     VARCHAR(64)  NOT NULL
                     COLLATE utf8mb4_0900_ai_ci,
    m_id         VARCHAR(50)  NOT NULL
                     COLLATE utf8mb4_0900_ai_ci,
    total_amount INT          NOT NULL,
    status       ENUM('READY','PAID','CANCELLED','FAILED')
                     NOT NULL DEFAULT 'READY',
    payment_key  VARCHAR(200) NULL,
    reg_date     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_date    DATETIME     NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT fk_order_member
        FOREIGN KEY (m_id) REFERENCES member(m_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- ════════════════════════════════════════════════════════════════
-- [7] order_item_t  신규 테이블 생성
-- ----------------------------------------------------------------
-- 사유: 토스페이먼츠 결제 연동 — 주문 상세 항목
-- 출처: create_order_tables.sql
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS order_item_t (
    oi_idx      INT          NOT NULL AUTO_INCREMENT,
    order_id    VARCHAR(64)  NOT NULL
                    COLLATE utf8mb4_0900_ai_ci,
    menu_name   VARCHAR(100) NOT NULL,
    temperature VARCHAR(10)  NOT NULL DEFAULT 'NONE',
    quantity    INT          NOT NULL DEFAULT 1,
    unit_price  INT          NOT NULL,
    subtotal    INT          NOT NULL,
    PRIMARY KEY (oi_idx),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id) REFERENCES order_t(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- ════════════════════════════════════════════════════════════════
-- [8] 검증 — 각 항목이 기대값과 일치하는지 확인
-- ----------------------------------------------------------------
-- 아래 8개 SELECT 는 모두 "기대 결과"와 일치해야 마이그레이션 성공.
-- ════════════════════════════════════════════════════════════════

-- 8-1. chat_log_t.m_idx 타입 확인
--      기대: DATA_TYPE=varchar, CHARACTER_MAXIMUM_LENGTH=50
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLLATION_NAME
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'chat_log_t'
   AND COLUMN_NAME  = 'm_idx';

-- 8-2. membership_t.user_id 타입 확인
--      기대: DATA_TYPE=varchar, LEN=50, COLLATION=utf8mb4_0900_ai_ci
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLLATION_NAME
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'membership_t'
   AND COLUMN_NAME  = 'user_id';

-- 8-3. membership_t FK 확인
--      기대: fk_membership_member | user_id | member | m_id
SELECT CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'membership_t'
   AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 8-4. board_t.content 타입 확인
--      기대: DATA_TYPE=mediumtext
SELECT COLUMN_NAME, DATA_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'board_t'
   AND COLUMN_NAME  = 'content';

-- 8-5. menu_t.ice_extra_price 컬럼 존재 및 기본값 확인
--      기대: DATA_TYPE=int, COLUMN_DEFAULT=500, IS_NULLABLE=NO
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT, IS_NULLABLE
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME   = 'menu_t'
   AND COLUMN_NAME  = 'ice_extra_price';

-- 8-6. menu_t ice_extra_price 카테고리별 분포 확인
--      기대: ADE/SMOOTHIE/FRAPPE/DESSERT = 0, 나머지 = 500
SELECT category, MIN(ice_extra_price) AS min_ice, MAX(ice_extra_price) AS max_ice, COUNT(*) AS cnt
  FROM menu_t
 GROUP BY category
 ORDER BY category;

-- 8-7. order_t, order_item_t 테이블 존재 확인
--      기대: 2행 반환
SELECT TABLE_NAME, ENGINE, TABLE_COLLATION
  FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME IN ('order_t', 'order_item_t')
 ORDER BY TABLE_NAME;

-- 8-8. order_t, order_item_t FK 확인
--      기대: fk_order_member(order_t.m_id → member.m_id),
--            fk_order_item_order(order_item_t.order_id → order_t.order_id)
SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
 WHERE TABLE_SCHEMA = 'project'
   AND TABLE_NAME IN ('order_t', 'order_item_t')
   AND REFERENCED_TABLE_NAME IS NOT NULL
 ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- ================================================================
-- 마이그레이션 완료
-- ================================================================
