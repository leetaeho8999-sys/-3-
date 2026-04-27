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
| Language | Java 21 |
| Backend | Spring Boot 3.2.0, Spring MVC |
| View | JSP + JSTL |
| ORM | MyBatis 3.0.3 |
| Database | MySQL 8.x |
| AI | Groq API — LLaMA 3.3 70B |
| Build | Maven (WAR) |
| 폰트 | Playfair Display, Noto Sans KR (Google Fonts) |
| 반응형 | clamp() + vw/rem 기반 유동 스케일링 (전체 CSS) |

---

## 주요 기능

### 회원 (Member)
- 회원가입 / 로그인 / 로그아웃
- 마이페이지 (닉네임·전화번호 수정, 회원 탈퇴)
- 아이디·닉네임 중복 확인 (Ajax)

### 게시판 (Board)
- 카테고리별 게시물 목록 (공지 / 자유 / 이벤트)
- 글 작성 · 수정 · 삭제 (소프트 딜리트)
- 댓글 등록 · 삭제
- 검색 (제목 / 작성자 / 내용), 페이지네이션

### 메뉴 (Menu)
- 커피 / 논커피 / 에이드&스무디 / 티 / 블렌디드·프라페 / 디저트&푸드 탭 분류
- **DB 기반 동적 렌더링** — `menu_t` 전체 목록을 JSP `c:forEach`로 렌더링 (하드코딩 50+ 카드 완전 제거)
- **카테고리 정렬** — `FIELD(category, 'ESPRESSO','COFFEE','LATTE',...)` + 가격 오름차순 정렬
- **이미지 URL 분기** — `https://` 외부 URL은 그대로, 로컬 경로는 contextPath 자동 prefix
- **HOT/ICE 가격 차등** — ICE 선택 시 `menu_t.ice_extra_price`(기본 +500원) 자동 반영
- **사이즈(Tall/Grande/Venti) 추가금** — 스타벅스 기준 Grande +500 / Venti +1,000. ESPRESSO·DESSERT 카테고리는 사이즈 선택 숨김 (DB 추가금 0)
- **서버 측 가격 검증** — 결제 생성 시 DB 가격 재조회 후 클라이언트 값 강제 보정 (가격 조작 방지)
- 로컬 이미지 사용 (에스프레소, 아메리카노, 카페라떼, 카푸치노, 카라멜마키아토, 아포가토, 콜드브루, 드립커피, 아인슈페너 등)

### 멤버십 (Membership)
- 로그인 회원 전용 대시보드 — 실제 DB 데이터 연동
- `member.m_phone = customer_t.phone` 조인으로 방문 횟수 실시간 조회
- visit_count 기반 등급 자동 재계산 → `membership_t` 즉시 갱신
- 등급별 카드 색상 테마 (일반 크림 / 실버 그라디언트 / 골드 메탈릭 / VIP 블랙+샤인)
- 다음 등급까지 프로그레스 바 표시

| 등급 | 기준 | 혜택 |
|------|------|------|
| 일반 | 가입 즉시 | 아메리카노 쿠폰 1장 |
| 실버 | 월 방문 3회 이상 | 사이즈업 쿠폰 월 1장 |
| 골드 | 월 방문 10회 이상 | 아메리카노 쿠폰 월 1장 |
| VIP  | 월 방문 30회 이상 | 아무 음료 쿠폰 월 2장 |

### 주문/결제 (Order)
- 메뉴 상세 모달 → 수량·온도 옵션 선택 → 토스페이먼츠 결제창 실연동
- 로그인 회원 전용 (비로그인 시 로그인 페이지로 리다이렉트)
- 공용 테스트 키 기본 적용 — 별도 발급 없이 테스트 가능
- 결제 금액 위변조 방지 (서버 DB 금액과 요청 금액 검증)
- 주문 완료·실패 전용 페이지
- **마이페이지 - 내 주문 내역**: 최근 20건 표시, 주문일시·메뉴·총액·상태 4컬럼, 행 클릭 시 AJAX 상세 모달에서 주문번호·결제키 확인 (본인 주문 403 검증)
- **주문 취소 / 환불** (2026-04-24) — 마이페이지 주문 상세 모달 내에서만 취소 가능 (실수 방지). 시간 기반 3단계 차등 환불: 3분 이내 전액, 3~10분 50%, 10분 초과 취소 불가. 토스페이먼츠 `cancel` API 연동, 서버에서 `paid_date` 기준 경과 시간으로 판정. 본인/PAID/payment_key 4중 검증 + `WHERE status='PAID'` 로 이중취소 방지. 취소 사유 4종(단순변심/주문실수/조리지연/기타) 드롭다운, "기타" 선택 시 비고 필수
- **공통 UI 다이얼로그 — 토스트 / 알림 모달 / 확인 모달** (2026-04-24) — 브라우저 기본 `alert()`/`confirm()` 을 전부 교체한 사이트 일관 UI. 전역 함수 3종: `showToast(message, type)` (우측 하단 슬라이드, 3초 자동 사라짐, 최대 3개 스택), `showAlert(message, title, type)` (중앙 모달, Promise<void>), `showConfirm(message, title, {confirmText, cancelText, dangerMode, html})` (Promise<boolean>). 접근성: ESC/배경 클릭 닫기, body 스크롤 잠금. 선언형 사용: `<a data-confirm="..." data-confirm-danger>` 로 링크·폼 자동 확인 처리. `header.jsp` 에 전역 로드되어 모든 페이지에서 사용 가능
- **장바구니** (2026-04-24) — `cart_t` DB 테이블 기반 영구 저장 (세션/로컬스토리지 X). 로그인 회원 전용. 헤더 🛒 + 뱃지(행 수) → 클릭 시 오른쪽 사이드 슬라이드 패널. 메뉴 옵션 모달에 **"장바구니 담기" / "바로 결제"** 두 버튼 공존. 같은 메뉴+옵션(온도/사이즈) 조합이면 수량 자동 누적. 패널에서 수량 +/- / 개별 삭제 / 전체 비우기 / 주문하기(토스 결제창). 결제 성공(/order/success) 시 장바구니 자동 비움. 서버가 HOT/ICE + 사이즈 추가금 재계산하여 `unit_price` 저장 — 클라이언트 조작 방지

### AI 챗봇 — 아메리
- Groq API (LLaMA 3.3 70B) 기반 한국어 전담 안내원
- 전체 페이지 채팅 (`/chat`) + 플로팅 위젯 (모든 페이지)
- 대화 내역 DB 저장 및 복원 (로그인: 회원별, 비로그인: 세션별 분리)
- 메시지 만족도 평가 (👍 / 👎), 대화 초기화 버튼

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
│   └── common/         # Paging 유틸
├── resources/
│   ├── application.properties  # 모든 민감값은 환경변수 참조
│   └── mapper/         # MyBatis XML Mapper
└── webapp/
    ├── resources/
    │   ├── css/        # style.css, home.css, auth.css, board.css,
    │   │               # membership.css, chat-page.css, chatbot.css,
    │   │               # ui-dialog.css (공통 토스트/모달), cart-panel.css ...
    │   └── js/         # home.js, chat-page.js, chatbot.js, register.js,
    │                   # ui-dialog.js (전역 showToast/showAlert/showConfirm),
    │                   # cart.js (장바구니 패널), my-orders.js ...
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
| `/membership/list` | 멤버십 대시보드 (로그인 필요) |
| `/chat` | AI 챗봇 전체 페이지 |
| `POST /chat/send` | AI 메시지 전송 (REST) |
| `POST /chat/reset` | 대화 내역 초기화 (REST) |
| `POST /chat/rate` | 챗봇 만족도 평가 (REST) |
| `GET  /chat/history` | 대화 내역 조회 (REST) |
| `POST /order/create` | 주문 생성 (REST, 로그인 필요) |
| `GET  /order/success` | 결제 성공 콜백 |
| `GET  /order/fail` | 결제 실패 콜백 |
| `GET  /order/my` | 내 주문 목록 |
| `GET  /order/detail/{orderId}` | 주문 상세 JSON (본인 주문만, 마이페이지 모달용) — 응답에 `cancelable`, `currentRefundRate`, `currentRefundAmount` 포함 |
| `POST /order/cancel` | 주문 취소 (로그인 필요, 본인 주문/PAID/10분 이내만) — `orderId`, `reason`, `memo` 폼 파라미터. 토스 cancel API 호출 후 DB 상태 `CANCELLED` 로 갱신 |
| `GET  /cart/list` | 내 장바구니 조회 (JSON) — 사이드 패널 로드용. `items` + `totalAmount` + `totalCount` |
| `GET  /cart/count` | 헤더 뱃지용 카운트 숫자만 |
| `POST /cart/add` | 장바구니 담기 — `menuName`, `temperature`, `size`, `quantity`. 같은 조합이면 수량 누적 |
| `POST /cart/update` | 수량 변경 — `cartIdx`, `quantity` (0 이하 시 서비스 단에서 삭제) |
| `POST /cart/delete` | 개별 아이템 삭제 — `cartIdx` |
| `POST /cart/clear` | 장바구니 전체 비우기 |
| `POST /cart/checkout` | 장바구니 → `order_t`+`order_item_t` 이관 후 `orderId`/`amount` 반환 → 프론트가 Toss 결제창 호출 |

---

## DB 테이블

| 테이블 | 주요 컬럼 | 용도 |
|--------|-----------|------|
| `member` | m_id (VARCHAR PK), m_pw, m_name, m_phone, m_email | **현재 로그인용** (abcd 방식) |
| `member_t` | m_idx (INT PK), email, password, name ... | 구 회원 테이블 — 로그인 미사용, 스키마 유지 |
| `customer_t` | c_idx, name, phone, grade, visit_count | CRM 고객 — brew-crm이 방문 관리 |
| `membership_t` | ms_idx, user_id (VARCHAR FK→member.m_id), grade, points | 멤버십 포인트·등급 |
| `board_t` | b_idx, title, content (MEDIUMTEXT), author, category | 게시글 |
| `comment_t` | cm_idx, b_idx, author, content | 댓글 |
| `chat_log_t` | log_idx, session_id, m_idx (VARCHAR), sender, message | 채팅 로그 |
| `chat_history` | id, sender, message | AI 대화 기록 |
| `chat_keyword` | keyword, response | AI 키워드 힌트 |
| `chat_rating` | id, bot_message, rating | 챗봇 만족도 |
| `menu_t` | m_idx, name, category, price, **ice_extra_price** (ICE 추가금), image_url, available | 메뉴 (2026-04-22 ice_extra_price 추가) |
| `order_t` | order_id (VARCHAR PK), m_id (FK→member), total_amount, status, payment_key | 주문 헤더 |
| `order_item_t` | oi_idx (INT PK), order_id (FK→order_t), menu_name, temperature, quantity, unit_price | 주문 상세 |

---

## 로컬 개발 환경 구축 체크리스트

> 아래 순서를 지키지 않으면 **500 Internal Server Error**가 발생합니다.

- [ ] 1. MySQL 8.x 설치 및 `project` DB 생성
- [ ] 2. `.env.example` 을 `.env` 로 복사 후 DB 정보와 Groq API 키 입력
- [ ] 3. `sql/init_schema.sql` 실행 — 모든 테이블 생성
- [ ] 4. (선택) 테스트 계정 INSERT
- [ ] 5. IntelliJ 에서 `CafeApplication.java` 실행
- [ ] 6. `http://localhost:8080/` 접속 확인

---

## 실행 방법

### 1. DB 생성

```sql
CREATE DATABASE project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. 환경변수 설정 (.env 파일)

DB 접속 정보와 Groq API 키는 `application.properties`에 직접 입력하거나 `.env` 파일로 관리할 수 있습니다.

**방법 ① — 직접 입력 (현재 적용 중, 개발·학습 환경 권장)**

`application.properties`에 값을 직접 적습니다.

```properties
spring.datasource.username=your_db_user
spring.datasource.password=your_db_password
groq.api.key=gsk_your_api_key_here
```

> `.env` 파일 없이 바로 실행됩니다.

**방법 ② — .env 파일 (팀 개발·배포 환경 권장)**

프로젝트 루트의 `.env.example`을 복사해 `.env`로 이름 변경 후 실제 값을 입력하세요.

```bash
cp .env.example .env
```

```dotenv
DB_URL=jdbc:mysql://localhost:3306/project?...
DB_USERNAME=root
DB_PASSWORD=your_db_password_here
GROQ_API_KEY=gsk_your_api_key_here
```

spring-dotenv 라이브러리가 앱 기동 시 `.env` 파일을 자동으로 읽어 `application.properties`의 `${ENV_VAR}` 자리에 주입합니다.

> `.env` 파일은 `.gitignore`에 등록되어 있으므로 Git에 올라가지 않습니다.

### 토스 키 설정

**방법 ① — `application.properties` 직접 입력 (현재 적용 중)**

```properties
toss.client-key=test_ck_docs_Ovk5rk1EwkEbP0W43n07xlzm
toss.secret-key=test_sk_docs_OaPz8L5KdmQXkzRz3y47BMw6
```

위 값은 TossPayments 공식 공용 테스트 키입니다 — 별도 발급 없이 개발·테스트 환경에서 그대로 사용 가능합니다.

**방법 ② — 환경변수 / .env 주입 (프로덕션 배포 시)**

`application.properties`를 아래 형식으로 교체하고 `.env` 또는 서버 환경변수에 실제 발급 키를 입력합니다.

```properties
toss.client-key=${TOSS_CLIENT_KEY:test_ck_docs_Ovk5rk1EwkEbP0W43n07xlzm}
toss.secret-key=${TOSS_SECRET_KEY:test_sk_docs_OaPz8L5KdmQXkzRz3y47BMw6}
```

### 3. 스키마 생성 (신규 환경)

`sql/init_schema.sql` 하나로 모든 테이블을 생성할 수 있습니다.  
이미 존재하는 테이블은 자동으로 건너뜁니다(`IF NOT EXISTS`).

MySQL Workbench에서 실행:

```sql
source /절대경로/sql/init_schema.sql;
```

### 4. 테스트 계정 생성 (선택)

```sql
INSERT INTO member (m_id, m_pw, m_name, m_phone, m_email)
VALUES ('test', '1234', '홍길동', '010-1234-5678', 'test@rown.com');
```

### 5. 서버 실행

```bash
# IntelliJ: CafeApplication.java 실행
# 또는 터미널:
mvn spring-boot:run
```

접속: `http://localhost:8080/`

### 자주 발생하는 500 오류 원인

| 증상 | 원인 | 해결 |
|------|------|------|
| 앱 기동 실패 | `.env` 파일 없음 또는 DB 정보 미입력 | `.env.example` 복사 후 값 입력, 또는 `application.properties` 직접 입력 |
| 로그인 시 500 | `member` 테이블 없음 | `init_schema.sql` 실행 |
| 로그인 시 500 | DB 접속 정보 불일치 | `application.properties`의 `username` / `password` 확인 |
| 홈 화면 500 | `board_t` 테이블 없음 | `init_schema.sql` 실행 |
| 멤버십 500 | `membership_t` FK 오류 | `fix_membership_fk.sql` 실행 |
| 챗봇 500 | `chat_log_t.m_idx` 타입 오류 | `alter_chat_log_t_midx.sql` 실행 |
| 챗봇 응답 없음 | Groq API 키 미설정 | `application.properties`의 `groq.api.key` 확인 |
| 결제창 오류: 잘못된 successUrl | successUrl 이 상대경로로 전달됨 | `order.js`에서 `window.location.origin` 으로 절대 URL 조립 — 현재 수정 완료 |

---

## DB 변경 이력

| 날짜 | 테이블 | 변경 내용 |
|------|--------|-----------|
| 2026-04-21 | `chat_log_t` | `m_idx` INT → VARCHAR(50) NULL — 로그인 ID(문자열) 저장 대응 |
| 2026-04-21 | `membership_t` | `user_id` INT → VARCHAR(50), FK 대상 `member_t.m_idx` → `member.m_id` 변경, COLLATE utf8mb4_0900_ai_ci |
| 2026-04-22 | `board_t` | `content` TEXT → MEDIUMTEXT — 이미지 URL 포함 장문 게시글 대비 |
| 2026-04-22 | `order_t` | 신규 생성 — 토스페이먼츠 주문 헤더 |
| 2026-04-22 | `order_item_t` | 신규 생성 — 주문 상세 항목 |
| 2026-04-24 | (통합) | `sql/migrate_all_2026_04_24.sql` 실행 — 로컬 DB에 [1]~[7] 변경(chat_log_t.m_idx, membership_t.user_id/FK, board_t.content, menu_t.ice_extra_price, order_t, order_item_t)을 일괄 반영. 기존 `membership_t` 1행은 스크립트 상단 주석에 백업 후 TRUNCATE 진행 |
| 2026-04-24 | `menu_t` | image_url: 주요 메뉴 11개 외부 URL → 로컬 영문 파일 경로로 교체 (이미지 파일 한글→영문 rename 동반) |
| 2026-04-24 | `sql/` 폴더 | ALTER 파일 6개를 `init_schema.sql` 에 통합 후 삭제 (10개→3개, `diagnose_membership.sql` 은 `sql/archive/` 로) |
| 2026-04-24 | `menu_t`, `order_item_t` | `sql/alter_menu_size_upcharge.sql` — 사이즈 추가금 컬럼(`size_upcharge_grande`, `size_upcharge_venti`) 추가, `order_item_t.size` 컬럼 추가. 스타벅스 기준 Grande +500 / Venti +1,000, ESPRESSO/DESSERT 는 0 |
| 2026-04-24 | `order_t` | `sql/alter_order_cancel.sql` — 취소/환불 컬럼 5개 추가 (`cancel_reason`, `cancel_memo`, `cancel_date`, `refund_amount`, `refund_rate`). 시간 기반 3단계 환불 정책 지원 |
| 2026-04-24 | `cart_t` (신규) + `init_schema.sql` 통합 | 장바구니 테이블 신설 (`cart_idx`/`m_id`/`menu_name`/`temperature`/`size`/`quantity`/`unit_price`/`reg_date` + FK→member) + `init_schema.sql` 을 "최종 완성본" 으로 업그레이드 — 기존 alter 3종 내용(menu_t size 추가금 2컬럼, order_t cancel 5컬럼, order_item_t size 1컬럼)을 본문에 통합. 신규 환경은 `init_schema.sql` 한 번만 실행하면 완성. **기존 alter_*.sql / migrate_all_*.sql / update_menu_images_*.sql 은 이력 보존 목적으로 유지 (재실행 불필요)** |
| 2026-04-27 | `menu_t` | image_url 경로 단축 (`/resources/images/` → `/images/`) — 정적 자원 classpath 이전(`webapp/resources` → `resources/static`) 동반 |
| 2026-04-27 | 업로드 디렉토리 외부화 | `BoardController` 가 `getServletContext().getRealPath()` 대신 `app.upload.dir` (기본 `./uploads`, Docker 는 `/app/uploads`) 사용. URL 패턴(`/resources/upload/...`) 은 보존하여 기존 게시글 호환성 유지. `docker-compose.yml` 에 `./uploads:/app/uploads` 볼륨 마운트 추가. |

---

## 개발 시 주의사항

- **로그인은 `member` 테이블** — `member_t`는 구 테이블이므로 신규 코드에서 참조 금지
- **세션 키**: `m_id` (아이디 String), `m_name` (이름) — `member_t`의 `m_idx` (INT)와 혼동 주의
- **membership_t FK 추가 시** COLLATE는 반드시 `utf8mb4_0900_ai_ci` — `member.m_id`와 일치해야 FK 생성 가능
- **챗봇 시스템 프롬프트** (`SYSTEM_PROMPT_BASE`) 수정 시 1,000 토큰 이하 유지
- **민감 정보 관리** — 개발 환경은 `application.properties` 직접 입력, 배포 환경은 `.env` 또는 서버 환경변수 사용

### 🚀 운영 전환 체크리스트 (배포 시 반드시 확인)

- ✅ **환불 정책 상수 운영값 적용 완료 (3분/10분)** — `OrderServiceImpl.java` 의 `FULL_REFUND_WINDOW_SEC=180`, `HALF_REFUND_WINDOW_SEC=600` (2026-04-24 적용)

### 🔎 주문 취소 환불률 디버깅 — DB ↔ UI 교차 검증 SQL

UI 에 표시되는 환불률(100%/50%/불가)이 의심될 때 HeidiSQL 에서 실행해 DB 상태와 교차 검증:

```sql
SELECT order_id, m_id, total_amount, paid_date,
       TIMESTAMPDIFF(SECOND, paid_date, NOW()) AS db_elapsed_sec,
       status, refund_rate, refund_amount
  FROM order_t
 WHERE status = 'PAID'
 ORDER BY paid_date DESC
 LIMIT 5;
```

판정 기준 (개발 상수 기준 — 운영은 180/600):
- `db_elapsed_sec <= 10`  → UI 에 **100%** 표시되어야 정상
- `10 < db_elapsed_sec <= 30` → UI 에 **50%** 표시되어야 정상
- `db_elapsed_sec > 30`  → UI 에 **"취소 가능 시간이 지났습니다"** 표시되어야 정상

UI 와 DB 경과 초 판정이 어긋나면:
1. IntelliJ 콘솔에서 `Cancel check -` 키워드 로그 확인 — `elapsedSec`, `FULL<=`, `HALF<=` 숫자로 실제 계산 경로 추적 가능
2. `Cancel check [detail]` 키워드만 grep 하면 상세 모달 렌더 호출만 필터되어, `/order/cancel` 경로와 `/order/detail` 경로에서 계산된 `elapsedSec` 값을 서로 비교 가능
3. `NEGATIVE_CLOCK_SKEW` 로그가 있으면 서버/DB 시계 불일치
4. 브라우저 네트워크 탭에서 `/order/detail/{orderId}` 응답의 `cancelable`/`currentRefundRate` 값 확인 — UI 렌더 원본
5. **UI 표시와 소스코드가 어긋나는 경우** — Tomcat 이 과거 `.class` 를 메모리에 적재 중일 수 있음. IntelliJ `Build > Rebuild Project` 후 서버 완전 재시작, 브라우저는 `Ctrl+Shift+R` (Windows/Linux) / `Cmd+Shift+R` (Mac) 로 강제 새로고침

### 🧹 테스트 중 누적된 만료 PAID 주문 청소 SQL (선택)

개발 중 `elapsedSec > 30초` 상태로 남아 취소도 안 되고 계속 쌓이는 주문을 정리하려면 아래 SQL 을 주석 해제 후 실행. **프로덕션 금지** — 테스트 DB 전용.

```sql
-- 대상 확인 (삭제 전 반드시 SELECT 먼저)
-- SELECT order_id, m_id, paid_date,
--        TIMESTAMPDIFF(MINUTE, paid_date, NOW()) AS elapsed_min,
--        status, total_amount
--   FROM order_t
--  WHERE status = 'PAID'
--    AND TIMESTAMPDIFF(MINUTE, paid_date, NOW()) > 10
--  ORDER BY paid_date;

-- 실제 삭제 (주석 해제 후 실행, 외래키 CASCADE 로 order_item_t 동시 정리됨)
-- DELETE FROM order_item_t WHERE order_id IN (
--   SELECT order_id FROM (
--     SELECT order_id FROM order_t
--      WHERE status = 'PAID'
--        AND TIMESTAMPDIFF(MINUTE, paid_date, NOW()) > 10
--   ) x
-- );
-- DELETE FROM order_t
--  WHERE status = 'PAID'
--    AND TIMESTAMPDIFF(MINUTE, paid_date, NOW()) > 10;
```

> ⚠️ 이는 "취소 처리" 가 아닌 **DB 행 삭제** 입니다. 실제 토스 결제는 그대로 남으므로 테스트 키 환경에서만 사용하세요.

### 🛒 기존 운영 DB 에 장바구니 기능 적용 (2026-04-24)

이미 운영 중인 DB 에 장바구니 기능만 추가하려면 아래 한 블록만 HeidiSQL 에서 실행:

```sql
USE project;

CREATE TABLE IF NOT EXISTS cart_t (
    cart_idx    INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    m_id        VARCHAR(50)  NOT NULL COLLATE utf8mb4_0900_ai_ci COMMENT '회원 ID',
    menu_name   VARCHAR(100) NOT NULL COMMENT '메뉴명',
    temperature VARCHAR(10)  NOT NULL DEFAULT 'NONE' COMMENT 'HOT/ICE/NONE',
    size        VARCHAR(10)  NOT NULL DEFAULT 'TALL' COMMENT 'TALL/GRANDE/VENTI/NONE',
    quantity    INT          NOT NULL DEFAULT 1,
    unit_price  INT          NOT NULL COMMENT '옵션 반영된 잔당 가격 (서버 재계산값)',
    reg_date    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_cart_m_id (m_id),
    CONSTRAINT fk_cart_member
        FOREIGN KEY (m_id) REFERENCES member(m_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- 검증: 테이블 생성 확인
SELECT TABLE_NAME, ENGINE, TABLE_COLLATION, TABLE_COMMENT
  FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_SCHEMA = 'project' AND TABLE_NAME = 'cart_t';
```

> ⚠️ **`init_schema.sql` 전체를 다시 실행하지 마세요** — 기존 주문/회원 데이터가 보존되어야 하므로 위 `CREATE TABLE IF NOT EXISTS cart_t` 블록만 실행하면 됩니다. 신규 환경 구축 시에만 `init_schema.sql` 전체 실행.

---

## 개발 환경

- **IDE**: IntelliJ IDEA
- **Java**: JDK 21
- **DB**: MySQL 8.x
- **Server**: Spring Boot 내장 Tomcat
