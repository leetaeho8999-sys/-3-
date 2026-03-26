-- =============================================
-- 정성을 다한 커피 — schema.sql
-- =============================================
USE dbstudy;

-- 회원
DROP TABLE IF EXISTS member_t;
CREATE TABLE member_t (
    m_idx    INT          NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    email    VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone    VARCHAR(20)  DEFAULT '',
    reg_date TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    active   TINYINT      DEFAULT 0,
    PRIMARY KEY (m_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 게시판
DROP TABLE IF EXISTS comment_t;
DROP TABLE IF EXISTS board_t;
CREATE TABLE board_t (
    b_idx    INT          NOT NULL AUTO_INCREMENT,
    title    VARCHAR(255) NOT NULL,
    category VARCHAR(50)  DEFAULT '자유',
    content  TEXT,
    author   VARCHAR(100) NOT NULL,
    views    INT          DEFAULT 0,
    comments INT          DEFAULT 0,
    reg_date TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    active   TINYINT      DEFAULT 0,
    PRIMARY KEY (b_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 댓글
CREATE TABLE comment_t (
    c_idx    INT          NOT NULL AUTO_INCREMENT,
    b_idx    INT          NOT NULL,
    author   VARCHAR(100) NOT NULL,
    content  TEXT         NOT NULL,
    reg_date TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (c_idx),
    FOREIGN KEY (b_idx) REFERENCES board_t(b_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 메뉴
DROP TABLE IF EXISTS menu_t;
CREATE TABLE menu_t (
    m_idx       INT            NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100)   NOT NULL,
    description TEXT,
    price       INT            DEFAULT 0,
    category    VARCHAR(50),
    image_url   VARCHAR(500),
    story       TEXT,
    origin      VARCHAR(100),
    available   TINYINT        DEFAULT 1,
    PRIMARY KEY (m_idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 멤버십
DROP TABLE IF EXISTS membership_t;
CREATE TABLE membership_t (
    ms_idx   INT         NOT NULL AUTO_INCREMENT,
    user_id  INT         NOT NULL UNIQUE,
    grade    VARCHAR(20) DEFAULT '베이직',
    points   INT         DEFAULT 0,
    reg_date TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ms_idx),
    FOREIGN KEY (user_id) REFERENCES member_t(m_idx) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
