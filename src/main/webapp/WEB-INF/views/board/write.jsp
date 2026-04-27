<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="새 글 작성 — 게시판"/>
<%@ include file="../common/header.jsp" %>
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board-form.css">

<div class="bf-page">

  <div class="bf-hero">
    <div class="bf-hero__inner">
      <p class="bf-hero__eyebrow">Community · Write</p>
      <h1 class="bf-hero__title">새 글 작성</h1>
    </div>
  </div>

  <div class="bf-body">
    <div class="bf-card">

      <c:if test="${not empty errorMsg}">
        <div class="bf-alert bf-alert--error">${errorMsg}</div>
      </c:if>

      <form id="boardForm" action="${pageContext.request.contextPath}/board/writeOk" method="post">

        <%-- 카테고리 --%>
        <div class="bf-group">
          <label class="bf-label">카테고리</label>
          <select name="category" class="bf-select">
            <c:forEach var="cat" items="${['질문','후기','정보','자유','건의']}">
              <option value="${cat}">${cat}</option>
            </c:forEach>
          </select>
        </div>

        <%-- 제목 --%>
        <div class="bf-group">
          <label class="bf-label">제목 <span class="bf-required">*</span></label>
          <input type="text" name="title" id="title" class="bf-input bf-input--title"
                 placeholder="제목을 입력하세요" required>
        </div>

        <%-- 내용 --%>
        <div class="bf-group">
          <label class="bf-label">내용 <span class="bf-required">*</span></label>
          <div class="bf-editor-wrap">
            <div id="editor-container"></div>
          </div>
          <input type="hidden" name="content" id="content">
        </div>

        <%-- 태그 --%>
        <div class="bf-group">
          <label class="bf-label">태그</label>
          <input type="text" name="tags" class="bf-input bf-input--tag"
                 placeholder="#태그를 입력하세요 (쉼표로 구분)">
          <div class="bf-input-hint">예) #커피추천, #아메리카노, #원두</div>
        </div>

        <div class="bf-divider"></div>

        <div class="bf-actions">
          <a href="${pageContext.request.contextPath}/board/list" class="bf-btn bf-btn--cancel">취소</a>
          <button type="button" onclick="submitBoard()" class="bf-btn bf-btn--primary">등록하기</button>
        </div>

      </form>
    </div>
  </div>

</div>

<%-- 이미지 업로드용 숨김 파일 입력 --%>
<input type="file" id="imageUploadInput" accept="image/jpeg,image/png,image/gif,image/webp" style="display:none">

<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script>
  const quill = new Quill('#editor-container', {
    theme: 'snow',
    placeholder: '로운 카페에 대한 이야기를 자유롭게 나눠보세요...',
    modules: {
      toolbar: {
        container: [
          [{ 'header': [1, 2, false] }],
          ['bold', 'italic', 'underline'],
          ['image', 'code-block'],
          [{ 'list': 'ordered' }, { 'list': 'bullet' }],
          ['clean']
        ],
        handlers: {
          image: function() {
            document.getElementById('imageUploadInput').click();
          }
        }
      }
    }
  });

  document.getElementById('imageUploadInput').addEventListener('change', function() {
    const file = this.files[0];
    if (!file) return;

    if (file.size > 5 * 1024 * 1024) {
      showAlert('이미지 파일은 5MB를 초과할 수 없습니다.', '용량 초과', 'warning');
      this.value = '';
      return;
    }

    const formData = new FormData();
    formData.append('file', file);

    fetch('${pageContext.request.contextPath}/board/uploadImage', {
      method: 'POST',
      body: formData
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data.error) {
        showAlert(data.error, '업로드 실패', 'error');
        return;
      }
      const range = quill.getSelection(true);
      quill.insertEmbed(range.index, 'image', data.url);
      quill.setSelection(range.index + 1);
    })
    .catch(function() {
      showAlert('이미지 업로드에 실패했습니다. 다시 시도해주세요.', '업로드 실패', 'error');
    })
    .finally(function() {
      document.getElementById('imageUploadInput').value = '';
    });
  });

  function submitBoard() {
    var title   = document.getElementById('title').value;
    var content = quill.root.innerHTML;

    if (!title.trim()) {
      showToast('제목을 입력해주세요.', 'info');
      return;
    }
    if (quill.getText().trim().length === 0) {
      showToast('내용을 입력해주세요.', 'info');
      return;
    }

    document.getElementById('content').value = content;
    document.getElementById('boardForm').submit();
  }
</script>

<%@ include file="../common/footer.jsp" %>
