// ============================================================
// 정성을 다한 커피 — app.js
// React(TypeScript) → 순수 JavaScript 변환
// ============================================================

// ── 헤더 스크롤 (useEffect + useState → addEventListener) ──
(function () {
    var header = document.getElementById('site-header');
    if (!header) return;
    function handleScroll() {
        header.classList.toggle('scrolled', window.scrollY > 50);
    }
    window.addEventListener('scroll', handleScroll);
    handleScroll();
})();

// ── 모바일 메뉴 (useState → DOM 조작) ──
function toggleMobileMenu() {
    var nav = document.getElementById('mobile-nav');
    var btn = document.getElementById('hamburger-icon');
    if (!nav) return;
    var open = nav.classList.toggle('open');
    if (btn) btn.textContent = open ? '✕' : '☰';
}

// ── 메뉴 드롭다운 ──
function toggleDropdown() {
    var menu = document.getElementById('dropdown-menu');
    var chev = document.getElementById('chevron');
    if (!menu) return;
    var open = menu.classList.toggle('open');
    if (chev) chev.classList.toggle('open', open);
}

// ── 유저 드롭다운 ──
function toggleUserDropdown() {
    var menu = document.getElementById('user-dropdown');
    if (!menu) return;
    menu.classList.toggle('open');
}

// 외부 클릭 시 드롭다운 닫기 (useEffect + useRef → addEventListener)
document.addEventListener('click', function (e) {
    ['dropdown-menu', 'user-dropdown'].forEach(function (id) {
        var el = document.getElementById(id);
        if (!el) return;
        var parent = el.parentElement;
        if (parent && !parent.contains(e.target)) {
            el.classList.remove('open');
            var chev = document.getElementById('chevron');
            if (chev) chev.classList.remove('open');
        }
    });
});

// ── FAQ 아코디언 (useState(openIndex) → DOM 조작) ──
function toggleFAQ(btn) {
    var item   = btn.closest('.faq-item');
    var answer = item.querySelector('.faq-answer');
    var chev   = btn.querySelector('.faq-chevron');
    var isOpen = answer.classList.contains('open');

    // 모두 닫기
    document.querySelectorAll('.faq-answer').forEach(function (a) { a.classList.remove('open'); });
    document.querySelectorAll('.faq-chevron').forEach(function (c) { c.classList.remove('open'); });

    if (!isOpen) {
        answer.classList.add('open');
        if (chev) chev.classList.add('open');
    }
}

// ── FAQ 카테고리 필터 (useState → DOM 조작) ──
function filterFAQ(cat, btn) {
    document.querySelectorAll('.faq-cat-btn').forEach(function (b) { b.classList.remove('active'); });
    btn.classList.add('active');
    document.querySelectorAll('.faq-item').forEach(function (item) {
        var c = item.getAttribute('data-category');
        item.classList.toggle('hidden', cat !== '전체' && c !== cat);
    });
    // 열린 아코디언 닫기
    document.querySelectorAll('.faq-answer').forEach(function (a) { a.classList.remove('open'); });
    document.querySelectorAll('.faq-chevron').forEach(function (c) { c.classList.remove('open'); });
}

// ── 게시판 카테고리 탭 ──
function selectBoardCat(cat) {
    var form  = document.getElementById('board-cat-form');
    var input = document.getElementById('board-cat-input');
    if (form && input) { input.value = cat; form.submit(); }
}

// ── 채팅 메시지 전송 ──
function sendChat() {
    var input = document.getElementById('chat-input');
    var list  = document.getElementById('chat-messages');
    if (!input || !list || !input.value.trim()) return;
    var text = input.value.trim();
    input.value = '';

    var userRow = document.createElement('div');
    userRow.className = 'msg-user-row';
    userRow.innerHTML = '<div class="msg-user-bubble">' + escapeHtml(text) + '</div><div class="chat-avatar avatar-user">나</div>';
    list.appendChild(userRow);

    // 간단한 자동응답 (실제 Gemini API 연동 시 Spring Controller로 AJAX 요청)
    setTimeout(function () {
        var botRow = document.createElement('div');
        botRow.className = 'msg-bot-row';
        botRow.innerHTML = '<div class="chat-avatar avatar-bot">AI</div><div class="msg-bot-bubble">메뉴, 영업시간, 위치 등 궁금하신 점을 물어보세요! 전화 02-1234-5678로도 문의 가능합니다.</div>';
        list.appendChild(botRow);
        list.scrollTop = list.scrollHeight;
    }, 600);

    list.scrollTop = list.scrollHeight;
}

function escapeHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// 채팅 엔터 전송
document.addEventListener('keydown', function (e) {
    if (e.target && e.target.id === 'chat-input' && e.key === 'Enter') sendChat();
});
