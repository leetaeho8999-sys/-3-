<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="고객 목록"/>
<c:set var="activeMenu" value="list"/>
<%@ include file="header.jsp" %>

<div class="glass-card">
  <div class="card-header">
    <h3>고객 목록 <span class="count-badge">${paging.totalRecord}명</span></h3>
    <form action="${pageContext.request.contextPath}/customer/list" method="get" style="display:inline">
      <input type="hidden" name="keyword" value="${keyword}">
      <select name="grade" class="filter-select" onchange="this.form.submit()">
        <option value="전체" ${grade == '전체' ? 'selected' : ''}>전체 등급</option>
        <option value="일반" ${grade == '일반' ? 'selected' : ''}>일반</option>
        <option value="실버" ${grade == '실버' ? 'selected' : ''}>실버</option>
        <option value="골드" ${grade == '골드' ? 'selected' : ''}>골드</option>
        <option value="VIP"  ${grade == 'VIP'  ? 'selected' : ''}>VIP</option>
      </select>
    </form>
  </div>

  <table class="crm-table">
    <thead>
      <tr>
        <th>번호</th><th>이름</th><th>연락처</th><th>등급</th>
        <th>방문횟수</th><th>메모</th><th>등록일</th><th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty list}">
          <tr><td colspan="8" class="empty-msg">등록된 고객이 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="c" items="${list}" varStatus="status">
            <tr>
              <td class="td-faint">${paging.totalRecord - paging.offset - status.index}</td>
              <td class="td-name">${c.name}</td>
              <td class="td-muted">${c.phone}</td>
              <td><span class="grade-badge grade-${c.grade}">${c.grade}</span></td>
              <td>
                <!-- POST form으로 방문 기록 (CSRF/GET 취약점 수정) -->
                <form action="${pageContext.request.contextPath}/customer/addVisit"
                      method="post" style="display:inline">
                  <input type="hidden" name="c_idx"    value="${c.c_idx}">
                  <input type="hidden" name="nowPage"  value="${paging.nowPage}">
                  <input type="hidden" name="keyword"  value="${keyword}">
                  <input type="hidden" name="grade"    value="${grade}">
                  <button type="submit" class="btn-visit"
                          title="방문 기록 (+1)">+</button>
                </form>
                <span class="td-muted">${c.visitCount}회</span>
              </td>
              <td class="td-memo">${c.memo}</td>
              <td class="td-faint">${c.regDate}</td>
              <td>
                <a href="${pageContext.request.contextPath}/customer/edit?c_idx=${c.c_idx}"
                   class="btn-edit">수정</a>
                <a href="${pageContext.request.contextPath}/customer/delete?c_idx=${c.c_idx}"
                   class="btn-delete"
                   onclick="return confirm('${c.name} 고객을 삭제하시겠습니까?')">삭제</a>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>

  <!-- 페이징 -->
  <div class="paging">
    <c:if test="${paging.beginBlock > 1}">
      <a href="${pageContext.request.contextPath}/customer/list?nowPage=${paging.beginBlock-1}&keyword=${keyword}&grade=${grade}"
         class="page-btn">◀</a>
    </c:if>
    <c:forEach begin="${paging.beginBlock}" end="${paging.endBlock}" var="i">
      <a href="${pageContext.request.contextPath}/customer/list?nowPage=${i}&keyword=${keyword}&grade=${grade}"
         class="page-btn ${paging.nowPage == i ? 'active' : ''}">${i}</a>
    </c:forEach>
    <c:if test="${paging.endBlock < paging.totalPage}">
      <a href="${pageContext.request.contextPath}/customer/list?nowPage=${paging.endBlock+1}&keyword=${keyword}&grade=${grade}"
         class="page-btn">▶</a>
    </c:if>
  </div>
</div>

<%@ include file="footer.jsp" %>
