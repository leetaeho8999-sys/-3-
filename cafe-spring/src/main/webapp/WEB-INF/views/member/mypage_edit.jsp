<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="정보 수정 — 마이페이지"/>
<%@ include file="../common/header.jsp" %>

<main class="page-main bg-light">
    <div class="auth-container" style="max-width:460px">
        <div class="profile-header">
            <div class="profile-avatar">👤</div>
            <div class="profile-name">${sessionScope.loginMember.name}</div>
            <div class="profile-email">${sessionScope.loginMember.email}</div>
        </div>

        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
        <c:if test="${not empty error}">  <div class="alert alert-error">${error}</div></c:if>

        <div class="auth-card">
            <h3 style="font-size:1rem;margin-bottom:1rem">정보 수정</h3>
            <form action="${pageContext.request.contextPath}/member/mypage/update" method="post" class="auth-form">
                <div class="form-group">
                    <label class="form-label">이름</label>
                    <input type="text" name="name" value="${sessionScope.loginMember.name}" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">이메일 (수정 불가)</label>
                    <input type="email" value="${sessionScope.loginMember.email}" class="form-control" readonly style="background:#F3F4F6">
                </div>
                <div class="form-group">
                    <label class="form-label">전화번호</label>
                    <input type="tel" name="phone" value="${sessionScope.loginMember.phone}" class="form-control" placeholder="010-1234-5678">
                </div>
                <button type="submit" class="btn-primary btn-full">저장</button>
            </form>
        </div>
    </div>
</main>

<%@ include file="../common/footer.jsp" %>
