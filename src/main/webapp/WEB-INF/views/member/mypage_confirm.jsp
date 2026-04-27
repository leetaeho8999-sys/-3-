<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="본인 확인 — 마이페이지"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage-theme.css">

<div class="auth-page">
  <div class="auth-wrap">

    <div class="auth-brand">
      <div class="auth-brand__logo">로<span>운</span></div>
      <div class="auth-brand__sub">My Page · 본인 확인</div>
    </div>

    <div class="auth-deco">
      <div class="auth-deco__line"></div>
      <div class="auth-deco__dot"></div>
      <div class="auth-deco__line"></div>
    </div>

    <div class="auth-card">
      <h2 class="auth-card__title">본인 확인</h2>
      <p class="auth-card__desc">
        개인정보 보호를 위해 비밀번호를 한 번 더 입력해주세요.
      </p>

      <c:if test="${not empty errorMsg}">
        <div class="auth-alert auth-alert--error">${errorMsg}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/member/mypageConfirm" method="post">
        <div class="auth-form-group">
          <label class="auth-label">아이디</label>
          <input type="text" class="auth-input"
                 value="${sessionScope.m_id}" readonly
                 style="background:var(--rown-beige); opacity:.7; cursor:not-allowed;">
        </div>
        <div class="auth-form-group">
          <label class="auth-label">비밀번호 <span class="auth-required">*</span></label>
          <input type="password" name="m_pw" class="auth-input"
                 placeholder="비밀번호를 입력하세요" required autofocus>
        </div>
        <button type="submit" class="auth-submit">마이페이지로 이동</button>
      </form>
    </div>

    <div class="auth-foot">
      <a href="${pageContext.request.contextPath}/">홈으로 돌아가기</a>
    </div>

  </div>
</div>

<%@ include file="../common/footer.jsp" %>
