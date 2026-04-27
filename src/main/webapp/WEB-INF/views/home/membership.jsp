<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="멤버십 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/membership.css">

<!-- ── 히어로 ── -->
<div class="ms-hero">
  <div class="ms-hero__inner">
    <p class="ms-hero__eyebrow">Membership</p>
    <h1 class="ms-hero__title">정성 클럽</h1>
    <p class="ms-hero__sub">함께하는 커피의 즐거움</p>
  </div>
</div>

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

<!-- ── 등급 기준 ── -->
<section class="ms-section ms-section--dark">
  <div class="ms-inner">
    <div class="ms-head">
      <p class="ms-head__eyebrow">Grade</p>
      <h2 class="ms-head__title ms-head__title--light">멤버십 등급 기준</h2>
      <div class="ms-head__line"></div>
    </div>
    <p class="ms-grade-subtitle">이번 달 방문 횟수 기준, 매월 자동 산정</p>
    <div class="ms-grade-row">

      <!-- 일반 -->
      <div class="ms-grade-card">
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

      <!-- 실버 -->
      <div class="ms-grade-card">
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

      <!-- 골드 -->
      <div class="ms-grade-card">
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

      <!-- VIP -->
      <div class="ms-grade-card ms-grade-card--vip">
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

<%@ include file="../common/footer.jsp" %>
