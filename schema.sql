-- ================================================================
-- BREW CRM v2 — MySQL 완전 연동 스크립트
-- ----------------------------------------------------------------
-- DB     : dbstudy
-- USER   : dbuser  /  PASSWORD : 1234
-- ENGINE : InnoDB  /  CHARSET  : utf8mb4
--
-- 실행 방법 (MySQL root 계정으로):
--   mysql -u root -p < schema.sql
--   또는 MySQL Workbench / DBeaver 에서 전체 선택 후 실행
-- ================================================================


-- ================================================================
-- STEP 1. 데이터베이스 & 사용자 생성
--         root 계정으로 최초 1회 실행
-- ================================================================

CREATE DATABASE IF NOT EXISTS dbstudy
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 사용자가 이미 존재하면 무시, 없으면 생성
CREATE USER IF NOT EXISTS 'dbuser'@'localhost' IDENTIFIED BY '1234';

-- dbstudy 스키마 전체 권한 부여
GRANT ALL PRIVILEGES ON dbstudy.* TO 'dbuser'@'localhost';
FLUSH PRIVILEGES;

USE dbstudy;


-- ================================================================
-- STEP 2. 기존 트리거 제거
--         (트리거가 살아있으면 DROP TABLE 시 문제될 수 있음)
-- ================================================================

DROP TRIGGER IF EXISTS trg_auto_grade_insert;
DROP TRIGGER IF EXISTS trg_auto_grade;


-- ================================================================
-- STEP 3. 기존 테이블 제거
--         FK 제약 순서: member_t(참조하는 쪽) 먼저 삭제
-- ================================================================

DROP TABLE IF EXISTS member_t;
DROP TABLE IF EXISTS customer_t;


-- ================================================================
-- STEP 4. 테이블 생성
-- ================================================================

-- ── 4-1. 고객 테이블 ─────────────────────────────────────────
CREATE TABLE customer_t (
    c_idx       INT           NOT NULL AUTO_INCREMENT  COMMENT '고객 번호 (PK)',
    name        VARCHAR(50)   NOT NULL                 COMMENT '고객 이름',
    phone       VARCHAR(20)   DEFAULT '-'              COMMENT '연락처',
    grade       VARCHAR(10)   DEFAULT '일반'            COMMENT '등급 (일반/실버/골드/VIP)',
    visit_count INT           DEFAULT 0                COMMENT '방문 횟수',
    memo        TEXT                                   COMMENT '메모 (알레르기, 선호 음료 등)',
    reg_date    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    active      TINYINT       DEFAULT 0                COMMENT '0=정상, 1=삭제',
    PRIMARY KEY (c_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM 고객 테이블';

-- ── 4-2. 회원 테이블 ─────────────────────────────────────────
--  linked_customer → customer_t.c_idx (1:1, 회원 탈퇴 시 NULL 처리)
CREATE TABLE member_t (
    m_idx           INT           NOT NULL AUTO_INCREMENT  COMMENT '회원 번호 (PK)',
    email           VARCHAR(100)  NOT NULL UNIQUE          COMMENT '이메일 (로그인 ID)',
    password        VARCHAR(255)  NOT NULL                 COMMENT '비밀번호 (BCrypt)',
    name            VARCHAR(50)   NOT NULL                 COMMENT '이름',
    linked_customer INT           DEFAULT NULL             COMMENT '연결된 customer_t.c_idx (FK)',
    reg_date        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    active          TINYINT       DEFAULT 0                COMMENT '0=정상, 1=탈퇴',
    PRIMARY KEY (m_idx),
    CONSTRAINT fk_member_customer
        FOREIGN KEY (linked_customer)
        REFERENCES customer_t(c_idx)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원 테이블 (마이페이지 로그인)';


-- ================================================================
-- STEP 5. 트리거 생성
--         Java ServiceImpl 과 이중으로 동작 — DB 레벨 안전망
-- ================================================================

-- ── 5-1. BEFORE INSERT — 신규 고객 등록 시 등급 자동 계산 ────
DELIMITER //
CREATE TRIGGER trg_auto_grade_insert
BEFORE INSERT ON customer_t
FOR EACH ROW
BEGIN
    IF NEW.visit_count >= 31 THEN
        SET NEW.grade = 'VIP';
    ELSEIF NEW.visit_count >= 16 THEN
        SET NEW.grade = '골드';
    ELSEIF NEW.visit_count >= 6 THEN
        SET NEW.grade = '실버';
    ELSE
        SET NEW.grade = '일반';
    END IF;
END//
DELIMITER ;

-- ── 5-2. BEFORE UPDATE — 방문 횟수 변경 시 등급 자동 갱신 ───
DELIMITER //
CREATE TRIGGER trg_auto_grade
BEFORE UPDATE ON customer_t
FOR EACH ROW
BEGIN
    IF NEW.visit_count >= 31 THEN
        SET NEW.grade = 'VIP';
    ELSEIF NEW.visit_count >= 16 THEN
        SET NEW.grade = '골드';
    ELSEIF NEW.visit_count >= 6 THEN
        SET NEW.grade = '실버';
    ELSE
        SET NEW.grade = '일반';
    END IF;
END//
DELIMITER ;


-- ================================================================
-- STEP 6. 테스트 데이터
--         grade 컬럼은 트리거가 visit_count 기준으로 자동 설정
--         → INSERT 시 grade 를 명시하지 않아도 됨
-- ================================================================

-- ── 6-1. 고객 샘플 데이터 (5명) ──────────────────────────────
INSERT INTO customer_t (name, phone, visit_count, memo) VALUES
('김민준', '010-1234-5678', 42, '아이스 아메리카노 고정 주문, 우유 알레르기'),   -- → VIP
('이서연', '010-2345-6789', 28, '라떼 계열 선호, 연하게'),                     -- → 골드
('박도윤', '010-3456-7890', 15, '캐러멜 마키아토 즐겨 마심'),                   -- → 실버
('최지우', '010-4567-8901',  3, ''),                                           -- → 일반
('정하은', '010-5678-9012', 55, '매일 오전 9시 방문, 더블 샷 에스프레소');      -- → VIP

-- ── 6-2. 회원 샘플 데이터 ────────────────────────────────────
--  비밀번호 원문: "password123"
--  BCrypt 해시 (rounds=10): $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
--  → 김민준(c_idx=1) 계정과 연결
INSERT INTO member_t (email, password, name, linked_customer) VALUES
('test@brew.com',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '김민준', 1);


-- ================================================================
-- STEP 7. 결과 확인 쿼리
-- ================================================================

-- 고객 목록 + 등급 확인 (트리거 정상 동작 검증)
SELECT '▶ customer_t' AS '';
SELECT c_idx, name, phone, grade, visit_count, memo
FROM   customer_t
ORDER  BY c_idx;

-- 회원-고객 JOIN 확인 (linked_customer 연결 검증)
SELECT '▶ member_t JOIN customer_t' AS '';
SELECT m.m_idx,
       m.email,
       m.name          AS member_name,
       m.linked_customer,
       c.grade,
       c.visit_count,
       c.phone
FROM   member_t  m
LEFT   JOIN customer_t c ON m.linked_customer = c.c_idx;

-- 트리거 등록 확인
SELECT '▶ 트리거 목록' AS '';
SHOW TRIGGERS WHERE `Table` = 'customer_t';
