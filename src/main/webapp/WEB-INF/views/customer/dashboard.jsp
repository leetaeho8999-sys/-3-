<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="대시보드"/>
<c:set var="activeMenu" value="dashboard"/>
<%@ include file="header.jsp" %>

<div class="stat-grid">
  <div class="stat-card">
    <div class="stat-label">전체 고객</div>
    <div class="stat-value">${totalCount}</div>
  </div>
  <div class="stat-card">
    <div class="stat-label">👑 VIP</div>
    <div class="stat-value" style="color:#cc88ff">${vipCount}</div>
  </div>
  <div class="stat-card">
    <div class="stat-label">⭐ 골드</div>
    <div class="stat-value">${goldCount}</div>
  </div>
  <div class="stat-card">
    <div class="stat-label">🥈 실버</div>
    <div class="stat-value" style="color:#d8d8d8">${silverCount}</div>
  </div>
  <div class="stat-card">
    <div class="stat-label">이번 달 신규</div>
    <div class="stat-value">${newCount}</div>
  </div>
</div>

<div class="glass-card">
  <div class="card-header">
    <h3>최근 등록 고객</h3>
    <a href="${pageContext.request.contextPath}/customer/list" class="card-link">전체 보기 →</a>
  </div>
  <table class="crm-table">
    <thead>
      <tr><th>이름</th><th>연락처</th><th>등급</th><th>방문횟수</th><th>등록일</th></tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty recentList}">
          <tr><td colspan="5" class="empty-msg">등록된 고객이 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="c" items="${recentList}">
            <tr>
              <td class="td-name">
                <a href="${pageContext.request.contextPath}/customer/detail?c_idx=${c.c_idx}">${c.name}</a>
              </td>
              <td class="td-muted">${c.phone}</td>
              <td><span class="grade-badge grade-${c.grade}">${c.grade}</span></td>
              <td class="td-muted">${c.visitCount}회</td>
              <td class="td-faint">${c.regDate}</td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<%@ include file="footer.jsp" %>
