<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="로그인 — 정성을 다한 커피"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main bg-gray">
  <div class="auth-container">
    <div class="auth-header"><div class="auth-icon">☕</div><h1>로그인</h1><p>정성을 다한 커피에 오신 것을 환영합니다</p></div>
    <div class="auth-card">
      <h2>계정 로그인</h2><p class="auth-desc">이메일과 비밀번호를 입력하여 로그인하세요</p>
      <c:if test="${param.registered=='true'}"><div class="alert alert-success">회원가입이 완료되었습니다. 로그인해주세요.</div></c:if>
      <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
      <form action="${pageContext.request.contextPath}/member/loginOk" method="post">
        <div class="form-group"><label class="form-label">이메일</label><input type="email" name="email" class="form-control" placeholder="example@email.com" required></div>
        <div class="form-group"><label class="form-label">비밀번호</label><input type="password" name="password" class="form-control" placeholder="••••••••" required></div>
        <button type="submit" class="btn-primary btn-full" style="margin-top:.5rem">로그인</button>
      </form>
    </div>
    <div class="auth-footer">계정이 없으신가요? <a href="${pageContext.request.contextPath}/member/register">회원가입</a></div>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
