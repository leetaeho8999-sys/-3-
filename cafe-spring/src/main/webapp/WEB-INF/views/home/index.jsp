<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="로운 — Our Own Way to Bloom"/>
<%@ include file="../common/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">


<main>

<!-- ① HERO -->
<section class="rn-hero hero-section">
  <div class="rn-hero__bg" id="heroBg"></div>
  <div class="rn-hero__overlay"></div>
  <div class="rn-hero__inner">
    <div class="rn-hero__eyebrow">Rowoon Cafe &nbsp;·&nbsp; Since 2025</div>
    <h1 class="rn-hero__title">로<em>운</em></h1>
    <p class="rn-hero__subtitle-ko">우리만의 방식으로 꽃을 피우다</p>
    <p class="rn-hero__subtitle-en">Our Own Way to Bloom</p>
    <div>
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-hero__cta">View Menu</a>
      <a href="${pageContext.request.contextPath}/about" class="rn-hero__cta-ghost">Our Story</a>
    </div>
  </div>
  <div class="rn-hero__scroll">▼<span>Scroll</span></div>
</section>

<!-- ② BRAND MARQUEE -->
<div class="rn-strip">
  <div class="rn-strip__inner" id="marqueeInner">
    <span class="rn-strip__item">Premium Coffee</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">로운카페</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">Crafted Experiences</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">정성을 다한 커피</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">Single Origin Roast</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">한 잔의 진심</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">Seasonal Menu</span><span class="rn-strip__dot">✦</span>
    <!-- 마퀴 반복용 -->
    <span class="rn-strip__item">Premium Coffee</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">로운카페</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">Crafted Experiences</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">정성을 다한 커피</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">Single Origin Roast</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">한 잔의 진심</span><span class="rn-strip__dot">✦</span>
    <span class="rn-strip__item">Seasonal Menu</span><span class="rn-strip__dot">✦</span>
  </div>
</div>

<!-- ③ STORY -->
<section class="rn-story">
  <div class="rn-story__inner">
    <div class="rn-story__img-wrap">
      <img class="rn-story__img"
        src="${pageContext.request.contextPath}/resources/images/바리스타-드립.jpg"
        alt="로운 카페 내부" loading="lazy">
      <div class="rn-story__badge">SINCE<br>2025<br>ROWOON</div>
    </div>
    <div>
      <p class="rn-story__eyebrow">Our Story</p>
      <h2 class="rn-story__title">커피 한 잔에<br>담긴 <em>로운</em>의 정성</h2>
      <p class="rn-story__desc">
        로운은 '두리의 앞시내로'라는 뜻을 담고 있습니다.<br>
        세계 각지에서 엄선한 원두를 직접 로스팅하고,
        숙련된 바리스타가 한 잔 한 잔 정성껏 추출합니다.<br>
        우리만의 방식으로 피어나는 특별한 경험을 드립니다.
      </p>
      <div class="rn-story__features">
        <div class="rn-story__feat">
          <span class="rn-story__feat-icon">☕</span>
          <div>
            <div class="rn-story__feat-title">프리미엄 원두</div>
            <div class="rn-story__feat-text">에티오피아·콜롬비아·파나마 등 최상급 싱글 오리진</div>
          </div>
        </div>
        <div class="rn-story__feat">
          <span class="rn-story__feat-icon">🏅</span>
          <div>
            <div class="rn-story__feat-title">전문 바리스타</div>
            <div class="rn-story__feat-text">국내외 대회 수상 경력의 숙련된 바리스타</div>
          </div>
        </div>
        <div class="rn-story__feat">
          <span class="rn-story__feat-icon">🌿</span>
          <div>
            <div class="rn-story__feat-title">매일 신선 로스팅</div>
            <div class="rn-story__feat-text">당일 로스팅한 원두만을 사용해 최상의 풍미 보장</div>
          </div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/about" class="rn-btn-dark">더 알아보기 →</a>
    </div>
  </div>
</section>

<!-- ④ COLLECTION GRID -->
<section class="rn-collection">
  <div style="max-width:1200px;margin:0 auto">
    <div class="rn-section-header">
      <p class="rn-section-eyebrow">ROWNCafe Collection</p>
      <h2 class="rn-section-title">로운의 공간과 경험</h2>
      <p class="rn-collection__sub">Explore · Taste · Connect</p>
    </div>
    <div class="rn-grid">
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-card rn-card--wide">
        <img class="rn-card__img"
          src="${pageContext.request.contextPath}/resources/images/에스프레소.jpg"
          alt="커피 메뉴" loading="lazy">
        <div class="rn-card__overlay"></div>
        <div class="rn-card__body">
          <span class="rn-card__tag">Menu</span>
          <div class="rn-card__title">시그니처 커피 컬렉션</div>
          <div class="rn-card__sub">Crafted Coffee Experiences</div>
        </div>
        <div class="rn-card__arrow">→</div>
      </a>
      <a href="${pageContext.request.contextPath}/about" class="rn-card">
        <img class="rn-card__img"
          src="${pageContext.request.contextPath}/resources/images/카페-내부.jpg"
          alt="카페 공간" loading="lazy">
        <div class="rn-card__overlay"></div>
        <div class="rn-card__body">
          <span class="rn-card__tag">Space</span>
          <div class="rn-card__title">따뜻한 공간,<br>로운의 이야기</div>
          <div class="rn-card__sub">Our Story</div>
        </div>
        <div class="rn-card__arrow">→</div>
      </a>
      <a href="${pageContext.request.contextPath}/membership/list" class="rn-card">
        <img class="rn-card__img"
          src="${pageContext.request.contextPath}/resources/images/바리스타-팀.jpg"
          alt="멤버십" loading="lazy">
        <div class="rn-card__overlay"></div>
        <div class="rn-card__body">
          <span class="rn-card__tag">Membership</span>
          <div class="rn-card__title">멤버십 혜택</div>
          <div class="rn-card__sub">일반 · 실버 · 골드 · VIP</div>
        </div>
        <div class="rn-card__arrow">→</div>
      </a>
      <a href="${pageContext.request.contextPath}/board/list" class="rn-card">
        <img class="rn-card__img"
          src="${pageContext.request.contextPath}/resources/images/원두-산지.jpg"
          alt="커뮤니티" loading="lazy">
        <div class="rn-card__overlay"></div>
        <div class="rn-card__body">
          <span class="rn-card__tag">Community</span>
          <div class="rn-card__title">로운 커뮤니티</div>
          <div class="rn-card__sub">Journal · Stories</div>
        </div>
        <div class="rn-card__arrow">→</div>
      </a>
      <a href="${pageContext.request.contextPath}/chat" class="rn-card">
        <img class="rn-card__img"
          src="${pageContext.request.contextPath}/resources/images/라떼-백조.jpg"
          alt="AI 상담" loading="lazy">
        <div class="rn-card__overlay"></div>
        <div class="rn-card__body">
          <span class="rn-card__tag">AI</span>
          <div class="rn-card__title">아메리 AI 상담</div>
          <div class="rn-card__sub">24시간 상담 가능</div>
        </div>
        <div class="rn-card__arrow">→</div>
      </a>
    </div>
  </div>
</section>

<!-- ⑤ MENU SHOWCASE -->
<section class="rn-menu">
  <div class="rn-menu__inner">
    <div class="rn-section-header">
      <p class="rn-section-eyebrow">Signature Menu</p>
      <h2 class="rn-section-title">오늘의 추천 메뉴</h2>
    </div>
    <div class="rn-menu-grid">
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-menu-card">
        <div class="rn-menu-card__img-wrap">
          <img class="rn-menu-card__img"
            src="${pageContext.request.contextPath}/resources/images/아메리카노.jpg"
            alt="아메리카노" loading="lazy">
        </div>
        <div class="rn-menu-card__body">
          <div class="rn-menu-card__cat">Coffee</div>
          <div class="rn-menu-card__name">아메리카노</div>
          <div class="rn-menu-card__desc">깊고 부드러운 에스프레소 베이스</div>
          <div class="rn-menu-card__footer">
            <span class="rn-menu-card__price">₩4,200</span>
            <span class="rn-menu-card__badge">HOT/ICE</span>
          </div>
        </div>
      </a>
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-menu-card">
        <div class="rn-menu-card__img-wrap">
          <img class="rn-menu-card__img"
            src="${pageContext.request.contextPath}/resources/images/카페라떼.jpg"
            alt="카페라떼" loading="lazy">
        </div>
        <div class="rn-menu-card__body">
          <div class="rn-menu-card__cat">Coffee</div>
          <div class="rn-menu-card__name">카페라떼</div>
          <div class="rn-menu-card__desc">스팀 밀크와 에스프레소의 조화</div>
          <div class="rn-menu-card__footer">
            <span class="rn-menu-card__price">₩4,700</span>
            <span class="rn-menu-card__badge">HOT/ICE</span>
          </div>
        </div>
      </a>
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-menu-card">
        <div class="rn-menu-card__img-wrap">
          <img class="rn-menu-card__img"
            src="https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&h=400&fit=crop&auto=format"
            alt="녹차라떼" loading="lazy">
        </div>
        <div class="rn-menu-card__body">
          <div class="rn-menu-card__cat">Non-Coffee</div>
          <div class="rn-menu-card__name">녹차라떼</div>
          <div class="rn-menu-card__desc">우지 말차와 스팀 밀크의 조화</div>
          <div class="rn-menu-card__footer">
            <span class="rn-menu-card__price">₩5,400</span>
            <span class="rn-menu-card__badge">HOT/ICE</span>
          </div>
        </div>
      </a>
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-menu-card">
        <div class="rn-menu-card__img-wrap">
          <img class="rn-menu-card__img"
            src="${pageContext.request.contextPath}/resources/images/콜드브루.jpg"
            alt="콜드브루" loading="lazy">
        </div>
        <div class="rn-menu-card__body">
          <div class="rn-menu-card__cat">Coffee</div>
          <div class="rn-menu-card__name">콜드브루</div>
          <div class="rn-menu-card__desc">12시간 냉침 추출, 깊은 단맛</div>
          <div class="rn-menu-card__footer">
            <span class="rn-menu-card__price">₩4,450</span>
            <span class="rn-menu-card__badge">ICE</span>
          </div>
        </div>
      </a>
    </div>
    <div class="rn-menu__more">
      <a href="${pageContext.request.contextPath}/menu/list" class="rn-btn-outline">전체 메뉴 보기 →</a>
    </div>
  </div>
</section>

<!-- ⑥ MEMBERSHIP CTA -->
<section class="rn-membership">
  <div class="rn-membership__deco"></div>
  <div class="rn-membership__inner">
    <p class="rn-membership__eyebrow">Rowoon Membership</p>
    <h2 class="rn-membership__title">로운과 함께하는<br><em>특별한 혜택</em></h2>
    <p class="rn-membership__desc">방문할수록 쌓이는 포인트, 등급별 맞춤 혜택.<br>로운 멤버가 되어 더 풍요로운 커피 라이프를 즐기세요.</p>
    <div class="rn-membership__grades">
      <div class="rn-grade">
        <span class="rn-grade__icon">☕</span>
        <span class="rn-grade__name">일반</span>
        <span class="rn-grade__pt">1~5회</span>
      </div>
      <div class="rn-grade">
        <span class="rn-grade__icon">🥈</span>
        <span class="rn-grade__name">실버</span>
        <span class="rn-grade__pt">6~15회</span>
      </div>
      <div class="rn-grade">
        <span class="rn-grade__icon">🥇</span>
        <span class="rn-grade__name">골드</span>
        <span class="rn-grade__pt">16~30회</span>
      </div>
      <div class="rn-grade">
        <span class="rn-grade__icon">👑</span>
        <span class="rn-grade__name">VIP</span>
        <span class="rn-grade__pt">31회+</span>
      </div>
    </div>
    <c:choose>
      <c:when test="${empty sessionScope.m_id}">
        <a href="${pageContext.request.contextPath}/member/register" class="rn-btn-gold">멤버십 가입하기 →</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/membership/list" class="rn-btn-gold">내 멤버십 확인하기 →</a>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<!-- ⑦ BOARD -->
<c:if test="${not empty popularList or not empty recentList}">
<section class="rn-board">
  <div class="rn-board__inner">
    <div class="rn-section-header" style="text-align:left;margin-bottom:0">
      <p class="rn-section-eyebrow">Community</p>
      <h2 class="rn-section-title rn-board__title" style="font-size:1.5rem;color:#2A1A0E">로운 커뮤니티</h2>
    </div>
    <div class="rn-board__grid">
      <div>
        <div class="rn-board__head">
          <span class="rn-board__head-title">📈 인기 게시글</span>
          <a href="${pageContext.request.contextPath}/board/list" class="rn-board__more">전체보기 →</a>
        </div>
        <c:forEach var="p" items="${popularList}" varStatus="s">
          <div class="rn-post">
            <span class="rn-post__num">0${s.index+1}</span>
            <div class="rn-post__body">
              <a href="${pageContext.request.contextPath}/board/detail?b_idx=${p.b_idx}" class="rn-post__title">${p.title}</a>
              <div class="rn-post__meta">
                <span class="rn-post__cat">${p.category}</span>
                <span>${p.author}</span>
                <span>👁 ${p.views}</span>
                <span>💬 ${p.comments}</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
      <div>
        <div class="rn-board__head">
          <span class="rn-board__head-title">💬 최근 게시글</span>
          <a href="${pageContext.request.contextPath}/board/list" class="rn-board__more">전체보기 →</a>
        </div>
        <c:forEach var="p" items="${recentList}" varStatus="s">
          <div class="rn-post">
            <span class="rn-post__num">0${s.index+1}</span>
            <div class="rn-post__body">
              <a href="${pageContext.request.contextPath}/board/detail?b_idx=${p.b_idx}" class="rn-post__title">${p.title}</a>
              <div class="rn-post__meta">
                <span class="rn-post__cat">${p.category}</span>
                <span>${p.author}</span>
                <span>${p.regDate}</span>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
</section>
</c:if>

</main>

<!-- ⑧ CUSTOM FOOTER -->
<footer class="rn-footer">
  <div class="rn-footer__inner">
    <div class="rn-footer__top">
      <div>
        <div class="rn-footer__brand-name">로<em>운</em></div>
        <div class="rn-footer__brand-sub">Rowoon Cafe · Since 2025</div>
        <div class="rn-footer__brand-desc">
          두리의 앞시내로, 로운.<br>
          한 잔의 커피에 담긴 진심과 정성으로<br>
          우리만의 방식으로 피어납니다.
        </div>
        <div class="rn-footer__social">
          <a href="https://www.instagram.com/" target="_blank" rel="noopener noreferrer"
             class="rn-footer__social-btn" data-p="instagram" aria-label="인스타그램">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor">
              <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
            </svg>
          </a>
          <a href="https://www.facebook.com/" target="_blank" rel="noopener noreferrer"
             class="rn-footer__social-btn" data-p="facebook" aria-label="페이스북">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
            </svg>
          </a>
          <a href="https://www.youtube.com/" target="_blank" rel="noopener noreferrer"
             class="rn-footer__social-btn" data-p="youtube" aria-label="유튜브">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor">
              <path d="M23.495 6.205a3.007 3.007 0 0 0-2.088-2.088c-1.87-.501-9.396-.501-9.396-.501s-7.507-.01-9.396.501A3.007 3.007 0 0 0 .527 6.205a31.247 31.247 0 0 0-.522 5.805 31.247 31.247 0 0 0 .522 5.783 3.007 3.007 0 0 0 2.088 2.088c1.868.502 9.396.502 9.396.502s7.506 0 9.396-.502a3.007 3.007 0 0 0 2.088-2.088 31.247 31.247 0 0 0 .5-5.783 31.247 31.247 0 0 0-.5-5.805zM9.609 15.601V8.408l6.264 3.602z"/>
            </svg>
          </a>
        </div>
      </div>
      <div>
        <div class="rn-footer__col-title">Explore</div>
        <div class="rn-footer__links">
          <a href="${pageContext.request.contextPath}/about">Our Story</a>
          <a href="${pageContext.request.contextPath}/menu/list">Menu</a>
          <a href="${pageContext.request.contextPath}/membership/list">Membership</a>
          <a href="${pageContext.request.contextPath}/chat">AI 상담</a>
        </div>
      </div>
      <div>
        <div class="rn-footer__col-title">Community</div>
        <div class="rn-footer__links">
          <a href="${pageContext.request.contextPath}/board/list">게시판</a>
          <a href="${pageContext.request.contextPath}/faq">FAQ</a>
          <a href="${pageContext.request.contextPath}/contact">문의하기</a>
        </div>
      </div>
      <div>
        <div class="rn-footer__col-title">Account</div>
        <div class="rn-footer__links">
          <c:choose>
            <c:when test="${not empty sessionScope.m_id}">
              <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
              <a href="${pageContext.request.contextPath}/member/logout">로그아웃</a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/member/login">로그인</a>
              <a href="${pageContext.request.contextPath}/member/register">회원가입</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
    <div class="rn-footer__bottom">
      <span>© 2025 Rowoon Cafe. All rights reserved.</span>
      <div class="rn-footer__bottom-links">
        <a href="${pageContext.request.contextPath}/privacy-policy">개인정보처리방침</a>
        <a href="${pageContext.request.contextPath}/terms-of-service">이용약관</a>
      </div>
    </div>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/resources/js/home.js"></script>

<%@ include file="../common/footer.jsp" %>
