# ☕ BREW CRM — 커피전문점 고객관리 시스템

## 기술 스택
- **백엔드**: Spring Boot 3.2, Java 17
- **뷰**: JSP + JSTL (기존 프로젝트와 동일)
- **ORM**: MyBatis
- **DB**: MySQL
- **기타**: Lombok, BCrypt, Spring Security Crypto

---

## 실행 순서

### 1. DB 설정
```sql
-- MySQL에서 실행
source schema.sql
```

### 2. application.properties 수정
```properties
# 본인 DB 정보로 변경
spring.datasource.url=jdbc:mysql://localhost:3306/dbstudy?...
spring.datasource.username=dbuser
spring.datasource.password=1234
```

### 3. IntelliJ에서 실행
- `pom.xml` 우클릭 → **Add as Maven Project**
- Maven 탭 → 새로고침 (라이브러리 다운로드)
- `BrewCrmApplication.java` 실행

### 4. 브라우저 접속
```
http://localhost:8080/brew-crm/customer/dashboard
```

---

## 프로젝트 구조

```
brew-crm/
├── pom.xml
├── schema.sql                          ← DB 테이블 생성
└── src/main/
    ├── java/org/study/brewcrm/
    │   ├── BrewCrmApplication.java
    │   ├── ServletInitializer.java      ← WAR 배포용
    │   ├── config/
    │   │   ├── BCryptConfig.java        ← BCrypt 빈
    │   │   ├── WebMvcConfig.java        ← 인터셉터 등록
    │   │   ├── LoginInterceptor.java    ← 로그인/권한 체크
    │   │   └── BadgeAdvice.java         ← 미처리 신고 배지 카운트 (전역)
    │   ├── customer/
    │   │   ├── controller/CustomerController.java   ← 고객 CRUD + CSV 내보내기
    │   │   ├── controller/AdminController.java      ← 시스템 관리 (직원 권한)
    │   │   ├── controller/MarketingController.java  ← 마케팅 + 쿠폰
    │   │   ├── service/CustomerService(Impl).java
    │   │   ├── mapper/CustomerMapper.java
    │   │   └── vo/CustomerVO.java
    │   ├── board/
    │   │   ├── controller/BoardAdminController.java ← 게시판·신고 관리
    │   │   ├── mapper/BoardAdminMapper.java
    │   │   └── vo/BoardVO.java / BoardReportVO.java
    │   ├── member/
    │   │   ├── controller/MemberController.java     ← 로그인·마이페이지·비밀번호변경
    │   │   ├── service/MemberService(Impl).java
    │   │   ├── mapper/MemberMapper.java
    │   │   └── vo/MemberVO.java
    │   └── common/Paging.java
    ├── resources/
    │   ├── application.properties
    │   └── mapper/
    │       ├── CustomerMapper.xml
    │       ├── MemberMapper.xml
    │       └── BoardAdminMapper.xml
    └── webapp/
        ├── WEB-INF/views/customer/
        │   ├── header.jsp / footer.jsp  ← 공통 레이아웃 (사이드바 신고 배지 포함)
        │   ├── dashboard.jsp            ← 대시보드
        │   ├── list.jsp                 ← 고객 목록 + CSV 내보내기 버튼
        │   ├── register.jsp / edit.jsp / detail.jsp
        │   ├── stats.jsp                ← 통계 (Chart.js + datalabels)
        │   ├── marketing.jsp            ← 마케팅 + 쿠폰 발급
        │   ├── board.jsp                ← 게시판·신고·신고유저 관리
        │   ├── admin.jsp                ← 시스템 관리 (직원 권한)
        │   └── error.jsp
        ├── WEB-INF/views/member/
        │   ├── login.jsp / register.jsp
        │   └── mypage.jsp               ← 등급 카드 + 비밀번호 변경 + 내 정보 수정
        └── resources/
            ├── css/style.css            ← 글래스모피즘 디자인
            └── js/app.js
```

---

## 주요 URL

| URL | 설명 |
|-----|------|
| `/brew-crm/customer/dashboard` | 대시보드 (통계 + 최근 고객) |
| `/brew-crm/customer/list` | 고객 목록 (페이징, 검색) |
| `/brew-crm/customer/register` | 고객 등록 폼 |
| `/brew-crm/customer/registerOk` | 고객 등록 처리 (POST) |
| `/brew-crm/customer/detail?c_idx=` | 고객 상세 |
| `/brew-crm/customer/edit?c_idx=` | 고객 수정 폼 |
| `/brew-crm/customer/delete?c_idx=` | 고객 삭제 |
| `/brew-crm/customer/addVisit?c_idx=` | 방문 횟수 +1 |
