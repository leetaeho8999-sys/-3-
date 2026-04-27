<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>카페 단골손님 - 환영합니다</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* ☕ 오리지널 카페 감성 디자인 */
        body { font-family: 'Malgun Gothic', sans-serif; background-color: #fdfaf6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .join-box { background-color: white; padding: 40px 50px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); width: 420px; text-align: center; }
        h2 { color: #5c4033; margin-bottom: 5px; }
        p.subtitle { color: #888; font-size: 14px; margin-bottom: 30px; }

        /* 공통 폼 스타일 */
        .form-group { margin-bottom: 15px; display: flex; gap: 10px; align-items: center; }
        .full-width { margin-bottom: 15px; width: 100%; text-align: left; }
        .full-width input { width: 100%; box-sizing: border-box; }

        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
            flex: 1; padding: 12px; border: 1px solid #e0e0e0; border-radius: 6px; outline: none; font-size: 14px;
        }
        input:focus { border-color: #8B7355; }

        /* 버튼 스타일 */
        button { padding: 12px 18px; background-color: #8B7355; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; white-space: nowrap; transition: 0.2s; }
        button:hover { background-color: #725c44; }
        button:disabled { background-color: #d3d3d3; cursor: not-allowed; }
        .submit-btn { width: 100%; margin-top: 10px; background-color: #5c4033; font-size: 16px; padding: 15px; }

        /* 상태 메시지 (경고/성공 텍스트) */
        .status-msg { font-size: 12px; font-weight: bold; display: block; text-align: left; margin-top: 5px; margin-bottom: 10px; }

        /* 링크 및 하단 메뉴 */
        .link-menu { margin-top: 20px; font-size: 13px; color: #888; display: flex; justify-content: center; gap: 15px; }
        .link-menu span { cursor: pointer; color: #8B7355; font-weight: bold; }
        .link-menu span:hover { text-decoration: underline; }

        .hidden { display: none; }
    </style>
</head>
<body>

<div class="join-box">

    <div id="login-section">
        <h2>단골손님 로그인</h2>
        <p class="subtitle">카페에 오신 것을 환영합니다!</p>

        <form action="/member/loginOk" method="post">
            <div class="full-width">
                <input type="text" name="m_id" placeholder="아이디를 입력하세요" required>
            </div>
            <div class="full-width">
                <input type="password" name="m_pw" placeholder="비밀번호를 입력하세요" required>
            </div>
            <button type="submit" class="submit-btn">로그인</button>
        </form>

        <div class="link-menu">
            <span onclick="findId()">아이디 찾기</span> |
            <span onclick="findPw()">비밀번호 찾기</span> |
            <span onclick="toggleView('join')">회원가입</span>
        </div>
    </div>

    <div id="join-section" class="hidden">
        <h2>새로운 단골손님 등록</h2>
        <p class="subtitle">카페 회원이 되어 다양한 혜택을 누려보세요!</p>

        <form action="/member/join" method="post" id="joinForm">

            <div class="form-group">
                <input type="text" id="m_id" name="m_id" placeholder="사용할 아이디" required>
                <button type="button" id="btnIdCheck">중복확인</button>
            </div>
            <span id="id-warn" class="status-msg"></span>

            <div class="full-width">
                <input type="password" id="m_pw" name="m_pw" placeholder="사용할 비밀번호" required>
            </div>

            <div class="full-width">
                <input type="password" id="m_pw_confirm" placeholder="비밀번호 다시 입력 (확인)" required>
                <span id="pw-warn" class="status-msg"></span>
            </div>

            <div class="full-width">
                <input type="tel" id="m_phone" name="m_phone" placeholder="전화번호 (예: 010-1234-5678)" required>
            </div>

            <div class="form-group">
                <input type="email" id="email" name="m_email" placeholder="실제 이메일 주소 입력" required>
                <button type="button" id="btnSendEmail">인증요청</button>
            </div>

            <div class="form-group">
                <input type="text" id="verifyCode" placeholder="메일로 받은 4자리 입력" maxlength="4" disabled="disabled">
                <button type="button" id="btnVerifyCode" disabled="disabled">인증확인</button>
            </div>
            <span id="mail-check-warn" class="status-msg"></span>

            <button type="button" id="btnFinalSubmit" class="submit-btn" disabled="disabled">단골손님으로 등록하기</button>
        </form>

        <div class="link-menu" style="margin-top: 15px;">
            <span onclick="toggleView('login')">이미 계정이 있으신가요? 로그인으로 돌아가기</span>
        </div>
    </div>

</div>

<script>
    // 상태 체크용 변수들 (모두 true가 되어야 가입 가능)
    let isIdChecked = false;
    let isPwMatched = false;
    let isEmailVerified = false;
    let serverAuthCode = ""; // 실제 메일로 보낸 4자리 인증번호 저장

    // 1. 화면 전환 함수 (로그인 <-> 회원가입)
    function toggleView(type) {
        if(type === 'join') {
            $('#login-section').hide();
            $('#join-section').show();
        } else {
            $('#join-section').hide();
            $('#login-section').show();
        }
    }

    $(document).ready(function() {

        // 2. [아이디 중복확인] 컨트롤러의 /member/idCheck 연동
        $('#btnIdCheck').click(function() {
            const id = $('#m_id').val();
            if(id === '') { alert("아이디를 입력해주세요."); return; }

            $.ajax({
                type: 'POST',
                url: '/member/idCheck',
                data: { "m_id": id },
                success: function(result) {
                    // result가 0이면 사용 가능 (경고문 없이 성공 메시지!)
                    if(result == 0) {
                        $('#id-warn').text('멋진 아이디네요! 사용 가능합니다.').css('color', 'green');
                        isIdChecked = true;
                        $('#m_id').attr('readonly', true); // 아이디 확정
                    } else {
                        $('#id-warn').text('아쉽지만 이미 사용 중인 아이디입니다.').css('color', 'red');
                        isIdChecked = false;
                    }
                    checkAllStatus();
                }
            });
        });

        // 3. [비밀번호 확인] 입력할 때마다 실시간으로 일치하는지 체크
        $('#m_pw, #m_pw_confirm').on('keyup', function() {
            const pw = $('#m_pw').val();
            const pwConfirm = $('#m_pw_confirm').val();

            if(pw === '' && pwConfirm === '') {
                $('#pw-warn').text('');
                isPwMatched = false;
                return;
            }

            if(pw === pwConfirm) {
                $('#pw-warn').text('비밀번호가 일치합니다!').css('color', 'green');
                isPwMatched = true;
            } else {
                $('#pw-warn').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
                isPwMatched = false;
            }
            checkAllStatus();
        });

        // 4. [실제 이메일 인증 발송]
        $('#btnSendEmail').click(function() {
            const email = $('#email').val();
            if (email === '') { alert('실제 존재하는 이메일을 입력해주세요.'); return; }

            alert('입력하신 실제 이메일로 인증번호 4자리를 발송 중입니다. 잠시만 기다려주세요...');

            $.ajax({
                type: 'GET',
                url: '/mailCheck?email=' + email, // 컨트롤러의 메일 발송 주소
                success: function(data) {
                    serverAuthCode = data; // 백엔드에서 생성된 실제 4자리 코드 저장
                    alert('성공! 메일함(또는 스팸함)을 확인하여 4자리 숫자를 입력해주세요.');
                    $('#verifyCode').attr('disabled', false);
                    $('#btnVerifyCode').attr('disabled', false);
                    $('#email').attr('readonly', true);
                },
                error: function() {
                    alert('메일 발송 에러: 네이버 서버 비밀번호 설정이나 인터넷 연결을 확인하세요.');
                }
            });
        });

        // 5. [인증번호 확인]
        $('#btnVerifyCode').click(function() {
            const inputCode = $('#verifyCode').val();

            if (inputCode === serverAuthCode) {
                $('#mail-check-warn').text('이메일 인증이 완벽하게 성공했습니다! ✅').css('color', 'green');
                isEmailVerified = true;

                $('#verifyCode').attr('readonly', true);
                $('#btnVerifyCode').attr('disabled', true);
            } else {
                $('#mail-check-warn').text('인증번호 4자리가 틀렸습니다. 다시 확인해주세요.').css('color', 'red');
                isEmailVerified = false;
            }
            checkAllStatus();
        });

        // 6. [최종 회원가입 제출]
        $('#btnFinalSubmit').click(function() {
            const phone = $('#m_phone').val();
            if(phone === '') {
                alert("전화번호를 입력해주세요!");
                $('#m_phone').focus();
                return;
            }

            alert('축하합니다! 카페 단골손님으로 완벽하게 등록되었습니다.');
            $('#joinForm').submit(); // 실제 DB로 데이터 전송
        });

    });

    // 모든 조건(아이디, 비번, 이메일)이 통과되었는지 확인하여 최종 버튼 활성화
    function checkAllStatus() {
        if(isIdChecked && isPwMatched && isEmailVerified) {
            $('#btnFinalSubmit').attr('disabled', false);
        } else {
            $('#btnFinalSubmit').attr('disabled', true);
        }
    }

    // 아이디 찾기 기능 (컨트롤러 /member/findId 연동)
    function findId() {
        const name = prompt("가입하신 이름을 입력하세요 (예: 홍길동)");
        if(!name) return;
        const phone = prompt("가입하신 전화번호를 입력하세요 (예: 010-1234-5678)");
        if(!phone) return;

        $.post('/member/findId', { m_name: name, m_phone: phone }, function(res) {
            if(res === 'fail') alert("해당 정보로 가입된 아이디를 찾을 수 없습니다.");
            else alert("고객님의 아이디는 [" + res + "] 입니다.");
        });
    }

    // 비밀번호 찾기 기능 (컨트롤러 /member/findPw 연동)
    function findPw() {
        const id = prompt("가입하신 아이디를 입력하세요");
        if(!id) return;
        const phone = prompt("가입하신 전화번호를 입력하세요");
        if(!phone) return;

        $.post('/member/findPw', { m_id: id, m_phone: phone }, function(res) {
            if(res === 'fail') alert("정보가 일치하지 않습니다.");
            else alert("고객님의 비밀번호는 [" + res + "] 입니다. 로그인 후 반드시 변경해주세요.");
        });
    }
</script>
</body>
</html>