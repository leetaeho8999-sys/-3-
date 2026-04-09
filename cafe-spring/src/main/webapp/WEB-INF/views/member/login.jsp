<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="로그인 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css">

<div class="login-page">
  <div class="login-wrap">

    <div class="login-brand">
      <div class="login-brand__logo">로운</div>
      <div class="login-brand__sub">Welcome Back</div>
    </div>

    <div class="login-deco">
      <div class="login-deco__line"></div>
      <div class="login-deco__dot"></div>
      <div class="login-deco__line"></div>
    </div>

    <div class="login-card">
      <h1 class="login-card__title">로그인</h1>
      <p class="login-card__desc">이메일과 비밀번호를 입력해주세요</p>

      <c:if test="${not empty msg}">
        <div class="login-alert login-alert--success">${msg}</div>
      </c:if>
      <c:if test="${not empty errorMsg}">
        <div class="login-alert login-alert--error">${errorMsg}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/member/loginOk" method="post">
        <div class="login-form-group">
          <label class="login-label" for="email">이메일</label>
          <input type="email" id="email" name="email" class="login-input"
                 placeholder="example@email.com" required autocomplete="email">
        </div>
        <div class="login-form-group">
          <label class="login-label" for="password">비밀번호</label>
          <input type="password" id="password" name="password" class="login-input"
                 placeholder="••••••••" required autocomplete="current-password">
        </div>
        <button type="submit" class="login-submit">로그인</button>
      </form>
    </div>

    <div class="login-foot">
      계정이 없으신가요?
      <a href="${pageContext.request.contextPath}/member/register">회원가입</a>
    </div>

  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/login.js"></script>
<%@ include file="../common/footer.jsp" %>
