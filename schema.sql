-- ================================================================
-- 정성을 다한 커피 (cafe-spring) — schema.sql
-- ----------------------------------------------------------------
-- DB     : dbstudy  (brew-crm-v2 와 같은 DB 공유)
-- PORT   : 8080  (brew-crm-v2 는 8081)
--
-- ※ 실제 DB 구조는 brew-crm-v2/schema.sql 기준으로 생성한다.
--    이 파일은 cafe-spring 전용 테이블(board_t, comment_t, menu_t)과
--    공유 테이블(customer_t, member_t, membership_t) 전체를 기술한다.
-- ================================================================

USE dbstudy;


-- ================================================================
-- ★ 기존 DB 마이그레이션 (이미 테이블이 있는 경우 아래 중 필요한 것만 실행)
-- 새로 설치하는 경우에는 아래 CREATE TABLE 이 대신 처리하므로 생략 가능.
-- ※ 이미 해당 컬럼이 있으면 "Duplicate column name" 오류 → 그냥 무시하면 됨.
-- ================================================================

-- [1] member_t.role — 로그인·권한 체크에 필수. 없으면 로그인 시 SQL 오류 발생
ALTER TABLE member_t
    ADD COLUMN role VARCHAR(20) DEFAULT 'STAFF'
        COMMENT '권한 (ADMIN/MANAGER/STAFF/MEMBER)' AFTER active;

-- [2] customer_t.monthly_visit — 이번 달 방문 횟수, 등급 산정에 필요
ALTER TABLE customer_t
    ADD COLUMN monthly_visit INT DEFAULT 0
        COMMENT '이번 달 방문 횟수' AFTER visit_count;

-- [3] customer_t.monthly_amount — 이번 달 결제액, 대시보드 통계에 필요
ALTER TABLE customer_t
    ADD COLUMN monthly_amount INT DEFAULT 0
        COMMENT '이번 달 누적 결제액(원)' AFTER monthly_visit;

-- [4] customer_t.birthday — 마케팅 페이지 생일 고객 조회에 필요
ALTER TABLE customer_t
    ADD COLUMN birthday DATE DEFAULT NULL
        COMMENT '생일 (마케팅 자동화용)' AFTER monthly_amount;

-- [5] customer_t.last_visit_date — 이탈 고객 탐지에 필요
ALTER TABLE customer_t
    ADD COLUMN last_visit_date TIMESTAMP NULL
        COMMENT '마지막 방문 일시' AFTER birthday;

-- [6] 첫 번째 계정을 ADMIN으로 설정 (최초 1회만 실행, 주석 해제 후 실행)
-- UPDATE member_t SET role = 'ADMIN' WHERE m_idx = 1;

-- ================================================================
-- 공유 테이블 (brew-crm-v2 와 동일 DB 사용)
-- ================================================================

-- ── customer_t ───────────────────────────────────────────────
--  brew-crm 관리자가 주로 관리하는 고객 테이블.
--  cafe-spring 에서는 회원가입 시 row를 생성하고(insertCustomerForMember),
--  member_t.linked_customer FK 로 참조하여 등급·방문 정보를 읽는다.
CREATE TABLE IF NOT EXISTS customer_t (
    c_idx       INT           NOT NULL AUTO_INCREMENT
        COMMENT '고객 번호 (PK) — member_t.linked_customer FK 로 참조. cafe-spring 회원가입(insertCustomerForMember) 시 자동 생성',

    name        VARCHAR(50)   NOT NULL
        COMMENT '고객 이름 — cafe-spring 회원가입 시 username 값으로 채워짐. brew-crm 고객 목록 표시. 마이페이지 수정 시 updateLinkedCustomer 로 동기화',

    phone       VARCHAR(20)   DEFAULT '-'
        COMMENT '연락처 — cafe-spring 회원가입·정보 수정 시 동기화. brew-crm 고객 검색(이름/전화 LIKE) 에 사용',

    grade       VARCHAR(10)   DEFAULT '일반'
        COMMENT '등급 (일반/실버/골드/VIP) — brew-crm 방문 기록 시 자동 갱신. cafe-spring MemberMapper.findMyPageInfo() LEFT JOIN 으로 읽어 ${memberInfo.grade} 표시. membership_t.grade 와 항상 동기화',

    visit_count INT           DEFAULT 0
        COMMENT '방문 횟수 — brew-crm 관리자 [방문 기록] 클릭 시 +1. 등급 산정 기준, 포인트(×100) 계산 기준. cafe-spring 마이페이지 ${memberInfo.visitCount} 표시',

    memo        TEXT
        COMMENT '메모 — 알레르기·선호 음료 등. brew-crm 관리자 메모 화면에서 수정',

    reg_date    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
        COMMENT '등록일 — brew-crm 대시보드 이번 달 신규 고객 수 집계에 사용',

    monthly_visit  INT           DEFAULT 0
        COMMENT '이번 달 방문 횟수 — 등급 산정 기준(실버 3회+, 골드 10회+). 매월 1일 0으로 리셋 필요',

    monthly_amount INT           DEFAULT 0
        COMMENT '이번 달 누적 결제액(원) — 등급 산정 기준(실버 3만원+, 골드 7만원+, VIP 15만원+). 매월 1일 0으로 리셋 필요',

    birthday        DATE          DEFAULT NULL
        COMMENT '생일 — 마케팅 자동화(생일 쿠폰 발송)에 사용',

    last_visit_date TIMESTAMP     NULL
        COMMENT '마지막 방문 일시 — 이탈 의심 고객(30일 이상 미방문) 탐지에 사용',

    active      TINYINT       DEFAULT 0
        COMMENT '삭제 여부 (0=정상, 1=논리삭제) — 모든 SELECT에 AND c.active=0 조건 포함. 실제 row는 남김',

    PRIMARY KEY (c_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='CRM 고객 테이블 — brew-crm에서 관리, cafe-spring 회원가입 시 row 자동 생성';

-- ※ 기존 DB에 컬럼 추가 시 아래 ALTER 실행
-- ALTER TABLE customer_t
--   ADD COLUMN monthly_visit    INT  DEFAULT 0    COMMENT '이번 달 방문 횟수'    AFTER visit_count,
--   ADD COLUMN monthly_amount   INT  DEFAULT 0    COMMENT '이번 달 누적 결제액'  AFTER monthly_visit,
--   ADD COLUMN birthday         DATE DEFAULT NULL COMMENT '생일 (마케팅 자동화용)' AFTER monthly_amount,
--   ADD COLUMN last_visit_date  TIMESTAMP NULL    COMMENT '마지막 방문일시'       AFTER birthday;


-- ── member_t ─────────────────────────────────────────────────
--  brew-crm·cafe-spring 공통 로그인 계정 테이블.
--  cafe-spring 에서는 name 컬럼을 AS username 으로 alias 해서 읽는다.
CREATE TABLE IF NOT EXISTS member_t (
    m_idx           INT           NOT NULL AUTO_INCREMENT
        COMMENT '회원 번호 (PK) — 세션 loginMember.m_idx. membership_t.user_id FK. findMyPageInfo·login·updateMember 등 모든 조회 기준 키',

    email           VARCHAR(100)  NOT NULL UNIQUE
        COMMENT '이메일 (로그인 ID) — cafe-spring·brew-crm 공통 로그인 식별자. findByEmail() WHERE 조건. UNIQUE 제약',

    password        VARCHAR(255)  NOT NULL
        COMMENT 'BCrypt 암호화 비밀번호 — BCryptPasswordEncoder.matches(입력값, DB값)으로 검증. 평문 저장 금지',

    name            VARCHAR(50)   NOT NULL
        COMMENT '이름/닉네임 — cafe-spring 회원가입 시 username 값을 저장(INSERT INTO member_t ... VALUES(#{username})). cafe-spring MemberMapper.xml 에서 name AS username 으로 읽음. brew-crm 마이페이지에서 name 필드로 직접 표시·수정',

    linked_customer INT           DEFAULT NULL
        COMMENT '연결된 고객 번호 (FK → customer_t.c_idx) — 회원가입 시 customer_t row 먼저 생성 후 여기에 저장. findMyPageInfo LEFT JOIN 기준. brew-crm이 방문 기록 시 역방향 조회(findMemberByCustomer)로 membership_t 동기화에 사용',

    reg_date        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
        COMMENT '가입일 — 현재 화면에 표시되지 않음',

    role            VARCHAR(20)   DEFAULT 'STAFF'
        COMMENT '권한 (ADMIN/MANAGER/STAFF/MEMBER) — ADMIN: 전체 권한, MANAGER: 통계·마케팅, STAFF: 방문기록·조회, MEMBER: 고객용 계정',

    active          TINYINT       DEFAULT 0
        COMMENT '탈퇴 여부 (0=정상, 1=탈퇴) — 모든 SELECT에 AND m.active=0 조건 포함. 탈퇴 시 UPDATE active=1(논리삭제)',

    PRIMARY KEY (m_idx),
    CONSTRAINT fk_member_customer
        FOREIGN KEY (linked_customer)
        REFERENCES customer_t(c_idx)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='회원 테이블 — cafe-spring·brew-crm 공통 사용. name 컬럼을 cafe-spring은 username으로 alias해서 읽음';


-- ── membership_t ─────────────────────────────────────────────
--  cafe-spring 포인트·등급 테이블.
--  brew-crm 방문 기록 시 CustomerServiceImpl.addVisitAndUpdateGrade() 가 자동 동기화.
CREATE TABLE IF NOT EXISTS membership_t (
    ms_idx   INT         NOT NULL AUTO_INCREMENT
        COMMENT '멤버십 번호 (PK) — 내부 식별자',

    user_id  INT         NOT NULL UNIQUE
        COMMENT '회원 번호 (FK → member_t.m_idx) — getByUserId()·insertMembership()·updateMembership()의 WHERE 조건. UNIQUE: 회원 1명당 1행',

    grade    VARCHAR(20) DEFAULT '일반'
        COMMENT '등급 — brew-crm 방문 기록 시 customer_t.grade 와 동기화. cafe-spring MembershipController 에서 ${membership.grade}로 표시',

    points   INT         DEFAULT 0
        COMMENT '누적 포인트 — 방문 1회 = 100점(visit_count × 100). brew-crm 마이페이지 ${myInfo.points} 배지, cafe-spring 멤버십 페이지 ${membership.points} 에 표시',

    reg_date TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
        COMMENT '최초 멤버십 생성일 — 현재 화면에 표시되지 않음',

    PRIMARY KEY (ms_idx),
    FOREIGN KEY (user_id) REFERENCES member_t(m_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='멤버십 포인트·등급 테이블 — cafe-spring 포인트 화면의 데이터 소스. brew-crm 방문 기록 시 자동 동기화';


-- ================================================================
-- brew-crm 확장 테이블
-- ================================================================

-- ── visit_log_t ───────────────────────────────────────────────
--  방문별 상세 기록 — 각 방문마다 1행 INSERT.
--  시간대별·요일별 매출 분석 및 메뉴 인기도 분석의 데이터 소스.
CREATE TABLE IF NOT EXISTS visit_log_t (
    log_idx    INT           NOT NULL AUTO_INCREMENT
        COMMENT '기록 번호 (PK)',
    c_idx      INT           NOT NULL
        COMMENT '고객 번호 (FK → customer_t.c_idx)',
    amount     INT           DEFAULT 0
        COMMENT '결제액 (원)',
    menu_item  VARCHAR(200)  DEFAULT ''
        COMMENT '주문 메뉴 (자유 텍스트, 예: 아이스 아메리카노, 카라멜 마끼아또)',
    note       VARCHAR(300)  DEFAULT ''
        COMMENT '방문 메모 (관리자 입력)',
    reg_date   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
        COMMENT '방문 일시 — HOUR(reg_date)/DAYOFWEEK(reg_date) 집계에 사용',
    PRIMARY KEY (log_idx),
    INDEX idx_visit_c_idx (c_idx),
    INDEX idx_visit_date  (reg_date),
    CONSTRAINT fk_visit_customer
        FOREIGN KEY (c_idx) REFERENCES customer_t(c_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='방문 이력 테이블 — 각 방문 기록. 시간대·요일·메뉴 통계 소스';


-- ── customer_tag_t ────────────────────────────────────────────
--  고객 특이사항 태그 (우유 알레르기, 텀블러 지참 등).
--  고객 상세 화면에서 태그 추가/삭제 가능.
CREATE TABLE IF NOT EXISTS customer_tag_t (
    tag_idx  INT         NOT NULL AUTO_INCREMENT
        COMMENT '태그 번호 (PK)',
    c_idx    INT         NOT NULL
        COMMENT '고객 번호 (FK → customer_t.c_idx)',
    tag      VARCHAR(50) NOT NULL
        COMMENT '태그 내용 (예: 우유 알레르기, 샷 연하게)',
    PRIMARY KEY (tag_idx),
    INDEX idx_tag_c_idx (c_idx),
    CONSTRAINT fk_tag_customer
        FOREIGN KEY (c_idx) REFERENCES customer_t(c_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='고객 특이사항 태그 테이블';


-- ── coupon_t ──────────────────────────────────────────────────
--  쿠폰 종류(템플릿) 관리 테이블.
--  관리자가 쿠폰 종류를 사전에 등록하고, 고객에게 발급(customer_coupon_t).
CREATE TABLE IF NOT EXISTS coupon_t (
    coupon_idx   INT          NOT NULL AUTO_INCREMENT
        COMMENT '쿠폰 번호 (PK)',
    name         VARCHAR(100) NOT NULL
        COMMENT '쿠폰명 (예: 아메리카노 1+1, 사이즈업 무료)',
    description  VARCHAR(255) DEFAULT ''
        COMMENT '쿠폰 설명',
    type         VARCHAR(20)  DEFAULT 'DISCOUNT'
        COMMENT '쿠폰 종류 (DISCOUNT=할인, FREE=무료음료, UPGRADE=업그레이드)',
    value        INT          DEFAULT 0
        COMMENT '할인액(원) 또는 할인율(%). 종류에 따라 의미 다름',
    expire_days  INT          DEFAULT 30
        COMMENT '발급 후 유효 일수',
    active       TINYINT      DEFAULT 1
        COMMENT '사용 여부 (1=활성, 0=비활성)',
    reg_date     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (coupon_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='쿠폰 종류 템플릿 테이블';


-- ── customer_coupon_t ─────────────────────────────────────────
--  고객별 발급된 쿠폰. 관리자가 수동 발급하거나 스케줄러가 자동 발급.
CREATE TABLE IF NOT EXISTS customer_coupon_t (
    cc_idx       INT       NOT NULL AUTO_INCREMENT
        COMMENT '발급 번호 (PK)',
    c_idx        INT       NOT NULL
        COMMENT '고객 번호 (FK → customer_t.c_idx)',
    coupon_idx   INT       NOT NULL
        COMMENT '쿠폰 번호 (FK → coupon_t.coupon_idx)',
    issued_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        COMMENT '발급 일시',
    expire_date  DATE      NOT NULL
        COMMENT '만료일',
    used         TINYINT   DEFAULT 0
        COMMENT '사용 여부 (0=미사용, 1=사용완료)',
    used_date    TIMESTAMP NULL
        COMMENT '사용 일시',
    PRIMARY KEY (cc_idx),
    INDEX idx_cc_c_idx (c_idx),
    CONSTRAINT fk_cc_customer
        FOREIGN KEY (c_idx)      REFERENCES customer_t(c_idx) ON DELETE CASCADE,
    CONSTRAINT fk_cc_coupon
        FOREIGN KEY (coupon_idx) REFERENCES coupon_t(coupon_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='고객별 발급 쿠폰 테이블';


-- ── scheduler_log_t ───────────────────────────────────────────
--  스케줄러 실행 이력 (월별 리셋, 등급 재산정 등).
--  시스템 관리자가 자동화 작업의 결과를 확인하는 용도.
CREATE TABLE IF NOT EXISTS scheduler_log_t (
    log_idx   INT          NOT NULL AUTO_INCREMENT
        COMMENT '로그 번호 (PK)',
    job_name  VARCHAR(100) NOT NULL
        COMMENT '작업명 (예: MONTHLY_RESET, GRADE_RECALC, BIRTHDAY_COUPON)',
    status    VARCHAR(20)  NOT NULL
        COMMENT '처리 결과 (SUCCESS/FAILED)',
    affected  INT          DEFAULT 0
        COMMENT '처리된 고객 수',
    message   TEXT
        COMMENT '상세 메시지 또는 오류 내용',
    reg_date  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
        COMMENT '실행 일시',
    PRIMARY KEY (log_idx),
    INDEX idx_slog_date (reg_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='스케줄러 실행 이력 테이블';


-- 기본 쿠폰 템플릿 샘플
INSERT INTO coupon_t (name, description, type, value, expire_days) VALUES
('아메리카노 1+1',    '아메리카노 한 잔 주문 시 한 잔 무료',          'FREE',     0,  14),
('사이즈업 무료',     '모든 음료 사이즈업 무료 (최대 L)',              'UPGRADE',  0,  30),
('10% 할인',          '전 메뉴 10% 할인',                             'DISCOUNT', 10, 30),
('500원 할인',        '500원 할인 쿠폰',                               'DISCOUNT', 500, 30),
('생일 케이크 쿠폰',  'VIP 전용 — 생일 당일 케이크 슬라이스 무료',     'FREE',     0,  3)
ON DUPLICATE KEY UPDATE name=VALUES(name);


-- ── 기본 관리자 계정 ──────────────────────────────────────────
--   이메일 : admin@brew.com
--   비밀번호: brew1234
--   역할    : ADMIN
-- ※ 이미 이메일이 존재하면 "Duplicate entry" 오류 → 무시해도 됨
INSERT INTO customer_t (name, phone, grade, visit_count, memo, active)
VALUES ('관리자', '010-0000-0000', 'VIP', 0, 'CRM 관리자 계정', 0);

INSERT INTO member_t (email, password, name, linked_customer, role, active)
VALUES (
    'admin@brew.com',
    '$2a$10$mxjsTqv8VQaVhunoWI/COOhQbBQWudx6LcYRPMo6hkIV0tmnKyC6G',
    '관리자',
    LAST_INSERT_ID(),
    'ADMIN',
    0
);


-- ================================================================
-- cafe-spring 전용 테이블
-- ================================================================

-- ── board_t ──────────────────────────────────────────────────
DROP TABLE IF EXISTS comment_t;
DROP TABLE IF EXISTS board_t;
CREATE TABLE board_t (
    b_idx    INT          NOT NULL AUTO_INCREMENT
        COMMENT '게시글 번호 (PK) — BoardController·comment_t.b_idx FK',

    title    VARCHAR(255) NOT NULL
        COMMENT '제목 — 게시판 목록·상세 표시',

    category VARCHAR(50)  DEFAULT '자유'
        COMMENT '카테고리 (공지/질문/후기/정보/자유) — 게시판 필터·표시에 사용',

    content  TEXT
        COMMENT '본문 내용 — 게시글 상세 화면 표시',

    author   VARCHAR(100) NOT NULL
        COMMENT '작성자 — 로그인 회원의 username(name) 값을 저장',

    views    INT          DEFAULT 0
        COMMENT '조회 수 — 게시글 상세 접근 시 +1',

    comments INT          DEFAULT 0
        COMMENT '댓글 수 — 댓글 등록·삭제 시 갱신. 목록 화면에 표시',

    reg_date TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
        COMMENT '작성일 — 게시판 목록 표시',

    active   TINYINT      DEFAULT 0
        COMMENT '삭제 여부 (0=정상, 1=논리삭제)',

    PRIMARY KEY (b_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='게시판 테이블 — cafe-spring 커뮤니티 게시판 전용';


-- ── board_report_t ───────────────────────────────────────────
--  게시글·댓글 신고 테이블.
--  cafe-spring 에서 신고 버튼 클릭 시 INSERT, brew-crm 에서 관리.
CREATE TABLE IF NOT EXISTS board_report_t (
    r_idx       INT           NOT NULL AUTO_INCREMENT
        COMMENT '신고 번호 (PK)',

    target_type ENUM('POST','COMMENT') NOT NULL
        COMMENT '신고 대상 유형 (POST=게시글, COMMENT=댓글)',

    target_idx  INT           NOT NULL
        COMMENT '신고 대상 번호 (board_t.b_idx 또는 comment_t.c_idx)',

    reporter    VARCHAR(100)  NOT NULL
        COMMENT '신고자 (로그인 회원 username)',

    reason      VARCHAR(500)  DEFAULT NULL
        COMMENT '신고 사유',

    status      ENUM('PENDING','PROCESSED','DISMISSED') DEFAULT 'PENDING'
        COMMENT '처리 상태 (PENDING=미처리, PROCESSED=처리완료, DISMISSED=기각)',

    reg_date    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
        COMMENT '신고 일시',

    PRIMARY KEY (r_idx),
    INDEX idx_target (target_type, target_idx),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='게시판 신고 테이블 — cafe-spring 신고, brew-crm 관리';


-- ── comment_t ─────────────────────────────────────────────────
CREATE TABLE comment_t (
    c_idx    INT          NOT NULL AUTO_INCREMENT
        COMMENT '댓글 번호 (PK)',

    b_idx    INT          NOT NULL
        COMMENT '게시글 번호 (FK → board_t.b_idx) — ON DELETE CASCADE: 게시글 삭제 시 댓글도 자동 삭제',

    author   VARCHAR(100) NOT NULL
        COMMENT '작성자 — 로그인 회원의 username 값을 저장',

    content  TEXT         NOT NULL
        COMMENT '댓글 내용',

    reg_date TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
        COMMENT '작성일',

    PRIMARY KEY (c_idx),
    FOREIGN KEY (b_idx) REFERENCES board_t(b_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='댓글 테이블 — cafe-spring 게시판 댓글 전용. board_t 삭제 시 CASCADE 자동 삭제';


-- ── menu_t ────────────────────────────────────────────────────
DROP TABLE IF EXISTS menu_t;
CREATE TABLE menu_t (
    m_idx       INT            NOT NULL AUTO_INCREMENT
        COMMENT '메뉴 번호 (PK) — MenuController 상세·수정·삭제 식별자',

    name        VARCHAR(100)   NOT NULL
        COMMENT '메뉴 이름 — 메뉴 목록·상세 화면 표시',

    description TEXT
        COMMENT '메뉴 설명 — 메뉴 목록 카드 설명 문구',

    price       INT            DEFAULT 0
        COMMENT '가격 (원) — 메뉴 목록·상세 화면 표시',

    category    VARCHAR(50)
        COMMENT '카테고리 (ESPRESSO/LATTE/SPECIAL 등) — 메뉴 탭 필터에 사용',

    image_url   VARCHAR(500)
        COMMENT '메뉴 이미지 URL — 메뉴 카드 img src에 사용. 외부 URL(Unsplash 등) 허용',

    story       TEXT
        COMMENT '메뉴 스토리 — 메뉴 상세 페이지 하단 소개 문구',

    origin      VARCHAR(100)
        COMMENT '원두 산지 — 메뉴 상세 페이지에 표시 (예: 에티오피아 예가체프)',

    available   TINYINT        DEFAULT 1
        COMMENT '판매 여부 (1=판매중, 0=품절) — 메뉴 목록에서 품절 표시 분기에 사용',

    PRIMARY KEY (m_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='메뉴 테이블 — cafe-spring 메뉴 화면 전용. brew-crm 에서는 사용하지 않음';


-- ── chat_log_t ───────────────────────────────────────────────
--  cafe-spring 채팅 로그 테이블.
--  ChatMapper.insertMessage / getHistory 에서 사용.
CREATE TABLE IF NOT EXISTS chat_log_t (
    log_idx    INT           NOT NULL AUTO_INCREMENT
        COMMENT '로그 번호 (PK)',

    session_id VARCHAR(100)  NOT NULL
        COMMENT '채팅 세션 ID — getHistory WHERE 조건',

    m_idx      INT           DEFAULT NULL
        COMMENT '회원 번호 (NULL = 비로그인) — FK 없이 참조',

    sender     VARCHAR(20)   NOT NULL
        COMMENT '발신자 구분 (user / bot)',

    message    TEXT          NOT NULL
        COMMENT '채팅 메시지 내용',

    reg_date   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
        COMMENT '전송 시각',

    PRIMARY KEY (log_idx),
    INDEX idx_session (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='채팅 로그 테이블 — cafe-spring 챗봇 대화 내역 저장';


-- ================================================================
-- 샘플 데이터
-- ================================================================

-- 샘플 메뉴
INSERT INTO menu_t (name, description, price, category, image_url, origin, story) VALUES
('에스프레소','진하고 풍부한 맛의 클래식 에스프레소',3500,'ESPRESSO','https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400&h=400&fit=crop','에티오피아 예가체프','에스프레소는 19세기 말 이탈리아에서 탄생했습니다.'),
('아메리카노','깔끔하고 부드러운 정통 아메리카노',4000,'ESPRESSO','https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=400&fit=crop','콜롬비아 수프리모','아메리카노의 기원은 제2차 세계대전 시기로 거슬러 올라갑니다.'),
('카페라떼','부드러운 우유와 에스프레소의 완벽한 조화',4500,'LATTE','https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=400&fit=crop','브라질 산토스','카페라떼는 이탈리아어로 우유 커피를 의미합니다.'),
('카푸치노','풍성한 거품과 함께 즐기는 이탈리안 클래식',4500,'LATTE','https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=400&fit=crop','과테말라 안티구아','카푸치노의 이름은 16세기 이탈리아 카푸친 수도회의 갈색 수도복에서 유래했습니다.'),
('바닐라 라떼','은은한 바닐라 향이 가득한 달콤한 라떼',5000,'LATTE','https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400&h=400&fit=crop','케냐 AA','바닐라의 달콤한 향과 에스프레소의 강렬함이 만나 탄생한 현대적인 라떼입니다.'),
('카라멜 마끼아또','달콤한 카라멜 시럽과 에스프레소의 환상 조합',5000,'LATTE','https://images.unsplash.com/photo-1599639957043-f0e7d8c2a9ae?w=400&h=400&fit=crop','온두라스 SHG','마끼아또는 이탈리아어로 얼룩진이라는 뜻입니다.'),
('아인슈페너','진한 에스프레소 위에 올린 부드러운 생크림',5500,'SPECIAL','https://images.unsplash.com/photo-1607260550778-aa4d29eb0177?w=400&h=400&fit=crop','케냐 AA','아인슈페너는 오스트리아 빈의 전통 커피 음료입니다.'),
('콜드브루','12시간 저온 추출한 깊고 부드러운 커피',5000,'SPECIAL','https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400&h=400&fit=crop','에티오피아 시다마','콜드브루는 차가운 물로 12시간 이상 천천히 추출합니다.'),
('시그니처 라떼','정성을 다한 커피만의 특별한 레시피',6000,'SPECIAL','https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=400&h=400&fit=crop','파나마 게이샤','저희만의 비밀 레시피로 만든 시그니처 메뉴입니다.');

-- 샘플 게시글
INSERT INTO board_t (title, category, content, author, views, comments) VALUES
('3월 이벤트 안내', '공지', '3월 한 달간 아메리카노 1+1 이벤트를 진행합니다.', '관리자', 567, 23),
('에스프레소 원두 추천 부탁드립니다', '질문', '에스프레소 추출에 좋은 원두를 추천해주세요.', '커피러버', 152, 8),
('신메뉴 시즌 라떼 후기', '후기', '신메뉴 시즌 라떼 정말 맛있어요!', '카페인중독', 234, 15),
('콜드브루 제조 방법 공유합니다', '정보', '집에서 콜드브루 만드는 방법을 공유합니다.', '바리스타김', 389, 12),
('매장 방문 인증샷', '자유', '오늘 방문한 카페 인증샷 공유합니다.', '커피마니아', 421, 31);
