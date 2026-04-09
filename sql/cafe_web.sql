-- ================================================================
-- 정성을 다한 커피 (cafe-spring) — schema.sql
-- ----------------------------------------------------------------
-- DB     : project  (brew-crm-v2 와 같은 DB 공유)
-- PORT   : 8080  (brew-crm-v2 는 8081)
--
-- ※ 실제 DB 구조는 brew-crm-v2/schema.sql 기준으로 생성한다.
--    이 파일은 cafe-spring 전용 테이블(board_t, comment_t, menu_t)과
--    공유 테이블(customer_t, member_t, membership_t) 전체를 기술한다.
-- ================================================================
USE project;
-- ================================================================
-- 공유 테이블 (brew-crm-v2 와 동일 DB 사용)
-- ================================================================
-- ── customer_t ───────────────────────────────────────────────
--  brew-crm 관리자가 주로 관리하는 고객 테이블.
--  cafe-spring 에서는 회원가입 시 row를 생성하고(insertCustomerForMember),
--  member_t.linked_customer FK 로 참조하여 등급·방문 정보를 읽는다.
CREATE TABLE IF NOT EXISTS customer_t (
    c_idx INT NOT NULL AUTO_INCREMENT COMMENT '고객 번호 (PK) — member_t.linked_customer FK 로 참조. cafe-spring 회원가입(insertCustomerForMember) 시 자동 생성',
    name VARCHAR(50) NOT NULL COMMENT '고객 이름 — cafe-spring 회원가입 시 username 값으로 채워짐. brew-crm 고객 목록 표시. 마이페이지 수정 시 updateLinkedCustomer 로 동기화',
    phone VARCHAR(20) DEFAULT '-' COMMENT '연락처 — cafe-spring 회원가입·정보 수정 시 동기화. brew-crm 고객 검색(이름/전화 LIKE) 에 사용',
    grade VARCHAR(10) DEFAULT '일반' COMMENT '등급 (일반/실버/골드/VIP) — brew-crm 방문 기록 시 자동 갱신. cafe-spring MemberMapper.findMyPageInfo() LEFT JOIN 으로 읽어 ${memberInfo.grade} 표시. membership_t.grade 와 항상 동기화',
    visit_count INT DEFAULT 0 COMMENT '방문 횟수 — brew-crm 관리자 [방문 기록] 클릭 시 +1. 등급 산정 기준, 포인트(×100) 계산 기준. cafe-spring 마이페이지 ${memberInfo.visitCount} 표시',
    memo TEXT COMMENT '메모 — 알레르기·선호 음료 등. brew-crm 관리자 메모 화면에서 수정',
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일 — brew-crm 대시보드 이번 달 신규 고객 수 집계에 사용',
    active TINYINT DEFAULT 0 COMMENT '삭제 여부 (0=정상, 1=논리삭제) — 모든 SELECT에 AND c.active=0 조건 포함. 실제 row는 남김',
    PRIMARY KEY (c_idx)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'CRM 고객 테이블 — brew-crm에서 관리, cafe-spring 회원가입 시 row 자동 생성';
-- ── member_t ─────────────────────────────────────────────────
--  brew-crm·cafe-spring 공통 로그인 계정 테이블.
--  cafe-spring 에서는 name 컬럼을 AS username 으로 alias 해서 읽는다.
CREATE TABLE IF NOT EXISTS member_t (
    m_idx INT NOT NULL AUTO_INCREMENT COMMENT '회원 번호 (PK) — 세션 loginMember.m_idx. membership_t.user_id FK. findMyPageInfo·login·updateMember 등 모든 조회 기준 키',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '이메일 (로그인 ID) — cafe-spring·brew-crm 공통 로그인 식별자. findByEmail() WHERE 조건. UNIQUE 제약',
    password VARCHAR(255) NOT NULL COMMENT 'BCrypt 암호화 비밀번호 — BCryptPasswordEncoder.matches(입력값, DB값)으로 검증. 평문 저장 금지',
    name VARCHAR(50) NOT NULL COMMENT '이름/닉네임 — cafe-spring 회원가입 시 username 값을 저장(INSERT INTO member_t ... VALUES(#{username})). cafe-spring MemberMapper.xml 에서 name AS username 으로 읽음. brew-crm 마이페이지에서 name 필드로 직접 표시·수정',
    linked_customer INT DEFAULT NULL COMMENT '연결된 고객 번호 (FK → customer_t.c_idx) — 회원가입 시 customer_t row 먼저 생성 후 여기에 저장. findMyPageInfo LEFT JOIN 기준. brew-crm이 방문 기록 시 역방향 조회(findMemberByCustomer)로 membership_t 동기화에 사용',
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '가입일 — 현재 화면에 표시되지 않음',
    active TINYINT DEFAULT 0 COMMENT '탈퇴 여부 (0=정상, 1=탈퇴) — 모든 SELECT에 AND m.active=0 조건 포함. 탈퇴 시 UPDATE active=1(논리삭제)',
    PRIMARY KEY (m_idx),
    CONSTRAINT fk_member_customer FOREIGN KEY (linked_customer) REFERENCES customer_t(c_idx) ON DELETE
    SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '회원 테이블 — cafe-spring·brew-crm 공통 사용. name 컬럼을 cafe-spring은 username으로 alias해서 읽음';
-- ── membership_t ─────────────────────────────────────────────
--  cafe-spring 포인트·등급 테이블.
--  brew-crm 방문 기록 시 CustomerServiceImpl.addVisitAndUpdateGrade() 가 자동 동기화.
CREATE TABLE IF NOT EXISTS membership_t (
    ms_idx INT NOT NULL AUTO_INCREMENT COMMENT '멤버십 번호 (PK) — 내부 식별자',
    user_id INT NOT NULL UNIQUE COMMENT '회원 번호 (FK → member_t.m_idx) — getByUserId()·insertMembership()·updateMembership()의 WHERE 조건. UNIQUE: 회원 1명당 1행',
    grade VARCHAR(20) DEFAULT '일반' COMMENT '등급 — brew-crm 방문 기록 시 customer_t.grade 와 동기화. cafe-spring MembershipController 에서 ${membership.grade}로 표시',
    points INT DEFAULT 0 COMMENT '누적 포인트 — 방문 1회 = 100점(visit_count × 100). brew-crm 마이페이지 ${myInfo.points} 배지, cafe-spring 멤버십 페이지 ${membership.points} 에 표시',
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '최초 멤버십 생성일 — 현재 화면에 표시되지 않음',
    PRIMARY KEY (ms_idx),
    FOREIGN KEY (user_id) REFERENCES member_t(m_idx) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '멤버십 포인트·등급 테이블 — cafe-spring 포인트 화면의 데이터 소스. brew-crm 방문 기록 시 자동 동기화';
-- ================================================================
-- cafe-spring 전용 테이블
-- ================================================================
-- ── board_t ──────────────────────────────────────────────────
DROP TABLE IF EXISTS comment_t;
DROP TABLE IF EXISTS board_t;
CREATE TABLE board_t (
    b_idx INT NOT NULL AUTO_INCREMENT COMMENT '게시글 번호 (PK) — BoardController·comment_t.b_idx FK',
    title VARCHAR(255) NOT NULL COMMENT '제목 — 게시판 목록·상세 표시',
    category VARCHAR(50) DEFAULT '자유' COMMENT '카테고리 (공지/질문/후기/정보/자유) — 게시판 필터·표시에 사용',
    content TEXT COMMENT '본문 내용 — 게시글 상세 화면 표시',
    author VARCHAR(100) NOT NULL COMMENT '작성자 — 로그인 회원의 username(name) 값을 저장',
    views INT DEFAULT 0 COMMENT '조회 수 — 게시글 상세 접근 시 +1',
    comments INT DEFAULT 0 COMMENT '댓글 수 — 댓글 등록·삭제 시 갱신. 목록 화면에 표시',
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일 — 게시판 목록 표시',
    active TINYINT DEFAULT 0 COMMENT '삭제 여부 (0=정상, 1=논리삭제)',
    PRIMARY KEY (b_idx)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '게시판 테이블 — cafe-spring 커뮤니티 게시판 전용';
-- ── comment_t ─────────────────────────────────────────────────
CREATE TABLE comment_t (
    c_idx INT NOT NULL AUTO_INCREMENT COMMENT '댓글 번호 (PK)',
    b_idx INT NOT NULL COMMENT '게시글 번호 (FK → board_t.b_idx) — ON DELETE CASCADE: 게시글 삭제 시 댓글도 자동 삭제',
    author VARCHAR(100) NOT NULL COMMENT '작성자 — 로그인 회원의 username 값을 저장',
    content TEXT NOT NULL COMMENT '댓글 내용',
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    PRIMARY KEY (c_idx),
    FOREIGN KEY (b_idx) REFERENCES board_t(b_idx) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '댓글 테이블 — cafe-spring 게시판 댓글 전용. board_t 삭제 시 CASCADE 자동 삭제';
-- ── menu_t ────────────────────────────────────────────────────
DROP TABLE IF EXISTS menu_t;
CREATE TABLE menu_t (
    m_idx INT NOT NULL AUTO_INCREMENT COMMENT '메뉴 번호 (PK) — MenuController 상세·수정·삭제 식별자',
    name VARCHAR(100) NOT NULL COMMENT '메뉴 이름 — 메뉴 목록·상세 화면 표시',
    description TEXT COMMENT '메뉴 설명 — 메뉴 목록 카드 설명 문구',
    price INT DEFAULT 0 COMMENT '가격 (원) — 메뉴 목록·상세 화면 표시',
    category VARCHAR(50) COMMENT '카테고리 (ESPRESSO/LATTE/SPECIAL 등) — 메뉴 탭 필터에 사용',
    image_url VARCHAR(500) COMMENT '메뉴 이미지 URL — 메뉴 카드 img src에 사용. 외부 URL(Unsplash 등) 허용',
    story TEXT COMMENT '메뉴 스토리 — 메뉴 상세 페이지 하단 소개 문구',
    origin VARCHAR(100) COMMENT '원두 산지 — 메뉴 상세 페이지에 표시 (예: 에티오피아 예가체프)',
    available TINYINT DEFAULT 1 COMMENT '판매 여부 (1=판매중, 0=품절) — 메뉴 목록에서 품절 표시 분기에 사용',
    PRIMARY KEY (m_idx)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '메뉴 테이블 — cafe-spring 메뉴 화면 전용. brew-crm 에서는 사용하지 않음';
-- ── chat_log_t ───────────────────────────────────────────────
--  cafe-spring 채팅 로그 테이블.
--  ChatMapper.insertMessage / getHistory / getContextHistory 에서 사용.
CREATE TABLE IF NOT EXISTS chat_log_t (
    log_idx INT NOT NULL AUTO_INCREMENT COMMENT '로그 번호 (PK)',
    session_id VARCHAR(100) NOT NULL COMMENT '채팅 세션 ID — getHistory / getContextHistory(비로그인) WHERE 조건',
    m_idx INT DEFAULT NULL COMMENT '회원 번호 (NULL = 비로그인) — getContextHistory(로그인) WHERE 조건',
    sender VARCHAR(20) NOT NULL COMMENT '발신자 구분 (user / bot)',
    message TEXT NOT NULL COMMENT '채팅 메시지 내용',
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '전송 시각',
    PRIMARY KEY (log_idx),
    INDEX idx_session (session_id),
    INDEX idx_m_idx   (m_idx)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '채팅 로그 테이블 — cafe-spring 챗봇 대화 내역 저장';
-- ================================================================
-- 샘플 데이터
-- ================================================================
-- 메뉴 전체 데이터 (화면 메뉴와 동일)
INSERT INTO menu_t (
        name,
        description,
        price,
        category,
        image_url,
        origin,
        story
    )
VALUES -- 커피
    (
        '에스프레소',
        '커피의 정수, 황금빛 크레마와 진한 농도',
        3600,
        'COFFEE',
        'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=600&h=400&fit=crop&auto=format',
        'HOT',
        '에스프레소는 이탈리아어로 ''빠른''이라는 뜻을 지닌 커피의 정수입니다. 20세기 초 밀라노에서 탄생한 이 음료는 9기압의 고압으로 25~30초 만에 추출하여 커피의 진한 풍미와 황금빛 크레마를 완성합니다.'
    ),
    (
        '아메리카노',
        '에스프레소의 깊은 향과 물의 부드러움이 어우러진 균형',
        4200,
        'COFFEE',
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '제2차 세계대전 당시 이탈리아에 주둔한 미군 병사들이 에스프레소의 강한 맛을 물로 희석해 마시기 시작한 것이 아메리카노의 유래입니다.'
    ),
    (
        '카페라떼',
        '에스프레소 위에 스팀 밀크를 부어 완성한 부드러운 라떼',
        4700,
        'COFFEE',
        'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '라떼는 이탈리아어로 ''우유''를 의미합니다. 이탈리아 가정에서 아침 식사와 함께 마시던 문화에서 시작된 카페라떼는 에스프레소 위에 스팀 밀크를 부어 부드럽고 크리미한 풍미를 완성합니다.'
    ),
    (
        '카푸치노',
        '에스프레소·스팀밀크·거품을 1:1:1로 담은 이탈리안 클래식',
        4700,
        'COFFEE',
        'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '카푸치노는 이탈리아 카푸친 수도회 수도사들의 갈색 수도복에서 이름이 유래했습니다. 에스프레소·스팀 밀크·우유 거품을 1:1:1 비율로 담아내는 것이 정통 방식입니다.'
    ),
    (
        '바닐라라떼',
        '마다가스카르 바닐라빈의 달콤한 향이 담긴 라떼',
        5300,
        'COFFEE',
        'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '바닐라는 멕시코 원주민 토토낙족이 처음 발견한 향신료로, 16세기 스페인 탐험가들에 의해 유럽에 전해졌습니다. 마다가스카르의 바닐라빈 달콤함이 에스프레소와 만나 완벽한 균형을 이룹니다.'
    ),
    (
        '카라멜마키아토',
        '카라멜 소스와 에스프레소 레이어가 만드는 풍미',
        5650,
        'COFFEE',
        'https://images.unsplash.com/photo-1590138695581-1e82b57e78d1?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '마키아토는 이탈리아어로 ''점을 찍다''라는 뜻입니다. 바닐라 시럽과 스팀 밀크 위에 에스프레소를 천천히 부어 아름다운 레이어를 만들고, 황금빛 카라멜 소스로 마무리합니다.'
    ),
    (
        '카페모카',
        '초콜릿과 에스프레소의 달콤 쌉쌀한 조화',
        5300,
        'COFFEE',
        'https://images.unsplash.com/photo-1534778101976-62847782c213?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '카페모카의 이름은 15세기 커피 무역의 중심지였던 예멘의 항구도시 ''모카''에서 유래했습니다. 달콤 쌉쌀한 초콜릿과 진한 에스프레소의 만남입니다.'
    ),
    (
        '헤이즐넛라떼',
        '이탈리아 피에몬테 헤이즐넛의 고소한 풍미',
        5300,
        'COFFEE',
        'https://images.unsplash.com/photo-1574914629377-e97c19438717?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '이탈리아 피에몬테 지방은 세계 최고의 헤이즐넛 산지로 유명합니다. 구운 견과류의 따뜻한 향이 가득한 한 잔은 가을 낙엽처럼 마음을 포근하게 감싸줍니다.'
    ),
    (
        '돌체라떼',
        '연유 크림과 에스프레소의 달콤한 만남',
        5400,
        'COFFEE',
        'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '돌체(Dolce)는 이탈리아어로 ''달콤한''이라는 뜻입니다. 연유를 베이스로 한 부드럽고 달콤한 크림이 에스프레소와 만나 탄생한 돌체라떼입니다.'
    ),
    (
        '아포가토',
        '뜨거운 에스프레소와 바닐라 아이스크림의 만남',
        5600,
        'COFFEE',
        'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '아포가토(Affogato)는 이탈리아어로 ''물에 빠진''이라는 뜻입니다. 뜨거운 에스프레소 한 샷을 바닐라 아이스크림 위에 부으면 뜨거움과 차가움, 쓴맛과 단맛이 어우러지는 마법이 시작됩니다.'
    ),
    (
        '콜드브루',
        '12시간 냉침 추출, 낮은 산도와 깊은 단맛',
        4450,
        'COFFEE',
        'https://images.unsplash.com/photo-1556791766-66ac915737cf?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '콜드브루는 일본 교토의 전통 냉침 추출 방식에서 유래했습니다. 차가운 물로 12~24시간 천천히 추출하여 산도는 낮추고 자연스러운 단맛과 깊은 풍미를 끌어냅니다.'
    ),
    (
        '콜드브루라떼',
        '냉침 콜드브루와 신선한 우유의 부드러운 조화',
        5150,
        'COFFEE',
        'https://images.unsplash.com/photo-1545285179-78da7c2b8f83?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '12시간 냉침 추출한 콜드브루에 신선한 우유를 더해 완성됩니다. 콜드브루 특유의 낮은 산도와 깊은 단맛이 고소한 우유와 만나 부드럽고 진한 풍미를 만들어냅니다.'
    ),
    (
        '드립커피',
        '바리스타의 손으로 직접 추출하는 핸드드립',
        4000,
        'COFFEE',
        'https://images.unsplash.com/photo-1439242088854-0c76045f4124?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '핸드드립은 바리스타의 손으로 직접 물을 부어 커피를 추출하는 방식입니다. 기계가 아닌 사람의 온도가 담긴 드립커피는 바리스타와 손님 사이의 조용한 대화입니다.'
    ),
    -- 논커피
    (
        '녹차라떼',
        '일본 우지 말차와 스팀 밀크의 고요한 조화',
        5400,
        'NONCOFFEE',
        'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '일본 우지(宇治) 지방의 말차는 차 문화의 정점으로 불립니다. 고온을 피해 재배된 찻잎을 맷돌로 곱게 갈아 만든 말차가 부드러운 스팀 밀크와 만나 일본 다도의 고요함을 한 잔에 담아냅니다.'
    ),
    (
        '고구마라떼',
        '국내산 고구마 페이스트와 우유의 달콤한 조합',
        5100,
        'NONCOFFEE',
        '',
        'HOT/ICE',
        '한국의 가을, 노릇하게 구운 고구마 향은 어릴 적 추억을 소환합니다. 달콤하고 구수한 국내산 고구마를 직접 쪄서 만든 고구마 페이스트를 따뜻한 우유와 블렌딩하여 완성합니다.'
    ),
    (
        '초콜릿 (핫초코)',
        '벨기에산 다크 초콜릿이 녹아드는 위로의 한 잔',
        5100,
        'NONCOFFEE',
        'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '초콜릿의 역사는 3,000년 전 고대 아즈텍 문명으로 거슬러 올라갑니다. 벨기에산 다크 초콜릿의 깊은 풍미가 포근한 우유 안에 녹아드는 위로의 음료입니다.'
    ),
    (
        '딸기라떼',
        '국내산 생딸기 과육으로 만든 새콤달콤한 라떼',
        5600,
        'NONCOFFEE',
        '',
        'HOT/ICE',
        '봄의 전령사, 담양과 논산의 붉고 탐스러운 딸기가 우유 속에 녹아듭니다. 인공 향료 없이 신선한 딸기 과육과 퓨레를 직접 블렌딩하여 새콤달콤한 자연의 맛을 그대로 담았습니다.'
    ),
    (
        '토피넛라떼',
        '버터 캐러멜과 헤이즐넛의 달콤하고 고소한 풍미',
        5300,
        'NONCOFFEE',
        'https://images.unsplash.com/photo-1530124175301-15984e162c84?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '토피(Toffee)는 영국 빅토리아 시대부터 사랑받아온 전통 캔디입니다. 달콤하고 따뜻한 영국 겨울 오후의 정취를 담은 음료입니다.'
    ),
    (
        '밀크티',
        '진하게 우린 홍차와 신선한 우유의 클래식 조화',
        5000,
        'NONCOFFEE',
        '',
        'HOT/ICE',
        '영국 빅토리아 여왕의 오후 5시에서 시작된 애프터눈 티 문화에서 밀크티는 탄생했습니다. 진하게 우린 홍차와 신선한 우유의 클래식한 조화를 즐겨보세요.'
    ),
    -- 에이드
    (
        '레몬에이드',
        '제주산 청정 레몬의 상큼한 산미와 탄산의 만남',
        5200,
        'ADE',
        'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '지중해 시칠리아의 태양을 담은 레몬은 고대 아랍인들이 처음 재배하기 시작했습니다. 제주산 청정 레몬의 상큼한 산미와 달콤함이 탄산과 만나 여름을 가장 맛있게 즐기는 방법을 알려드립니다.'
    ),
    (
        '자몽에이드',
        '첫맛은 쌉쌀, 뒤따라오는 상큼한 단맛의 중독성',
        5200,
        'ADE',
        '',
        'ICE',
        '자몽은 18세기 카리브해 바베이도스에서 오렌지와 포멜로의 자연 교배로 탄생한 과일입니다. 신선한 자몽 착즙에 탄산을 더해 더운 날의 갈증을 시원하게 해결해 드립니다.'
    ),
    (
        '청포도에이드',
        '청포도의 달콤하고 산뜻한 맛이 반짝이는 에이드',
        5200,
        'ADE',
        'https://images.unsplash.com/photo-1560508180-03f285f67ded?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '통통하고 즙이 풍부한 청포도의 달콤하면서도 산뜻한 맛이 탄산과 만나 유리잔 속에서 반짝입니다. 보는 것만으로도 시원함이 느껴지는 청포도에이드입니다.'
    ),
    (
        '패션후르츠에이드',
        '아마존의 이국적인 열대 과일을 담은 에이드',
        5200,
        'ADE',
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '브라질의 아마존 밀림에서 처음 발견된 패션후르츠는 새콤달콤하면서도 이국적인 향이 가득합니다. 탄산과 블렌딩하여 열대 휴양지의 분위기를 한 잔에 담았습니다.'
    ),
    -- 스무디
    (
        '망고스무디',
        '태국 옐로망고 과육을 통째로 블렌딩한 스무디',
        5650,
        'SMOOTHIE',
        'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '인도에서 4,000년 이상 재배된 망고는 ''과일의 왕''으로 불립니다. 태국산 옐로망고의 진한 과육을 통째로 블렌딩하여 열대의 달콤함을 그대로 담은 스무디입니다.'
    ),
    (
        '딸기스무디',
        '새콤달콤한 국내산 생딸기를 가득 넣은 스무디',
        5650,
        'SMOOTHIE',
        'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '한국의 논산, 담양, 밀양에서 재배되는 국내산 딸기는 세계 최고 품질로 손꼽힙니다. 새콤달콤한 생딸기를 가득 넣어 블렌딩한 스무디로 오늘 하루를 달콤하게 물들여보세요.'
    ),
    (
        '블루베리스무디',
        '안토시아닌이 풍부한 신선한 블루베리 스무디',
        5650,
        'SMOOTHIE',
        'https://images.unsplash.com/photo-1508869901315-49c557f3969d?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '북미 원주민들이 수천 년 전부터 ''위대한 베리''라 부르며 즐겨온 블루베리는 안토시아닌이 풍부한 슈퍼푸드입니다. 신선한 블루베리를 가득 담아 몸도 마음도 건강해지는 스무디입니다.'
    ),
    -- 티
    (
        '캐모마일',
        '3,000년 역사의 허브티, 긴장을 풀어주는 한 잔',
        4000,
        'TEA',
        'https://images.unsplash.com/photo-1596343621063-c7a7aaf37aa6?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '고대 이집트에서 태양신 라(Ra)에게 바쳐지던 신성한 꽃, 캐모마일은 3,000년의 역사를 가진 허브입니다. 하루의 마지막, 긴장을 풀어주는 한 잔의 캐모마일이 편안한 밤을 열어드립니다.'
    ),
    (
        '페퍼민트',
        '청량한 멘톨이 머리를 맑게 해주는 허브티',
        4000,
        'TEA',
        'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '청량한 멘톨 성분이 입안을 가득 채우며 머리를 맑게 해주는 페퍼민트티는 집중이 필요한 오후에 딱 맞는 음료입니다.'
    ),
    (
        '얼그레이',
        '베르가못 향이 가득한 영국 귀족의 클래식 티',
        4000,
        'TEA',
        'https://images.unsplash.com/photo-1617443020605-d6aa7e968eb3?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '1830년대 영국 총리를 역임한 찰스 그레이 2세 백작의 이름을 딴 얼그레이는 홍차에 베르가못 오렌지 오일을 블렌딩한 티입니다.'
    ),
    (
        '녹차',
        '보성과 하동 유기농 찻잎의 은은한 깊은 맛',
        4000,
        'TEA',
        'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '중국 신농 황제가 기원전 2737년 끓는 물에 찻잎이 떨어지며 우연히 발견했다는 전설의 음료입니다. 보성과 하동의 청정한 산자락에서 자란 유기농 찻잎이 선사하는 은은하고 깊은 맛을 느껴보세요.'
    ),
    (
        '루이보스',
        '카페인 없는 남아프리카 전통 허브티',
        4000,
        'TEA',
        'https://images.unsplash.com/photo-1597318181412-49af291f617f?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '남아프리카 세더버그 산악지대에서만 자라는 루이보스는 카페인이 전혀 없고 항산화 성분이 풍부합니다. 붉은 황토빛 색깔만큼이나 따뜻하고 은은한 단맛이 마음을 편안하게 해줍니다.'
    ),
    (
        '유자차',
        '고흥·거제 겨울 유자청이 담긴 한국 전통 과일차',
        4850,
        'TEA',
        'https://images.unsplash.com/photo-1682530017002-34e2cb7b1653?w=600&h=400&fit=crop&auto=format',
        'HOT/ICE',
        '유자는 삼국시대부터 한반도에서 재배된 한국의 대표 전통 과일입니다. 달콤하게 재운 유자청이 따뜻한 물에 녹으면 한옥 마루에 앉아 마시는 겨울 오후의 향이 납니다.'
    ),
    (
        '레몬차',
        '국내산 레몬과 꿀로 우린 건강한 한 잔',
        4850,
        'TEA',
        '',
        'HOT/ICE',
        '국내산 레몬을 슬라이스하여 꿀과 함께 우린 레몬차 한 잔으로 활력을 충전하세요. 오래전부터 건강의 음료로 자리잡아 온 레몬차입니다.'
    ),
    -- 블렌디드 프라페
    (
        '자바칩프라페',
        '인도네시아 자바 원두와 초콜릿칩의 조화',
        5850,
        'FRAPPE',
        'https://images.unsplash.com/photo-1718267050202-9b1b6bfb8545?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '인도네시아 자바(Java) 섬은 세계적으로 유명한 커피 산지입니다. 시원하게 블렌딩된 커피 프라페에 초콜릿 칩의 씹히는 식감이 더해져 카페에서 가장 인기 있는 여름 메뉴가 되었습니다.'
    ),
    (
        '쿠키앤크림프라페',
        '오레오 쿠키와 밀크 베이스의 달콤한 블렌딩',
        5850,
        'FRAPPE',
        'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '1912년 미국 뉴저지에서 탄생한 오레오 쿠키를 시원한 밀크 베이스와 함께 블렌딩하면 어린 시절의 행복한 기억이 살아납니다.'
    ),
    (
        '망고프라페',
        '태국 남독마이 망고를 얼음과 블렌딩한 열대 음료',
        5650,
        'FRAPPE',
        'https://images.unsplash.com/photo-1546173159-315724a31696?w=600&h=400&fit=crop&auto=format',
        'ICE',
        '태국 치앙마이의 황금빛 망고밭에서 직수입한 남독마이 망고는 ''망고 중의 망고''로 불립니다. 섬유질 없이 부드럽고 꿀처럼 달콤한 과육을 얼음과 함께 블렌딩합니다.'
    ),
    -- 디저트 & 푸드 : 케이크
    (
        '치즈케이크',
        '덴마크산 크림치즈로 만든 진하고 부드러운 케이크',
        6500,
        'DESSERT',
        'https://images.unsplash.com/photo-1702925614886-50ad13c88d3f?w=600&h=400&fit=crop&auto=format',
        'Cake',
        '치즈케이크의 역사는 기원전 776년 고대 그리스 올림픽으로 거슬러 올라갑니다. 덴마크산 크림치즈를 듬뿍 사용해 진하고 부드러운 질감을 완성한 당신만을 위한 치즈케이크입니다.'
    ),
    (
        '티라미수',
        '이탈리아 전통 ''나를 들어올려줘'' 디저트 케이크',
        6500,
        'DESSERT',
        '',
        'Cake',
        '티라미수(Tiramisù)는 이탈리아어로 ''나를 들어올려줘''라는 뜻입니다. 마스카르포네 치즈, 에스프레소에 적신 레이디핑거, 코코아 파우더가 층을 이루는 마법 같은 케이크입니다.'
    ),
    (
        '초코케이크',
        '발로나 다크 초콜릿 가나슈를 층층이 쌓은 진한 케이크',
        6500,
        'DESSERT',
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&h=400&fit=crop&auto=format',
        'Cake',
        '발로나 다크 초콜릿으로 만든 가나슈를 층층이 쌓아 올린 진한 초코케이크는 초콜릿 애호가들의 로망입니다.'
    ),
    (
        '당근케이크',
        '촉촉한 당근 케이크 위에 크림치즈 프로스팅',
        6500,
        'DESSERT',
        '',
        'Cake',
        '중세 유럽에서 설탕이 귀했던 시절, 달콤한 당근이 설탕의 대체재로 사용되며 탄생했습니다. 촉촉한 당근 케이크 위에 크림치즈 프로스팅을 듬뿍 올린 케이크입니다.'
    ),
    (
        '딸기케이크',
        '국내산 생딸기와 생크림을 겹겹이 쌓은 케이크',
        7000,
        'DESSERT',
        '',
        'Cake',
        '폭신한 제누아즈 시트 사이에 신선한 생크림과 국내산 생딸기를 겹겹이 쌓아 올린 이 케이크는 보는 것만으로도 특별한 날이 된 기분을 선사합니다.'
    ),
    -- 디저트 & 푸드 : 베이커리
    (
        '크로와상',
        '결 따라 바삭하게 부서지는 프랑스 정통 빵',
        3600,
        'DESSERT',
        'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600&h=400&fit=crop&auto=format',
        'Bakery',
        '1683년 오스만 제국의 빈 포위 작전을 기념해 오스트리아 제빵사가 초승달 모양으로 만든 것이 크로와상의 기원입니다. 결 따라 바삭하게 부서지는 그 황홀함을 느껴보세요.'
    ),
    (
        '스콘',
        '잼과 함께 즐기는 스코틀랜드 전통 소박한 빵',
        3400,
        'DESSERT',
        '',
        'Bakery',
        '스코틀랜드의 스콘 마을에서 이름을 딴 스콘은 16세기부터 사랑받던 소박한 빵입니다. 잼과 함께라면 더할 나위 없는 오후의 동반자입니다.'
    ),
    (
        '머핀',
        '바삭한 겉면과 촉촉한 속이 매력인 간식용 빵',
        3400,
        'DESSERT',
        'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=600&h=400&fit=crop&auto=format',
        'Bakery',
        '18세기 영국 찻집에서 처음 등장한 머핀은 미국으로 건너가 오늘날의 형태가 되었습니다. 바삭한 겉면과 촉촉한 속이 매력인 간식입니다.'
    ),
    (
        '베이글',
        '쫄깃하고 윤기 있는 유대인 전통 방식의 빵',
        3150,
        'DESSERT',
        '',
        'Bakery',
        '17세기 폴란드 크라쿠프의 유대인 공동체에서 탄생한 베이글은 이민의 역사를 담은 빵입니다. 끓는 물에 데친 후 구워 완성되는 독특한 방식이 쫄깃하고 윤기 있는 특유의 식감을 만들어냅니다.'
    ),
    (
        '소금빵',
        '버터가 녹아 흘러내리는 일본식 시오빵',
        3050,
        'DESSERT',
        '',
        'Bakery',
        '일본 에히메현의 ''판야 요시다''에서 2013년 탄생한 시오빵이 소금빵의 원조입니다. 버터를 가득 품은 반죽 위에 굵은 소금을 뿌려 구우면 바삭한 겉면 안에서 버터가 녹아 흘러내립니다.'
    ),
    -- 디저트 & 푸드 : 간식
    (
        '마카롱',
        '파리 라뒤레에서 완성된 한 입의 예술작품',
        3050,
        'DESSERT',
        'https://images.unsplash.com/photo-1558326567-98ae2405596b?w=600&h=400&fit=crop&auto=format',
        'Snack',
        '마카롱의 역사는 8세기 이탈리아 수도원에서 시작됩니다. 19세기 파리의 라뒤레에서 두 개의 쿠키 사이에 크림을 채운 현재의 형태가 완성되었습니다.'
    ),
    (
        '쿠키',
        '벨기에산 초콜릿칩이 가득한 버터 향 쿠키',
        2800,
        'DESSERT',
        'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600&h=400&fit=crop&auto=format',
        'Snack',
        '버터의 고소함이 가득 밴 반죽에 벨기에산 초콜릿 칩을 아낌없이 넣어 구운 쿠키는 커피 한 잔과 함께하는 가장 완벽한 조합입니다.'
    ),
    (
        '휘낭시에',
        '뵈르 누아제트의 고소한 향이 담긴 금괴 모양 과자',
        2750,
        'DESSERT',
        'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=600&h=400&fit=crop&auto=format',
        'Snack',
        '19세기 파리 증권거래소 근처에서 정장을 입은 금융가들이 양복에 묻히지 않고 먹을 수 있도록 금괴 모양으로 만든 것이 유래입니다.'
    ),
    (
        '브라우니',
        '겉은 바삭, 속은 촉촉한 진한 초콜릿 바',
        3150,
        'DESSERT',
        'https://images.unsplash.com/photo-1515037893149-de7f840978e2?w=600&h=400&fit=crop&auto=format',
        'Snack',
        '1893년 시카고 만국박람회를 앞두고 탄생했다는 설이 전해집니다. 겉은 바삭하고 속은 촉촉한 진한 초콜릿의 풍미가 가득합니다.'
    ),
    (
        '마들렌',
        '레몬 향 은은한 조개 모양의 프랑스 전통 과자',
        2750,
        'DESSERT',
        'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=600&h=400&fit=crop&auto=format',
        'Snack',
        '프루스트의 소설 ''잃어버린 시간을 찾아서''에서 유명해진 이 조개 모양의 작은 케이크는 레몬 향이 은은하게 풍기며 추억을 소환하는 마법을 부립니다.'
    ),
    -- 디저트 & 푸드 : 브런치
    (
        '에그샌드위치',
        '국내산 신선한 달걀 스크램블이 가득한 든든한 아침',
        4750,
        'DESSERT',
        'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=600&h=400&fit=crop&auto=format',
        'Brunch',
        '국내산 신선한 달걀을 부드럽게 스크램블한 에그 샐러드를 두툼한 식빵 사이에 가득 담아 완성한 당신의 든든한 아침입니다.'
    ),
    (
        'BLT샌드위치',
        '베이컨·상추·토마토를 듬뿍 넣은 클래식 샌드위치',
        4900,
        'DESSERT',
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&h=400&fit=crop&auto=format',
        'Brunch',
        '바삭하게 구운 베이컨, 신선한 로메인 상추, 완숙 토마토를 듬뿍 넣고 마요네즈로 마무리한 간단하지만 완벽한 한 끼입니다.'
    ),
    (
        '크로크무슈',
        '햄과 그뤼에르 치즈를 베샤멜 소스로 구운 파리 명물',
        5150,
        'DESSERT',
        'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&h=400&fit=crop&auto=format',
        'Brunch',
        '1910년 파리의 한 카페 메뉴에 처음 등장한 크로크무슈는 프랑스 전역의 비스트로와 카페에서 필수 메뉴가 되었습니다.'
    ),
    (
        '토스트',
        '갓 구운 식빵과 버터의 소박하지만 완벽한 한 끼',
        3800,
        'DESSERT',
        'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=600&h=400&fit=crop&auto=format',
        'Brunch',
        '갓 구운 식빵의 따뜻한 온기와 버터가 녹아드는 순간의 소박한 행복을 담은 토스트는 언제나 옳은 선택입니다.'
    ),
    (
        '샐러드',
        '제철 유기농 채소와 견과류로 구성된 가벼운 한 끼',
        5000,
        'DESSERT',
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&h=400&fit=crop&auto=format',
        'Brunch',
        '제철 유기농 채소와 견과류, 신선한 드레싱으로 구성된 우리의 샐러드는 가볍지만 충분한 한 끼를 약속합니다.'
    );
-- 샘플 게시글
INSERT INTO board_t (
        title,
        category,
        content,
        author,
        views,
        comments
    )
VALUES (
        '3월 이벤트 안내',
        '공지',
        '3월 한 달간 아메리카노 1+1 이벤트를 진행합니다.',
        '관리자',
        567,
        23
    ),
    (
        '에스프레소 원두 추천 부탁드립니다',
        '질문',
        '에스프레소 추출에 좋은 원두를 추천해주세요.',
        '커피러버',
        152,
        8
    ),
    (
        '신메뉴 시즌 라떼 후기',
        '후기',
        '신메뉴 시즌 라떼 정말 맛있어요!',
        '카페인중독',
        234,
        15
    ),
    (
        '콜드브루 제조 방법 공유합니다',
        '정보',
        '집에서 콜드브루 만드는 방법을 공유합니다.',
        '바리스타김',
        389,
        12
    ),
    (
        '매장 방문 인증샷',
        '자유',
        '오늘 방문한 카페 인증샷 공유합니다.',
        '커피마니아',
        421,
        31
    );
-- ================================================================
-- AI 챗봇 테이블 (menu 프로젝트에서 추가)
-- ================================================================
-- AI 챗봇 키워드 힌트 테이블
CREATE TABLE IF NOT EXISTS chat_keyword (
    id INT NOT NULL AUTO_INCREMENT COMMENT '키워드 번호 (PK)',
    keyword VARCHAR(100) NOT NULL COMMENT '매칭 키워드',
    response TEXT NOT NULL COMMENT '해당 키워드 힌트 응답',
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'AI 챗봇 키워드 기반 힌트 테이블 — GeminiService.askWithHint()에서 참조';
-- AI 챗봇 대화 기록 테이블
CREATE TABLE IF NOT EXISTS chat_history (
    id INT NOT NULL AUTO_INCREMENT COMMENT '기록 번호 (PK)',
    sender VARCHAR(50) NOT NULL COMMENT '발신자 (손님 / 아메라)',
    message TEXT NOT NULL COMMENT '메시지 내용',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성 시각',
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'AI 챗봇 대화 기록 테이블 — ChatMapper.saveHistory() / getAiHistory() 사용';
-- 샘플 키워드 힌트 데이터
INSERT INTO chat_keyword (keyword, response)
VALUES (
        '메뉴',
        '저희 로운카페 메뉴는 에스프레소(3,600원), 아메리카노(4,200원), 카페라떼(4,700원) 등 다양하게 준비되어 있습니다. 자세한 내용은 [메뉴 페이지](/menu/list)에서 확인하세요! ☕'
    ),
    (
        '추천',
        '처음 오셨다면 콜드브루 라떼나 바닐라라떼를 추천드려요! 자세한 메뉴 정보와 스토리는 [메뉴 페이지](/menu/list)에서 확인하실 수 있습니다. 😊'
    ),
    (
        '가격',
        '아메리카노 4,200원 / 라떼류 4,700~5,300원 / 스페셜 5,600원대입니다. 개인 텀블러 지참 시 1,000원 할인! [전체 메뉴 보기](/menu/list) ☕'
    ),
    (
        '매장',
        '저희 로운카페는 서울특별시 마포구 백범로 23, 3층 (신수동, 케이터틀)에 위치해 있습니다. 365일 24시간 연중무휴 운영 중입니다! 직원은 매일 오전 9시~오후 10시 상주합니다. 더 궁금하신 점은 [문의 페이지](/contact)에서 편하게 남겨주세요. ✨'
    ),
    (
        '영업',
        '로운카페는 365일 24시간 운영합니다! 직원은 오전 9시~오후 10시에 상주하며, 그 외 시간에는 셀프로 이용 가능합니다. 자세한 내용은 [자주 묻는 질문](/faq)을 참고해주세요. ✨'
    ),
    (
        '영업시간',
        '로운카페는 24시간 365일 연중무휴로 운영합니다! 새벽에도, 주말에도, 공휴일에도 언제나 문이 열려 있어요. 더 궁금한 점은 [FAQ](/faq)에서 확인하세요. ☕'
    ),
    (
        '몇시',
        '로운카페는 24시간 운영합니다! 직원 상주는 오전 9시~오후 10시이며, 그 외 시간엔 셀프 이용 가능합니다. 추가 문의는 [문의하기](/contact)를 이용해 주세요. 😊'
    ),
    (
        '휴무',
        '로운카페는 연중무휴입니다! 명절, 공휴일, 주말 관계없이 365일 24시간 운영합니다. [자주 묻는 질문](/faq)에서 더 많은 정보를 확인하세요. ✨'
    ),
    (
        '쉬는날',
        '로운카페는 쉬는 날이 없습니다! 365일 24시간 연중무휴로 운영하니 언제든지 편하게 오세요. [FAQ 바로가기](/faq) ☕'
    ),
    (
        '24시간',
        '네, 로운카페는 24시간 연중무휴 운영합니다! 새벽 시간대에도 셀프로 이용 가능하며, 직원 상주는 오전 9시~오후 10시입니다. [문의하기](/contact) 🍃'
    ),
    (
        '이벤트',
        '현재 아메리카노 1+1 이벤트 진행 중입니다! SNS 팔로우 시 첫 방문 10% 할인 쿠폰도 드려요. 최신 소식은 [게시판](/board/list)에서 확인하세요. 🎁'
    ),
    (
        '멤버십',
        '멤버십은 일반 → 실버 → 골드 → VIP 등급으로 운영됩니다. 방문 횟수에 따라 자동 승급되며 쿠폰 혜택을 드려요! 자세한 내용은 [멤버십 페이지](/membership/list)에서 확인하세요. ⭐'
    ),
    (
        '텀블러',
        '개인 텀블러를 지참하시면 1,000원 할인해 드립니다. 환경도 지키고 혜택도 받으세요! 더 많은 혜택은 [멤버십 페이지](/membership/list)를 확인해 보세요. 🍃'
    ),
    (
        '와이파이',
        '무료 와이파이를 제공합니다. 비밀번호는 매장 내 안내판을 확인해 주세요. 기타 문의는 [문의하기](/contact)를 이용해 주세요. ✨'
    ),
    (
        '주차',
        '기계식 주차장을 이용하실 수 있으며, 주차 중 문제 발생 시 카페에서 전적으로 책임집니다. 기타 문의는 [문의하기](/contact)로 남겨주세요. 😊'
    ),
    (
        '주문',
        '주문 방법은 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오. 문의는 [문의하기](/contact)를 이용해 주세요.'
    ),
    (
        '배달',
        '배달 서비스는 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오. 문의는 [문의하기](/contact)를 이용해 주세요.'
    ),
    (
        '디카페인',
        '모든 에스프레소 베이스 음료에 디카페인 옵션을 무료로 선택하실 수 있습니다. [전체 메뉴 보기](/menu/list) ☕'
    );

-- AI 챗봇 만족도 평가 테이블
CREATE TABLE IF NOT EXISTS chat_rating (
    id          INT AUTO_INCREMENT PRIMARY KEY COMMENT '평가 번호 (PK)',
    bot_message TEXT               NOT NULL COMMENT '평가 대상 봇 응답',
    rating      ENUM('good','bad') NOT NULL COMMENT '좋아요 / 별로예요',
    created_at  TIMESTAMP          DEFAULT CURRENT_TIMESTAMP COMMENT '평가 시각'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'AI 챗봇 응답 만족도 평가 테이블 — ChatServiceImpl.saveRating() 사용';

-- ================================================================
-- 외국어 → 한국어 치환 사전 테이블 (ForeignWordFilter 사용)
-- ================================================================
CREATE TABLE IF NOT EXISTS foreign_word_map (
    id           INT NOT NULL AUTO_INCREMENT COMMENT '번호(PK)',
    foreign_word VARCHAR(100) NOT NULL         COMMENT '외국어 원문',
    korean_word  VARCHAR(100) NOT NULL         COMMENT '한국어 번역',
    language     VARCHAR(20)  NOT NULL         COMMENT 'ja / zh / zh-tw',
    PRIMARY KEY (id),
    UNIQUE KEY uk_foreign_word (foreign_word)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='외국어 한국어 치환 사전 — ForeignWordFilter.init() 시 전체 로드';

INSERT IGNORE INTO foreign_word_map (foreign_word, korean_word, language) VALUES
('限定','한정','ja'),('参加','참가','ja'),('參加','참가','zh-tw'),
('特別','특별','ja'),('注文','주문','ja'),('割引','할인','ja'),
('歡迎','환영합니다','zh-tw'),('感謝','감사','zh-tw'),
('飮料','음료','zh-tw'),('飲料','음료','ja'),('咖啡','커피','zh'),
('茶','차','zh'),('非常','매우','zh'),('口味','입맛','zh'),
('今日','오늘','ja'),('每日','매일','zh'),('無料','무료','ja'),
('詳細','자세한','ja'),('人氣','인기','zh-tw'),('人気','인기','ja'),
('新鮮','신선','zh'),('準備','준비','ja'),('確認','확인','ja'),
('利用','이용','ja'),('時間','시간','ja'),('追加','추가','ja'),
('最高','최고','ja'),('最新','최신','ja'),('商品','상품','zh'),
('ありがとうございます','감사합니다','ja'),('ありがとう','감사합니다','ja'),
('よろしくお願いします','잘 부탁드립니다','ja'),
('おはようございます','안녕하세요','ja'),('すみません','실례합니다','ja'),
('ごめんなさい','죄송합니다','ja'),('いらっしゃいませ','어서오세요','ja'),
('こんにちは','안녕하세요','ja'),('こんばんは','안녕하세요','ja'),
('おすすめ','추천','ja'),('お客様','고객님','ja'),
('欢迎光临','어서오세요','zh'),('歡迎光臨','어서오세요','zh-tw'),
('您好','안녕하세요','zh'),('你好','안녕하세요','zh'),
('谢谢您','감사합니다','zh'),('谢谢','감사합니다','zh'),('謝謝','감사합니다','zh-tw'),
('对不起','죄송합니다','zh'),('對不起','죄송합니다','zh-tw'),
('推荐','추천','zh'),('推薦','추천','zh-tw'),
('会员','회원','zh'),('會員','회원','zh-tw'),
('折扣','할인','zh'),('优惠','혜택','zh'),('優惠','혜택','zh-tw'),
('活动','이벤트','zh'),('活動','이벤트','zh-tw'),
('菜单','메뉴','zh'),('菜單','메뉴','zh-tw');