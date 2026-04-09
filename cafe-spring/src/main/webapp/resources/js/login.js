// login.js — 로그인 페이지 전용

document.addEventListener('DOMContentLoaded', function () {
    // 이메일 입력란에 자동 포커스
    var emailInput = document.getElementById('email');
    if (emailInput) emailInput.focus();

    // 엔터 키로 폼 제출 (비밀번호 입력란에서 엔터 시)
    var pwInput = document.getElementById('password');
    if (pwInput) {
        pwInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                var form = pwInput.closest('form');
                if (form) form.submit();
            }
        });
    }
});
