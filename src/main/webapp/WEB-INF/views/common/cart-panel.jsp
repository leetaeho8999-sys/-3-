<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ────────────────────────────────────────────────
  사이드 슬라이드 장바구니 패널 (로그인 회원 전용).
  header.jsp 끝에서 include 로 불려 모든 페이지에 노출.
  CSS 는 비로그인 상태에서도 옵션 모달의 .order-btn-row 스타일이
  필요하므로 <c:if> 바깥에서 항상 로드.
──────────────────────────────────────────────── --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart-panel.css">

<c:if test="${not empty sessionScope.m_id}">
<div class="cart-overlay" id="cart-overlay" onclick="closeCart()"></div>
<aside class="cart-panel" id="cart-panel" aria-hidden="true">
    <div class="cart-header">
        <h2>🛒 내 장바구니 <span class="cart-count-inline">(<span id="cart-count-inline">0</span>개)</span></h2>
        <button type="button" class="cart-close" onclick="closeCart()" aria-label="닫기">✕</button>
    </div>
    <div class="cart-body" id="cart-body">
        <div class="cart-empty" id="cart-empty" style="display:none">
            장바구니가 비어있습니다.
        </div>
        <ul class="cart-items" id="cart-items"></ul>
    </div>
    <div class="cart-footer">
        <%-- 포인트 사용 입력 영역 --%>
        <div class="cart-points-row">
            <div class="cart-points-balance">
                사용 가능 포인트: <strong id="cart-points-balance">${userPointBalance != null ? userPointBalance : 0}</strong>P
            </div>
            <div class="cart-points-input">
                <input type="number" id="cart-points-input" min="0" step="100" placeholder="0" />
                <button type="button" id="cart-points-all" onclick="useAllPoints()">전액 사용</button>
            </div>
            <small>1,000P부터 100P 단위로 사용 가능</small>
            <div class="cart-points-preview" id="cart-points-preview" style="display:none">
                포인트 사용 시 결제액: <strong id="cart-points-payable">0원</strong>
            </div>
        </div>

        <div class="cart-total-row">
            <span>합계</span>
            <strong id="cart-total">0원</strong>
        </div>
        <button type="button" class="btn-checkout" id="cart-checkout-btn" onclick="checkoutCart()">주문하기</button>
        <button type="button" class="btn-clear" onclick="clearCartConfirm()">전체 비우기</button>
    </div>
</aside>

<script>
    window.ctxPath = '${pageContext.request.contextPath}';
    window.customerName = '${sessionScope.m_name}';
    window.tossClientKey = '${tossClientKey}';
    window.userPointBalance = ${userPointBalance != null ? userPointBalance : 0};
</script>
<script src="https://js.tosspayments.com/v1/payment"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
</c:if>
