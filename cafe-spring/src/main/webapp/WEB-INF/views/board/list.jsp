<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="게시판 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board.css">

<style>
    /* 네이버 카페 스타일 고도화 커스텀 CSS */
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

    /* 카테고리별 색상 분기 */
    .cat-공지 {
        background: #fee2e2;
        color: #ef4444;
    }

    .cat-질문 {
        background: #e0f2fe;
        color: #0ea5e9;
    }

    .cat-자유 {
        background: #f3f4f6;
        color: #4b5563;
    }

    .cat-정보 {
        background: #dcfce7;
        color: #16a34a;
    }

    .bd-page-btn.active {
        background-color: #03c75a !important;
        border-color: #03c75a !important;
        color: #fff !important;
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
                <input type="text" name="keyword" value="${keyword}"
                       placeholder="제목 또는 작성자 검색..." class="bd-search-input"
                       style="padding: 0.6rem 1rem; border: 1px solid #ddd; border-radius: 4px; width: 250px;">
                <button type="submit" class="bd-search-btn"
                        style="background: #333; color: #fff; padding: 0.6rem 1.2rem; border: none; border-radius: 4px; cursor: pointer;">
                    검색
                </button>
            </form>

            <%-- 로그인 상태 확인 로직 (세션) --%>
            <c:if test="${not empty sessionScope.loginMember}">
                <a href="${pageContext.request.contextPath}/board/write" class="bd-write-btn"
                   style="background: #03c75a; color: #fff; padding: 0.6rem 1.5rem; border-radius: 4px; text-decoration: none; font-weight: 600;">글쓰기</a>
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
                            <tr style="border-bottom: 1px solid #f9f9f9;">
                                <td style="padding: 1rem; text-align: center;">
                                    <span class="c-badge cat-${b.category}">${b.category}</span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/board/detail?b_idx=${b.b_idx}"
                                       class="bd-title-link">
                                            ${b.title}
                                    </a>
                                        <%-- 댓글 수가 0보다 크면 표시 --%>
                                    <c:if test="${b.commentCount > 0}">
                                        <span class="comment-count">[${b.commentCount}]</span>
                                    </c:if>
                                </td>
                                <td class="bd-meta">${b.author}</td>
                                <td class="bd-meta">${b.regdate}</td>
                                    <%-- 수정된 필드명: regdate --%>
                                <td class="bd-meta" style="text-align:center">${b.viewcnt}</td>
                                    <%-- 수정된 필드명: viewcnt --%>
                                <td class="bd-meta" style="text-align:center">${b.commentCount}</td>
                                    <%-- 수정된 필드명: commentCount --%>
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
                   class="bd-page-btn"
                   style="padding: 0.5rem 0.8rem; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #666;">&lt;</a>
            </c:if>

            <c:forEach begin="${paging.beginBlock}" end="${paging.endBlock}" var="i">
                <a href="${pageContext.request.contextPath}/board/list?nowPage=${i}&keyword=${keyword}&category=${category}"
                   class="bd-page-btn ${paging.nowPage==i?'active':''}"
                   style="padding: 0.5rem 1rem; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333;">${i}</a>
            </c:forEach>

            <c:if test="${paging.endBlock < paging.totalPage}">
                <a href="${pageContext.request.contextPath}/board/list?nowPage=${paging.endBlock+1}&keyword=${keyword}&category=${category}"
                   class="bd-page-btn"
                   style="padding: 0.5rem 0.8rem; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #666;">&gt;</a>
            </c:if>
        </div>
    </div>
</div>

<script>
    // 성공 메시지 처리 (RedirectAttributes 대응)
    const msg = "${msg}";
    if (msg) alert(msg);
</script>

<%@ include file="../common/footer.jsp" %>