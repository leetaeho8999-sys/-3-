<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>BREW CRM — 로그인</title>
  
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div id="video-bg">
  <video autoplay muted loop playsinline id="bg-video">
    <source src="https://videos.pexels.com/video-files/3737294/3737294-hd_1920_1080_25fps.mp4" type="video/mp4">
  </video>
  <div id="video-overlay"></div>
</div>

<div class="auth-center">
  <div class="auth-card glass-card">
    <div class="auth-logo">
      <span class="logo-icon">☕</span>
      <div>
        <div class="logo-title">BREW</div>
        <div class="logo-sub">멤버십 로그인</div>
      </div>
    </div>

    <c:if test="${param.registered == 'true'}">
      <div class="auth-msg auth-msg-success">✓ 회원가입이 완료되었습니다. 로그인해주세요.</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="auth-msg auth-msg-error">⚠ ${error}</div>
    </c:if>

    <c:if test="${not empty param.redirect}">
      <div class="auth-msg auth-msg-info">🔒 로그인 후 이용할 수 있습니다.</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/loginOk" method="post">
      <input type="hidden" name="redirect" value="${param.redirect}">
      <div class="form-group">
        <label for="email">이메일</label>
        <input type="email" id="email" name="email" placeholder="example@email.com" required>
      </div>
      <div class="form-group">
        <label for="password">비밀번호</label>
        <input type="password" id="password" name="password" placeholder="••••••" required>
      </div>
      <button type="submit" class="btn-primary auth-submit">로그인</button>
    </form>

    <div class="auth-links">
      <a href="${pageContext.request.contextPath}/member/register">회원가입</a>
      <span>|</span>
      <a href="${pageContext.request.contextPath}/customer/dashboard">CRM 관리자</a>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
</body></html>
