<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="소개 — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <section class="about-section">
    <div class="container">
      <div class="section-header"><h2>우리의 이야기</h2><p>로운은 최상의 원두와 완벽한 추출로 여러분께 특별한 커피 경험을 선사합니다</p></div>
      <div class="about-story">
        <div class="about-text">
          <h3>진심을 담은 한 잔</h3>
          <p>우리는 커피 한 잔을 만드는 모든 과정에 정성을 담습니다. 엄선된 원두의 선택부터 완벽한 로스팅, 그리고 정교한 추출까지, 모든 단계가 여러분을 위한 특별한 순간이 됩니다.</p>
          <p>우리의 바리스타들은 커피에 대한 열정과 전문성으로 매일 최고의 커피를 만들어냅니다. 각각의 커피는 고유한 이야기와 풍미를 가지고 있습니다.</p>
        </div>
        <div class="about-img"><img src="https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800&h=600&fit=crop" alt="Barista"></div>
      </div>
      <div class="feature-grid">
        <div class="feature-card"><div class="feature-icon">☕</div><h4>프리미엄 원두</h4><p>세계 각지에서 엄선한 최상급 원두만을 사용합니다</p></div>
        <div class="feature-card"><div class="feature-icon">❤</div><h4>정성스런 서비스</h4><p>고객 한 분 한 분께 진심을 담아 서비스합니다</p></div>
        <div class="feature-card"><div class="feature-icon">🏆</div><h4>전문 바리스타</h4><p>풍부한 경험과 전문성을 갖춘 바리스타가 제조합니다</p></div>
      </div>
    </div>
  </section>
</main>
<%@ include file="../common/footer.jsp" %>
