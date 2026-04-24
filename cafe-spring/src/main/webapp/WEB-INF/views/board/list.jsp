<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시판 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board.css">

<style>
    /* ── 기존 스타일 유지 및 우선순위 강화 ── */
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

    /* 뱃지 공통 스타일 */
    .c-badge {
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 600;
        display: inline-block;
    }

    /* 카테고리별 컬러 (강력 적용) */
    .bd-table .cat-공지 {
        background-color: #fee2e2 !important;
        color: #ef4444 !important;
    }

    .bd-table .cat-질문 {
        background-color: #e0f2fe !important;
        color: #0ea5e9 !important;
    }

    .bd-table .cat-자유 {
        background-color: #f3f4f6 !important;
        color: #4b5563 !important;
    }

    .bd-table .cat-정보 {
        background-color: #dcfce7 !important;
        color: #16a34a !important;
    }

    .bd-table .cat-후기 {
        background-color: #fef3c7 !important;
        color: #d97706 !important;
    }

    .bd-table .cat-건의 {
        background-color: #ede9fe !important;
        color: #7c3aed !important;
    }

    /* [추가] 블라인드 게시글 스타일 */
    .blind-text {
        color: #999;
        font-size: 0.95rem;
        font-style: italic;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    /* 블라인드 행 배경색 (강력 적용) */
    .bd-table tr.blind-row,
    .bd-table tr.blind-row td {
        background-color: #f8f8f8 !important; /* 미세한 회색으로 변경 */
        color: #ccc !important;
    }
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
                <input type="text" name="keyword" value="${keyword}" placeholder="제목 또는 작성자 검색..."
                       class="bd-search-input"
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
                            <td colspan="6" class="bd-empty" style="text-align: center; padding: 4rem; color: #999;">작성된
                                게시글이 없습니다. 첫 글의 주인공이 되어보세요!
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${list}">
                            <%-- [신고 블라인드 로직] report_cnt가 5회 이상인 경우 처리 --%>
                            <tr style="border-bottom: 1px solid #f9f9f9;"
                                class="${b.report_cnt >= 5 ? 'blind-row' : ''}">
                                <td style="padding: 1rem; text-align: center;">
                                    <span class="c-badge cat-${b.category}">${b.category}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.report_cnt >= 5}">
                                            <%-- 신고 누적 시 제목 비노출 --%>
                                            <span class="blind-text">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                     viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle
                                                        cx="12" cy="12" r="10"></circle><line x1="4.93" y1="4.93"
                                                                                              x2="19.07"
                                                                                              y2="19.07"></line></svg>
                                                다수의 신고에 의해 블라인드 처리된 게시글입니다.
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/board/detail?b_idx=${b.b_idx}"
                                               class="bd-title-link">${b.title}</a>
                                            <c:if test="${b.comments > 0}">
                                                <span class="comment-count">[${b.comments}]</span>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
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
    if (msg) alert(msg);
</script>

<%@ include file="../common/footer.jsp" %>