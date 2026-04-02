<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="고객 상세"/>
<c:set var="activeMenu" value="list"/>
<%@ include file="header.jsp" %>

<div class="glass-card form-card">
    <div class="card-header">
        <h3>${customer.name} 고객 정보</h3>
        <span class="grade-badge grade-${customer.grade}">${customer.grade}</span>
    </div>

    <div class="detail-grid">
        <div class="detail-item">
            <div class="detail-label">이름</div>
            <div class="detail-value">${customer.name}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">연락처</div>
            <div class="detail-value">${customer.phone}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">등급</div>
            <div class="detail-value"><span class="grade-badge grade-${customer.grade}">${customer.grade}</span></div>
        </div>
        <div class="detail-item">
            <div class="detail-label">방문 횟수</div>
            <div class="detail-value">${customer.visitCount}회</div>
        </div>
        <div class="detail-item detail-full">
            <div class="detail-label">메모</div>
            <div class="detail-value">${customer.memo}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">등록일</div>
            <div class="detail-value td-faint">${customer.regDate}</div>
        </div>
    </div>

    <div class="form-actions" style="margin-top:24px">
        <a href="${pageContext.request.contextPath}/customer/edit?c_idx=${customer.c_idx}" class="btn-primary">수정</a>
        <form action="${pageContext.request.contextPath}/customer/addVisit" method="post" style="display:inline">
            <input type="hidden" name="c_idx" value="${customer.c_idx}">
            <button type="submit" class="btn-ghost">방문 기록</button>
        </form>
        <a href="${pageContext.request.contextPath}/customer/list" class="btn-ghost">목록</a>
        <a href="${pageContext.request.contextPath}/customer/delete?c_idx=${customer.c_idx}"
           class="btn-delete-lg"
           onclick="return confirm('${customer.name} 고객을 삭제하시겠습니까?')">삭제</a>
    </div>
</div>

<%@ include file="footer.jsp" %>
