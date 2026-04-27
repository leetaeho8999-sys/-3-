function showTab(id, btn) {
    document.querySelectorAll('.menu-section').forEach(function(s) { s.classList.remove('active'); });
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    document.getElementById(id).classList.add('active');
    btn.classList.add('active');
}

function imgError(img) {
    var ph = document.createElement('div');
    ph.className = 'img-placeholder';
    ph.textContent = '이미지 준비 중';
    img.parentNode.replaceChild(ph, img);
}
