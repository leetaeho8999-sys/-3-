<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="AI 상담 — 로운"/>
<%@ include file="../common/header.jsp" %>
<main style="padding-top:64px">
  <div class="chat-layout">
    <div class="chat-sidebar">
      <div style="font-size:.75rem;font-weight:500;color:#717182;margin-bottom:.75rem">대화 내역</div>
      <div class="chat-conv-item active"><div style="font-size:.8rem;font-weight:500">현재 대화</div><div style="font-size:.7rem;color:#9ca3af">오늘</div></div>
      <button class="chat-new-btn" onclick="clearChat()">+ 새 대화</button>
    </div>
    <div class="chat-main">
      <div style="padding:.75rem 1rem;border-bottom:1px solid rgba(0,0,0,.08);background:white;display:flex;align-items:center;gap:.75rem">
        <div style="font-size:.9rem;font-weight:500">🤖 AI 커피 어시스턴트</div>
        <div style="font-size:.7rem;padding:2px 8px;background:#dcfce7;color:#16a34a;border-radius:99px">온라인</div>
      </div>
      <div style="padding:.75rem 1rem;border-bottom:1px solid rgba(0,0,0,.06);display:flex;gap:.4rem;flex-wrap:wrap">
        <div class="chat-quick-chip" onclick="sendQuick('메뉴 추천해줘')">☕ 메뉴 추천</div>
        <div class="chat-quick-chip" onclick="sendQuick('매장 정보 알려줘')">📍 매장 정보</div>
        <div class="chat-quick-chip" onclick="sendQuick('이벤트 알려줘')">🎁 이벤트</div>
        <div class="chat-quick-chip" onclick="sendQuick('멤버십 혜택 알려줘')">⭐ 멤버십</div>
      </div>
      <div class="chat-messages" id="chat-messages">
        <div class="msg-bot-row">
          <div class="chat-avatar avatar-bot">AI</div>
          <div class="msg-bot-bubble">안녕하세요! 로운 AI 어시스턴트입니다. ☕<br>메뉴, 가격, 영업시간, 위치 등 궁금하신 점을 물어보세요!</div>
        </div>
      </div>
      <div class="chat-input-area">
        <input type="text" id="chat-input" class="chat-input" placeholder="메시지를 입력하세요..."
               onkeydown="if(event.key==='Enter')sendChat()">
        <button class="chat-send-btn" onclick="sendChat()">→</button>
      </div>
    </div>
  </div>
</main>

<script>
var ctx = '${pageContext.request.contextPath}';

function escapeHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function addMessage(text, isUser) {
    var messages = document.getElementById('chat-messages');
    var div = document.createElement('div');
    if (isUser) {
        div.className = 'msg-user-row';
        div.innerHTML = '<div class="msg-user-bubble">' + escapeHtml(text) + '</div><div class="chat-avatar avatar-user">나</div>';
    } else {
        div.className = 'msg-bot-row';
        div.innerHTML = '<div class="chat-avatar avatar-bot">AI</div><div class="msg-bot-bubble">' + escapeHtml(text) + '</div>';
    }
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
}

function showTyping() {
    var messages = document.getElementById('chat-messages');
    var div = document.createElement('div');
    div.className = 'msg-bot-row';
    div.id = 'typing-indicator';
    div.innerHTML = '<div class="chat-avatar avatar-bot">AI</div><div class="msg-bot-bubble" style="color:#9ca3af">입력 중...</div>';
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
}

function removeTyping() {
    var t = document.getElementById('typing-indicator');
    if (t) t.remove();
}

function sendChat() {
    var input = document.getElementById('chat-input');
    var text = input.value.trim();
    if (!text) return;
    addMessage(text, true);
    input.value = '';
    showTyping();

    fetch(ctx + '/chat/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text })
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        removeTyping();
        addMessage(data.response || '응답을 받지 못했어요.', false);
    })
    .catch(function() {
        removeTyping();
        addMessage('죄송해요, 일시적인 오류가 발생했어요. 잠시 후 다시 시도해 주세요.', false);
    });
}

function sendQuick(text) {
    document.getElementById('chat-input').value = text;
    sendChat();
}

function clearChat() {
    var m = document.getElementById('chat-messages');
    m.innerHTML = '<div class="msg-bot-row"><div class="chat-avatar avatar-bot">AI</div><div class="msg-bot-bubble">안녕하세요! 로운 AI 어시스턴트입니다. ☕<br>무엇을 도와드릴까요?</div></div>';
}

// 페이지 로드 시 이전 대화 내역 불러오기
window.addEventListener('DOMContentLoaded', function() {
    fetch(ctx + '/chat/history')
    .then(function(res) { return res.json(); })
    .then(function(history) {
        if (history && history.length > 0) {
            history.forEach(function(item) {
                addMessage(item.message, item.sender === 'user');
            });
        }
    })
    .catch(function() {});
});
</script>

<style>
.chat-quick-chip {
    padding:3px 10px;border:1px solid rgba(0,0,0,.1);border-radius:99px;
    font-size:.75rem;color:#717182;cursor:pointer;transition:background .15s;
}
.chat-quick-chip:hover { background:#f3f4f6; }
.msg-user-row {
    display:flex;justify-content:flex-end;align-items:flex-end;gap:.5rem;margin-bottom:.75rem;
}
.msg-user-bubble {
    background:#8b5cf6;color:white;border-radius:1rem 1rem 0 1rem;
    padding:.6rem 1rem;max-width:70%;font-size:.875rem;line-height:1.5;
}
.msg-bot-row {
    display:flex;align-items:flex-end;gap:.5rem;margin-bottom:.75rem;
}
.msg-bot-bubble {
    background:#f3f4f6;border-radius:1rem 1rem 1rem 0;
    padding:.6rem 1rem;max-width:70%;font-size:.875rem;line-height:1.5;
}
.chat-avatar { width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.7rem;font-weight:600;flex-shrink:0; }
.avatar-bot  { background:#8b5cf6;color:white; }
.avatar-user { background:#e5e7eb;color:#374151; }
</style>

<%@ include file="../common/footer.jsp" %>
