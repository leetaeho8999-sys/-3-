<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="로운 — 홈"/>
<%@ include file="../common/header.jsp" %>
<main>
  <!-- Hero -->
  <section class="hero-section">
    <div class="hero-overlay"></div>
    <img class="hero-bg" src="https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=1920&h=1080&fit=crop" alt="Coffee">
    <div class="hero-content">
      <h1 class="hero-title">로운</h1>
      <p class="hero-subtitle">한 잔의 커피에 담긴 진심과 정성</p>
      <a href="${pageContext.request.contextPath}/menu/list" class="btn-hero">메뉴 보기</a>
    </div>
  </section>
  <!-- 약속 -->
  <section class="promise-section">
    <div class="promise-overlay"></div>
    <img class="promise-bg" src="https://images.unsplash.com/photo-1544457070-4cd773b4d71e?w=1920&h=1080&fit=crop" alt="Cafe">
    <div class="promise-content">
      <h2 class="promise-title">우리의 약속</h2>
      <p class="promise-sub">최고의 원두와 정성스러운 추출로 완성되는 특별한 경험</p>
      <div class="promise-grid">
        <div class="promise-card"><div class="promise-icon">☕</div><div class="promise-name">프리미엄 원두</div><p class="promise-text">세계 각지에서 엄선한 최상급 원두만을 사용합니다</p></div>
        <div class="promise-card"><div class="promise-icon">👥</div><div class="promise-name">전문 바리스타</div><p class="promise-text">숙련된 바리스타가 정성껏 한 잔 한 잔 만듭니다</p></div>
        <div class="promise-card"><div class="promise-icon">🏆</div><div class="promise-name">품질 보증</div><p class="promise-text">매일 아침 신선하게 로스팅하여 최상의 맛을 보장합니다</p></div>
      </div>
      <a href="${pageContext.request.contextPath}/about" class="btn-white" style="margin-top:2rem;display:inline-block">더 알아보기</a>
    </div>
  </section>
  <!-- 게시글 -->
  <c:if test="${not empty popularList or not empty recentList}">
  <section class="home-board-section">
    <div class="container">
      <div class="home-board-grid">
        <div>
          <div class="home-board-title"><h2>📈 인기 게시글</h2><a href="${pageContext.request.contextPath}/board/list" style="font-size:.875rem;color:#c8832a">전체보기 →</a></div>
          <div class="home-board-list">
            <c:forEach var="p" items="${popularList}">
              <div class="home-board-card">
                <div style="display:flex;gap:.5rem;align-items:center;margin-bottom:.4rem">
                  <span class="c-badge cat-${p.category}">${p.category}</span>
                  <span style="font-size:.75rem;color:#9ca3af">${p.regDate}</span>
                </div>
                <a href="${pageContext.request.contextPath}/board/detail?b_idx=${p.b_idx}" style="font-weight:500">${p.title}</a>
                <div style="font-size:.8rem;color:#9ca3af;margin-top:.3rem">${p.author} · 👁${p.views} 💬${p.comments}</div>
              </div>
            </c:forEach>
          </div>
        </div>
        <div>
          <div class="home-board-title"><h2>💬 최근 게시글</h2><a href="${pageContext.request.contextPath}/board/list" style="font-size:.875rem;color:#c8832a">전체보기 →</a></div>
          <div class="home-board-list">
            <c:forEach var="p" items="${recentList}">
              <div class="home-board-card">
                <div style="display:flex;gap:.5rem;align-items:center;margin-bottom:.4rem">
                  <span class="c-badge cat-${p.category}">${p.category}</span>
                  <span style="font-size:.75rem;color:#9ca3af">${p.regDate}</span>
                </div>
                <a href="${pageContext.request.contextPath}/board/detail?b_idx=${p.b_idx}" style="font-weight:500">${p.title}</a>
                <div style="font-size:.8rem;color:#9ca3af;margin-top:.3rem">${p.author} · 👁${p.views} 💬${p.comments}</div>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </section>
  </c:if>
</main>
<%@ include file="../common/footer.jsp" %>
