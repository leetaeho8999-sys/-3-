// register.js — 회원가입 페이지 전용

function validateRegister() {
    var pw  = document.getElementById('pw').value;
    var cpw = document.getElementById('pw2').value;
    var err = document.getElementById('client-error');

    if (pw !== cpw) {
        err.textContent = '비밀번호가 일치하지 않습니다.';
        err.style.display = 'block';
        return false;
    }
    if (pw.length < 8) {
        err.textContent = '비밀번호는 최소 8자 이상이어야 합니다.';
        err.style.display = 'block';
        return false;
    }

    err.style.display = 'none';
    return true;
}
