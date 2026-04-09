<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="멤버십 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/membership.css">

<!-- ══════════════════════════════════════════
     히어로 + 내 멤버십 카드 (다크 통합)
══════════════════════════════════════════ -->
<div class="ms-top">
  <!-- 배경 이미지 오버레이 -->
  <div class="ms-top__bg"></div>

  <!-- 히어로 텍스트 -->
  <div class="ms-top__hero">
    <p class="ms-top__eyebrow">Membership</p>
    <h1 class="ms-top__title">정성 클럽</h1>
    <p class="ms-top__sub">함께하는 커피의 즐거움</p>
  </div>

  <!-- 내 멤버십 카드 -->
  <c:if test="${not empty memberInfo}">
  <div class="ms-top__card-wrap">
    <div class="ms-top__card">

      <!-- 등급 뱃지 -->
      <div class="ms-top__grade">
        <div class="ms-top__grade-icon">
          <c:choose>
            <c:when test="${memberInfo.grade == 'VIP'}">👑</c:when>
            <c:when test="${memberInfo.grade == '골드'}">⭐</c:when>
            <c:when test="${memberInfo.grade == '실버'}">🥈</c:when>
            <c:otherwise>☕</c:otherwise>
          </c:choose>
        </div>
        <span class="ms-top__grade-name grade-${memberInfo.grade}">${memberInfo.grade}</span>
      </div>

      <!-- 구분선 -->
      <div class="ms-top__divider"></div>

      <!-- 사용자 정보 -->
      <div class="ms-top__info">
        <div class="ms-top__username">${memberInfo.username} 님</div>
        <div class="ms-top__stats">
          <span>이번 달 방문 <b>${memberInfo.visitCount}회</b></span>
          <span class="ms-top__dot">·</span>
          <span>누적 포인트 <b>${membership.points}P</b></span>
        </div>
      </div>

      <!-- 다음 등급 -->
      <div class="ms-top__next">
        <c:choose>
          <c:when test="${memberInfo.grade == 'VIP'}">
            <span class="ms-top__next-label">최상위 등급 🎉</span>
          </c:when>
          <c:when test="${memberInfo.grade == '골드'}">
            <span class="ms-top__next-label">VIP까지</span>
            <span class="ms-top__next-count">${30 - memberInfo.visitCount}회</span>
          </c:when>
          <c:when test="${memberInfo.grade == '실버'}">
            <span class="ms-top__next-label">골드까지</span>
            <span class="ms-top__next-count">${10 - memberInfo.visitCount}회</span>
          </c:when>
          <c:otherwise>
            <span class="ms-top__next-label">실버까지</span>
            <span class="ms-top__next-count">${3 - memberInfo.visitCount}회</span>
          </c:otherwise>
        </c:choose>
      </div>

    </div>
  </div>
  </c:if>
</div>

<!-- ── 등급 기준 ── -->
<section class="ms-section ms-section--dark" style="padding-top:3.5rem">
  <div class="ms-inner">
    <div class="ms-head">
      <p class="ms-head__eyebrow">Grade</p>
      <h2 class="ms-head__title ms-head__title--light">멤버십 등급 기준</h2>
      <div class="ms-head__line"></div>
    </div>
    <p class="ms-grade-subtitle">이번 달 방문 횟수 기준, 매월 자동 산정</p>
    <c:set var="myGrade" value="${not empty memberInfo.grade ? memberInfo.grade : '일반'}"/>
    <div class="ms-grade-row">

      <c:set var="activeGeneral" value="${myGrade == '일반' ? 'ms-grade-card--active' : ''}"/>
      <div class="ms-grade-card ${activeGeneral}">
        <p class="ms-grade-label">General</p>
        <div class="ms-grade-name">일반</div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">승급 조건</span>
          <span class="ms-grade-row-value">가입 즉시 부여</span>
        </div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">쿠폰 혜택</span>
          <span class="ms-grade-row-value ms-grade-row-value--gold">아메리카노 쿠폰 1장</span>
        </div>
      </div>

      <div class="ms-grade-arrow">›</div>

      <c:set var="activeSilver" value="${myGrade == '실버' ? 'ms-grade-card--active' : ''}"/>
      <div class="ms-grade-card ${activeSilver}">
        <p class="ms-grade-label">Silver</p>
        <div class="ms-grade-name">실버</div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">승급 조건</span>
          <span class="ms-grade-row-value">월 방문 <b>3회</b> 이상</span>
        </div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">쿠폰 혜택</span>
          <span class="ms-grade-row-value ms-grade-row-value--gold">사이즈업 쿠폰 월 1장</span>
        </div>
      </div>

      <div class="ms-grade-arrow">›</div>

      <c:set var="activeGold" value="${myGrade == '골드' ? 'ms-grade-card--active' : ''}"/>
      <div class="ms-grade-card ${activeGold}">
        <p class="ms-grade-label">Gold</p>
        <div class="ms-grade-name">골드</div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">승급 조건</span>
          <span class="ms-grade-row-value">월 방문 <b>10회</b> 이상</span>
        </div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">쿠폰 혜택</span>
          <span class="ms-grade-row-value ms-grade-row-value--gold">아메리카노 쿠폰 월 1장</span>
        </div>
      </div>

      <div class="ms-grade-arrow">›</div>

      <c:set var="activeVip" value="${myGrade == 'VIP' ? 'ms-grade-card--active' : ''}"/>
      <div class="ms-grade-card ms-grade-card--vip ${activeVip}">
        <p class="ms-grade-label">VIP</p>
        <div class="ms-grade-name ms-grade-name--vip">VIP ✦</div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">승급 조건</span>
          <span class="ms-grade-row-value">월 방문 <b>30회</b> 이상</span>
        </div>
        <div class="ms-grade-row-item">
          <span class="ms-grade-row-label">쿠폰 혜택</span>
          <span class="ms-grade-row-value ms-grade-row-value--gold">아무 음료 쿠폰 월 2장</span>
        </div>
      </div>

    </div>
  </div>
</section>

<!-- ── 혜택 개요 ── -->
<section class="ms-section ms-section--cream">
  <div class="ms-inner">
    <div class="ms-head">
      <p class="ms-head__eyebrow">Benefits</p>
      <h2 class="ms-head__title ms-head__title--dark">멤버십 혜택</h2>
      <div class="ms-head__line"></div>
    </div>
    <div class="ms-benefit-grid">
      <div class="ms-benefit-card">
        <div class="ms-benefit-icon">🎁</div>
        <h4>웰컴 쿠폰</h4>
        <p>가입 즉시 아메리카노 쿠폰 1장 증정</p>
      </div>
      <div class="ms-benefit-card">
        <div class="ms-benefit-icon">☕</div>
        <h4>사이즈업 혜택</h4>
        <p>실버 이상 회원 전용 사이즈업 쿠폰 월 1장</p>
      </div>
      <div class="ms-benefit-card">
        <div class="ms-benefit-icon">⭐</div>
        <h4>등급별 쿠폰</h4>
        <p>골드 아메리카노·VIP 아무 음료 쿠폰 매월 지급</p>
      </div>
      <div class="ms-benefit-card">
        <div class="ms-benefit-icon">🔄</div>
        <h4>자동 등급 갱신</h4>
        <p>이번 달 방문 횟수 기준 매월 자동 산정</p>
      </div>
    </div>
  </div>
</section>

<%@ include file="../common/footer.jsp" %>
