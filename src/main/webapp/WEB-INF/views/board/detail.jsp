<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="${board.title} — 게시판"/>
<%@ include file="../common/header.jsp" %>

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<style>
    /* ── 게시글 상세 페이지 — 로운 카페 브랜드 테마 ── */
    .detail-page {
        padding-top: 64px;
        min-height: 100vh;
        background: var(--rown-cream);
    }

    /* 페이지 헤더 배너 */
    .detail-hero {
        background: var(--rown-dark);
        padding: 3rem 1.5rem 2rem;
        border-bottom: 1px solid rgba(200,169,126,.15);
    }
    .detail-hero__inner { max-width: 860px; margin: 0 auto; }
    .detail-hero__eyebrow {
        font-size: .62rem; letter-spacing: 4px; text-transform: uppercase;
        color: var(--rown-gold); margin-bottom: .5rem;
    }
    .detail-hero__title {
        font-family: var(--font-serif);
        font-size: clamp(1.4rem, 3vw, 1.9rem);
        font-weight: 300; color: var(--rown-cream);
        letter-spacing: .03em;
    }

    /* 본문 카드 */
    .board-detail {
        background: #fff;
        border: 1px solid var(--rown-border);
        border-radius: 8px;
        padding: 2rem 2.5rem;
        margin-bottom: 1.25rem;
        box-shadow: 0 2px 16px rgba(42,26,14,.07);
    }
    .board-detail-header {
        border-bottom: 1px solid var(--rown-beige);
        padding-bottom: 1.25rem;
        margin-bottom: 1.5rem;
    }
    .board-detail-title {
        font-family: var(--font-serif);
        font-size: 1.7rem;
        font-weight: 500;
        margin: .75rem 0;
        color: var(--rown-dark);
        letter-spacing: .01em;
    }
    .board-detail-meta {
        font-size: .855rem;
        color: var(--rown-muted);
        display: flex;
        gap: 15px;
        align-items: center;
        flex-wrap: wrap;
    }
    .board-detail-meta span:not(:last-child)::after {
        content: "|";
        margin-left: 15px;
        color: var(--rown-border);
    }
    .board-detail-content {
        min-height: 300px;
        line-height: 1.9;
        font-size: 1.05rem;
        color: var(--rown-text);
        overflow-wrap: break-word;
    }
    .ql-editor { padding: 0; }

    /* 액션 버튼 */
    .board-detail-actions {
        margin-top: 2.5rem;
        display: flex;
        justify-content: space-between;
        border-top: 1px solid var(--rown-beige);
        padding-top: 1.25rem;
    }
    .btn-back {
        display: inline-flex; align-items: center;
        padding: .55rem 1.2rem;
        border: 1px solid var(--rown-border);
        border-radius: 4px;
        color: var(--rown-muted);
        font-size: .875rem;
        transition: all .2s;
    }
    .btn-back:hover { background: var(--rown-beige); color: var(--rown-dark); border-color: var(--rown-gold2); }
    .btn-edit {
        display: inline-flex; align-items: center;
        padding: .55rem 1.2rem;
        background: var(--rown-dark); color: var(--rown-gold);
        border-radius: 4px; font-size: .875rem; font-weight: 600;
        margin-right: .4rem; transition: background .2s;
    }
    .btn-edit:hover { background: var(--rown-mid); }
    .btn-del {
        display: inline-flex; align-items: center;
        padding: .55rem 1.2rem;
        background: #fee2e2; color: #dc2626;
        border-radius: 4px; font-size: .875rem; font-weight: 600;
        border: 1px solid #fca5a5; transition: background .2s;
    }
    .btn-del:hover { background: #fecaca; }

    /* 댓글 섹션 */
    .comment-area { padding: 1rem 0; }
    .comment-title {
        font-family: var(--font-serif);
        font-weight: 500;
        font-size: 1rem;
        color: var(--rown-dark);
        margin-bottom: 1.25rem;
        border-bottom: 1px solid var(--rown-beige);
        padding-bottom: .75rem;
        letter-spacing: .02em;
    }
    .comment-item {
        display: flex;
        gap: 12px;
        margin-bottom: 1.25rem;
        padding-bottom: 1rem;
        border-bottom: 1px dotted var(--rown-beige);
    }
    .comment-avatar {
        width: 36px;
        height: 36px;
        background: var(--rown-mid);
        color: var(--rown-cream);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: .9rem;
        flex-shrink: 0;
    }
    .comment-avatar.is-author { background: var(--rown-gold2); }
    .comment-author { font-weight: 600; color: var(--rown-dark); margin-right: 8px; font-size: .9rem; }
    .comment-date { font-size: .78rem; color: var(--rown-muted); }
    .comment-text { margin-top: .45rem; color: var(--rown-text); line-height: 1.6; font-size: .93rem; }
    .comment-delete {
        font-size: .78rem;
        color: #dc2626;
        text-decoration: none;
        margin-left: 10px;
        opacity: .7;
        transition: opacity .15s;
    }
    .comment-delete:hover { opacity: 1; }
    .comment-empty {
        text-align: center;
        padding: 2.5rem 0;
        color: var(--rown-muted);
        font-size: .9rem;
    }

    /* 댓글 작성 폼 */
    .comment-form-wrap {
        background: var(--rown-beige);
        padding: 1.25rem 1.5rem;
        border-radius: 8px;
        border: 1px solid var(--rown-border);
        margin-top: 1.5rem;
    }
    .comment-input {
        flex: 1;
        padding: .65rem .875rem;
        border: 1px solid var(--rown-border);
        border-radius: 4px;
        font-size: .9rem;
        font-family: inherit;
        background: #fff;
        color: var(--rown-text);
        outline: none;
        transition: border-color .15s;
    }
    .comment-input:focus { border-color: var(--rown-gold2); }
    .btn-submit-comment {
        background: var(--rown-dark);
        color: var(--rown-gold);
        border: none;
        padding: .65rem 1.25rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: .875rem;
        font-family: inherit;
        cursor: pointer;
        white-space: nowrap;
        transition: background .2s;
    }
    .btn-submit-comment:hover { background: var(--rown-mid); }
    .comment-login-prompt { text-align: center; font-size: .9rem; color: var(--rown-muted); }
    .comment-login-link { color: var(--rown-gold2); font-weight: 600; }
    .comment-login-link:hover { color: var(--rown-dark); }
    .author-badge {
        font-size: .68rem; color: var(--rown-gold2);
        border: 1px solid var(--rown-gold2);
        padding: 1px 4px; border-radius: 3px;
        margin-right: 4px;
    }

    /* 카테고리 뱃지 */
    .c-badge { display: inline-block; padding: .2rem .6rem; border-radius: .3rem; font-size: .72rem; font-weight: 600; }
    .cat-공지 { background: #fee2e2; color: #dc2626; }
    .cat-질문 { background: #dbeafe; color: #2563eb; }
    .cat-후기 { background: #dcfce7; color: #16a34a; }
    .cat-정보 { background: #f3e8ff; color: #9333ea; }
    .cat-자유 { background: #fef9c3; color: #ca8a04; }
    .cat-건의 { background: #ffedd5; color: #c2410c; }
</style>

<div class="detail-page">
    <!-- 페이지 헤더 배너 -->
    <div class="detail-hero">
        <div class="detail-hero__inner">
            <p class="detail-hero__eyebrow">Community · Board</p>
            <h1 class="detail-hero__title">${board.title}</h1>
        </div>
    </div>

    <main style="padding: 2rem 0 4rem;">
        <div class="container-narrow">

            <!-- 게시글 본문 카드 -->
            <div class="board-detail">
                <div class="board-detail-header">
                    <span class="c-badge cat-${board.category}">${board.category}</span>
                    <div class="board-detail-meta" style="margin-top: .75rem;">
                        <strong style="color: var(--rown-dark);">${board.author}</strong>
                        <span>${board.regDate}</span>
                        <span>조회 ${board.views}</span>
                        <span style="color: var(--rown-gold2);">댓글 ${board.comments}</span>
                    </div>
                </div>

                <div class="board-detail-content ql-editor">
                    ${board.content}
                </div>

                <div class="board-detail-actions">
                    <a href="${pageContext.request.contextPath}/board/list" class="btn-back">← 목록으로</a>
                    <div class="owner-btns">
                        <c:if test="${not empty sessionScope.m_id and sessionScope.m_id == board.author}">
                            <a href="${pageContext.request.contextPath}/board/edit?b_idx=${board.b_idx}" class="btn-edit">수정</a>
                            <a href="${pageContext.request.contextPath}/board/delete?b_idx=${board.b_idx}" class="btn-del"
                               data-confirm="정말로 삭제하시겠습니까? 게시글은 복구되지 않습니다."
                               data-confirm-title="게시글 삭제"
                               data-confirm-text="삭제"
                               data-confirm-danger>삭제</a>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 댓글 카드 -->
            <div class="board-detail">
                <div class="comment-area">
                    <div class="comment-title">댓글 <span style="color: var(--rown-gold2);">${board.comments}</span></div>

                    <div class="comment-list">
                        <c:forEach var="c" items="${comments}">
                            <div class="comment-item">
                                <div class="comment-avatar ${c.author == board.author ? 'is-author' : ''}">
                                    ${fn:substring(c.author, 0, 1)}
                                </div>
                                <div class="comment-body" style="flex:1">
                                    <div>
                                        <c:if test="${c.author == board.author}">
                                            <span class="author-badge">작성자</span>
                                        </c:if>
                                        <span class="comment-author">${c.author}</span>
                                        <span class="comment-date">${c.regDate}</span>
                                        <c:if test="${not empty sessionScope.m_id and sessionScope.m_id == c.author}">
                                            <a href="${pageContext.request.contextPath}/board/commentDelete?c_idx=${c.c_idx}&b_idx=${board.b_idx}"
                                               class="comment-delete"
                                               data-confirm="댓글을 삭제하시겠습니까?"
                                               data-confirm-title="댓글 삭제"
                                               data-confirm-text="삭제"
                                               data-confirm-danger>삭제</a>
                                        </c:if>
                                    </div>
                                    <p class="comment-text">${c.content}</p>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty comments}">
                            <div class="comment-empty">
                                <p>아직 댓글이 없습니다. 따뜻한 댓글 한마디를 남겨주세요.</p>
                            </div>
                        </c:if>
                    </div>

                    <div class="comment-form-wrap">
                        <c:choose>
                            <c:when test="${not empty sessionScope.m_id}">
                                <form action="${pageContext.request.contextPath}/board/commentOk" method="post"
                                      style="display:flex; gap: .75rem;">
                                    <input type="hidden" name="b_idx" value="${board.b_idx}">
                                    <input type="text" name="content" placeholder="따뜻한 댓글을 남겨보세요" class="comment-input" required>
                                    <button type="submit" class="btn-submit-comment">등록</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="comment-login-prompt">
                                    댓글 작성을 위해
                                    <a href="${pageContext.request.contextPath}/member/login" class="comment-login-link">로그인</a>이
                                    필요합니다.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<script>
    const msg = "${msg}";
    if (msg) showToast(msg, 'info');
</script>

<%@ include file="../common/footer.jsp" %>
