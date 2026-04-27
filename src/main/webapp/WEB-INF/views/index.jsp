<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>나의 커피숍 메인 ☕</title>
    <style>
        /* 사용자님의 소중한 디자인 스타일 그대로 유지 */
        body { font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif; background-color: #F9F6F0; color: #4A3B32; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background-color: #FFFFFF; padding: 40px 35px; border-radius: 15px; box-shadow: 0 10px 25px rgba(111, 78, 55, 0.15); width: 440px; text-align: center; border-top: 8px solid #8B5A2B; box-sizing: border-box; }
        h2, h3 { color: #5D4037; margin-bottom: 25px; font-weight: 800; }
        input[type="text"], input[type="password"], input[type="email"] { width: 100%; padding: 12px; margin: 6px 0; border: 1px solid #D7CCC8; border-radius: 8px; background-color: #FAFAFA; transition: all 0.3s ease; box-sizing: border-box; font-size: 14px; }
        input:focus { border-color: #8B5A2B; outline: none; box-shadow: 0 0 8px rgba(139, 90, 43, 0.3); }
        input[readonly] { background-color: #EFEBE9; color: #8D6E63; cursor: not-allowed; }
        .input-group { display: flex; gap: 8px; margin: 6px 0; }
        button { width: 100%; padding: 12px; background-color: #8B5A2B; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 15px; font-weight: bold; margin-top: 10px; transition: background-color 0.3s ease; box-sizing: border-box; }
        button:hover { background-color: #6F4E37; }
        .sub-btn { width: 140px; background-color: #A1887F; margin-top: 0; }
        .logout-btn { background-color: #A0522D; }
        .cancel-btn { background-color: #A0522D; margin-top: 10px; }
        .link-box { margin-top: 20px; font-size: 13px; color: #8D6E63; }
        .link-box a { color: #D2691E; text-decoration: none; font-weight: bold; margin: 0 5px; cursor: pointer; }
        .link-box a:hover { text-decoration: underline; }
        #joinSection, #findIdSection, #findPwSection, #pwBox { display: none; margin-top: 15px; }
        #authBox { display: none; background-color: #FFF3E0; padding: 15px; border-radius: 8px; margin-top: 5px; }
    </style>
</head>
<body>

<div class="container">
    <% if(request.getAttribute("errorMsg") != null) { %>
    <script>alert("<%= request.getAttribute("errorMsg") %>");</script>
    <% } %>

    <% if(session.getAttribute("m_id") != null) { %>
    <h2>환영합니다! ☕</h2>
    <h3>🎉 <%= session.getAttribute("m_name") %>님, 반갑습니다!</h3>
    <button type="button" class="logout-btn" onclick="location.href='/member/logout'">로그아웃</button>
    <% } else { %>
    <div id="loginSection">
        <h2>환영합니다! ☕</h2>
        <form action="/member/loginOk" method="post">
            <input type="text" name="m_id" placeholder="아이디를 입력하세요" required>
            <input type="password" name="m_pw" placeholder="비밀번호를 입력하세요" required>
            <button type="submit">로그인</button>
        </form>

        <div class="link-box">
            <a onclick="showSection('joinSection')">회원가입</a> |
            <a onclick="showSection('findIdSection')">아이디 찾기</a> |
            <a onclick="showSection('findPwSection')">비밀번호 찾기</a>
        </div>
    </div>

    <div id="joinSection">
        <h2>새로운 단골손님 등록 ☕</h2>
        <form action="/member/join" method="post" onsubmit="return finalCheck()">
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
            <input type="text" name="m_phone" placeholder="전화번호 (010-0000-0000)" required>

            <div class="input-group">
                <input type="email" id="joinEmail" name="m_email" placeholder="이메일 주소" required>
                <button type="button" class="sub-btn" onclick="sendEmailAuth()">인증요청</button>
            </div>

            <div id="authBox">
                <div class="input-group">
                    <input type="text" id="authCodeInput" placeholder="인증번호 4자리">
                    <button type="button" class="sub-btn" style="background-color: #6D4C41;" onclick="verifyEmailAuth()">확인</button>
                </div>
            </div>
            <input type="hidden" id="isEmailVerified" value="false">

            <button type="submit" style="margin-top: 20px; font-size: 17px;">가입 신청하기</button>
            <button type="button" class="cancel-btn" onclick="showSection('loginSection')">로그인으로 돌아가기</button>
        </form>
    </div>

    <div id="findIdSection">
        <h3>아이디 찾기 🔍</h3>
        <input type="text" id="findIdName" placeholder="성함 입력">
        <input type="text" id="findIdPhone" placeholder="전화번호 입력">
        <button type="button" onclick="findId()">아이디 확인</button>
        <button type="button" class="cancel-btn" onclick="showSection('loginSection')">돌아가기</button>
    </div>

    <div id="findPwSection">
        <h3>비밀번호 찾기 🔍</h3>
        <input type="text" id="pwSearchId" placeholder="아이디 입력">
        <input type="text" id="pwSearchPhone" placeholder="전화번호 입력">
        <button type="button" onclick="findPassword()">비밀번호 확인</button>
        <button type="button" class="cancel-btn" onclick="showSection('loginSection')">돌아가기</button>
    </div>

    <div id="pwBox">
        <h3>새 비밀번호 설정 🔒</h3>
        <input type="hidden" id="resetId">
        <input type="password" id="newPw" placeholder="새 비밀번호">
        <input type="password" id="newPwConfirm" placeholder="비밀번호 재확인">
        <button type="button" onclick="finalReset()">변경하기</button>
    </div>
    <% } %>
</div>

<script>
    function showSection(id) {
        document.getElementById('loginSection').style.display = 'none';
        document.getElementById('joinSection').style.display = 'none';
        document.getElementById('findIdSection').style.display = 'none';
        document.getElementById('findPwSection').style.display = 'none';
        document.getElementById('pwBox').style.display = 'none';
        document.getElementById(id).style.display = 'block';
    }

    function checkId() {
        const id = document.getElementById('joinId').value;
        if(!id) { alert("아이디를 입력해주세요."); return; }
        // 🚨 [수정] 컨트롤러의 @RequestParam("m_id")와 맞춤
        fetch('/member/idCheck?m_id=' + id, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data.trim() === "0") {
                    alert("✅ 사용 가능한 아이디입니다.");
                    document.getElementById('isIdChecked').value = "true";
                    document.getElementById('joinId').readOnly = true;
                } else alert("❌ 이미 사용 중인 아이디입니다.");
            });
    }

    function checkPwMatch() {
        const pw1 = document.getElementById('joinPw').value;
        const pw2 = document.getElementById('joinPwConfirm').value;
        if(!pw1 || !pw2) { alert("비밀번호를 입력해주세요!"); return; }
        if(pw1 === pw2) {
            alert("✅ 비밀번호가 일치합니다!");
            document.getElementById('isPwChecked').value = "true";
        } else alert("❌ 비밀번호가 다릅니다.");
    }

    let savedAuthCode = "";
    function sendEmailAuth() {
        const email = document.getElementById('joinEmail').value;
        if(!email) { alert("이메일을 입력해주세요!"); return; }
        // 🚨 [수정] 사용자님의 실제 메일 체크 주소 (/mailCheck) 확인 필요
        fetch('/mailCheck?email=' + email)
            .then(res => res.text())
            .then(data => {
                savedAuthCode = data.trim();
                alert("☕ 인증번호가 발송되었습니다!");
                document.getElementById('authBox').style.display = 'block';
            });
    }

    function verifyEmailAuth() {
        const inputCode = document.getElementById('authCodeInput').value;
        if(inputCode === savedAuthCode) {
            alert("✅ 인증 성공!");
            document.getElementById('isEmailVerified').value = "true";
        } else alert("❌ 인증번호 불일치");
    }

    function finalCheck() {
        if(document.getElementById('isIdChecked').value !== "true") { alert("아이디 중복확인 필수!"); return false; }
        if(document.getElementById('isPwChecked').value !== "true") { alert("비밀번호 확인 필수!"); return false; }
        if(document.getElementById('isEmailVerified').value !== "true") { alert("이메일 인증 필수!"); return false; }
        return true;
    }

    function findId() {
        const name = document.getElementById('findIdName').value;
        const phone = document.getElementById('findIdPhone').value;
        fetch('/member/findId?m_name=' + name + '&m_phone=' + phone, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "fail") alert("정보가 없습니다.");
                else alert("아이디: " + data);
            });
    }

    function findPassword() {
        const id = document.getElementById('pwSearchId').value;
        const phone = document.getElementById('pwSearchPhone').value;
        fetch('/member/findPw?m_id=' + id + '&m_phone=' + phone, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "fail") alert("정보 불일치");
                else {
                    document.getElementById('resetId').value = id;
                    showSection('pwBox');
                }
            });
    }

    function finalReset() {
        const id = document.getElementById('resetId').value;
        const pw = document.getElementById('newPw').value;
        fetch('/member/updatePw?m_id=' + id + '&m_pw=' + pw, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "success") { alert("변경 완료!"); location.reload(); }
            });
    }
</script>
</body>
</html>