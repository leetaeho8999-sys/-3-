<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="로그인 — 로운"/>
<%@ include file="../common/header.jsp" %>

<style>
    body {
        font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
        background-color: #F9F6F0; color: #4A3B32;
    }
    .login-page-container {
        display: flex; justify-content: center; align-items: center;
        min-height: calc(100vh - 80px); padding: 40px 20px;
    }
    .login-box {
        background-color: #FFFFFF; padding: 40px 35px;
        border-radius: 15px; box-shadow: 0 10px 25px rgba(111, 78, 55, 0.15);
        width: 400px; text-align: center; border-top: 8px solid #8B5A2B;
    }
    .login-box h2, .login-box h3 { color: #5D4037; margin-bottom: 25px; font-weight: 800; }
    .login-box input[type="text"], .login-box input[type="password"] {
        width: 100%; padding: 14px; margin: 10px 0;
        border: 1px solid #D7CCC8; border-radius: 8px;
        background-color: #FAFAFA; transition: all 0.3s ease;
        box-sizing: border-box;
    }
    .login-box input:focus { border-color: #8B5A2B; outline: none; box-shadow: 0 0 8px rgba(139, 90, 43, 0.3); }
    .login-box button {
        width: 100%; padding: 14px;
        background-color: #8B5A2B; color: white; border: none; border-radius: 8px;
        cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 15px;
        transition: background-color 0.3s ease; box-sizing: border-box;
    }
    .login-box button:hover { background-color: #6F4E37; }
    .logout-btn { background-color: #A0522D; }
    .link-box { margin-top: 20px; font-size: 13px; color: #8D6E63; }
    .link-box a { color: #D2691E; text-decoration: none; font-weight: bold; margin: 0 5px; }
    .link-box a:hover { text-decoration: underline; }
    #findIdSection, #findPwSection, #pwBox {
        display: none; margin-top: 25px; padding: 20px;
        border-top: 2px dashed #D7CCC8; background-color: #FFFDF8; border-radius: 10px;
    }
    .error-msg { color: #c0392b; background: #fdecea; padding: 10px; border-radius: 8px; margin-bottom: 15px; font-size: 14px; }
</style>

<div class="login-page-container">
<div class="login-box">

    <c:if test="${not empty errorMsg}">
        <div class="error-msg">${errorMsg}</div>
    </c:if>

    <h2>환영합니다! ☕</h2>

    <form action="${pageContext.request.contextPath}/member/loginOk" method="post">
        <input type="hidden" name="redirect" value="<c:out value='${redirect}' />" />
        <input type="text" name="m_id" placeholder="아이디를 입력하세요" required>
        <input type="password" name="m_pw" placeholder="비밀번호를 입력하세요" required>
        <button type="submit">로그인</button>
    </form>

    <div class="link-box">
        <a href="${pageContext.request.contextPath}/member/register">회원가입</a> |
        <a href="javascript:void(0);" onclick="showSection('findIdSection')">아이디 찾기</a> |
        <a href="javascript:void(0);" onclick="showSection('findPwSection')">비밀번호 찾기</a>
    </div>

    <div id="findIdSection">
        <h3>아이디 찾기 🔍</h3>
        <input type="text" id="findIdName" placeholder="성함 입력">
        <input type="text" id="findIdPhone" placeholder="전화번호 입력">
        <button type="button" onclick="findId()">아이디 확인</button>
    </div>

    <div id="findPwSection">
        <h3>비밀번호 찾기 🔍</h3>
        <input type="text" id="pwSearchId" placeholder="아이디 입력">
        <input type="text" id="pwSearchPhone" placeholder="전화번호 입력">
        <button type="button" onclick="findPassword()">비밀번호 확인</button>
    </div>

    <div id="pwBox">
        <h3>새 비밀번호 설정 🔒</h3>
        <input type="hidden" id="resetId">
        <input type="password" id="newPw" placeholder="새 비밀번호">
        <input type="password" id="newPwConfirm" placeholder="비밀번호 재확인">
        <button type="button" onclick="finalReset()">변경하기</button>
    </div>

</div>
</div>

<script>
    var ctx = '${pageContext.request.contextPath}';

    function showSection(id) {
        document.getElementById('findIdSection').style.display = 'none';
        document.getElementById('findPwSection').style.display = 'none';
        document.getElementById('pwBox').style.display = 'none';
        document.getElementById(id).style.display = 'block';
    }

    function findId() {
        var name  = document.getElementById('findIdName').value;
        var phone = document.getElementById('findIdPhone').value;
        if (!name || !phone) { showToast("정보를 모두 입력해주세요.", 'info'); return; }
        fetch(ctx + '/member/findId?m_name=' + name + '&m_phone=' + phone, { method: 'POST' })
            .then(function(res) { return res.text(); })
            .then(function(data) {
                if (data === "fail") showAlert("일치하는 회원 정보가 없습니다.", '조회 실패', 'error');
                else showAlert("회원님의 아이디는 [ " + data + " ] 입니다.", '아이디 찾기', 'success');
            });
    }

    function findPassword() {
        var id    = document.getElementById('pwSearchId').value;
        var phone = document.getElementById('pwSearchPhone').value;
        fetch(ctx + '/member/findPw?m_id=' + id + '&m_phone=' + phone, { method: 'POST' })
            .then(function(res) { return res.text(); })
            .then(async function(data) {
                if (data === "fail") {
                    showAlert("정보가 일치하지 않습니다.", '조회 실패', 'error');
                } else {
                    await showAlert("회원님의 기존 비밀번호는 [ " + data + " ] 입니다.",
                                    '비밀번호 찾기', 'info');
                    document.getElementById('resetId').value = id;
                    showSection('pwBox');
                }
            });
    }

    async function finalReset() {
        var id  = document.getElementById('resetId').value;
        var pw1 = document.getElementById('newPw').value;
        var pw2 = document.getElementById('newPwConfirm').value;
        if (pw1 === pw2 && pw1 !== "") {
            fetch(ctx + '/member/updatePw?m_id=' + id + '&m_pw=' + pw1, { method: 'POST' })
                .then(function(res) { return res.text(); })
                .then(async function(data) {
                    if (data === "success") {
                        await showAlert("변경되었습니다! 새 비번으로 로그인하세요.",
                                        '비밀번호 변경 완료', 'success');
                        location.reload();
                    } else showAlert("변경에 실패했습니다.", '오류', 'error');
                });
        } else showToast("비밀번호를 다시 확인해주세요.", 'info');
    }
</script>

<%@ include file="../common/footer.jsp" %>
