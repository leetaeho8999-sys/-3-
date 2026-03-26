<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="멤버십 — 정성을 다한 커피"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <div class="membership-hero">
    <div class="membership-badge">
      <div style="font-size:.8rem;opacity:.7;letter-spacing:.1em">MEMBERSHIP</div>
      <div style="font-size:1.8rem;font-weight:600;margin:.4rem 0">정성 클럽</div>
      <div style="font-size:.875rem;opacity:.7">함께하는 커피의 즐거움</div>
    </div>
  </div>
  <section style="padding:3rem 0;background:white">
    <div class="container">
      <h2 style="font-family:'Noto Serif KR',serif;font-size:1.5rem;font-weight:400;margin-bottom:1.5rem">멤버십 혜택</h2>
      <div class="benefit-grid">
        <div class="benefit-card"><div style="font-size:1.5rem;margin-bottom:.75rem">🎁</div><h4 style="margin-bottom:.4rem">웰컴 기프트</h4><p style="color:#717182;font-size:.875rem">가입 즉시 5,000원 할인 쿠폰 증정</p></div>
        <div class="benefit-card"><div style="font-size:1.5rem;margin-bottom:.75rem">%</div><h4 style="margin-bottom:.4rem">멤버 전용 할인</h4><p style="color:#717182;font-size:.875rem">전 메뉴 10% 상시 할인 혜택</p></div>
        <div class="benefit-card"><div style="font-size:1.5rem;margin-bottom:.75rem">⭐</div><h4 style="margin-bottom:.4rem">포인트 적립</h4><p style="color:#717182;font-size:.875rem">구매 금액의 5% 포인트 적립</p></div>
        <div class="benefit-card"><div style="font-size:1.5rem;margin-bottom:.75rem">🎂</div><h4 style="margin-bottom:.4rem">생일 특별 혜택</h4><p style="color:#717182;font-size:.875rem">생일 당월 20% 할인</p></div>
      </div>

      <h2 style="font-family:'Noto Serif KR',serif;font-size:1.5rem;font-weight:400;margin:2rem 0 1rem">멤버십 플랜</h2>
      <div class="plan-grid">
        <div class="plan-card"><h4 style="margin-bottom:.5rem">베이직</h4><div style="font-size:1.5rem;font-weight:600;margin:.4rem 0">무료<span style="font-size:.875rem;font-weight:400">/월</span></div><p style="font-size:.8rem;color:#9ca3af">기본 혜택 포함</p></div>
        <div class="plan-card featured"><div style="font-size:.75rem;color:#c8832a;font-weight:500;margin-bottom:.3rem">인기</div><h4 style="margin-bottom:.5rem">실버</h4><div style="font-size:1.5rem;font-weight:600;margin:.4rem 0">9,900<span style="font-size:.875rem;font-weight:400">원/월</span></div><p style="font-size:.8rem;color:#9ca3af">10% 상시 할인, 5% 적립</p></div>
        <div class="plan-card"><h4 style="margin-bottom:.5rem">골드</h4><div style="font-size:1.5rem;font-weight:600;margin:.4rem 0">19,900<span style="font-size:.875rem;font-weight:400">원/월</span></div><p style="font-size:.8rem;color:#9ca3af">20% 상시 할인, 10% 적립</p></div>
      </div>

      <h2 style="font-family:'Noto Serif KR',serif;font-size:1.5rem;font-weight:400;margin:2rem 0 1rem">제휴 파트너</h2>
      <div class="partner-grid">
        <div class="partner-card"><div style="font-size:1.3rem;margin-bottom:.4rem">🌟</div><h4 style="font-size:.95rem;margin-bottom:.3rem">스타벅스</h4><p style="font-size:.8rem;color:#717182">음료 10% 할인 / 사이드 무료 업그레이드</p></div>
        <div class="partner-card"><div style="font-size:1.3rem;margin-bottom:.4rem">☕</div><h4 style="font-size:.95rem;margin-bottom:.3rem">투썸플레이스</h4><p style="font-size:.8rem;color:#717182">케이크 15% 할인 / 음료 2+1 쿠폰</p></div>
        <div class="partner-card"><div style="font-size:1.3rem;margin-bottom:.4rem">🏆</div><h4 style="font-size:.95rem;margin-bottom:.3rem">이디야커피</h4><p style="font-size:.8rem;color:#717182">모든 음료 5% 할인 / 생일 쿠폰 증정</p></div>
        <div class="partner-card"><div style="font-size:1.3rem;margin-bottom:.4rem">☕</div><h4 style="font-size:.95rem;margin-bottom:.3rem">컴포즈커피</h4><p style="font-size:.8rem;color:#717182">음료 10% 할인 / 포인트 2배 적립</p></div>
        <div class="partner-card"><div style="font-size:1.3rem;margin-bottom:.4rem">🎯</div><h4 style="font-size:.95rem;margin-bottom:.3rem">파스쿠찌</h4><p style="font-size:.8rem;color:#717182">시그니처 음료 20% 할인 / VIP 라운지</p></div>
        <div class="partner-card"><div style="font-size:1.3rem;margin-bottom:.4rem">☕</div><h4 style="font-size:.95rem;margin-bottom:.3rem">할리스커피</h4><p style="font-size:.8rem;color:#717182">음료 12% 할인 / 디저트 무료 쿠폰</p></div>
      </div>
    </div>
  </section>
</main>
<%@ include file="../common/footer.jsp" %>
