<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="새 글 작성 — 게시판"/>
<%@ include file="../common/header.jsp" %>

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<main class="page-main bg-gray">
    <div class="container container-narrow" style="padding-top:2rem; max-width: 800px;">
        <h1 style="font-family:'Noto Serif KR',serif;font-size:1.8rem;font-weight:400;margin-bottom:1.5rem">새 글 작성</h1>

        <form id="boardForm" action="${pageContext.request.contextPath}/board/writeOk" method="post"
              style="background:white;border:1px solid rgba(0,0,0,.1);border-radius:.625rem;padding:2.5rem; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">

            <div class="form-group" style="margin-bottom: 1.5rem;">
                <label class="form-label" style="font-weight: 600;">카테고리</label>
                <select name="category" class="form-control" style="width: 200px; height: 45px;">
                    <c:forEach var="cat" items="${['질문','후기','정보','자유','건의']}">
                        <option value="${cat}">${cat}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 1.5rem;">
                <label class="form-label" style="font-weight: 600;">제목 <span class="required"
                                                                             style="color:red;">*</span></label>
                <input type="text" name="title" id="title" class="form-control" style="height: 45px;"
                       placeholder="제목을 입력하세요" required>
            </div>

            <div class="form-group" style="margin-bottom: 2rem;">
                <label class="form-label" style="font-weight: 600;">내용 <span class="required"
                                                                             style="color:red;">*</span></label>
                <div id="editor-container" style="height: 400px; border-radius: 0 0 .625rem .625rem;"></div>
                <input type="hidden" name="content" id="content">
            </div>

            <div class="form-group" style="margin-bottom: 2rem;">
                <label class="form-label" style="font-weight: 600;">태그</label>
                <input type="text" name="tags" class="form-control" placeholder="#태그를 입력하세요 (쉼표로 구분)">
            </div>

            <div class="form-actions" style="display: flex; gap: 10px; justify-content: flex-end;">
                <a href="${pageContext.request.contextPath}/board/list" class="btn-ghost"
                   style="padding: 10px 20px; text-decoration: none; background: #eee; border-radius: 5px; color: #333;">취소</a>
                <button type="button" onclick="submitBoard()" class="btn-primary"
                        style="padding: 10px 30px; background: #03c75a; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">
                    등록
                </button>
            </div>
        </form>
    </div>
</main>

<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script>
    // 에디터 설정
    var quill = new Quill('#editor-container', {
        theme: 'snow',
        placeholder: '내용을 입력하세요...',
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

    // 폼 등록 시 에디터 내용을 Hidden input에 복사 후 전송
    function submitBoard() {
        var title = document.getElementById('title').value;
        var content = quill.root.innerHTML; // 에디터의 HTML 내용 추출

        if (!title.trim()) {
            alert("제목을 입력해주세요.");
            return;
        }

        // 에디터에 아무 내용이 없는지 체크 (기본값 <p><br></p> 제외)
        if (quill.getText().trim().length === 0) {
            alert("내용을 입력해주세요.");
            return;
        }

        document.getElementById('content').value = content;
        document.getElementById('boardForm').submit();
    }
</script>

<%@ include file="../common/footer.jsp" %>