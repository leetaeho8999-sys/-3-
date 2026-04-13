<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시판 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board.css">

<div class="board-page">
  <!-- 페이지 헤더 -->
  <div class="board-hero">
    <div class="board-hero__inner">
      <p class="board-hero__eyebrow">Community</p>
      <h1 class="board-hero__title">게시판</h1>
      <p class="board-hero__sub">커피에 대한 이야기를 나누고 소통하는 공간입니다</p>
    </div>
  </div>

  <!-- 본문 -->
  <div class="board-content">

    <!-- 카테고리 탭 -->
    <div class="bd-cats">
      <c:forEach var="cat" items="${['전체','공지','질문','후기','정보','자유','건의']}">
        <a href="${pageContext.request.contextPath}/board/list?category=${cat}&keyword=${keyword}"
           class="bd-cat-btn ${category==cat?'active':''}">${cat}</a>
      </c:forEach>
    </div>

    <!-- 검색 / 글쓰기 -->
    <div class="bd-toolbar">
      <form action="${pageContext.request.contextPath}/board/list" method="get" class="bd-search-form">
        <input type="hidden" name="category" value="${category}">
        <input type="text" name="keyword" value="${keyword}"
               placeholder="제목 또는 작성자 검색..." class="bd-search-input">
        <button type="submit" class="bd-search-btn">검색</button>
      </form>
      <c:if test="${not empty sessionScope.m_id}">
        <a href="${pageContext.request.contextPath}/board/write" class="bd-write-btn">글쓰기</a>
      </c:if>
    </div>

    <!-- 테이블 -->
    <div class="bd-table-wrap">
      <table class="bd-table">
        <thead>
          <tr>
            <th style="width:88px">카테고리</th>
            <th>제목</th>
            <th style="width:100px">작성자</th>
            <th style="width:100px">작성일</th>
            <th style="width:66px;text-align:center">조회</th>
            <th style="width:66px;text-align:center">댓글</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty list}">
              <tr><td colspan="6" class="bd-empty">게시글이 없습니다.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="b" items="${list}">
                <tr>
                  <td><span class="c-badge cat-${b.category}">${b.category}</span></td>
                  <td>
                    <a href="${pageContext.request.contextPath}/board/detail?b_idx=${b.b_idx}"
                       class="bd-title-link">${b.title}</a>
                  </td>
                  <td class="bd-meta">${b.author}</td>
                  <td class="bd-meta">${b.regDate}</td>
                  <td class="bd-meta" style="text-align:center">${b.views}</td>
                  <td class="bd-meta" style="text-align:center">${b.comments}</td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <!-- 페이지네이션 -->
    <div class="bd-paging">
      <c:if test="${paging.beginBlock > 1}">
        <a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.beginBlock-1}&keyword=${keyword}&category=${category}"
           class="bd-page-btn">◀</a>
      </c:if>
      <c:forEach begin="${paging.beginBlock}" end="${paging.endBlock}" var="i">
        <a href="${pageContext.request.contextPath}/board/list?nowPage=${i}&keyword=${keyword}&category=${category}"
           class="bd-page-btn ${paging.nowPage==i?'active':''}">${i}</a>
      </c:forEach>
      <c:if test="${paging.endBlock < paging.totalPage}">
        <a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.endBlock+1}&keyword=${keyword}&category=${category}"
           class="bd-page-btn">▶</a>
      </c:if>
    </div>

  </div>
</div>

<%@ include file="../common/footer.jsp" %>
