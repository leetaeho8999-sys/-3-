<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="멤버십 — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
    <!-- 히어로 배너 -->
    <div class="membership-hero">
        <div class="membership-badge">
            <div class="ms-label">MEMBERSHIP</div>
            <div class="ms-title">정성 클럽</div>
            <div class="ms-sub">함께하는 커피의 즐거움</div>
        </div>
    </div>

    <div class="container">
        <!-- 혜택 -->
        <div class="section-header" style="margin-top:3rem"><h2>멤버십 혜택</h2></div>
        <div class="benefit-grid">
            <div class="benefit-card"><div class="benefit-icon">🎁</div><h4>웰컴 기프트</h4><p>가입 즉시 5,000원 할인 쿠폰 증정</p></div>
            <div class="benefit-card"><div class="benefit-icon">%</div><h4>멤버 전용 할인</h4><p>전 메뉴 10% 상시 할인 혜택</p></div>
            <div class="benefit-card"><div class="benefit-icon">⭐</div><h4>포인트 적립</h4><p>구매 금액의 5% 포인트 적립</p></div>
            <div class="benefit-card"><div class="benefit-icon">🎂</div><h4>생일 특별 혜택</h4><p>생일 당월 20% 특별 할인</p></div>
        </div>

        <!-- 요금제 -->
        <div class="section-header" style="margin-top:2.5rem"><h2>멤버십 플랜</h2></div>
        <div class="plan-grid">
            <div class="plan-card">
                <div class="plan-name">베이직</div>
                <div class="plan-price">무료<span>/월</span></div>
                <ul class="plan-features"><li>포인트 적립 2%</li><li>생일 쿠폰</li></ul>
                <button class="plan-btn" style="background:var(--gray-100);color:var(--foreground)">현재 플랜</button>
            </div>
            <div class="plan-card plan-featured">
                <div class="plan-badge">인기</div>
                <div class="plan-name">실버</div>
                <div class="plan-price">9,900<span>원/월</span></div>
                <ul class="plan-features"><li>전 메뉴 10% 할인</li><li>포인트 적립 5%</li><li>생일 쿠폰</li></ul>
                <button class="plan-btn" style="background:var(--accent);color:white">업그레이드</button>
            </div>
            <div class="plan-card">
                <div class="plan-name">골드</div>
                <div class="plan-price">19,900<span>원/월</span></div>
                <ul class="plan-features"><li>전 메뉴 20% 할인</li><li>포인트 적립 10%</li><li>우선 예약</li></ul>
                <button class="plan-btn" style="background:var(--coffee-800);color:white">선택</button>
            </div>
        </div>

        <!-- 파트너 -->
        <div class="section-header" style="margin-top:2.5rem"><h2>제휴 파트너</h2></div>
        <div class="partner-grid">
            <div class="partner-card"><div class="partner-logo">🌟</div><div class="partner-name">스타벅스</div><div class="partner-benefit">음료 10% 할인<br>사이드 무료 업그레이드</div></div>
            <div class="partner-card"><div class="partner-logo">☕</div><div class="partner-name">투썸플레이스</div><div class="partner-benefit">케이크 15% 할인<br>음료 2+1 쿠폰</div></div>
            <div class="partner-card"><div class="partner-logo">🏆</div><div class="partner-name">이디야커피</div><div class="partner-benefit">모든 음료 5% 할인<br>생일 쿠폰 증정</div></div>
            <div class="partner-card"><div class="partner-logo">☕</div><div class="partner-name">컴포즈커피</div><div class="partner-benefit">음료 10% 할인<br>포인트 2배 적립</div></div>
            <div class="partner-card"><div class="partner-logo">🎯</div><div class="partner-name">파스쿠찌</div><div class="partner-benefit">시그니처 음료 20% 할인<br>VIP 라운지 이용</div></div>
            <div class="partner-card"><div class="partner-logo">☕</div><div class="partner-name">할리스커피</div><div class="partner-benefit">음료 12% 할인<br>디저트 무료 쿠폰</div></div>
        </div>
    </div>
</main>
<%@ include file="../common/footer.jsp" %>
