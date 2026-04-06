<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="고객 등록"/>
<c:set var="activeMenu" value="register"/>
<%@ include file="header.jsp" %>

<div class="glass-card form-card">
    <div class="card-header">
        <h3>신규 고객 등록</h3>
    </div>
    <form action="${pageContext.request.contextPath}/customer/registerOk" method="post">
        <div class="form-grid">
            <div class="form-group">
                <label for="name">이름 <span class="required">*</span></label>
                <input type="text" id="name" name="name" placeholder="고객 이름" required>
            </div>
            <div class="form-group">
                <label for="phone">연락처</label>
                <input type="tel" id="phone" name="phone" placeholder="010-0000-0000">
            </div>
            <div class="form-group">
                <label for="grade">등급</label>
                <select id="grade" name="grade">
                    <option value="일반">일반</option>
                    <option value="실버">실버</option>
                    <option value="골드">골드</option>
                    <option value="VIP">VIP</option>
                </select>
            </div>
            <div class="form-group form-group-full">
                <label for="memo">메모</label>
                <textarea id="memo" name="memo" placeholder="알레르기, 선호 음료, 특이사항 등"></textarea>
            </div>
        </div>
        <div class="form-actions">
            <button type="submit" class="btn-primary">등록하기</button>
            <a href="${pageContext.request.contextPath}/customer/list" class="btn-ghost">취소</a>
        </div>
    </form>
</div>

<%@ include file="footer.jsp" %>
