<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="글 수정 — 게시판"/>
<%@ include file="../common/header.jsp" %>

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<main class="page-main bg-gray">
    <div class="container container-narrow" style="padding-top:2rem; max-width: 800px;">
        <h1 style="font-family:'Noto Serif KR',serif;font-size:1.8rem;font-weight:400;margin-bottom:1.5rem">글 수정</h1>

        <form id="editForm" action="${pageContext.request.contextPath}/board/editOk" method="post"
              style="background:white;border:1px solid rgba(0,0,0,.1);border-radius:.625rem;padding:2.5rem; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">

            <input type="hidden" name="b_idx" value="${board.b_idx}">

            <div class="form-group" style="margin-bottom: 1.5rem;">
                <label class="form-label" style="font-weight: 600;">카테고리</label>
                <select name="category" class="form-control" style="width: 200px; height: 45px;">
                    <c:forEach var="cat" items="${['질문','후기','정보','자유','건의','공지']}">
                        <option value="${cat}" ${board.category == cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 1.5rem;">
                <label class="form-label" style="font-weight: 600;">제목 <span class="required"
                                                                             style="color:red;">*</span></label>
                <input type="text" name="title" id="title" class="form-control" style="height: 45px;"
                       value="${board.title}" required>
            </div>

            <div class="form-group" style="margin-bottom: 2rem;">
                <label class="form-label" style="font-weight: 600;">내용 <span class="required"
                                                                             style="color:red;">*</span></label>
                <div id="editor-container" style="height: 450px; border-radius: 0 0 .625rem .625rem;"></div>
                <input type="hidden" name="content" id="content">
            </div>

            <div class="form-group" style="margin-bottom: 2rem;">
                <label class="form-label" style="font-weight: 600;">태그</label>
                <input type="text" name="tags" class="form-control" placeholder="#태그를 입력하세요" value="${board.tags}">
            </div>

            <div class="form-actions" style="display: flex; gap: 10px; justify-content: flex-end;">
                <a href="${pageContext.request.contextPath}/board/detail?b_idx=${board.b_idx}" class="btn-ghost"
                   style="padding: 10px 20px; text-decoration: none; background: #eee; border-radius: 5px; color: #333;">취소</a>
                <button type="button" onclick="submitEdit()" class="btn-primary"
                        style="padding: 10px 30px; background: #6366f1; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">
                    저장하기
                </button>
            </div>
        </form>
    </div>
</main>

<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script>
    // 에디터 초기화
    var quill = new Quill('#editor-container', {
        theme: 'snow',
        placeholder: '내용을 수정하세요...',
        modules: {
            toolbar: [
                [{'header': [1, 2, false]}],
                ['bold', 'italic', 'underline'],
                ['image', 'code-block'],
                [{'list': 'ordered'}, {'list': 'bullet'}],
                ['clean']
            ]
        }
    });

    // [중요] 기존 DB에 저장되어 있던 HTML 본문을 에디터에 주입
    // JSP의 EL 문법으로 가져온 데이터를 자바스크립트 변수에 안전하게 담습니다.
    var initialContent = `${board.content}`;
    quill.root.innerHTML = initialContent;

    // 수정 완료 버튼 클릭 시
    function submitEdit() {
        var title = document.getElementById('title').value;
        var content = quill.root.innerHTML;

        if (!title.trim()) {
            alert("제목을 입력해주세요.");
            return;
        }

        if (quill.getText().trim().length === 0) {
            alert("내용을 입력해주세요.");
            return;
        }

        // 수정된 내용을 hidden 필드에 담아서 서버로 전송
        document.getElementById('content').value = content;
        document.getElementById('editForm').submit();
    }
</script>

<%@ include file="../common/footer.jsp" %>