<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="회원가입 — 로운"/>
<%@ include file="../common/header.jsp" %>

<style>
    body {
        font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
        background-color: #F9F6F0; color: #4A3B32;
    }
    .container {
        display: flex; justify-content: center; align-items: center;
        min-height: calc(100vh - 80px); padding: 40px 20px;
    }
    .register-box {
        background-color: #FFFFFF; padding: 40px 35px;
        border-radius: 15px; box-shadow: 0 10px 25px rgba(111, 78, 55, 0.15);
        width: 440px; text-align: center; border-top: 8px solid #8B5A2B;
    }
    h2 { color: #5D4037; margin-bottom: 20px; font-weight: 800; }
    .input-group { display: flex; gap: 8px; margin: 8px 0; }
    input {
        width: 100%; padding: 12px;
        border: 1px solid #D7CCC8; border-radius: 8px;
        background-color: #FAFAFA; transition: all 0.3s ease;
        box-sizing: border-box; font-size: 14px;
    }
    input:focus { border-color: #8B5A2B; outline: none; box-shadow: 0 0 8px rgba(139, 90, 43, 0.3); }
    input[readonly] { background-color: #EFEBE9; color: #8D6E63; cursor: not-allowed; }
    button {
        padding: 12px; background-color: #8B5A2B; color: white;
        border: none; border-radius: 8px; cursor: pointer;
        font-size: 14px; font-weight: bold; transition: background-color 0.3s ease;
    }
    button:hover { background-color: #6F4E37; }
    .sub-btn { width: 140px; background-color: #A1887F; }
    .join-btn { width: 100%; margin-top: 20px; font-size: 17px; }
    .cancel-btn { width: 100%; background-color: #A0522D; margin-top: 10px; }
    #authBox { display: none; background-color: #FFF3E0; padding: 15px; border-radius: 8px; margin-top: 5px; }
    .error-msg { color: #c0392b; background: #fdecea; padding: 10px; border-radius: 8px; margin-bottom: 15px; font-size: 14px; }
    .link-box { margin-top: 20px; font-size: 13px; color: #8D6E63; }
    .link-box a { color: #D2691E; text-decoration: none; font-weight: bold; }
    .link-box a:hover { text-decoration: underline; }
</style>

<div class="container">
<div class="register-box">
    <h2>새로운 단골손님 등록 ☕</h2>

    <c:if test="${not empty errorMsg}">
        <div class="error-msg">${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/registerOk" method="post" onsubmit="return finalCheck()">

        <div class="input-group">
            <input type="text" id="joinId" name="m_id" placeholder="아이디" required>
            <button type="button" class="sub-btn" onclick="checkId()">중복확인</button>
        </div>
        <input type="hidden" id="isIdChecked" value="false">

        <input type="password" id="joinPw" name="m_pw" placeholder="비밀번호 입력" required>
        <div class="input-group">
            <input type="password" id="joinPwConfirm" placeholder="비밀번호 확인" required>
            <button type="button" class="sub-btn" onclick="checkPwMatch()">일치확인</button>
        </div>
        <input type="hidden" id="isPwChecked" value="false">

        <input type="text" name="m_name" placeholder="성함 (이름)" required>

        <div class="input-group">
            <input type="text" id="joinPhone" name="m_phone" placeholder="전화번호 (010-0000-0000)" required>
            <button type="button" class="sub-btn" onclick="sendSms()">인증요청</button>
        </div>
        <div id="authBox">
            <div class="input-group">
                <input type="text" id="authCodeInput" placeholder="인증번호 4자리">
                <button type="button" class="sub-btn" style="background-color: #6D4C41;" onclick="verifySms()">확인</button>
            </div>
        </div>
        <input type="hidden" id="isPhoneVerified" value="false">

        <input type="email" name="m_email" placeholder="이메일 주소" required>

        <button type="submit" class="join-btn">가입 신청하기</button>
        <button type="button" class="cancel-btn" onclick="location.href='${pageContext.request.contextPath}/member/login'">취소</button>
    </form>

    <div class="link-box">
        이미 계정이 있으신가요?
        <a href="${pageContext.request.contextPath}/member/login">로그인</a>
    </div>
</div>
</div>

<script>
    var ctx = '${pageContext.request.contextPath}';
    var generatedCode = "";

    function checkId() {
        var id = document.getElementById('joinId').value;
        if (!id) { showToast("아이디를 입력해주세요.", 'info'); return; }
        fetch(ctx + '/member/idCheck?m_id=' + id, { method: 'POST' })
            .then(function(res) { return res.text(); })
            .then(function(data) {
                if (data === "0") {
                    showToast("사용 가능한 아이디입니다.", 'success');
                    document.getElementById('isIdChecked').value = "true";
                    document.getElementById('joinId').readOnly = true;
                } else showAlert("이미 사용 중인 아이디입니다.", '중복', 'error');
            });
    }

    function checkPwMatch() {
        var pw1 = document.getElementById('joinPw').value;
        var pw2 = document.getElementById('joinPwConfirm').value;
        if (!pw1 || !pw2) { showToast("비밀번호를 두 칸 모두 입력해주세요.", 'info'); return; }
        if (pw1 === pw2) {
            showToast("비밀번호가 일치합니다.", 'success');
            document.getElementById('isPwChecked').value = "true";
            document.getElementById('joinPw').readOnly = true;
            document.getElementById('joinPwConfirm').readOnly = true;
        } else {
            showAlert("비밀번호가 서로 다릅니다. 다시 확인해주세요.", '비밀번호 불일치', 'error');
            document.getElementById('joinPwConfirm').value = "";
            document.getElementById('joinPwConfirm').focus();
        }
    }

    function sendSms() {
        var phone = document.getElementById('joinPhone').value;
        if (!phone) { showToast("번호를 입력해주세요.", 'info'); return; }
        generatedCode = Math.floor(1000 + Math.random() * 9000).toString();
        showAlert("인증번호: " + generatedCode, '인증번호 발송', 'info');
        document.getElementById('authBox').style.display = 'block';
    }

    function verifySms() {
        var inputCode = document.getElementById('authCodeInput').value;
        if (inputCode === generatedCode) {
            showToast("인증되었습니다.", 'success');
            document.getElementById('isPhoneVerified').value = "true";
            document.getElementById('authBox').style.display = 'none';
            document.getElementById('joinPhone').readOnly = true;
        } else showAlert("인증번호를 다시 확인해주세요.", '인증 실패', 'error');
    }

    function finalCheck() {
        if (document.getElementById('isIdChecked').value !== "true") {
            showToast("아이디 중복확인을 해주세요.", 'info'); return false;
        }
        if (document.getElementById('isPwChecked').value !== "true") {
            showToast("비밀번호 일치확인을 해주세요.", 'info'); return false;
        }
        if (document.getElementById('isPhoneVerified').value !== "true") {
            showToast("전화번호 인증을 해주세요.", 'info'); return false;
        }
        return true;
    }
</script>

<%@ include file="../common/footer.jsp" %>
