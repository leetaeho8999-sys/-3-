<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="회원가입 — 정성을 다한 커피"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main bg-gray">
  <div class="auth-container">
    <div class="auth-header"><div class="auth-icon">☕</div><h1>회원가입</h1><p>정성을 다한 커피의 회원이 되어보세요</p></div>
    <div class="auth-card">
      <h2>계정 만들기</h2><p class="auth-desc">아래 정보를 입력하여 회원가입을 완료하세요</p>
      <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
      <div id="client-error" class="alert alert-error" style="display:none"></div>
      <form action="${pageContext.request.contextPath}/member/registerOk" method="post" onsubmit="return validateRegister()">
        <div class="form-group"><label class="form-label">닉네임 <span class="required">*</span></label><input type="text" name="username" class="form-control" placeholder="홍길동" required></div>
        <div class="form-group"><label class="form-label">이메일 <span class="required">*</span></label><input type="email" name="email" class="form-control" placeholder="example@email.com" required></div>
        <div class="form-group"><label class="form-label">전화번호</label><input type="tel" name="phone" class="form-control" placeholder="010-1234-5678"></div>
        <div class="form-group"><label class="form-label">비밀번호 <span class="required">*</span></label><input type="password" id="pw" name="password" class="form-control" placeholder="최소 8자 이상" required></div>
        <div class="form-group"><label class="form-label">비밀번호 확인 <span class="required">*</span></label><input type="password" id="pw2" name="confirmPassword" class="form-control" placeholder="비밀번호 재입력" required></div>
        <div class="form-check-group">
          <label class="form-check"><input type="checkbox" name="agreeTerms" value="true"> <a href="${pageContext.request.contextPath}/terms-of-service" target="_blank">이용약관</a>에 동의합니다 (필수)</label>
          <label class="form-check"><input type="checkbox" name="agreePrivacy" value="true"> <a href="${pageContext.request.contextPath}/privacy-policy" target="_blank">개인정보 처리방침</a>에 동의합니다 (필수)</label>
        </div>
        <button type="submit" class="btn-primary btn-full" style="margin-top:1.25rem">회원가입</button>
      </form>
    </div>
    <div class="auth-footer">이미 계정이 있으신가요? <a href="${pageContext.request.contextPath}/member/login">로그인</a></div>
  </div>
</main>
<script>
function validateRegister(){
  var pw=document.getElementById('pw').value,cpw=document.getElementById('pw2').value;
  var err=document.getElementById('client-error');
  if(pw!==cpw){err.textContent='비밀번호가 일치하지 않습니다.';err.style.display='block';return false;}
  if(pw.length<8){err.textContent='비밀번호는 최소 8자 이상이어야 합니다.';err.style.display='block';return false;}
  return true;
}
</script>
<%@ include file="../common/footer.jsp" %>
