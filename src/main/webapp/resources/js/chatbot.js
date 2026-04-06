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

    fetch('/chat/send', {
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
        appendChatMessage('아메라', data.response);
    })
    .catch(function() {
        var w = document.getElementById('waitingMsg');
        if (w) w.remove();
        appendChatMessage('아메라', '메시지 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    });
}

function appendChatMessage(sender, text) {
    var box = document.getElementById('chatBox');
    var div = document.createElement('div');
    div.className = (sender === '손님') ? 'msg-user' : 'msg-bot';
    var escaped = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    div.innerHTML = escaped.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>').replace(/\n/g, '<br>');
    box.appendChild(div);
    box.scrollTop = box.scrollHeight;
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
