<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="마이페이지 — 정성을 다한 커피"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <div class="profile-header"><div class="profile-avatar">👤</div>
    <div style="font-size:1.1rem;font-weight:500">${sessionScope.loginMember.username}</div>
    <div style="font-size:.875rem;opacity:.75">${sessionScope.loginMember.email}</div>
  </div>
  <div class="container" style="max-width:600px;padding-top:2rem">
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
    <div style="background:white;border:1px solid rgba(0,0,0,.1);border-radius:.625rem;padding:1.75rem;margin-bottom:1.5rem">
      <h2 style="font-size:1.1rem;margin-bottom:1.25rem">정보 수정</h2>
      <form action="${pageContext.request.contextPath}/member/updateOk" method="post">
        <input type="hidden" name="m_idx" value="${sessionScope.loginMember.m_idx}">
        <div class="form-group"><label class="form-label">닉네임</label><input type="text" name="username" class="form-control" value="${sessionScope.loginMember.username}" required></div>
        <div class="form-group"><label class="form-label">이메일</label><input type="email" class="form-control" value="${sessionScope.loginMember.email}" readonly style="opacity:.6"></div>
        <div class="form-group"><label class="form-label">전화번호</label><input type="tel" name="phone" class="form-control" value="${sessionScope.loginMember.phone}"></div>
        <button type="submit" class="btn-primary">저장</button>
      </form>
    </div>
    <div style="background:white;border:1px solid #fecaca;border-radius:.625rem;padding:1.75rem">
      <h2 style="font-size:1.1rem;color:#dc2626;margin-bottom:.5rem">⚠️ 계정 삭제</h2>
      <p style="font-size:.875rem;color:#717182;margin-bottom:1rem">계정 삭제 시 모든 데이터가 영구 삭제됩니다.</p>
      <form action="${pageContext.request.contextPath}/member/deleteOk" method="post" onsubmit="return confirm('정말로 계정을 삭제하시겠습니까?')">
        <input type="hidden" name="m_idx" value="${sessionScope.loginMember.m_idx}">
        <button type="submit" class="btn-danger">계정 삭제</button>
      </form>
    </div>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
