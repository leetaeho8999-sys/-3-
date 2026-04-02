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

## 프로젝트 구조 (기존 프로젝트와 동일)

```
brew-crm/
├── pom.xml
├── schema.sql                          ← DB 테이블 생성
└── src/main/
    ├── java/org/study/brewcrm/
    │   ├── BrewCrmApplication.java      ← Main 클래스
    │   ├── ServletInitializer.java      ← WAR 배포용
    │   ├── customer/
    │   │   ├── controller/CustomerController.java  ← BBSController와 동일 패턴
    │   │   ├── service/CustomerService.java         ← BBSService (인터페이스)
    │   │   ├── service/CustomerServiceImpl.java     ← BBSServiceImpl
    │   │   ├── mapper/CustomerMapper.java            ← BBSMapper (인터페이스)
    │   │   └── vo/CustomerVO.java                   ← BBSVO와 동일 패턴
    │   ├── common/Paging.java           ← 기존 Paging.java와 동일
    │   └── config/BCryptConfig.java     ← 기존 BCryptConfig.java와 동일
    ├── resources/
    │   ├── application.properties
    │   └── mapper/CustomerMapper.xml    ← BBSMapper.xml과 동일 패턴
    └── webapp/
        ├── WEB-INF/views/customer/
        │   ├── header.jsp / footer.jsp  ← 공통 레이아웃
        │   ├── dashboard.jsp            ← 대시보드
        │   ├── list.jsp                 ← 고객 목록 + 페이징
        │   ├── register.jsp             ← 고객 등록
        │   ├── detail.jsp               ← 고객 상세
        │   ├── edit.jsp                 ← 고객 수정
        │   └── error.jsp                ← 에러 화면
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
