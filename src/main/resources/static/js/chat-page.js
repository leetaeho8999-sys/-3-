/* chat-page.js — 아메리 AI 전체 페이지 스크립트
   ctx, nickname 변수는 JSP에서 전역으로 선언되어야 합니다. */

var acBusy = false;

/* 사용자 메시지 이스케이프 */
function esc(str) {
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/\n/g, '<br>');
}

/* 봇 메시지 렌더링: HTML 이스케이프 → 마크다운 링크 → 굵은 글씨 → 줄바꿈 */
function renderBot(str) {
    var r = str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
    r = r.replace(/\[([^\]]+)\]\(([^)]+)\)/g, function(_m, label, url) {
        var href = url.charAt(0) === '/' ? ctx + url : url;
        return '<a href="' + href + '" class="chat-link" target="_self">' + label + '</a>';
    });
    r = r.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>');
    r = r.replace(/\n/g, '<br>');
    return r;
}

function hideWelcome() {
    var w = document.getElementById('ac-welcome');
    if (w) w.style.display = 'none';
}

/* rawText: 원본 텍스트 (이스케이프 전), isUser: 사용자/봇 구분 */
function acAppend(rawText, isUser) {
    hideWelcome();
    var box = document.getElementById('ac-messages');
    var row = document.createElement('div');
    row.className = 'ac-row' + (isUser ? ' user' : '');

    if (isUser) {
        row.innerHTML =
            '<div class="ac-bubble user">' + esc(rawText) + '</div>' +
            '<div class="row-av user-av' + (nickname === '손님' ? ' guest-av' : '') + '">' +
            (nickname === '손님' ? 'guest' : esc(nickname.charAt(0))) + '</div>';
        box.appendChild(row);
    } else {
        row.innerHTML =
            '<div class="row-av bot-av">☕</div>' +
            '<div class="ac-bubble bot">' + renderBot(rawText) + '</div>';

        /* 만족도 평가 버튼 — addEventListener로 클로저 사용 (XSS 방지) */
        var ratingRow = document.createElement('div');
        ratingRow.className = 'ac-rating';

        var goodBtn = document.createElement('button');
        goodBtn.className = 'ac-rate-btn';
        goodBtn.textContent = '👍';
        goodBtn.addEventListener('click', function() { acRate(this, rawText, 'good'); });

        var badBtn = document.createElement('button');
        badBtn.className = 'ac-rate-btn';
        badBtn.textContent = '👎';
        badBtn.addEventListener('click', function() { acRate(this, rawText, 'bad'); });

        ratingRow.appendChild(goodBtn);
        ratingRow.appendChild(badBtn);
        box.appendChild(row);
        box.appendChild(ratingRow);
    }

    box.scrollTop = box.scrollHeight;
    return row;
}

function acWaiting() {
    hideWelcome();
    var box = document.getElementById('ac-messages');
    var row = document.createElement('div');
    row.className = 'ac-row';
    row.innerHTML =
        '<div class="row-av bot-av">☕</div>' +
        '<div class="ac-bubble waiting">아메리가 답변을 준비하고 있어요...</div>';
    box.appendChild(row);
    box.scrollTop = box.scrollHeight;
    return row;
}

function acSend() {
    if (acBusy) return;
    var inp = document.getElementById('ac-input');
    var text = inp.value.trim();
    if (!text) return;
    inp.value = '';
    acAppend(text, true);
    acBusy = true;
    var w = acWaiting();

    fetch(ctx + '/chat/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text, nickname: nickname })
    })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        w.remove();
        acAppend(d.response || '답변을 가져오지 못했습니다.', false);
    })
    .catch(function() {
        w.remove();
        acAppend('연결에 문제가 생겼어요. 잠시 후 다시 시도해주세요. 😊', false);
    })
    .finally(function() { acBusy = false; });
}

function sendQuick(text) {
    document.getElementById('ac-input').value = text;
    acSend();
}

function acRate(btn, botMessage, rating) {
    var ratingRow = btn.parentElement;
    var btns = ratingRow.querySelectorAll('.ac-rate-btn');
    btns.forEach(function(b) { b.disabled = true; });

    fetch(ctx + '/chat/rate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ botMessage: botMessage, rating: rating })
    })
    .then(function() {
        var msg = rating === 'good' ? '도움이 됐어요 👍' : '피드백 감사해요 👎';
        var done = document.createElement('div');
        done.className = 'ac-rate-done';
        done.textContent = msg;
        ratingRow.replaceWith(done);
    })
    .catch(function() {
        btns.forEach(function(b) { b.disabled = false; });
    });
}

function acClear() {
    document.getElementById('ac-messages').innerHTML =
        '<div class="ac-welcome" id="ac-welcome">' +
        '<div class="aw-emoji">☕</div>' +
        '<div class="aw-title">안녕하세요, 아메리입니다</div>' +
        '<div class="aw-line"></div>' +
        '<div class="aw-sub">로운카페 전담 AI 안내원이에요.<br>궁금한 것을 편하게 물어보세요!</div>' +
        '<div class="ac-chips">' +
        '<div class="ac-chip" onclick="sendQuick(\'커피 추천해줘\')">☕ 커피 추천</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'달달한 음료 뭐 있어?\')">🍬 달달한 음료</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'디카페인 옵션 있어?\')">🍃 디카페인</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'멤버십 어떻게 가입해?\')">⭐ 멤버십</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'오늘 이벤트 있어?\')">🎁 이벤트</div>' +
        '</div></div>';
}

/* 이전 대화 내역 불러오기 */
window.addEventListener('DOMContentLoaded', function() {
    fetch(ctx + '/chat/history')
    .then(function(r) { return r.json(); })
    .then(function(history) {
        if (history && history.length > 0) {
            history.forEach(function(item) {
                acAppend(item.message, item.sender === 'user');
            });
        }
    })
    .catch(function() {});
});
