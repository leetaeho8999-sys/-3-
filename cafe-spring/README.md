# ROWNCafe — 로운카페

> 정성을 다한 커피 | Spring Boot MVC · JSP · MyBatis · Groq AI

---

## 프로젝트 개요

ROWNCafe는 카페 브랜드 **로운(ROWN)**의 공식 홈페이지입니다.  
회원 관리, 게시판, 멤버십 등급 시스템, Groq AI 기반 전담 챗봇 **아메리**를 포함한 Java Spring Boot MVC 웹 애플리케이션입니다.

---

## 기술 스택

| 분류 | 사용 기술 |
|------|-----------|
| Language | Java 17 |
| Backend | Spring Boot 3.2.0, Spring MVC |
| View | JSP + JSTL |
| ORM | MyBatis 3.0.3 |
| Database | MySQL 8.x |
| 인증/보안 | Spring Security Crypto (BCrypt) |
| AI | Groq API — LLaMA 3.3 70B |
| Build | Maven (WAR) |
| 폰트 | Playfair Display, Noto Sans KR (Google Fonts) |

---

## 주요 기능

### 회원 (Member)
- 회원가입 / 로그인 / 로그아웃
- 마이페이지 (닉네임·전화번호 수정, 회원 탈퇴)
- BCrypt 비밀번호 암호화
- 이메일·닉네임 중복 확인 (Ajax)

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
- 메시지 만족도 평가 (👍 / 👎)

---

## 프로젝트 구조

```
src/main/
├── java/org/study/cafe/
│   ├── board/          # 게시판 Controller · Service · Mapper · VO
│   ├── chat/           # AI 챗봇 Controller · GroqService · Mapper · VO
│   ├── home/           # HomeController
│   ├── member/         # 회원 Controller · Service · Mapper · VO
│   ├── membership/     # 멤버십 Controller · Service · Mapper · VO
│   ├── menu/           # 메뉴 Controller · Service · Mapper · VO
│   ├── common/         # Paging 유틸
│   └── config/         # BCryptConfig
├── resources/
│   ├── application.properties
│   └── mapper/         # MyBatis XML Mapper
└── webapp/
    ├── resources/
    │   ├── css/        # style.css, home.css, auth.css, board.css,
    │   │               # membership.css, chat-page.css, chatbot.css ...
    │   └── js/         # home.js, chat-page.js, chatbot.js, register.js ...
    └── WEB-INF/views/
        ├── common/     # header.jsp, footer.jsp, chatbot.jsp
        ├── home/       # index.jsp, about.jsp, chat.jsp, faq.jsp ...
        ├── board/      # list.jsp, write.jsp, detail.jsp, edit.jsp
        ├── member/     # login.jsp, register.jsp, mypage.jsp
        ├── membership/ # list.jsp
        └── menu/       # detail.jsp
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
| `/chat` | AI 챗봇 전체 페이지 |
| `POST /chat/send` | AI 메시지 전송 (REST) |
| `POST /chat/rate` | 챗봇 만족도 평가 (REST) |
| `GET /chat/history` | 대화 내역 조회 (REST) |

---

## DB 테이블

```sql
member_t        -- 회원 (m_idx, name, email, password, linked_customer, reg_date, active)
customer_t      -- CRM 고객 (c_idx, name, phone, grade, visit_count, memo, active)
board_t         -- 게시글 (b_idx, title, content, author, category, reg_date, active)
comment_t       -- 댓글 (cm_idx, b_idx, author, content, reg_date, active)
membership_t    -- 멤버십 (ms_idx, user_id, grade, points, reg_date)
chat_log_t      -- 채팅 로그 (log_idx, session_id, m_idx, sender, message, reg_date)
chat_history    -- AI 대화 기록 (id, sender, message, created_at)
chat_keyword    -- 키워드 힌트 (keyword, response)
chat_rating     -- 챗봇 만족도 (id, bot_message, rating, created_at)
```

---

## 실행 방법

### 1. DB 설정

```sql
CREATE DATABASE project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

`application.properties`에서 DB 접속 정보를 수정합니다.

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/project?useSSL=false&serverTimezone=Asia/Seoul
spring.datasource.username=your_db_user
spring.datasource.password=your_password
```

### 2. Groq API 키 설정

[Groq Console](https://console.groq.com)에서 API 키를 발급받아 입력합니다.

```properties
groq.api.key=gsk_your_api_key_here
```

### 3. 실행

```bash
# IntelliJ: CafeApplication.java 실행
# 또는 터미널:
mvn spring-boot:run
```

### 4. 접속

```
http://localhost:8080/
```

---

## 개발 환경

- **IDE**: IntelliJ IDEA
- **Java**: JDK 17
- **DB**: MySQL 8.x
- **Server**: Spring Boot 내장 Tomcat
