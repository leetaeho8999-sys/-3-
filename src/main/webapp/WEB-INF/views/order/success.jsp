<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<c:set var="pageTitle" value="결제 완료 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/order.css">

<div class="od-page">
  <div class="od-card">

    <div class="od-check">✓</div>
    <h2 class="od-title">결제가 완료되었습니다</h2>
    <p class="od-sub">주문해 주셔서 감사합니다.</p>

    <div class="od-info">
      <div class="od-row">
        <span class="od-label">주문번호</span>
        <span class="od-value od-value--sm">${order.orderId}</span>
      </div>
      <div class="od-row">
        <span class="od-label">결제금액</span>
        <span class="od-value"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>원</span>
      </div>
    </div>

    <table class="od-table">
      <thead>
        <tr><th>메뉴</th><th>온도</th><th>수량</th><th>금액</th></tr>
      </thead>
      <tbody>
        <c:forEach var="item" items="${items}">
          <tr>
            <td>${item.menuName}</td>
            <td>${item.temperature}</td>
            <td>${item.quantity}</td>
            <td><fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>원</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <div class="od-actions">
      <a href="${pageContext.request.contextPath}/menu/list" class="od-btn od-btn--outline">메뉴로 돌아가기</a>
      <a href="${pageContext.request.contextPath}/member/mypage" class="od-btn od-btn--primary">마이페이지</a>
    </div>

  </div>
</div>

<%@ include file="../common/footer.jsp" %>
