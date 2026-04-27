<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="결제 실패 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/order.css">

<div class="od-page">
  <div class="od-card">

    <div class="od-check od-check--fail">✕</div>
    <h2 class="od-title">결제에 실패했습니다</h2>
    <p class="od-sub">${message}</p>

    <div class="od-actions">
      <a href="${pageContext.request.contextPath}/menu/list" class="od-btn od-btn--outline">메뉴로 돌아가기</a>
      <a href="${pageContext.request.contextPath}/member/mypage" class="od-btn od-btn--primary">마이페이지</a>
    </div>

  </div>
</div>

<%@ include file="../common/footer.jsp" %>
