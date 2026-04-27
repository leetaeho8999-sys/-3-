-- ================================================================
-- ROWNCafe — 전체 스키마 초기화 스크립트
-- ----------------------------------------------------------------
-- 신규 환경 구축 시 이 파일 하나만 실행하면 됩니다.
-- 이미 존재하는 테이블은 건너뜁니다 (IF NOT EXISTS).
-- ----------------------------------------------------------------
-- 실행 순서
--   1. source sql/init_schema.sql   ← 이 파일 하나만 실행하면 됨
-- ================================================================

USE project;

-- ──────────────────────────────────────────────────────────────
-- 1. member — 로그인·회원가입 (현재 사용 중인 테이블)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS member (
    m_id    VARCHAR(50)  NOT NULL PRIMARY KEY COMMENT '아이디',
    m_pw    VARCHAR(100) NOT NULL             COMMENT '비밀번호',
    m_name  VARCHAR(50)  NOT NULL             COMMENT '이름',
    m_phone VARCHAR(20)  NULL                 COMMENT '전화번호',
    m_email VARCHAR(100) NULL                 COMMENT '이메일'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci
  COMMENT='현재 로그인용 회원 테이블';

-- ──────────────────────────────────────────────────────────────
-- 2. customer_t — CRM 고객 (멤버십 방문 횟수 조인 대상)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS customer_t (
    c_idx       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL COMMENT '고객 이름',
    phone       VARCHAR(20)  NOT NULL UNIQUE COMMENT '전화번호 (member.m_phone 조인 키)',
    grade       VARCHAR(20)  NULL     COMMENT 'CRM 등급',
    visit_count INT          NOT NULL DEFAULT 0 COMMENT '방문 횟수',
    active      TINYINT      NOT NULL DEFAULT 0 COMMENT '0=활성, 1=비활성'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci
  COMMENT='CRM 고객 테이블 — 방문 횟수 기준 멤버십 등급 산정';

-- ──────────────────────────────────────────────────────────────
-- 3. membership_t — 멤버십 포인트·등급
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS membership_t (
    ms_idx   INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id  VARCHAR(50)  NOT NULL
             CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci
             COMMENT '회원 아이디 (FK → member.m_id)',
    grade    VARCHAR(20)  NOT NULL DEFAULT '일반' COMMENT '등급',
    points   INT          NOT NULL DEFAULT 0      COMMENT '포인트',
    reg_date DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_membership_user UNIQUE (user_id),
    CONSTRAINT chk_membership_points_nonneg CHECK (points >= 0),
    CONSTRAINT fk_membership_member
        FOREIGN KEY (user_id) REFERENCES member(m_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 4. board_t — 게시판 (active: 0=정상, 1=소프트삭제)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS board_t (
    b_idx    INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title    VARCHAR(200) NOT NULL,
    category VARCHAR(20)  NOT NULL COMMENT '공지/자유/이벤트',
    content  MEDIUMTEXT   NOT NULL             COMMENT '게시글 본문 (Quill 이미지 URL 포함 장문 대응)',
    author   VARCHAR(50)  NOT NULL COMMENT 'member.m_id',
    reg_date DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    views    INT          NOT NULL DEFAULT 0,
    comments INT          NOT NULL DEFAULT 0,
    active   TINYINT      NOT NULL DEFAULT 0 COMMENT '0=정상, 1=삭제'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 5. comment_t — 댓글
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS comment_t (
    c_idx    INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    b_idx    INT          NOT NULL,
    author   VARCHAR(50)  NOT NULL,
    content  VARCHAR(500) NOT NULL,
    reg_date DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_board FOREIGN KEY (b_idx)
        REFERENCES board_t(b_idx) ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 6. menu_t — 메뉴
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS menu_t (
    m_idx       INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL COMMENT '메뉴명',
    description VARCHAR(500)  NULL     COMMENT '설명',
    category    VARCHAR(50)   NOT NULL COMMENT '커피/논커피/에이드&스무디/티/블렌디드·프라페/디저트&푸드',
    image_url   VARCHAR(300)  NULL     COMMENT '이미지 경로',
    story       TEXT          NULL     COMMENT '메뉴 스토리',
    origin      VARCHAR(200)  NULL     COMMENT '원산지',
    price                INT          NOT NULL DEFAULT 0    COMMENT '가격 (원)',
    ice_extra_price      INT          NOT NULL DEFAULT 500  COMMENT 'ICE 추가금 (원). 음식류=0',
    size_upcharge_grande INT          NOT NULL DEFAULT 500  COMMENT 'Grande 추가금(원). ESPRESSO/DESSERT=0',
    size_upcharge_venti  INT          NOT NULL DEFAULT 1000 COMMENT 'Venti 추가금(원). ESPRESSO/DESSERT=0',
    available            TINYINT      NOT NULL DEFAULT 1    COMMENT '1=판매중, 0=판매중지'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 7. chat_log_t — 채팅 로그 (m_idx: VARCHAR — alter 스크립트 적용 후 형태)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS chat_log_t (
    log_idx    INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL COMMENT 'HTTP 세션 ID',
    m_idx      VARCHAR(50)  NULL     COMMENT '로그인 회원 아이디 (member.m_id), 비로그인 시 NULL',
    sender     VARCHAR(10)  NOT NULL COMMENT 'user / bot',
    message    TEXT         NOT NULL,
    reg_date   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 8. chat_history — AI 대화 기록 (Groq 컨텍스트용)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS chat_history (
    id         INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sender     VARCHAR(10)  NOT NULL COMMENT 'user / bot',
    message    TEXT         NOT NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 9. chat_keyword — AI 키워드 힌트
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS chat_keyword (
    id       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    keyword  VARCHAR(100) NOT NULL COMMENT '매칭 키워드',
    response TEXT         NOT NULL COMMENT 'AI에 전달할 힌트 텍스트'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 10. chat_rating — 챗봇 만족도 평가
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS chat_rating (
    id          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    bot_message TEXT         NOT NULL,
    rating      VARCHAR(10)  NOT NULL COMMENT 'good / bad',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 11. foreign_word_map — AI 외래어 필터 치환 사전
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS foreign_word_map (
    id           INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    foreign_word VARCHAR(200) NOT NULL COMMENT '치환 대상 외래어',
    korean_word  VARCHAR(200) NOT NULL COMMENT '치환 결과 한국어'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 12. order_t — 주문 헤더 (TossPayments 결제)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_t (
    order_id      VARCHAR(64)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    m_id          VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    total_amount  INT          NOT NULL,
    status        ENUM('READY','PAID','CANCELLED','FAILED') NOT NULL DEFAULT 'READY',
    payment_key   VARCHAR(200) NULL,
    reg_date      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_date     DATETIME     NULL,
    cancel_reason VARCHAR(20)  NULL COMMENT '취소 사유: CHANGE_MIND/WRONG_ORDER/TOO_SLOW/ETC',
    cancel_memo   VARCHAR(200) NULL COMMENT '취소 비고 (기타 사유 시 사용자 입력)',
    cancel_date   DATETIME     NULL COMMENT '취소 처리 일시',
    refund_amount INT          NOT NULL DEFAULT 0 COMMENT '환불 금액 (100% 또는 50%)',
    refund_rate   INT          NOT NULL DEFAULT 0 COMMENT '환불 비율 (100 또는 50)',
    points_used   INT          NOT NULL DEFAULT 0 COMMENT '주문 시 사용한 포인트',
    points_earned INT          NOT NULL DEFAULT 0 COMMENT '결제 승인 시 적립된 포인트',
    PRIMARY KEY (order_id),
    CONSTRAINT chk_order_points_used_nonneg   CHECK (points_used   >= 0),
    CONSTRAINT chk_order_points_earned_nonneg CHECK (points_earned >= 0),
    CONSTRAINT fk_order_member
        FOREIGN KEY (m_id) REFERENCES member(m_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 12-A. visit_t — 방문 이벤트 로그 (결제 PAID = +1 / CANCELLED = cancelled=1)
--       멤버십 페이지의 "이번 달 방문 횟수" 단일 진원지
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS visit_t (
    v_idx       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    m_id        VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    order_id    VARCHAR(64)  NULL     COLLATE utf8mb4_0900_ai_ci COMMENT '관련 주문, order_t 물리 삭제 시 NULL 로 초기화',
    visit_date  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cancelled   TINYINT      NOT NULL DEFAULT 0 COMMENT '1=결제 취소되어 방문 무효',
    cancel_date DATETIME     NULL,
    INDEX idx_visit_member_month (m_id, visit_date, cancelled),
    INDEX idx_visit_order (order_id),
    CONSTRAINT uk_visit_order UNIQUE (order_id),
    CONSTRAINT fk_visit_member FOREIGN KEY (m_id)
        REFERENCES member(m_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_visit_order  FOREIGN KEY (order_id)
        REFERENCES order_t(order_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_visit_cancelled CHECK (cancelled IN (0,1))
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 13. order_item_t — 주문 상세 항목
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_item_t (
    oi_idx      INT          NOT NULL AUTO_INCREMENT,
    order_id    VARCHAR(64)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    menu_name   VARCHAR(100) NOT NULL,
    temperature VARCHAR(10)  NOT NULL DEFAULT 'NONE',
    size        VARCHAR(10)  NOT NULL DEFAULT 'TALL' COMMENT 'TALL/GRANDE/VENTI/NONE',
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

-- ──────────────────────────────────────────────────────────────
-- 14. cart_t — 장바구니 (결제 전 임시 보관, DB 기반 영구 저장)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cart_t (
    cart_idx    INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    m_id        VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci COMMENT '회원 ID',
    menu_name   VARCHAR(100) NOT NULL COMMENT '메뉴명',
    temperature VARCHAR(10)  NOT NULL DEFAULT 'NONE' COMMENT 'HOT/ICE/NONE',
    size        VARCHAR(10)  NOT NULL DEFAULT 'TALL' COMMENT 'TALL/GRANDE/VENTI/NONE',
    quantity    INT          NOT NULL DEFAULT 1,
    unit_price  INT          NOT NULL COMMENT '옵션 반영된 잔당 가격 (서버에서 재계산된 값)',
    reg_date    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_cart_m_id (m_id),
    CONSTRAINT fk_cart_member
        FOREIGN KEY (m_id) REFERENCES member(m_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────────────
-- 15. point_history_t — 포인트 적립/사용 내역 (감사 + 마이페이지 표시)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS point_history_t (
    ph_idx        INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    m_id          VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci,
    type          ENUM('EARN','USE','CANCEL_EARN','RESTORE_USE','SIGNUP_BONUS')
                  NOT NULL COMMENT '적립/사용/적립취소/사용복원/가입보너스',
    amount        INT          NOT NULL COMMENT '+ 적립/복원/보너스, - 사용/적립취소',
    balance_after INT          NOT NULL COMMENT '거래 후 잔액 (감사용)',
    order_id      VARCHAR(64)  NULL COLLATE utf8mb4_0900_ai_ci COMMENT '관련 주문 (가입보너스는 NULL)',
    description   VARCHAR(200) NULL,
    reg_date      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_ph_member_date (m_id, reg_date DESC),
    INDEX idx_ph_order (order_id),
    CONSTRAINT chk_ph_balance_nonneg CHECK (balance_after >= 0),
    CONSTRAINT fk_ph_member FOREIGN KEY (m_id)
        REFERENCES member(m_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ph_order FOREIGN KEY (order_id)
        REFERENCES order_t(order_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- ================================================================
-- 완료 확인
-- ================================================================
SHOW TABLES;
