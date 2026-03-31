<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시판 — 로운"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main">
  <div class="container" style="padding-top:2rem">
    <div style="margin-bottom:1.5rem"><h1 style="font-family:'Noto Serif KR',serif;font-size:2rem;font-weight:400">게시판</h1><p style="color:#717182">커피에 대한 이야기를 나누고 소통하는 공간입니다</p></div>

    <div class="board-cats">
      <c:forEach var="cat" items="${['전체','공지','질문','후기','정보','자유','건의']}">
        <a href="${pageContext.request.contextPath}/board/list?category=${cat}&keyword=${keyword}"
           class="board-cat-btn ${category==cat?'active':''}">${cat}</a>
      </c:forEach>
    </div>

    <div class="board-toolbar">
      <form action="${pageContext.request.contextPath}/board/list" method="get" class="board-search-form">
        <input type="hidden" name="category" value="${category}">
        <input type="text" name="keyword" value="${keyword}" placeholder="제목 또는 작성자 검색..." class="search-input">
        <button type="submit" class="btn-search">검색</button>
      </form>
      <c:if test="${not empty sessionScope.loginMember}">
        <a href="${pageContext.request.contextPath}/board/write" class="btn-primary-sm">글쓰기</a>
      </c:if>
    </div>

    <div class="board-table-wrap">
      <table class="board-table">
        <thead><tr><th style="width:80px">카테고리</th><th>제목</th><th style="width:100px">작성자</th><th style="width:100px">작성일</th><th style="width:70px;text-align:center">조회</th><th style="width:70px;text-align:center">댓글</th></tr></thead>
        <tbody>
          <c:choose>
            <c:when test="${empty list}"><tr><td colspan="6" class="board-empty">게시글이 없습니다.</td></tr></c:when>
            <c:otherwise>
              <c:forEach var="b" items="${list}">
                <tr>
                  <td><span class="c-badge cat-${b.category}">${b.category}</span></td>
                  <td><a href="${pageContext.request.contextPath}/board/detail?b_idx=${b.b_idx}" class="board-title-link">${b.title}</a></td>
                  <td class="text-muted">${b.author}</td>
                  <td class="text-muted">${b.regDate}</td>
                  <td class="text-center text-muted">${b.views}</td>
                  <td class="text-center text-muted">${b.comments}</td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <div class="paging">
      <c:if test="${paging.beginBlock > 1}"><a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.beginBlock-1}&keyword=${keyword}&category=${category}" class="page-btn">◀</a></c:if>
      <c:forEach begin="${paging.beginBlock}" end="${paging.endBlock}" var="i">
        <a href="${pageContext.request.contextPath}/board/list?nowPage=${i}&keyword=${keyword}&category=${category}" class="page-btn ${paging.nowPage==i?'active':''}">${i}</a>
      </c:forEach>
      <c:if test="${paging.endBlock < paging.totalPage}"><a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.endBlock+1}&keyword=${keyword}&category=${category}" class="page-btn">▶</a></c:if>
    </div>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
