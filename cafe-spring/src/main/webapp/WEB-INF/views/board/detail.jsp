<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="${board.title} — 게시판"/>
<%@ include file="../common/header.jsp" %>

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<style>
    .board-detail {
        background: #fff;
        border: 1px solid #ebecef;
        border-radius: 8px;
        padding: 30px;
        margin-bottom: 20px;
    }

    .board-detail-header {
        border-bottom: 1px solid #f4f4f4;
        padding-bottom: 20px;
        margin-bottom: 25px;
    }

    .board-detail-title {
        font-size: 2rem;
        font-weight: 700;
        margin: 15px 0;
        color: #1e1e23;
    }

    .board-detail-meta {
        font-size: 0.9rem;
        color: #999;
        display: flex;
        gap: 15px;
        align-items: center;
    }

    .board-detail-meta span:not(:last-child)::after {
        content: "|";
        margin-left: 15px;
        color: #eee;
    }

    /* 에디터 내용 출력 영역 */
    .board-detail-content {
        min-height: 300px;
        line-height: 1.8;
        font-size: 1.1rem;
        color: #333;
        overflow-wrap: break-word;
    }

    .ql-editor {
        padding: 0;
    }

    /* Quill 스타일 초기화 */

    /* 댓글 영역 고도화 */
    .comment-area {
        padding: 20px 0;
    }

    .comment-title {
        font-weight: 700;
        font-size: 1.1rem;
        margin-bottom: 20px;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
    }

    .comment-item {
        display: flex;
        gap: 12px;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px dotted #f0f0f0;
    }

    .comment-avatar {
        width: 36px;
        height: 36px;
        background: #8b5cf6;
        color: #fff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }

    .comment-author {
        font-weight: 600;
        color: #333;
        margin-right: 8px;
    }

    .comment-date {
        font-size: 0.8rem;
        color: #bbb;
    }

    .comment-text {
        margin-top: 8px;
        color: #444;
        line-height: 1.5;
    }

    .comment-delete {
        font-size: 0.8rem;
        color: #ff4d4f;
        text-decoration: none;
        margin-left: 10px;
    }

    /* 입력창 */
    .comment-form-wrap {
        background: #f9fafb;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #eee;
    }

    .comment-input {
        flex: 1;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 1rem;
    }

    .btn-submit-comment {
        background: #03c75a;
        color: #fff;
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        font-weight: 600;
        cursor: pointer;
    }

    .c-badge {
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    .cat-공지 {
        background: #fee2e2;
        color: #ef4444;
    }

    .cat-자유 {
        background: #f3f4f6;
        color: #4b5563;
    }
</style>

<main class="page-main bg-gray" style="padding: 2rem 0;">
    <div class="container container-narrow">

        <div class="board-detail shadow-sm">
            <div class="board-detail-header">
                <span class="c-badge cat-${board.category}">${board.category}</span>
                <h2 class="board-detail-title">${board.title}</h2>
                <div class="board-detail-meta">
                    <strong style="color:#333">${board.author}</strong>
                    <span>${board.regdate}</span>
                    <span>조회 ${board.viewcnt}</span>
                    <span style="color:#03c75a">댓글 ${board.commentCount}</span>
                </div>
            </div>

            <div class="board-detail-content ql-editor">
                ${board.content}
            </div>

            <div class="board-detail-actions"
                 style="margin-top: 50px; display: flex; justify-content: space-between; border-top: 1px solid #eee; padding-top: 20px;">
                <a href="${pageContext.request.contextPath}/board/list" class="btn-ghost"
                   style="padding: 10px 20px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #666;">목록으로</a>

                <div class="owner-btns">
                    <c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.username == board.author}">
                        <a href="${pageContext.request.contextPath}/board/edit?b_idx=${board.b_idx}"
                           class="btn-primary-sm"
                           style="padding: 10px 20px; background: #6366f1; color: #fff; border-radius: 4px; text-decoration: none; margin-right: 5px;">수정</a>
                        <a href="${pageContext.request.contextPath}/board/delete?b_idx=${board.b_idx}"
                           class="btn-danger"
                           style="padding: 10px 20px; background: #ef4444; color: #fff; border-radius: 4px; text-decoration: none;"
                           onclick="return confirm('정말로 삭제하시겠습니까? 게시글은 복구되지 않습니다.')">삭제</a>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="board-detail shadow-sm">
            <div class="comment-area">
                <div class="comment-title">댓글 <span style="color:#03c75a">${board.commentCount}</span></div>

                <div class="comment-list">
                    <c:forEach var="c" items="${comments}">
                        <div class="comment-item">
                            <div class="comment-avatar"
                                 style="background: ${c.author == board.author ? '#03c75a' : '#8b5cf6'}">
                                    ${fn:substring(c.author, 0, 1)}
                            </div>
                            <div class="comment-body" style="flex:1">
                                <div>
                                    <span class="comment-author">${c.author}</span>
                                    <c:if test="${c.author == board.author}"><span
                                            style="font-size:10px; color:#03c75a; border:1px solid #03c75a; padding:1px 3px; border-radius:3px;">작성자</span></c:if>
                                    <span class="comment-date">${c.regdate}</span>
                                    <c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.username == c.author}">
                                        <a href="${pageContext.request.contextPath}/board/commentDelete?c_idx=${c.c_idx}&b_idx=${board.b_idx}"
                                           class="comment-delete" onclick="return confirm('댓글을 삭제하시겠습니까?')">삭제</a>
                                    </c:if>
                                </div>
                                <p class="comment-text">${c.content}</p>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty comments}">
                        <div style="text-align:center; padding: 40px 0; color: #ccc;">
                            <p>아직 댓글이 없습니다. 따뜻한 댓글 한마디를 남겨주세요!</p>
                        </div>
                    </c:if>
                </div>

                <div class="comment-form-wrap" style="margin-top: 30px;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginMember}">
                            <form action="${pageContext.request.contextPath}/board/commentOk" method="post"
                                  style="display:flex; gap: 10px;">
                                <input type="hidden" name="b_idx" value="${board.b_idx}">
                                <input type="text" name="content" placeholder="댓글을 남겨보세요" class="comment-input"
                                       required>
                                <button type="submit" class="btn-submit-comment">등록</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; font-size: 0.95rem; color: #777;">
                                댓글 작성을 위해 <a href="${pageContext.request.contextPath}/member/login"
                                             style="color:#03c75a; font-weight: bold; text-decoration: none;">로그인</a>이
                                필요합니다.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // 성공 메시지 알림 (삭제 완료 등)
    const msg = "${msg}";
    if (msg) alert(msg);
</script>

<%@ include file="../common/header.jsp" %>
<%@ include file="../common/footer.jsp" %>