# ROWNCafe — 로운카페

> 정성을 다한 커피 | Spring Boot · JSP · MyBatis · Groq AI

---

## 프로젝트 개요

ROWNCafe는 카페 브랜드 **로운(ROWN)**의 공식 홈페이지입니다.  
회원 관리, 게시판, 멤버십 등급 시스템, 그리고 Groq AI 기반의 전담 챗봇 **아메리**를 포함한 풀스택 Spring MVC 웹 애플리케이션입니다.

---

## 기술 스택

| 분류 | 사용 기술 |
|------|-----------|
| Backend | Spring Boot 3.2.0, Spring MVC |
| View | JSP + JSTL |
| ORM | MyBatis 3.0.3 |
| Database | MySQL 8.x |
| 인증/보안 | 세션 기반 인증 (평문 비밀번호 비교, mypractice01 패턴) |
| AI | Groq API — LLaMA 3.3 70B |
| Build | Maven (WAR) |
| Java | JDK 17 |
| 폰트 | Playfair Display, Noto Sans KR (Google Fonts) |
| 이미지 | 로컬 한국어 파일명 (resources/images/) |

---

## 주요 기능

### 회원 (Member)
- 회원가입 / 로그인 / 로그아웃 — mypractice01 방식으로 재구성 (RedirectAttributes 플래시 메시지, MemberVO 통합 파라미터)
- 마이페이지 (닉네임·전화번호 수정, 회원 탈퇴)
- 이메일 중복 확인 (회원가입 시 서버 체크)

### 게시판 (Board)
- 카테고리별 게시물 목록 (공지 / 자유 / 이벤트)
- 글 작성 · 수정 · 삭제 (소프트 딜리트)
- 댓글 등록 · 삭제
- 검색 (제목 / 작성자 / 내용)
- 페이지네이션

### 멤버십 (Membership)
| 등급 | 기준 | 혜택 |
|------|------|------|
| 일반 | 가입 즉시 | 아메리카노 쿠폰 1장 |
| 실버 | 월 방문 3회 이상 | 사이즈업 쿠폰 월 1장 |
| 골드 | 월 방문 10회 이상 | 아메리카노 쿠폰 월 1장 |
| VIP | 월 방문 30회 이상 | 아무 음료 쿠폰 월 2장 |

### AI 챗봇 — 아메리
- Groq API (LLaMA 3.3 70B) 기반 한국어 전담 안내원
- 전체 페이지 채팅 (`/chat`) + 플로팅 위젯 (모든 페이지)
- 대화 내역 DB 저장 및 복원
- **대화 기억 기능**: 이전 대화를 Groq에 함께 전달하여 맥락을 유지한 답변 생성
  - 비로그인 손님: 현재 세션(탭) 동안 최근 10쌍(20개 메시지) 기억
  - 로그인 회원: 방문 간 연속 기억, 최근 20쌍(40개 메시지) 유지
- 메시지 만족도 평가 (👍 / 👎)
- 키워드 힌트 DB 연동 (24시간·연중무휴·영업시간 등 강조 키워드 포함)
- 응답 내 마크다운 링크 렌더링 (메뉴·멤버십·게시판·문의·FAQ 페이지로 바로 이동) — context path 자동 적용
- 다국어 입력 감지 및 자동 번역 후 한국어 응답 (힌디어·아랍어·러시아어·태국어 등)
- 외국어 필터: 힌디어·벵골어·키릴·그리스어·아르메니아어·조지아어 등 20개 이상 스크립트 제거
- 마크다운 링크 URL 보호: 외국어 필터 적용 시 URL 경로가 손상되지 않도록 placeholder 보호 후 복원
- 시스템 프롬프트 DB 연동: 앱 시작 시 `menu_t`(메뉴·가격)·`chat_keyword`(매장·영업·멤버십 정보)를 로드하여 프롬프트에 동적 주입 — 하드코딩 없이 DB 수정만으로 AI 답변 내용 변경 가능
- **카페 무관 질문 응대**: 공감 → 현실 답변 → 로운카페 자연스러운 언급 3단계로 응대 (예: 우산·과일 구매 문의 등)
- `ForeignWordFilter` 개선: 마크다운 링크의 URL만 보호하고 label 텍스트는 외국어 필터 적용 — label에 한자 등이 섞여도 제거됨
- null 안전성 강화: `@Value("${groq.api.key:}")` 기본값 추가, `HTTP_POST` 상수에 `@NonNull` 명시

---

## 프로젝트 구조

```
cafe-spring/
├── src/main/
│   ├── java/org/study/cafe/
│   │   ├── board/          # 게시판 Controller · Service · Mapper · VO
│   │   ├── chat/           # AI 챗봇 Controller · GroqService · Mapper · VO
│   │   ├── home/           # HomeController
│   │   ├── member/         # 회원 Controller · Service · Mapper · VO
│   │   ├── membership/     # 멤버십 Controller · Service · Mapper · VO
│   │   ├── menu/           # 메뉴 Controller · Service · Mapper · VO
│   │   ├── common/         # Paging 유틸
│   │   └── config/         # BCryptConfig
│   ├── resources/
│   │   ├── application.properties
│   │   └── mapper/         # MyBatis XML Mapper 파일들
│   └── webapp/
│       ├── resources/
│       │   ├── css/        # style.css, home.css, login.css, register.css,
│       │   │               # board.css, membership.css, chat-page.css, chatbot.css, about.css ...
│       │   ├── js/         # home.js, chat-page.js, chatbot.js,
│       │   │               # login.js, register.js, menu.js, detail.js ...
│       │   └── images/     # 메인-히어로.jpg, 카페-내부.jpg, 로스팅-배너.jpg,
│       │                   # 바리스타-드립.jpg, 바리스타-팀.jpg, 에스프레소.jpg,
│       │                   # 아메리카노.jpg, 카페라떼.jpg, 콜드브루.jpg,
│       │                   # 원두-산지.jpg, 카푸치노.jpg, 아인슈페너.jpg,
│       │                   # 카라멜_마끼아또.jpg, 라떼-백조.jpg, 라떼-에스.jpg ...
│       └── WEB-INF/views/
│           ├── common/     # header.jsp, footer.jsp (Instagram·Facebook·YouTube 소셜 링크), chatbot.jsp
│           ├── home/       # index.jsp, about.jsp, chat.jsp, faq.jsp ...
│           ├── board/      # list.jsp, write.jsp, detail.jsp, edit.jsp
│           ├── member/     # login.jsp, register.jsp, mypage.jsp
│           ├── membership/ # list.jsp
│           └── menu/       # detail.jsp
```

---

## URL 구조

| URL | 설명 |
|-----|------|
| `/` | 홈 |
| `/about` | 브랜드 스토리 |
| `/board/list` | 게시판 목록 |
| `/board/write` | 게시글 작성 |
| `/board/detail/{idx}` | 게시글 상세 |
| `/member/login` | 로그인 |
| `/member/register` | 회원가입 |
| `/member/mypage` | 마이페이지 |
| `/membership/list` | 멤버십 등급 안내 |
| `/contact` | 오시는 길 (주소·Google Maps·운영시간) |
| `/faq` | 자주 묻는 질문 (DB 연동 내용 반영) |
| `/chat` | AI 챗봇 전체 페이지 |
| `POST /chat/send` | AI 메시지 전송 (REST) |
| `POST /chat/rate` | 챗봇 만족도 평가 (REST) |
| `GET /chat/history` | 대화 내역 조회 (REST) |
| `/terms-of-service` | 이용약관 (14개 조항) |
| `/privacy-policy` | 개인정보 처리방침 (12개 조항) |

---

## DB 테이블

```sql
-- DB: project  /  접속: dbuser1 / 1234
member_t          -- 회원 (m_idx, name, email, password, linked_customer, reg_date, active)
customer_t        -- CRM 고객 (c_idx, name, phone, grade, visit_count, memo, active)
board_t           -- 게시글 (b_idx, title, content, author, category, reg_date, active)
comment_t         -- 댓글 (c_idx, b_idx, author, content, reg_date)
membership_t      -- 멤버십 (ms_idx, user_id, grade, points, reg_date)
menu_t            -- 메뉴 (m_idx, name, description, price, category, image_url, story, origin, available)
chat_log_t        -- 채팅 로그 (log_idx, session_id, m_idx, sender, message, reg_date)
chat_history      -- AI 대화 기록 (id, sender, message, created_at)
chat_keyword      -- 키워드 힌트 (id, keyword, response, search_count, bad_count)
chat_rating       -- 챗봇 만족도 (id, bot_message, rating, created_at, keyword_id→chat_keyword)
foreign_word_map  -- 외국어→한국어 치환 사전 (id, foreign_word, korean_word, language)
users             -- 챗봇 로그인 사용자 (id, username, password, nickname, created_at)
```

> **⚠️ SQL 파일 동기화 내역 (2026-04-09)**
> - `chat_bot.sql` : 대상 DB를 `dbstudy` → `project` 로 변경 (실제 DB와 일치)
> - `chat_bot.sql` : `chat_keyword` 에 `bad_count` 컬럼 추가
> - `chat_bot.sql` : `chat_rating` 에 `keyword_id` FK 컬럼 추가
> - `chat_bot_filter.sql` : `USE Project` → `USE project` (소문자 통일)

---

## 실행 방법

### 1. DB 설정

```sql
CREATE DATABASE project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

`sql/cafe_web.sql` 파일을 `project` DB에 실행합니다. (모든 테이블 + 샘플 데이터 포함)

`application.properties`에서 DB 접속 정보를 수정합니다.

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/project?useSSL=false&serverTimezone=Asia/Seoul
spring.datasource.username=dbuser1
spring.datasource.password=1234
```

### 2. Groq API 키 설정

[Groq Console](https://console.groq.com)에서 API 키를 발급받아 `application.properties`에 입력합니다.

```properties
groq.api.key=gsk_your_api_key_here
```

### 3. 빌드 및 실행

```bash
cd cafe-spring/cafe-spring
mvn spring-boot:run
```

또는 WAR로 빌드 후 외부 Tomcat에 배포합니다.

```bash
mvn clean package
# target/cafe-0.0.1-SNAPSHOT.war → Tomcat webapps/
```

### 4. 접속

```
http://localhost:8080/
```

---

## 환경 변수 (application.properties 주요 항목)

| 키 | 설명 |
|----|------|
| `spring.datasource.url` | MySQL 접속 URL |
| `spring.datasource.username` | DB 사용자 |
| `spring.datasource.password` | DB 비밀번호 |
| `groq.api.key` | Groq AI API 키 |
| `spring.servlet.multipart.max-file-size` | 파일 업로드 최대 크기 (기본 10MB) |

---

## 개발 환경

- **IDE**: IntelliJ IDEA
- **Java**: JDK 17
- **DB**: MySQL 8.x (로컬)
- **Server**: Spring Boot 내장 Tomcat
