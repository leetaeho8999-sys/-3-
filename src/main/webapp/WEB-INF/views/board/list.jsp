<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시판 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">

<style>
    .bd-title-link {
        font-weight: 500;
        color: #333;
        transition: color 0.2s;
    }
    .bd-title-link:hover {
        color: #03c75a;
        text-decoration: underline;
    }
    .comment-count {
        color: #ff4d4f;
        font-size: 0.85rem;
        margin-left: 4px;
        font-weight: bold;
    }
    .c-badge {
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 600;
        display: inline-block;
    }
    .cat-공지 { background: #fee2e2; color: #ef4444; }
    .cat-질문 { background: #e0f2fe; color: #0ea5e9; }
    .cat-자유 { background: #f3f4f6; color: #4b5563; }
    .cat-정보 { background: #dcfce7; color: #16a34a; }
    .cat-후기 { background: #fef3c7; color: #d97706; }
    .cat-건의 { background: #ede9fe; color: #7c3aed; }
    /* 활성 페이지 버튼 — board.css 의 .bd-page-btn.active 사용 */
</style>

<div class="board-page">
    <div class="board-hero">
        <div class="board-hero__inner">
            <p class="board-hero__eyebrow">Community</p>
            <h1 class="board-hero__title">게시판</h1>
            <p class="board-hero__sub">커피에 대한 이야기를 나누고 소통하는 공간입니다</p>
        </div>
    </div>

    <div class="board-content">
        <div class="bd-cats" style="margin-bottom: 2rem;">
            <c:forEach var="cat" items="${['전체','공지','질문','후기','정보','자유','건의']}">
                <a href="${pageContext.request.contextPath}/board/list?category=${cat}&keyword=${keyword}"
                   class="bd-cat-btn ${category==cat || (empty category && cat=='전체') ? 'active' : ''}">${cat}</a>
            </c:forEach>
        </div>

        <div class="bd-toolbar"
             style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
            <form action="${pageContext.request.contextPath}/board/list" method="get" class="bd-search-form"
                  style="display: flex; gap: 5px;">
                <input type="hidden" name="category" value="${category}">
                <input type="text" name="keyword" value="${keyword}"
                       placeholder="제목 또는 작성자 검색..." class="bd-search-input"
                       style="padding: 0.6rem 1rem; border: 1px solid #ddd; border-radius: 4px; width: 250px;">
                <button type="submit" class="bd-search-btn"
                        style="background: #333; color: #fff; padding: 0.6rem 1.2rem; border: none; border-radius: 4px; cursor: pointer;">
                    검색
                </button>
            </form>

            <c:if test="${not empty sessionScope.m_id}">
                <a href="${pageContext.request.contextPath}/board/write" class="bd-write-btn">글쓰기</a>
            </c:if>
        </div>

        <div class="bd-table-wrap" style="background: #fff; border-radius: 8px; border: 1px solid #eee;">
            <table class="bd-table" style="width: 100%; border-collapse: collapse;">
                <thead>
                <tr style="border-bottom: 2px solid #f4f4f4;">
                    <th style="width:100px; padding: 1.2rem;">카테고리</th>
                    <th>제목</th>
                    <th style="width:120px">작성자</th>
                    <th style="width:120px">작성일</th>
                    <th style="width:80px;text-align:center">조회</th>
                    <th style="width:80px;text-align:center">댓글</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="6" class="bd-empty"
                                style="text-align: center; padding: 4rem; color: #999;">작성된
                                게시글이 없습니다. 첫 글의 주인공이 되어보세요!
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${list}">
                            <tr style="border-bottom: 1px solid #f9f9f9; ${b.category == '공지' ? 'background:#fff8e1;' : ''}">
                                <td style="padding: 1rem; text-align: center;">
                                    <span class="c-badge cat-${b.category}">${b.category}</span>
                                </td>
                                <td>
                                    <c:if test="${b.category == '공지'}">📌 </c:if>
                                    <a href="${pageContext.request.contextPath}/board/detail?b_idx=${b.b_idx}"
                                       class="bd-title-link">${b.title}</a>
                                    <c:if test="${b.comments > 0}">
                                        <span class="comment-count">[${b.comments}]</span>
                                    </c:if>
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

        <div class="bd-paging" style="display: flex; justify-content: center; gap: 8px; margin-top: 3rem;">
            <c:if test="${paging.beginBlock > 1}">
                <a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.beginBlock-1}&keyword=${keyword}&category=${category}"
                   class="bd-page-btn">&lt;</a>
            </c:if>
            <c:forEach begin="${paging.beginBlock}" end="${paging.endBlock}" var="i">
                <a href="${pageContext.request.contextPath}/board/list?nowPage=${i}&keyword=${keyword}&category=${category}"
                   class="bd-page-btn ${paging.nowPage==i?'active':''}">${i}</a>
            </c:forEach>
            <c:if test="${paging.endBlock < paging.totalPage}">
                <a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.endBlock+1}&keyword=${keyword}&category=${category}"
                   class="bd-page-btn">&gt;</a>
            </c:if>
        </div>
    </div>
</div>

<script>
    const msg = "${msg}";
    if (msg) showToast(msg, 'info');
</script>

<%@ include file="../common/footer.jsp" %>
