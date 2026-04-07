<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>BREW CRM — 회원가입</title>
  
  
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
        <div class="logo-sub">멤버십 가입</div>
      </div>
    </div>

    <c:if test="${not empty error}">
      <div class="auth-msg auth-msg-error">⚠ ${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/registerOk" method="post">
      <div class="form-group">
        <label for="name">이름 <span class="required">*</span></label>
        <input type="text" id="name" name="name" placeholder="홍길동" required>
      </div>
      <div class="form-group">
        <label for="phone">연락처 <span style="font-size:11px;opacity:.6">(선택)</span></label>
        <input type="text" id="phone" name="phone" placeholder="010-0000-0000">
      </div>
      <div class="form-group">
        <label for="email">이메일 <span class="required">*</span></label>
        <input type="email" id="email" name="email" placeholder="example@email.com" required>
      </div>
      <div class="form-group">
        <label for="password">비밀번호 <span class="required">*</span></label>
        <input type="password" id="password" name="password" placeholder="최소 6자 이상" required>
      </div>
      <div class="form-group">
        <label for="confirmPassword">비밀번호 확인 <span class="required">*</span></label>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>
      </div>
      <button type="submit" class="btn-primary auth-submit">회원가입</button>
    </form>

    <div class="auth-links">
      <a href="${pageContext.request.contextPath}/member/login">로그인으로 돌아가기</a>
    </div>
  </div>
</div>
<script>
    document.querySelectorAll('input[name="phone"]').forEach(function(el) {
        el.addEventListener('input', function() {
            var v = this.value.replace(/\D/g, '');
            if (v.length <= 3) {
                this.value = v;
            } else if (v.length <= 7) {
                this.value = v.slice(0,3) + '-' + v.slice(3);
            } else {
                this.value = v.slice(0,3) + '-' + v.slice(3,7) + '-' + v.slice(7,11);
            }
        });
    });
</script>
</body></html>
