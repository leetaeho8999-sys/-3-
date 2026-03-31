<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="마이페이지 — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <div class="profile-header"><div class="profile-avatar">👤</div>
    <div style="font-size:1.1rem;font-weight:500">${sessionScope.loginMember.username}</div>
    <div style="font-size:.875rem;opacity:.75">${sessionScope.loginMember.email}</div>
  </div>
  <div class="container" style="max-width:600px;padding-top:2rem">
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

    <%-- 멤버십 등급 카드 --%>
    <c:set var="grade" value="${not empty memberInfo.grade ? memberInfo.grade : '일반'}"/>
    <c:choose>
      <c:when test="${grade == 'VIP'}">  <c:set var="gradeColor" value="#7c3aed"/><c:set var="gradeBg" value="#ede9fe"/><c:set var="gradeIcon" value="👑"/></c:when>
      <c:when test="${grade == '골드'}"> <c:set var="gradeColor" value="#d97706"/><c:set var="gradeBg" value="#fef3c7"/><c:set var="gradeIcon" value="🥇"/></c:when>
      <c:when test="${grade == '실버'}"> <c:set var="gradeColor" value="#475569"/><c:set var="gradeBg" value="#f1f5f9"/><c:set var="gradeIcon" value="🥈"/></c:when>
      <c:otherwise>                      <c:set var="gradeColor" value="#6b7280"/><c:set var="gradeBg" value="#f9fafb"/><c:set var="gradeIcon" value="☕"/></c:otherwise>
    </c:choose>
    <div style="background:${gradeBg};border:1px solid ${gradeColor}33;border-radius:.625rem;padding:1.5rem;margin-bottom:1.5rem;display:flex;align-items:center;justify-content:space-between">
      <div>
        <div style="font-size:.75rem;color:#717182;margin-bottom:.25rem">나의 멤버십 등급</div>
        <div style="font-size:1.5rem;font-weight:700;color:${gradeColor}">${gradeIcon} ${grade}</div>
        <div style="font-size:.8rem;color:#717182;margin-top:.4rem">누적 방문 <strong>${memberInfo.visitCount}</strong>회</div>
      </div>
      <div style="text-align:right;font-size:.75rem;color:#717182;line-height:1.8">
        <div>일반 &nbsp;1~5회</div>
        <div>실버 &nbsp;6~15회</div>
        <div>골드 16~30회</div>
        <div>VIP &nbsp;31회~</div>
      </div>
    </div>

    <div style="background:white;border:1px solid rgba(0,0,0,.1);border-radius:.625rem;padding:1.75rem;margin-bottom:1.5rem">
      <h2 style="font-size:1.1rem;margin-bottom:1.25rem">정보 수정</h2>
      <form action="${pageContext.request.contextPath}/member/updateOk" method="post">
        <input type="hidden" name="m_idx" value="${sessionScope.loginMember.m_idx}">
        <input type="hidden" name="linkedCustomer" value="${memberInfo.linkedCustomer}">
        <div class="form-group"><label class="form-label">닉네임</label><input type="text" name="username" class="form-control" value="${sessionScope.loginMember.username}" required></div>
        <div class="form-group"><label class="form-label">이메일</label><input type="email" class="form-control" value="${sessionScope.loginMember.email}" readonly style="opacity:.6"></div>
        <div class="form-group"><label class="form-label">전화번호</label><input type="tel" name="phone" class="form-control" value="${memberInfo.phone}"></div>
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
