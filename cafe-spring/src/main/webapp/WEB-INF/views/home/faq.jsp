<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="FAQ — 로운"/>
<%@ include file="../common/header.jsp" %>

<main class="page-main">
  <div class="container container-narrow" style="padding-top:2rem;padding-bottom:3rem">

    <a href="${pageContext.request.contextPath}/" style="font-size:.875rem;color:#717182">← 홈으로 돌아가기</a>
    <h1 style="font-family:'Noto Serif KR',serif;font-size:2rem;font-weight:400;margin:1rem 0 .5rem">자주 묻는 질문</h1>
    <p style="color:#717182;margin-bottom:2rem">로운에 대해 자주 묻는 질문과 답변을 확인하세요.</p>

    <!-- 카테고리 필터 -->
    <div class="faq-cats">
      <button class="faq-cat-btn active" onclick="filterFAQ('전체',this)">전체</button>
      <button class="faq-cat-btn" onclick="filterFAQ('영업 및 매장',this)">영업 및 매장</button>
      <button class="faq-cat-btn" onclick="filterFAQ('시설 및 편의',this)">시설 및 편의</button>
      <button class="faq-cat-btn" onclick="filterFAQ('주문 및 결제',this)">주문 및 결제</button>
      <button class="faq-cat-btn" onclick="filterFAQ('메뉴 및 제품',this)">메뉴 및 제품</button>
      <button class="faq-cat-btn" onclick="filterFAQ('멤버십 및 혜택',this)">멤버십 및 혜택</button>
      <button class="faq-cat-btn" onclick="filterFAQ('예약',this)">예약</button>
    </div>

    <div class="faq-list">

      <!-- ── 영업 및 매장 ── -->
      <div class="faq-item" data-category="영업 및 매장">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">영업 및 매장</span><span class="faq-q-text">영업시간은 어떻게 되나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">로운카페는 24시간 365일 연중무휴로 운영합니다. 직원은 매일 오전 9시~오후 10시 상주하며, 그 외 시간에는 셀프로 자유롭게 이용하실 수 있습니다.</div>
      </div>

      <div class="faq-item" data-category="영업 및 매장">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">영업 및 매장</span><span class="faq-q-text">카페 위치가 어디인가요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">서울특별시 마포구 백범로 23, 3층 (신수동, 케이터틀)에 위치해 있습니다. 지하철 5·6호선 공덕역 8번 출구에서 도보 5분 거리입니다.</div>
      </div>

      <div class="faq-item" data-category="영업 및 매장">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">영업 및 매장</span><span class="faq-q-text">주차가 가능한가요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">기계식 주차장을 이용하실 수 있습니다. 주차 중 문제가 발생할 경우 카페에서 전적으로 책임집니다.</div>
      </div>

      <!-- ── 시설 및 편의 ── -->
      <div class="faq-item" data-category="시설 및 편의">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">시설 및 편의</span><span class="faq-q-text">와이파이를 이용할 수 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">카페 내 와이파이를 안전하게 이용하실 수 있습니다.</div>
      </div>

      <div class="faq-item" data-category="시설 및 편의">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">시설 및 편의</span><span class="faq-q-text">콘센트(충전)를 사용할 수 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">카페 내 콘센트가 설비되어 있어 자유롭게 사용하실 수 있습니다.</div>
      </div>

      <div class="faq-item" data-category="시설 및 편의">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">시설 및 편의</span><span class="faq-q-text">반려동물을 데려올 수 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">반려동물 입장 가능합니다. 카페 앞 마당이 있어 산책도 즐기실 수 있습니다.</div>
      </div>

      <div class="faq-item" data-category="시설 및 편의">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">시설 및 편의</span><span class="faq-q-text">아이와 함께 방문해도 되나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">카페 내 키즈존이 마련되어 있어 아이와 함께 편리하게 이용하실 수 있습니다.</div>
      </div>

      <!-- ── 주문 및 결제 ── -->
      <div class="faq-item" data-category="주문 및 결제">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">주문 및 결제</span><span class="faq-q-text">주문은 어떻게 하나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">주문 방법은 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오.</div>
      </div>

      <div class="faq-item" data-category="주문 및 결제">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">주문 및 결제</span><span class="faq-q-text">어떤 결제 방법을 사용할 수 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">카드, 카카오페이, 삼성페이, 애플페이 등 다양한 결제 수단을 이용하실 수 있습니다. 현금 결제는 직원 상주 시간(오전 9시~오후 10시)에만 가능합니다.</div>
      </div>

      <div class="faq-item" data-category="주문 및 결제">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">주문 및 결제</span><span class="faq-q-text">배달 서비스를 제공하나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">배달 서비스는 아직 준비 중입니다. 나중에 추가할 사항이니 조금만 기다려 주십시오.</div>
      </div>

      <!-- ── 메뉴 및 제품 ── -->
      <div class="faq-item" data-category="메뉴 및 제품">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">메뉴 및 제품</span><span class="faq-q-text">디카페인 옵션이 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">네, 모든 에스프레소 베이스 음료에 디카페인 옵션을 무료로 선택하실 수 있습니다.</div>
      </div>

      <!-- ── 멤버십 및 혜택 ── -->
      <div class="faq-item" data-category="멤버십 및 혜택">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">멤버십 및 혜택</span><span class="faq-q-text">멤버십 프로그램이 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">멤버십은 일반 → 실버 → 골드 → VIP 등급으로 운영됩니다. 방문 횟수에 따라 자동으로 등급이 올라가며, 등급별 쿠폰 혜택을 드립니다. 자세한 내용은 <a href="${pageContext.request.contextPath}/membership/list" style="color:var(--rown-gold2)">멤버십 페이지</a>에서 확인하세요.</div>
      </div>

      <div class="faq-item" data-category="멤버십 및 혜택">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">멤버십 및 혜택</span><span class="faq-q-text">텀블러 할인이 있나요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">개인 텀블러를 지참하시면 음료 가격에서 1,000원 할인해 드립니다. 환경도 지키고 혜택도 받으세요!</div>
      </div>

      <!-- ── 예약 ── -->
      <div class="faq-item" data-category="예약">
        <button class="faq-question" onclick="toggleFAQ(this)">
          <div><span class="faq-cat-label">예약</span><span class="faq-q-text">예약이 가능한가요?</span></div>
          <span class="faq-chevron">▾</span>
        </button>
        <div class="faq-answer">방문 3일 전까지 예약이 가능하며, 단체석도 이용하실 수 있습니다. 예약 문의는 <a href="${pageContext.request.contextPath}/contact" style="color:var(--rown-gold2)">문의하기</a>를 이용해 주세요.</div>
      </div>

    </div>

    <!-- 하단 문의 안내 -->
    <div style="padding:1.25rem;background:#f9fafb;border:1px solid rgba(0,0,0,.1);border-radius:.625rem">
      <h3 style="font-size:1.1rem;margin-bottom:.5rem">찾으시는 답변이 없나요?</h3>
      <p style="color:#717182;margin-bottom:.75rem;font-size:.9rem">추가 문의사항이 있으시면 언제든지 연락 주세요.</p>
      <p style="font-size:.875rem">📞 02-1234-5678 &nbsp;✉ contact@rowncafe.com</p>
    </div>

  </div>
</main>

<%@ include file="../common/footer.jsp" %>
