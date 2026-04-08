<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="회원가입 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/register.css">

<div class="register-page">
  <div class="register-wrap">

    <div class="register-brand">
      <div class="register-brand__logo">로운</div>
      <div class="register-brand__sub">Create Account</div>
    </div>

    <div class="register-deco">
      <div class="register-deco__line"></div>
      <div class="register-deco__dot"></div>
      <div class="register-deco__line"></div>
    </div>

    <div class="register-card">
      <h1 class="register-card__title">회원가입</h1>
      <p class="register-card__desc">로운의 회원이 되어 특별한 혜택을 누리세요</p>

      <c:if test="${not empty errorMsg}">
        <div class="register-alert register-alert--error">${errorMsg}</div>
      </c:if>
      <div id="client-error" class="register-alert register-alert--error" style="display:none"></div>

      <form action="${pageContext.request.contextPath}/member/registerOk" method="post"
            onsubmit="return validateRegister()">

        <div class="register-form-group">
          <label class="register-label" for="username">
            닉네임 <span class="register-required">*</span>
          </label>
          <input type="text" id="username" name="username" class="register-input"
                 placeholder="홍길동" required>
        </div>

        <div class="register-form-group">
          <label class="register-label" for="email">
            이메일 <span class="register-required">*</span>
          </label>
          <input type="email" id="email" name="email" class="register-input"
                 placeholder="example@email.com" required autocomplete="email">
        </div>

        <div class="register-form-group">
          <label class="register-label" for="phone">전화번호</label>
          <input type="tel" id="phone" name="phone" class="register-input"
                 placeholder="010-1234-5678">
        </div>

        <div class="register-form-group">
          <label class="register-label" for="pw">
            비밀번호 <span class="register-required">*</span>
          </label>
          <input type="password" id="pw" name="password" class="register-input"
                 placeholder="최소 8자 이상" required autocomplete="new-password">
        </div>

        <div class="register-form-group">
          <label class="register-label" for="pw2">
            비밀번호 확인 <span class="register-required">*</span>
          </label>
          <input type="password" id="pw2" name="confirmPassword" class="register-input"
                 placeholder="비밀번호 재입력" required autocomplete="new-password">
        </div>

        <div class="register-checks">
          <label class="register-check">
            <input type="checkbox" name="agreeTerms" value="true">
            <a href="${pageContext.request.contextPath}/terms-of-service" target="_blank">이용약관</a>에 동의합니다 (필수)
          </label>
          <label class="register-check">
            <input type="checkbox" name="agreePrivacy" value="true">
            <a href="${pageContext.request.contextPath}/privacy-policy" target="_blank">개인정보 처리방침</a>에 동의합니다 (필수)
          </label>
        </div>

        <button type="submit" class="register-submit">회원가입</button>
      </form>
    </div>

    <div class="register-foot">
      이미 계정이 있으신가요?
      <a href="${pageContext.request.contextPath}/member/login">로그인</a>
    </div>

  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/register.js"></script>
<%@ include file="../common/footer.jsp" %>
