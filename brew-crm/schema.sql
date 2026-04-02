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

    active      TINYINT       DEFAULT 0
        COMMENT '삭제 여부 (0=정상, 1=논리삭제) — 모든 SELECT에 AND c.active=0 조건 포함. 실제 row는 남김',

    PRIMARY KEY (c_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='CRM 고객 테이블 — brew-crm에서 관리, cafe-spring 회원가입 시 row 자동 생성';


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
