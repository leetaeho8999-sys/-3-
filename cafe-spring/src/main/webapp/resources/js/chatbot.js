function openChat() {
    document.getElementById('openBtn').style.display = 'none';
    document.getElementById('chatContainer').style.display = 'flex';
}

function sendChatbotMessage() {
    var input = document.getElementById('userInput');
    var message = input.value.trim();
    if (!message) return;

    appendChatMessage('손님', message);
    input.value = '';

    var waiting = document.createElement('div');
    waiting.id = 'waitingMsg';
    waiting.className = 'msg-waiting';
    waiting.textContent = '☕ 잠시만 기다려 주세요..';
    var box = document.getElementById('chatBox');
    box.appendChild(waiting);
    box.scrollTop = box.scrollHeight;

    fetch(chatCtx + '/chat/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: message, nickname: '손님' })
    })
    .then(function(res) {
        if (!res.ok) throw new Error('오류');
        return res.json();
    })
    .then(function(data) {
        var w = document.getElementById('waitingMsg');
        if (w) w.remove();
        appendChatMessage('아메리', data.response);
    })
    .catch(function() {
        var w = document.getElementById('waitingMsg');
        if (w) w.remove();
        appendChatMessage('아메리', '메시지 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    });
}

/* 봇 메시지 렌더링: HTML 이스케이프 → 마크다운 링크 → 굵은 글씨 → 줄바꿈 */
function renderBotText(text) {
    var r = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    r = r.replace(/\[([^\]]+)\]\(([^)]+)\)/g, function(_match, label, url) {
        var href = url.charAt(0) === '/' ? chatCtx + url : url;
        return '<a href="' + href + '" class="chat-link" target="_self">' + label + '</a>';
    });
    r = r.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>');
    r = r.replace(/\n/g, '<br>');
    return r;
}

function appendChatMessage(sender, text) {
    var box = document.getElementById('chatBox');
    var div = document.createElement('div');
    div.className = (sender === '손님') ? 'msg-user' : 'msg-bot';
    if (sender === '손님') {
        var escaped = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        div.innerHTML = escaped.replace(/\n/g, '<br>');
    } else {
        div.innerHTML = renderBotText(text);
    }
    box.appendChild(div);

    if (sender !== '손님') {
        var ratingDiv = document.createElement('div');
        ratingDiv.className = 'msg-rating';

        var goodBtn = document.createElement('button');
        goodBtn.className = 'rating-btn';
        goodBtn.textContent = '👍';
        goodBtn.addEventListener('click', function() { sendChatbotRating(ratingDiv, text, 'good'); });

        var badBtn = document.createElement('button');
        badBtn.className = 'rating-btn';
        badBtn.textContent = '👎';
        badBtn.addEventListener('click', function() { sendChatbotRating(ratingDiv, text, 'bad'); });

        ratingDiv.appendChild(goodBtn);
        ratingDiv.appendChild(badBtn);
        box.appendChild(ratingDiv);
    }

    box.scrollTop = box.scrollHeight;
}

function sendChatbotRating(ratingDiv, botMessage, rating) {
    var buttons = ratingDiv.querySelectorAll('.rating-btn');
    buttons.forEach(function(btn) { btn.disabled = true; });

    fetch(chatCtx + '/chat/rate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ botMessage: botMessage, rating: rating })
    })
    .then(function(res) {
        if (res.ok) {
            var msg = rating === 'good' ? '도움이 됐어요 👍' : '피드백 감사해요 👎';
            ratingDiv.innerHTML = '<span class="rating-done">' + msg + '</span>';
        } else {
            buttons.forEach(function(btn) { btn.disabled = false; });
        }
    })
    .catch(function() {
        buttons.forEach(function(btn) { btn.disabled = false; });
    });
}

document.addEventListener('DOMContentLoaded', function() {
    var input = document.getElementById('userInput');
    if (input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') sendChatbotMessage();
        });
    }

    document.addEventListener('click', function(e) {
        var container = document.getElementById('chatContainer');
        var openBtn   = document.getElementById('openBtn');
        if (!container || !openBtn) return;
        if (container.style.display !== 'none'
            && !container.contains(e.target)
            && e.target !== openBtn) {
            container.style.display = 'none';
            openBtn.style.display = 'block';
        }
    });
});
