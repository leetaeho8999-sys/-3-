-- ================================================================
-- membership_t 상태 진단 스크립트 (읽기 전용 — 변경 없음)
-- 용도: fix_membership_fk.sql 실행 전후 상태 확인
-- 실행: MySQL Workbench 또는 CLI에서 USE project; 후 실행
-- ================================================================
USE project;

-- 1. membership_t 테이블 DDL 전체 (FK 제약조건 이름 확인)
SHOW CREATE TABLE membership_t;

-- 2. 컬럼 타입 확인 (user_id 가 INT 인지 VARCHAR 인지)
DESC membership_t;

-- 3. member 테이블 구조 확인 (m_id 타입 확인)
DESC member;

-- 4. member_t 테이블 구조 확인 (구 FK 참조 대상)
DESC member_t;

-- 5. 현재 데이터 건수
SELECT COUNT(*) AS membership_rows FROM membership_t;
SELECT COUNT(*) AS member_rows     FROM member;

-- 6. information_schema 에서 FK 제약조건 이름 확인
SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'project'
  AND TABLE_NAME = 'membership_t'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
