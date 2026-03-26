<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <c:set var="pageTitle" value="${board.title} — 게시판" />
    <%@ include file="../common/header.jsp" %>
      <main class="page-main">
        <div class="container container-narrow" style="padding-top:2rem">
          <div class="board-detail">
            <div class="board-detail-header">
              <span class="c-badge cat-${board.category}">${board.category}</span>
              <h2 class="board-detail-title">${board.title}</h2>
              <div class="board-detail-meta">
                <span>${board.author}</span><span>${board.regDate}</span><span>조회 ${board.views}</span><span>댓글
                  ${board.comments}</span>
              </div>
            </div>
            <div class="board-detail-content">${board.content}</div>
            <div class="board-detail-actions">
              <a href="${pageContext.request.contextPath}/board/list" class="btn-ghost">목록</a>
              <c:if test="${not empty sessionScope.loginMember}">
                <a href="${pageContext.request.contextPath}/board/edit?b_idx=${board.b_idx}"
                  class="btn-primary-sm">수정</a>
                <a href="${pageContext.request.contextPath}/board/delete?b_idx=${board.b_idx}" class="btn-danger"
                  onclick="return confirm('삭제하시겠습니까?')">삭제</a>
              </c:if>
            </div>
          </div>

          <!-- 댓글 -->
          <div class="board-detail" style="margin-top:1rem">
            <div class="comment-area">
              <div class="comment-title">댓글 ${board.comments}개</div>
              <div class="comment-list">
                <c:forEach var="c" items="${comments}">
                  <div class="comment-item">
                    <div class="comment-avatar">${fn:substring(c.author,0,1)}</div>
                    <div class="comment-body">
                      <span class="comment-author">${c.author}</span>
                      <span class="comment-date">${c.regDate}</span>
                      <c:if test="${not empty sessionScope.loginMember}">
                        <a href="${pageContext.request.contextPath}/board/commentDelete?c_idx=${c.c_idx}&b_idx=${board.b_idx}"
                          class="comment-delete" onclick="return confirm('삭제?')">삭제</a>
                      </c:if>
                      <p class="comment-text">${c.content}</p>
                    </div>
                  </div>
                </c:forEach>
              </div>
              <c:if test="${not empty sessionScope.loginMember}">
                <form action="${pageContext.request.contextPath}/board/commentOk" method="post"
                  style="display:flex;gap:.75rem">
                  <input type="hidden" name="b_idx" value="${board.b_idx}">
                  <input type="text" name="content" placeholder="댓글을 입력하세요..." class="comment-input" required>
                  <button type="submit" class="btn-primary-sm">등록</button>
                </form>
              </c:if>
            </div>
          </div>
        </div>
      </main>
      <%@ include file="../common/footer.jsp" %>