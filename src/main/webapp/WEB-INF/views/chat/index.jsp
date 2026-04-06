<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="아메리 AI 상담 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">

<style>
/* 플로팅 챗봇 숨김 */
#openBtn, #chatContainer { display: none !important; }

/* ── 리셋 & 기본 ── */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

.ac-page {
    display: flex;
    height: calc(100vh - 64px);
    margin-top: 64px;
    overflow: hidden;
    font-family: 'Noto Sans KR', sans-serif;
}

/* ═══════════════════════════════
   왼쪽 패널 — 브랜드 데코
═══════════════════════════════ */
.ac-panel {
    width: 340px;
    flex-shrink: 0;
    background: #2A1A0E;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 48px 36px;
    position: relative;
    overflow: hidden;
}

/* 배경 원형 장식 */
.ac-panel::before {
    content: '';
    position: absolute;
    top: -80px; right: -80px;
    width: 280px; height: 280px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(200,169,126,0.12) 0%, transparent 70%);
    pointer-events: none;
}
.ac-panel::after {
    content: '';
    position: absolute;
    bottom: -60px; left: -60px;
    width: 220px; height: 220px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(200,169,126,0.08) 0%, transparent 70%);
    pointer-events: none;
}

.ac-panel-top {}

.ac-panel-eyebrow {
    font-size: 0.62rem;
    letter-spacing: 4px;
    text-transform: uppercase;
    color: #C8A97E;
    margin-bottom: 14px;
}

.ac-panel-name {
    font-family: 'Playfair Display', serif;
    font-size: 3rem;
    font-weight: 700;
    color: #FAF7F2;
    line-height: 1.1;
    margin-bottom: 6px;
}

.ac-panel-name em {
    font-style: italic;
    color: #C8A97E;
}

.ac-panel-tagline {
    font-size: 0.82rem;
    color: rgba(250,247,242,0.5);
    line-height: 1.7;
    margin-top: 12px;
    padding-top: 16px;
    border-top: 1px solid rgba(200,169,126,0.2);
}

/* 중간 장식 */
.ac-panel-deco {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.ac-deco-item {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px 16px;
    background: rgba(200,169,126,0.07);
    border: 1px solid rgba(200,169,126,0.15);
    border-radius: 10px;
    cursor: pointer;
    transition: background 0.2s;
}

.ac-deco-item:hover {
    background: rgba(200,169,126,0.14);
}

.ac-deco-item .di-icon {
    font-size: 1.3rem;
    flex-shrink: 0;
    width: 28px;
    text-align: center;
}

.ac-deco-item .di-body {}

.ac-deco-item .di-title {
    font-size: 0.8rem;
    color: rgba(250,247,242,0.85);
    font-weight: 500;
    margin-bottom: 2px;
}

.ac-deco-item .di-desc {
    font-size: 0.68rem;
    color: rgba(200,169,126,0.6);
    letter-spacing: 0.3px;
}

/* 하단 */
.ac-panel-bottom {
    font-size: 0.65rem;
    color: rgba(200,169,126,0.35);
    letter-spacing: 1px;
    text-align: center;
}

/* ═══════════════════════════════
   오른쪽 — 채팅 영역
═══════════════════════════════ */
.ac-chat {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #FAF7F2;
    min-width: 0;
}

/* 채팅 상단 바 */
.ac-chat-top {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 16px 32px;
    background: #FFFFFF;
    border-bottom: 1px solid #EDE5DA;
    flex-shrink: 0;
}

.ac-chat-top .ct-avatar {
    width: 38px; height: 38px;
    border-radius: 50%;
    background: linear-gradient(135deg, #C8A97E 0%, #7B4F2E 100%);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem; flex-shrink: 0;
}

.ac-chat-top .ct-name {
    font-family: 'Playfair Display', serif;
    font-size: 1rem; font-weight: 600; color: #3B2314;
}

.ac-chat-top .ct-status {
    font-size: 0.68rem; color: #8C7B6E; margin-top: 2px;
    display: flex; align-items: center; gap: 5px;
}

.ac-chat-top .ct-status::before {
    content: '';
    width: 6px; height: 6px;
    border-radius: 50%;
    background: #7CB87C;
    display: inline-block;
}

.ac-chat-top .ct-badge {
    margin-left: auto;
    font-size: 0.62rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    color: #7B4F2E;
    background: #F0E8DC;
    border: 1px solid #C8A97E;
    padding: 3px 10px;
    border-radius: 20px;
}

/* 메시지 목록 */
.ac-messages {
    flex: 1;
    overflow-y: auto;
    padding: 32px;
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.ac-messages::-webkit-scrollbar { width: 4px; }
.ac-messages::-webkit-scrollbar-thumb { background: #D4C4B0; border-radius: 4px; }

/* 웰컴 */
.ac-welcome {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 32px 16px;
    gap: 10px;
}

.ac-welcome .aw-emoji { font-size: 2.5rem; }

.ac-welcome .aw-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.5rem;
    color: #3B2314;
}

.ac-welcome .aw-line {
    width: 36px; height: 1px; background: #C8A97E;
}

.ac-welcome .aw-sub {
    font-size: 0.85rem;
    color: #8C7B6E;
    line-height: 1.7;
    max-width: 340px;
}

.ac-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    justify-content: center;
    margin-top: 6px;
}

.ac-chip {
    padding: 7px 16px;
    background: #FFFFFF;
    border: 1px solid #C8A97E;
    color: #7B4F2E;
    font-size: 0.78rem;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.2s;
    font-family: 'Noto Sans KR', sans-serif;
}

.ac-chip:hover {
    background: #3B2314; color: #FAF7F2; border-color: #3B2314;
}

/* 메시지 행 */
.ac-row { display: flex; align-items: flex-end; gap: 8px; }
.ac-row.user { flex-direction: row-reverse; }

.ac-row .row-av {
    width: 30px; height: 30px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0; font-size: 0.85rem; margin-bottom: 2px;
}

.ac-row .row-av.bot-av {
    background: linear-gradient(135deg, #C8A97E 0%, #7B4F2E 100%);
    color: #FAF7F2;
}

.ac-row .row-av.user-av {
    background: #3B2314; color: #C8A97E;
    font-size: 0.68rem; letter-spacing: 0;
}

.ac-bubble {
    max-width: 62%;
    padding: 12px 18px;
    font-size: 0.875rem;
    line-height: 1.75;
    word-break: break-word;
}

.ac-bubble.bot {
    background: #FFFFFF;
    color: #3D2B1F;
    border: 1px solid #EDE5DA;
    border-radius: 4px 16px 16px 16px;
    box-shadow: 0 2px 10px rgba(59,35,20,0.06);
}

.ac-bubble.user {
    background: #3B2314;
    color: #FAF7F2;
    border-radius: 16px 4px 16px 16px;
}

.ac-bubble.waiting {
    background: #F5F0E8;
    border: 1px solid #EDE5DA;
    border-left: 3px solid #C8A97E;
    border-radius: 4px 16px 16px 16px;
    color: #8C7B6E;
    font-style: italic;
    font-size: 0.82rem;
}

/* 입력 영역 */
.ac-input-area {
    padding: 18px 32px 22px;
    background: #FFFFFF;
    border-top: 1px solid #EDE5DA;
    flex-shrink: 0;
}

.ac-input-row {
    display: flex;
    align-items: center;
    gap: 10px;
    background: #FAF7F2;
    border: 1.5px solid #C8A97E;
    border-radius: 50px;
    padding: 6px 8px 6px 22px;
    transition: box-shadow 0.2s, border-color 0.2s;
}

.ac-input-row:focus-within {
    border-color: #7B4F2E;
    box-shadow: 0 0 0 4px rgba(200,169,126,0.18);
    background: #FFFFFF;
}

.ac-input-row input {
    flex: 1;
    border: none;
    background: transparent;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 0.875rem;
    color: #3D2B1F;
    outline: none;
    padding: 6px 0;
}

.ac-input-row input::placeholder { color: #B0A090; }

.ac-btn-send {
    width: 40px; height: 40px; border-radius: 50%;
    background: #3B2314; color: #FAF7F2;
    border: none; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; flex-shrink: 0;
    transition: background 0.2s, transform 0.15s;
}

.ac-btn-send:hover { background: #7B4F2E; transform: scale(1.06); }

.ac-btn-reset {
    width: 40px; height: 40px; border-radius: 50%;
    background: transparent;
    border: 1px solid #D4C4B0; color: #8C7B6E;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; flex-shrink: 0;
    transition: all 0.2s;
}

.ac-btn-reset:hover { background: #F0E8DC; border-color: #C8A97E; color: #3B2314; }

.ac-input-hint {
    font-size: 0.65rem;
    color: #C0B0A0;
    text-align: center;
    margin-top: 8px;
    letter-spacing: 0.5px;
}

/* 반응형 */
@media (max-width: 860px) { .ac-panel { display: none; } }
@media (max-width: 640px) {
    .ac-messages { padding: 16px; }
    .ac-input-area { padding: 14px 16px 18px; }
}
</style>

<div class="ac-page">

    <!-- ── 왼쪽 브랜드 패널 ── -->
    <aside class="ac-panel">
        <div class="ac-panel-top">
            <div class="ac-panel-eyebrow">Rowoon Cafe · AI</div>
            <div class="ac-panel-name">아<em>메</em>리</div>
            <div class="ac-panel-tagline">
                로운카페의 전담 AI 안내원입니다.<br>
                메뉴 추천부터 매장 정보까지<br>
                무엇이든 편하게 물어보세요.
            </div>
        </div>

        <div class="ac-panel-deco">
            <div class="ac-deco-item" onclick="sendQuick('오늘 추천 음료 알려줘')">
                <span class="di-icon">☕</span>
                <div class="di-body">
                    <div class="di-title">오늘의 추천</div>
                    <div class="di-desc">날씨와 취향에 맞는 메뉴</div>
                </div>
            </div>
            <div class="ac-deco-item" onclick="sendQuick('매장 영업시간 알려줘')">
                <span class="di-icon">📍</span>
                <div class="di-body">
                    <div class="di-title">매장 & 영업 안내</div>
                    <div class="di-desc">위치 · 영업시간 · 주차</div>
                </div>
            </div>
            <div class="ac-deco-item" onclick="sendQuick('멤버십 혜택 알려줘')">
                <span class="di-icon">⭐</span>
                <div class="di-body">
                    <div class="di-title">멤버십 혜택</div>
                    <div class="di-desc">등급별 할인 · 포인트 적립</div>
                </div>
            </div>
            <div class="ac-deco-item" onclick="sendQuick('이벤트 알려줘')">
                <span class="di-icon">🎁</span>
                <div class="di-body">
                    <div class="di-title">이벤트 · 프로모션</div>
                    <div class="di-desc">진행 중인 혜택 안내</div>
                </div>
            </div>
        </div>

        <div class="ac-panel-bottom">ROWOON CAFE · SINCE 2025</div>
    </aside>

    <!-- ── 오른쪽 채팅 ── -->
    <div class="ac-chat">

        <div class="ac-chat-top">
            <div class="ct-avatar">☕</div>
            <div>
                <div class="ct-name">아메리</div>
                <div class="ct-status">온라인 · 바로 답변 가능</div>
            </div>
            <span class="ct-badge">Groq AI</span>
        </div>

        <div class="ac-messages" id="ac-messages">
            <div class="ac-welcome" id="ac-welcome">
                <div class="aw-emoji">☕</div>
                <div class="aw-title">안녕하세요, 아메리입니다</div>
                <div class="aw-line"></div>
                <div class="aw-sub">
                    로운카페 전담 AI 안내원이에요.<br>
                    궁금한 것을 편하게 물어보세요!
                </div>
                <div class="ac-chips">
                    <div class="ac-chip" onclick="sendQuick('아메리카노 추천해줘')">☕ 커피 추천</div>
                    <div class="ac-chip" onclick="sendQuick('달달한 음료 뭐 있어?')">🍬 달달한 음료</div>
                    <div class="ac-chip" onclick="sendQuick('디카페인 옵션 있어?')">🍃 디카페인</div>
                    <div class="ac-chip" onclick="sendQuick('멤버십 어떻게 가입해?')">⭐ 멤버십</div>
                    <div class="ac-chip" onclick="sendQuick('오늘 이벤트 있어?')">🎁 이벤트</div>
                </div>
            </div>
        </div>

        <div class="ac-input-area">
            <div class="ac-input-row">
                <input type="text" id="ac-input"
                       placeholder="아메리에게 무엇이든 물어보세요..."
                       onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();acSend();}">
                <button class="ac-btn-send" onclick="acSend()" title="전송">&#x27A4;</button>
                <button class="ac-btn-reset" onclick="acClear()" title="대화 초기화">↺</button>
            </div>
            <div class="ac-input-hint">Enter 키로 전송 · Groq AI가 실시간 응답합니다</div>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
var acBusy = false;

function esc(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\n/g,'<br>');
}

function acAppend(text, isUser) {
    var w = document.getElementById('ac-welcome');
    if (w) w.style.display = 'none';

    var box = document.getElementById('ac-messages');
    var row = document.createElement('div');
    row.className = 'ac-row ' + (isUser ? 'user' : '');

    if (isUser) {
        row.innerHTML =
            '<div class="ac-bubble user">' + esc(text) + '</div>' +
            '<div class="row-av user-av">나</div>';
    } else {
        row.innerHTML =
            '<div class="row-av bot-av">☕</div>' +
            '<div class="ac-bubble bot">' + text + '</div>';
    }
    box.appendChild(row);
    box.scrollTop = box.scrollHeight;
    return row;
}

function acWaiting() {
    var w = document.getElementById('ac-welcome');
    if (w) w.style.display = 'none';

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
        body: JSON.stringify({ message: text })
    })
    .then(function(r){ return r.json(); })
    .then(function(d){
        w.remove();
        acAppend(esc(d.response || '답변을 가져오지 못했습니다.'), false);
    })
    .catch(function(){
        w.remove();
        acAppend('연결에 문제가 생겼어요. 잠시 후 다시 시도해주세요. 😊', false);
    })
    .finally(function(){ acBusy = false; });
}

function sendQuick(text) {
    document.getElementById('ac-input').value = text;
    acSend();
}

function acClear() {
    var box = document.getElementById('ac-messages');
    box.innerHTML =
        '<div class="ac-welcome" id="ac-welcome">' +
        '<div class="aw-emoji">☕</div>' +
        '<div class="aw-title">안녕하세요, 아메리입니다</div>' +
        '<div class="aw-line"></div>' +
        '<div class="aw-sub">로운카페 전담 AI 안내원이에요.<br>궁금한 것을 편하게 물어보세요!</div>' +
        '<div class="ac-chips">' +
        '<div class="ac-chip" onclick="sendQuick(\'아메리카노 추천해줘\')">☕ 커피 추천</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'달달한 음료 뭐 있어?\')">🍬 달달한 음료</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'디카페인 옵션 있어?\')">🍃 디카페인</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'멤버십 어떻게 가입해?\')">⭐ 멤버십</div>' +
        '<div class="ac-chip" onclick="sendQuick(\'오늘 이벤트 있어?\')">🎁 이벤트</div>' +
        '</div></div>';
}
</script>

<%@ include file="../common/footer.jsp" %>
