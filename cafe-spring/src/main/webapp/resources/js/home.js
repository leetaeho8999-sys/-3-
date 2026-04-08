document.addEventListener('DOMContentLoaded', function() {
    // 히어로 배경 로드 애니메이션
    var bg = document.getElementById('heroBg');
    if (bg) setTimeout(function() { bg.classList.add('loaded'); }, 100);

    // 헤더 스크롤 효과
    var header = document.getElementById('site-header');
    window.addEventListener('scroll', function() {
        if (header) header.classList.toggle('scrolled', window.scrollY > 60);
    });
});
