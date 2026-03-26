<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="오시는 길 — 정성을 다한 커피"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <section class="contact-section">
    <div class="container">
      <div class="section-header"><h2>오시는 길</h2><p>정성을 다한 커피에서 특별한 커피 한 잔의 여유를 즐겨보세요</p></div>
      <div class="contact-grid">
        <div>
          <div class="contact-item"><div class="contact-icon">📍</div><div><h4>주소</h4><p>서울시 강남구 테헤란로 123<br>(역삼동, 정성빌딩 1층)</p></div></div>
          <div class="contact-item"><div class="contact-icon">📞</div><div><h4>전화</h4><p>02-1234-5678</p></div></div>
          <div class="contact-item"><div class="contact-icon">✉</div><div><h4>이메일</h4><p>contact@jungsungcoffee.com</p></div></div>
          <div class="contact-item"><div class="contact-icon">🕐</div><div><h4>영업시간</h4><p>평일: 08:00 - 22:00<br>주말: 09:00 - 23:00<br><span class="text-danger">월요일 휴무</span></p></div></div>
        </div>
        <div class="map-area"><div class="map-placeholder"><div class="icon">📍</div><p>지도 영역</p><p style="font-size:.875rem;margin-top:.5rem">2호선 역삼역 3번 출구 도보 5분</p></div></div>
      </div>
    </div>
  </section>
</main>
<%@ include file="../common/footer.jsp" %>
