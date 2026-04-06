# ☕ 정성을 다한 커피 — Spring MVC 변환

React(TypeScript) + Tailwind → **Spring MVC + JSP + MyBatis + MySQL** 변환

## 스택
- Spring Boot 3.2.0 (WAR), Java 17, Spring MVC
- JSP + JSTL, 순수 CSS, 순수 JavaScript
- MyBatis, MySQL (dbstudy)
- Lombok, BCrypt

## React → JSP 변환 대응표
| React/TS | JSP/JS |
|---|---|
| `useState`, `useEffect` | JS 변수 + DOM 조작 |
| `Link to="/about"` | `<a href="${contextPath}/about">` |
| Tailwind 클래스 | 순수 CSS (style.css) |
| 컴포넌트 import | `<%@ include %>` |
| `{variable}` | `${variable}` (JSTL EL) |
| `.map()` | `<c:forEach>` |
| 조건부 렌더링 | `<c:if>`, `<c:choose>` |
| localStorage | MySQL DB (MyBatis) |
| AuthContext | HttpSession |

## 실행 방법
1. `schema.sql` 실행 (`USE dbstudy;` 후)
2. `application.properties` DB 정보 수정
3. IntelliJ → `pom.xml` 우클릭 → Add as Maven Project
4. `CafeApplication.java` 실행
5. `http://localhost:8080/cafe/` 접속

## 페이지 목록
| URL | 설명 |
|-----|------|
| `/cafe/` | 홈 (히어로 + 약속 + 인기/최근 게시글) |
| `/cafe/about` | 소개 |
| `/cafe/menu/list` | 메뉴 목록 (카테고리 필터) |
| `/cafe/menu/detail?m_idx=` | 메뉴 상세 (스토리, 원산지) |
| `/cafe/board/list` | 게시판 목록 |
| `/cafe/board/detail?b_idx=` | 게시글 상세 + 댓글 |
| `/cafe/board/write` | 글쓰기 |
| `/cafe/board/edit?b_idx=` | 글 수정 |
| `/cafe/contact` | 오시는 길 |
| `/cafe/faq` | FAQ 아코디언 |
| `/cafe/chat` | AI 상담 챗봇 |
| `/cafe/membership/list` | 멤버십 |
| `/cafe/member/login` | 로그인 |
| `/cafe/member/register` | 회원가입 |
| `/cafe/member/mypage` | 마이페이지 |
| `/cafe/privacy-policy` | 개인정보 처리방침 |
| `/cafe/terms-of-service` | 이용약관 |
