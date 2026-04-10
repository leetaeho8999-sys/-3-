<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커피숍 단골손님 가입 ☕</title>
    <style>
        body {
            font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
            background-color: #F9F6F0; color: #4A3B32;
            display: flex; justify-content: center; align-items: center;
            height: 100vh; margin: 0;
        }
        .container {
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

        .sub-btn { width: 140px; background-color: #A1887F; } /* 중복/인증/일치 버튼 */
        .join-btn { width: 100%; margin-top: 20px; font-size: 17px; }
        .cancel-btn { width: 100%; background-color: #A0522D; margin-top: 10px; }

        #authBox { display: none; background-color: #FFF3E0; padding: 15px; border-radius: 8px; margin-top: 5px; }
        .guide-text { font-size: 11px; text-align: left; margin-top: -5px; margin-bottom: 10px; color: #8B5A2B; padding-left: 5px;}
    </style>
</head>
<body>

<div class="container">
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
        <button type="button" class="cancel-btn" onclick="location.href='/'">취소</button>
    </form>
</div>

<script>
    let generatedCode = "";

    // [아이디 중복확인]
    function checkId() {
        const id = document.getElementById('joinId').value;
        if(!id) { alert("아이디를 입력해주세요."); return; }
        fetch('/member/idCheck?m_id=' + id, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "0") {
                    alert("✅ 사용 가능한 아이디입니다.");
                    document.getElementById('isIdChecked').value = "true";
                    document.getElementById('joinId').readOnly = true;
                } else alert("❌ 이미 사용 중인 아이디입니다.");
            });
    }

    // [NEW! 비밀번호 일치확인]
    function checkPwMatch() {
        const pw1 = document.getElementById('joinPw').value;
        const pw2 = document.getElementById('joinPwConfirm').value;
        if(!pw1 || !pw2) { alert("비밀번호를 두 칸 모두 입력해주세요!"); return; }

        if(pw1 === pw2) {
            alert("✅ 비밀번호가 일치합니다!");
            document.getElementById('isPwChecked').value = "true";
            document.getElementById('joinPw').readOnly = true;
            document.getElementById('joinPwConfirm').readOnly = true;
        } else {
            alert("❌ 비밀번호가 서로 다릅니다. 다시 확인해주세요.");
            document.getElementById('joinPwConfirm').value = "";
            document.getElementById('joinPwConfirm').focus();
        }
    }

    // [전화번호 인증번호 발송]
    function sendSms() {
        const phone = document.getElementById('joinPhone').value;
        if(!phone) { alert("번호를 입력해주세요."); return; }
        generatedCode = Math.floor(1000 + Math.random() * 9000).toString();
        alert("☕ [인증번호]: " + generatedCode);
        document.getElementById('authBox').style.display = 'block';
    }

    // [전화번호 인증확인]
    function verifySms() {
        const inputCode = document.getElementById('authCodeInput').value;
        if(inputCode === generatedCode) {
            alert("✅ 인증되었습니다.");
            document.getElementById('isPhoneVerified').value = "true";
            document.getElementById('authBox').style.display = 'none';
            document.getElementById('joinPhone').readOnly = true;
        } else alert("❌ 인증번호를 다시 확인해주세요.");
    }

    // [최종 수문장 체크]
    function finalCheck() {
        if(document.getElementById('isIdChecked').value !== "true") {
            alert("아이디 중복확인을 해주세요!"); return false;
        }
        if(document.getElementById('isPwChecked').value !== "true") {
            alert("비밀번호 일치확인을 해주세요!"); return false;
        }
        if(document.getElementById('isPhoneVerified').value !== "true") {
            alert("전화번호 인증을 해주세요!"); return false;
        }
        return true;
    }
</script>
</body>
</html>