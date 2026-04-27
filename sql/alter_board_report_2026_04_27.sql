-- ================================================================
-- alter_board_report_2026_04_27.sql
-- 게시글 신고 기능 — 신규 테이블 + board_t 카운터 컬럼 추가
-- ----------------------------------------------------------------
-- 적용 일자 : 2026-04-27
-- 영향 테이블: 신규 report_t, 기존 board_t (컬럼 1개 추가)
-- ================================================================
USE project;

-- 1. 신고 내역 테이블 신규 생성
CREATE TABLE IF NOT EXISTS report_t (
    rno       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    b_idx     INT          NOT NULL                COMMENT '신고 대상 게시글',
    reporter  VARCHAR(50)  NOT NULL                COMMENT '신고자 m_id',
    reason    VARCHAR(50)  NOT NULL                COMMENT '신고 사유 (드롭다운 선택)',
    content   VARCHAR(500) NULL                    COMMENT '추가 사유 (선택)',
    reg_date  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_report_unique (b_idx, reporter)  -- 한 사람이 같은 글 중복 신고 방지
        COMMENT '한 게시글당 한 회원 1회 신고',
    CONSTRAINT fk_report_board FOREIGN KEY (b_idx)
        REFERENCES board_t(b_idx) ON DELETE CASCADE,
    CONSTRAINT fk_report_member FOREIGN KEY (reporter)
        REFERENCES member(m_id) ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- 2. board_t 에 신고 카운터 컬럼 추가
ALTER TABLE board_t
    ADD COLUMN report_cnt INT NOT NULL DEFAULT 0 COMMENT '신고 누적 카운트'
    AFTER active;

-- 3. 검증
SHOW CREATE TABLE report_t;
SHOW COLUMNS FROM board_t LIKE 'report_cnt';
