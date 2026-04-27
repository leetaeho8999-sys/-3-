<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="소개 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">

<!-- ── 히어로 ── -->
<div class="ab-hero">
  <div class="ab-hero__bg"></div>
  <div class="ab-hero__overlay"></div>
  <div class="ab-hero__inner">
    <p class="ab-hero__eyebrow">Our Story</p>
    <h1 class="ab-hero__title">우리의 이야기</h1>
    <p class="ab-hero__sub">한 잔의 커피에 담긴 진심과 정성</p>
  </div>
</div>

<!-- ── 스토리 ── -->
<section class="ab-story">
  <div class="ab-story__grid">
    <div class="ab-story__img-wrap">
      <img class="ab-story__img"
           src="https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800&h=900&fit=crop&auto=format"
           alt="로운 카페 바리스타">
      <div class="ab-story__accent"></div>
    </div>
    <div>
      <p class="ab-story__eyebrow">Since 2020</p>
      <h2 class="ab-story__title">진심을 담은<br>한 잔의 커피</h2>
      <div class="ab-story__divider"></div>
      <p class="ab-story__text">
        우리는 커피 한 잔을 만드는 모든 과정에 정성을 담습니다. 엄선된 원두의 선택부터 완벽한 로스팅, 그리고 정교한 추출까지, 모든 단계가 여러분을 위한 특별한 순간이 됩니다.
      </p>
      <p class="ab-story__text">
        우리의 바리스타들은 커피에 대한 열정과 전문성으로 매일 최고의 커피를 만들어냅니다. 각각의 커피는 고유한 이야기와 풍미를 가지고 있으며, 한 잔에 담긴 온기가 여러분의 하루를 따뜻하게 채워드립니다.
      </p>
      <p class="ab-story__text">
        로운은 단순한 카페가 아닙니다. 사람과 커피가 만나는 특별한 공간, 일상 속 작은 쉼표가 되고자 합니다.
      </p>
    </div>
  </div>
</section>

<!-- ── 인용구 배너 ── -->
<div class="ab-banner">
  <div class="ab-banner__line"></div>
  <blockquote class="ab-banner__quote">
    "한 잔의 커피에는 원두를 재배한 농부의 손길, 로스터의 감각, 바리스타의 정성이 모두 담겨 있습니다."
  </blockquote>
  <div class="ab-banner__line"></div>
  <p class="ab-banner__author">로운 카페 철학</p>
</div>

<!-- ── 가치 ── -->
<section class="ab-values">
  <div class="ab-values__inner">
    <div class="ab-values__head">
      <p class="ab-values__eyebrow">Our Values</p>
      <h2 class="ab-values__title">로운이 추구하는 가치</h2>
    </div>
    <div class="ab-values__grid">
      <div class="ab-value-card">
        <div class="ab-value-icon">☕</div>
        <h4>프리미엄 원두</h4>
        <p>에티오피아, 콜롬비아, 브라질 등 세계 각지에서 엄선한 최상급 스페셜티 원두만을 사용합니다.</p>
      </div>
      <div class="ab-value-card">
        <div class="ab-value-icon">❤</div>
        <h4>정성스런 서비스</h4>
        <p>고객 한 분 한 분께 진심을 담아 서비스합니다. 당신의 하루를 특별하게 만드는 것이 저희의 기쁨입니다.</p>
      </div>
      <div class="ab-value-card">
        <div class="ab-value-icon">🏆</div>
        <h4>전문 바리스타</h4>
        <p>국내외 대회 수상 경력을 지닌 전문 바리스타들이 풍부한 경험과 열정으로 최고의 커피를 제조합니다.</p>
      </div>
    </div>
  </div>
</section>

<%@ include file="../common/footer.jsp" %>
