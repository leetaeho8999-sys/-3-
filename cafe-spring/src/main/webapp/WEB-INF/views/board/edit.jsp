<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="글 수정 — 게시판"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main bg-gray">
  <div class="container container-narrow" style="padding-top:2rem">
    <h1 style="font-family:'Noto Serif KR',serif;font-size:1.8rem;font-weight:400;margin-bottom:1.5rem">글 수정</h1>
    <form action="${pageContext.request.contextPath}/board/editOk" method="post" style="background:white;border:1px solid rgba(0,0,0,.1);border-radius:.625rem;padding:2rem">
      <input type="hidden" name="b_idx" value="${board.b_idx}">
      <div class="form-group"><label class="form-label">카테고리</label>
        <select name="category" class="form-control">
          <c:forEach var="cat" items="${['질문','후기','정보','자유','건의','공지']}">
            <option ${board.category==cat?'selected':''}>${cat}</option>
          </c:forEach>
        </select>
      </div>
      <div class="form-group"><label class="form-label">제목</label><input type="text" name="title" class="form-control" value="${board.title}" required></div>
      <div class="form-group"><label class="form-label">내용</label><textarea name="content" class="form-control form-textarea" required>${board.content}</textarea></div>
      <div class="form-actions">
        <button type="submit" class="btn-primary">저장</button>
        <a href="${pageContext.request.contextPath}/board/detail?b_idx=${board.b_idx}" class="btn-ghost">취소</a>
      </div>
    </form>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
