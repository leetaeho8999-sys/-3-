<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>나의 커피숍 메인 ☕</title>
    <style>
        /* 1. 전체 배경 & 레이아웃 */
        body {
            font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
            background-color: #F9F6F0; color: #4A3B32;
            display: flex; justify-content: center; align-items: center;
            height: 100vh; margin: 0;
        }

        /* 2. 메인 컨테이너 */
        .container {
            background-color: #FFFFFF; padding: 40px 35px;
            border-radius: 15px; box-shadow: 0 10px 25px rgba(111, 78, 55, 0.15);
            width: 400px; text-align: center; border-top: 8px solid #8B5A2B;
        }

        h2, h3 { color: #5D4037; margin-bottom: 25px; font-weight: 800; }

        /* 3. 입력창 디자인 */
        input[type="text"], input[type="password"] {
            width: 100%; padding: 14px; margin: 10px 0;
            border: 1px solid #D7CCC8; border-radius: 8px;
            background-color: #FAFAFA; transition: all 0.3s ease;
            box-sizing: border-box;
        }

        input:focus { border-color: #8B5A2B; outline: none; box-shadow: 0 0 8px rgba(139, 90, 43, 0.3); }

        /* 4. 버튼 디자인 */
        button {
            width: 100%; padding: 14px;
            background-color: #8B5A2B; color: white; border: none; border-radius: 8px;
            cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 15px;
            transition: background-color 0.3s ease; box-sizing: border-box;
        }

        button:hover { background-color: #6F4E37; }
        .logout-btn { background-color: #A0522D; }

        /* 5. 링크 구역 (아이디/비번 찾기 등) */
        .link-box { margin-top: 20px; font-size: 13px; color: #8D6E63; }
        .link-box a { color: #D2691E; text-decoration: none; font-weight: bold; margin: 0 5px; }
        .link-box a:hover { text-decoration: underline; }

        /* 6. 숨겨진 기능 섹션들 */
        #findIdSection, #findPwSection, #pwBox {
            display: none; margin-top: 25px; padding: 20px;
            border-top: 2px dashed #D7CCC8; background-color: #FFFDF8; border-radius: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <% if(request.getAttribute("errorMsg") != null) { %>
    <script>alert("<%= request.getAttribute("errorMsg") %>");</script>
    <% } %>

    <h2>환영합니다! ☕</h2>

    <% if(session.getAttribute("m_id") == null) { %>
    <form action="/member/loginOk" method="post">
        <input type="text" name="m_id" placeholder="아이디를 입력하세요" required>
        <input type="password" name="m_pw" placeholder="비밀번호를 입력하세요" required>
        <button type="submit">로그인</button>
    </form>

    <div class="link-box">
        <a href="/member/joinForm">회원가입</a> |
        <a href="javascript:void(0);" onclick="showSection('findIdSection')">아이디 찾기</a> |
        <a href="javascript:void(0);" onclick="showSection('findPwSection')">비밀번호 찾기</a>
    </div>

    <% } else { %>
    <h3>🎉 <%= session.getAttribute("m_name") %>님, 반갑습니다!</h3>
    <button type="button" class="logout-btn" onclick="location.href='/logout'">로그아웃</button>
    <% } %>

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

<script>
    // 섹션 전환 함수 (깔끔하게 하나만 보여주기)
    function showSection(id) {
        document.getElementById('findIdSection').style.display = 'none';
        document.getElementById('findPwSection').style.display = 'none';
        document.getElementById('pwBox').style.display = 'none';
        document.getElementById(id).style.display = 'block';
    }

    // 1. 아이디 찾기 로직
    function findId() {
        const name = document.getElementById('findIdName').value;
        const phone = document.getElementById('findIdPhone').value;

        if(!name || !phone) { alert("정보를 모두 입력해주세요."); return; }

        fetch('/member/findId?m_name=' + name + '&m_phone=' + phone, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "fail") alert("❌ 일치하는 회원 정보가 없습니다.");
                else alert("☕ 회원님의 아이디는 [ " + data + " ] 입니다.");
            });
    }

    // 2. 비밀번호 찾기 로직
    function findPassword() {
        const id = document.getElementById('pwSearchId').value;
        const phone = document.getElementById('pwSearchPhone').value;

        fetch('/member/findPw?m_id=' + id + '&m_phone=' + phone, { method: 'POST' })
            .then(res => res.text())
            .then(data => {
                if(data === "fail") alert("❌ 정보가 일치하지 않습니다.");
                else {
                    alert("회원님의 기존 비밀번호는 [ " + data + " ] 입니다.");
                    document.getElementById('resetId').value = id;
                    showSection('pwBox');
                }
            });
    }

    // 3. 비밀번호 재설정 로직
    function finalReset() {
        const id = document.getElementById('resetId').value;
        const pw1 = document.getElementById('newPw').value;
        const pw2 = document.getElementById('newPwConfirm').value;

        if(pw1 === pw2 && pw1 !== "") {
            fetch('/member/updatePw?m_id=' + id + '&m_pw=' + pw1, { method: 'POST' })
                .then(res => res.text())
                .then(data => {
                    if(data === "success") {
                        alert("✅ 변경되었습니다! 새 비번으로 로그인하세요.");
                        location.reload();
                    } else alert("❌ 변경 실패!");
                });
        } else alert("비밀번호를 다시 확인해주세요.");
    }
</script>
</body>
</html>