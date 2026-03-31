<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="FAQ — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <div class="container container-narrow" style="padding-top:2rem;padding-bottom:3rem">
    <a href="${pageContext.request.contextPath}/" style="font-size:.875rem;color:#717182">← 홈으로 돌아가기</a>
    <h1 style="font-family:'Noto Serif KR',serif;font-size:2rem;font-weight:400;margin:1rem 0 .5rem">자주 묻는 질문</h1>
    <p style="color:#717182;margin-bottom:2rem">로운에 대해 자주 묻는 질문과 답변을 확인하세요.</p>
    <div class="faq-cats">
      <button class="faq-cat-btn active" onclick="filterFAQ('전체',this)">전체</button>
      <button class="faq-cat-btn" onclick="filterFAQ('주문 및 결제',this)">주문 및 결제</button>
      <button class="faq-cat-btn" onclick="filterFAQ('배달 및 픽업',this)">배달 및 픽업</button>
      <button class="faq-cat-btn" onclick="filterFAQ('메뉴 및 제품',this)">메뉴 및 제품</button>
      <button class="faq-cat-btn" onclick="filterFAQ('영업 및 매장',this)">영업 및 매장</button>
      <button class="faq-cat-btn" onclick="filterFAQ('멤버십 및 혜택',this)">멤버십 및 혜택</button>
      <button class="faq-cat-btn" onclick="filterFAQ('기타',this)">기타</button>
    </div>
    <div class="faq-list">
      <div class="faq-item" data-category="주문 및 결제"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">주문 및 결제</span><span class="faq-q-text">주문은 어떻게 하나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">챗봇을 통해 주문하시거나 전화(02-1234-5678)로 주문하실 수 있습니다.</div></div>
      <div class="faq-item" data-category="주문 및 결제"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">주문 및 결제</span><span class="faq-q-text">어떤 결제 방법을 사용할 수 있나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">현금, 신용카드, 모바일 결제(카카오페이, 네이버페이) 등 다양한 결제 수단을 지원합니다.</div></div>
      <div class="faq-item" data-category="배달 및 픽업"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">배달 및 픽업</span><span class="faq-q-text">배달 서비스를 제공하나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">매장 반경 3km 이내 지역에 배달 서비스를 제공합니다. 최소 주문 금액은 15,000원이며, 배달비는 3,000원입니다.</div></div>
      <div class="faq-item" data-category="메뉴 및 제품"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">메뉴 및 제품</span><span class="faq-q-text">디카페인 옵션이 있나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">네, 모든 에스프레소 베이스 음료에 디카페인 옵션을 선택하실 수 있습니다. 추가 비용은 500원입니다.</div></div>
      <div class="faq-item" data-category="영업 및 매장"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">영업 및 매장</span><span class="faq-q-text">영업시간은 어떻게 되나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">평일 08:00~22:00, 주말 09:00~23:00 영업합니다. 월요일은 휴무입니다.</div></div>
      <div class="faq-item" data-category="멤버십 및 혜택"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">멤버십 및 혜택</span><span class="faq-q-text">멤버십 프로그램이 있나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">현재 멤버십 프로그램을 준비 중입니다. 출시 시 기존 고객분들께 우선 혜택을 제공할 예정입니다.</div></div>
      <div class="faq-item" data-category="기타"><button class="faq-question" onclick="toggleFAQ(this)"><div><span class="faq-cat-label">기타</span><span class="faq-q-text">텀블러 할인이 있나요?</span></div><span class="faq-chevron">▾</span></button><div class="faq-answer">개인 텀블러를 지참하시면 음료 가격에서 500원 할인해 드립니다.</div></div>
    </div>
    <div style="padding:1.25rem;background:#f9fafb;border:1px solid rgba(0,0,0,.1);border-radius:.625rem">
      <h3 style="font-size:1.1rem;margin-bottom:.5rem">찾으시는 답변이 없나요?</h3>
      <p style="color:#717182;margin-bottom:.75rem;font-size:.9rem">추가 문의사항이 있으시면 언제든지 연락 주세요.</p>
      <p style="font-size:.875rem">📞 02-1234-5678 &nbsp;✉ info@coffeewithcare.com</p>
    </div>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
