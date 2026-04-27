<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="오시는 길 — 로운"/>
<%@ include file="../common/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/contact.css">

<main>

<!-- 히어로 배너 -->
<section class="ct-hero">
  <div class="ct-hero__overlay"></div>
  <div class="ct-hero__inner">
    <p class="ct-hero__eyebrow">Find Us</p>
    <h1 class="ct-hero__title">오시는 길</h1>
    <p class="ct-hero__sub">서울특별시 마포구 백범로 23, 3층</p>
  </div>
</section>

<!-- 정보 + 지도 -->
<section class="ct-section">
  <div class="ct-inner">

    <!-- 왼쪽: 상세 정보 -->
    <div class="ct-info">

      <div class="ct-item">
        <div class="ct-item__icon">📍</div>
        <div>
          <div class="ct-item__label">주소</div>
          <p>서울특별시 마포구 백범로 23, 3층<br>
             <span class="ct-item__sub">(신수동, 케이터틀)</span></p>
        </div>
      </div>

      <div class="ct-item">
        <div class="ct-item__icon">🚇</div>
        <div>
          <div class="ct-item__label">대중교통</div>
          <p>지하철 5·6호선 공덕역 8번 출구 도보 5분<br>
             버스: 마포구청 정류장 하차 후 도보 3분</p>
        </div>
      </div>

      <div class="ct-item">
        <div class="ct-item__icon">🕐</div>
        <div>
          <div class="ct-item__label">운영시간</div>
          <p>24시간 / 365일 연중무휴<br>
             <span class="ct-item__staff">직원 상주: 매일 09:00 – 22:00</span></p>
        </div>
      </div>

      <div class="ct-item">
        <div class="ct-item__icon">📞</div>
        <div>
          <div class="ct-item__label">전화</div>
          <p>02-1234-5678</p>
        </div>
      </div>

      <div class="ct-item">
        <div class="ct-item__icon">✉</div>
        <div>
          <div class="ct-item__label">이메일</div>
          <p>contact@rowncafe.com</p>
        </div>
      </div>

    </div>

    <!-- 오른쪽: 지도 -->
    <div class="ct-map">
      <iframe
        class="ct-map__iframe"
        src="https://maps.google.com/maps?q=서울특별시+마포구+백범로+23&output=embed&hl=ko&z=17"
        allowfullscreen="" loading="lazy"
        referrerpolicy="no-referrer-when-downgrade"
        title="로운카페 위치">
      </iframe>
      <a class="ct-map__link"
         href="https://map.kakao.com/link/search/서울특별시 마포구 백범로 23"
         target="_blank" rel="noopener noreferrer">
        카카오맵으로 보기 →
      </a>
    </div>

  </div>
</section>

</main>

<%@ include file="../common/footer.jsp" %>
