<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="글쓰기 — 게시판"/>
<%@ include file="../common/header.jsp" %>
<main class="page-main bg-gray">
  <div class="container container-narrow" style="padding-top:2rem">
    <h1 style="font-family:'Noto Serif KR',serif;font-size:1.8rem;font-weight:400;margin-bottom:1.5rem">새 글 작성</h1>
    <form action="${pageContext.request.contextPath}/board/writeOk" method="post" style="background:white;border:1px solid rgba(0,0,0,.1);border-radius:.625rem;padding:2rem">
      <div class="form-group"><label class="form-label">카테고리</label>
        <select name="category" class="form-control">
          <option>질문</option><option>후기</option><option>정보</option><option>자유</option><option>건의</option>
        </select>
      </div>
      <div class="form-group"><label class="form-label">제목 <span class="required">*</span></label><input type="text" name="title" class="form-control" placeholder="제목을 입력하세요" required></div>
      <div class="form-group"><label class="form-label">내용 <span class="required">*</span></label><textarea name="content" class="form-control form-textarea" placeholder="내용을 입력하세요" required></textarea></div>
      <div class="form-actions">
        <button type="submit" class="btn-primary">등록</button>
        <a href="${pageContext.request.contextPath}/board/list" class="btn-ghost">취소</a>
      </div>
    </form>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
