<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="고객 수정"/>
<c:set var="activeMenu" value="list"/>
<%@ include file="header.jsp" %>

<div class="glass-card form-card">
    <div class="card-header">
        <h3>${customer.name} 고객 정보 수정</h3>
    </div>
    <form action="${pageContext.request.contextPath}/customer/editOk" method="post">
        <input type="hidden" name="c_idx" value="${customer.c_idx}">
        <div class="form-grid">
            <div class="form-group">
                <label for="name">이름 <span class="required">*</span></label>
                <input type="text" id="name" name="name" value="${customer.name}" required>
            </div>
            <div class="form-group">
                <label for="phone">연락처</label>
                <input type="tel" id="phone" name="phone" value="${customer.phone}">
            </div>
            <div class="form-group">
                <label for="grade">등급</label>
                <select id="grade" name="grade">
                    <option value="일반" ${customer.grade == '일반' ? 'selected' : ''}>일반</option>
                    <option value="실버" ${customer.grade == '실버' ? 'selected' : ''}>실버</option>
                    <option value="골드" ${customer.grade == '골드' ? 'selected' : ''}>골드</option>
                    <option value="VIP"  ${customer.grade == 'VIP'  ? 'selected' : ''}>VIP</option>
                </select>
            </div>
            <div class="form-group">
                <label for="birthday">생일</label>
                <input type="date" id="birthday" name="birthday" value="${customer.birthday}">
            </div>
            <div class="form-group form-group-full">
                <label for="memo">메모</label>
                <textarea id="memo" name="memo">${customer.memo}</textarea>
            </div>
        </div>
        <div class="form-actions">
            <button type="submit" class="btn-primary">저장하기</button>
            <a href="${pageContext.request.contextPath}/customer/detail?c_idx=${customer.c_idx}" class="btn-ghost">취소</a>
        </div>
    </form>
</div>

<%@ include file="footer.jsp" %>
