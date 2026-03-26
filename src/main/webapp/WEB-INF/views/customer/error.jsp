<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="오류"/>
<c:set var="activeMenu" value=""/>
<%@ include file="header.jsp" %>

<div class="glass-card form-card" style="text-align:center; padding:48px;">
    <div style="font-size:40px; margin-bottom:16px;">⚠</div>
    <h3 style="font-family:'Cormorant Garamond',serif; font-size:22px; margin-bottom:12px;">오류가 발생했습니다</h3>
    <p style="color:rgba(255,255,255,0.55); margin-bottom:28px;">요청을 처리하는 중 문제가 발생했습니다.</p>
    <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn-primary">대시보드로 돌아가기</a>
</div>

<%@ include file="footer.jsp" %>
