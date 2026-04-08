-- ================================================================
-- 로운 카페 — 독립형 챗봇 (chat_bot) DB 설정
-- 대상 DB : dbstudy
-- 참조 위치: D:\dev\중간프로젝트\chat_bot
-- ================================================================

CREATE DATABASE IF NOT EXISTS dbstudy
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE dbstudy;

-- ── 1. 키워드 응답 테이블 ──────────────────────────────────────
-- 챗봇이 특정 질문에 우선 참고할 답변을 저장합니다.
-- ChatMapper.findByKeyword() / incrementSearchCount() 에서 사용
CREATE TABLE IF NOT EXISTS chat_keyword (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    keyword      VARCHAR(100) NOT NULL COMMENT '매칭할 키워드',
    response     TEXT         NOT NULL COMMENT '참고 답변',
    search_count INT          NOT NULL DEFAULT 0 COMMENT '검색 횟수'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- 기존 테이블에 search_count 컬럼이 없을 경우 실행
-- ALTER TABLE chat_keyword ADD COLUMN search_count INT NOT NULL DEFAULT 0 COMMENT '검색 횟수';

-- ── 2. 채팅 기록 테이블 ────────────────────────────────────────
-- 사용자와 봇(아메리)의 대화 내용을 저장합니다.
-- ChatMapper.saveHistory() / getHistory() 에서 사용
CREATE TABLE IF NOT EXISTS chat_history (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    sender     VARCHAR(50)  NOT NULL COMMENT '닉네임 또는 아메리',
    message    TEXT         NOT NULL COMMENT '대화 내용',
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- 기존 테이블의 sender 컬럼 크기가 작을 경우 실행
-- ALTER TABLE chat_history MODIFY COLUMN sender VARCHAR(50) NOT NULL;

-- ── 3. 회원 테이블 ─────────────────────────────────────────────
-- 로그인 기능 구현 시 사용합니다.
CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE  COMMENT '로그인 아이디',
    password   VARCHAR(255) NOT NULL         COMMENT '비밀번호 (암호화 저장)',
    nickname   VARCHAR(50)  NOT NULL         COMMENT '채팅에 표시될 닉네임',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- ── 4. 만족도 평가 테이블 ──────────────────────────────────────
-- 챗봇 응답에 대한 👍👎 평가를 저장합니다.
-- ChatServiceImpl.saveRating() 에서 사용
CREATE TABLE IF NOT EXISTS chat_rating (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    bot_message TEXT               NOT NULL COMMENT '평가 대상 봇 응답',
    rating      ENUM('good','bad') NOT NULL COMMENT '좋아요/별로예요',
    created_at  TIMESTAMP          DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- ── 5. 초기 키워드 데이터 ──────────────────────────────────────

-- 아메리 자기소개
INSERT INTO chat_keyword (keyword, response) VALUES
('이름',    '저는 로운카페의 AI 안내원 아메리입니다. 무엇이든 편하게 물어보세요!'),
('너 누구', '저는 로운카페의 AI 안내원 아메리입니다. 무엇이든 편하게 물어보세요!'),
('누구야',  '저는 로운카페의 AI 안내원 아메리입니다. 무엇이든 편하게 물어보세요!'),
('뭐야',    '저는 로운카페의 AI 안내원 아메리입니다. 무엇이든 편하게 물어보세요!'),
('챗봇',    '저는 로운카페의 AI 안내원 아메리입니다. 무엇이든 편하게 물어보세요!');

-- 카페 정보
INSERT INTO chat_keyword (keyword, response) VALUES
-- 휴무일
('휴무일', '저희 카페는 연중무휴 운영합니다. 직원이 없는 시간에도 셀프로 자유롭게 이용하실 수 있습니다.'),
('쉬는날', '저희 카페는 연중무휴 운영합니다. 직원이 없는 시간에도 셀프로 자유롭게 이용하실 수 있습니다.'),

-- 위치
('위치', '저희 카페는 서울특별시 마포구 백범로 23, 3층 (신수동, 케이터틀)에 위치해 있습니다. 지하철 5·6호선 공덕역 8번 출구에서 도보 5분 거리입니다.'),
('주소', '저희 카페는 서울특별시 마포구 백범로 23, 3층 (신수동, 케이터틀)에 위치해 있습니다. 지하철 5·6호선 공덕역 8번 출구에서 도보 5분 거리입니다.'),

-- 주차
('주차', '기계식 주차장을 이용하실 수 있습니다. 주차 중 문제가 발생할 경우 카페에서 전적으로 책임집니다.'),

-- 영업시간
('영업시간', '로운카페는 24시간 365일 연중무휴로 운영합니다! 직원은 매일 오전 9시~오후 10시 상주하며, 그 외 시간에는 셀프로 자유롭게 이용하실 수 있습니다. 더 자세한 내용은 [오시는 길](/contact)에서 확인하세요.'),
('몇시',     '로운카페는 24시간 365일 연중무휴로 운영합니다! 직원은 매일 오전 9시~오후 10시 상주하며, 그 외 시간에는 셀프로 자유롭게 이용하실 수 있습니다.'),

-- 와이파이
('와이파이', '카페 내 와이파이를 안전하게 이용하실 수 있습니다.'),
('wifi',     '카페 내 와이파이를 안전하게 이용하실 수 있습니다.'),

-- 콘센트
('콘센트', '카페 내 콘센트가 설비되어 있어 자유롭게 사용하실 수 있습니다.'),
('충전',   '카페 내 콘센트가 설비되어 있어 자유롭게 사용하실 수 있습니다.'),

-- 예약
('예약', '3일 전까지 예약이 가능하며 단체석도 이용하실 수 있습니다.'),
('단체', '단체석 이용 가능합니다. 방문 3일 전까지 예약해 주세요.'),

-- 결제
('결제',       '카드, 카카오페이, 삼성페이, 애플페이 등 다양한 결제 수단을 이용하실 수 있습니다. 현금 결제는 직원 상주 시간(오전 9시~오후 10시)에만 가능합니다.'),
('현금',       '현금 결제는 직원 상주 시간(오전 9시~오후 10시)에만 가능합니다.'),
('카카오페이', '카카오페이 결제 가능합니다. 그 외 카드, 삼성페이, 애플페이도 이용하실 수 있습니다.'),
('삼성페이',   '삼성페이 결제 가능합니다. 그 외 카드, 카카오페이, 애플페이도 이용하실 수 있습니다.'),
('애플페이',   '애플페이 결제 가능합니다. 그 외 카드, 카카오페이, 삼성페이도 이용하실 수 있습니다.'),

-- 반려동물
('반려동물', '반려동물 입장 가능합니다. 카페 앞 마당이 있어 산책도 즐기실 수 있습니다.'),
('강아지',   '반려동물 입장 가능합니다. 카페 앞 마당이 있어 산책도 즐기실 수 있습니다.'),
('고양이',   '반려동물 입장 가능합니다. 카페 앞 마당이 있어 산책도 즐기실 수 있습니다.'),
('펫',       '반려동물 입장 가능합니다. 카페 앞 마당이 있어 산책도 즐기실 수 있습니다.'),

-- 키즈존
('키즈존', '카페 내 키즈존이 마련되어 있어 아이와 함께 편리하게 이용하실 수 있습니다.'),
('어린이', '카페 내 키즈존이 마련되어 있어 아이와 함께 편리하게 이용하실 수 있습니다.'),
('아이',   '카페 내 키즈존이 마련되어 있어 아이와 함께 편리하게 이용하실 수 있습니다.'),

-- 텀블러
('텀블러', '개인 텀블러 지참 시 1,000원 할인해 드립니다.'),
('개인컵', '개인 텀블러 지참 시 1,000원 할인해 드립니다.'),
('할인',   '개인 텀블러 지참 시 1,000원 할인해 드립니다.');

-- 주문 방법 (준비 중)
INSERT INTO chat_keyword (keyword, response) VALUES
('주문',     '주문 방법은 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오.'),
('주문방법', '주문 방법은 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오.');

-- 디카페인 (무료)
INSERT INTO chat_keyword (keyword, response) VALUES
('디카페인', '모든 에스프레소 베이스 음료에 디카페인 옵션을 무료로 선택하실 수 있습니다.'),
('카페인',   '모든 에스프레소 베이스 음료에 디카페인 옵션을 무료로 선택하실 수 있습니다.');

-- 배달 (준비 중)
INSERT INTO chat_keyword (keyword, response) VALUES
('배달',   '배달 서비스는 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오.'),
('배달비', '배달 서비스는 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오.');

-- ── 관리자용 조회 쿼리 ─────────────────────────────────────────

-- 자주 묻는 키워드 TOP 10
-- SELECT keyword, response, search_count FROM chat_keyword ORDER BY search_count DESC LIMIT 10;

-- 만족도 평가 집계
-- SELECT rating, COUNT(*) AS 건수 FROM chat_rating GROUP BY rating;

-- 별로예요(👎)를 많이 받은 응답 TOP 5
-- SELECT bot_message, COUNT(*) AS 비추천수 FROM chat_rating WHERE rating = 'bad'
-- GROUP BY bot_message ORDER BY 비추천수 DESC LIMIT 5;
