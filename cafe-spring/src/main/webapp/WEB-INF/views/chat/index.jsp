<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="AI 상담 — 정성을 다한 커피"/>
<c:set var="activePage" value="chat"/>
<%@ include file="../common/header.jsp" %>

<main style="padding-top:64px;height:calc(100vh - 64px);display:flex;flex-direction:column">
    <div class="chat-layout">

        <!-- 대화 목록 사이드바 -->
        <div class="chat-sidebar">
            <div class="chat-sidebar-title">대화 내역</div>
            <div class="chat-conv-item active">
                <div class="chat-conv-name">커피 추천</div>
                <div class="chat-conv-date">오늘</div>
            </div>
            <button class="btn-new-chat" onclick="clearChat()">+ 새 대화</button>
        </div>

        <!-- 채팅 영역 -->
        <div class="chat-main">
            <div class="chat-header">
                <span class="chat-title">🤖 AI 커피 어시스턴트</span>
                <span class="chat-badge">Gemini</span>
            </div>

            <!-- 퀵 버튼 -->
            <div class="chat-quick-btns">
                <button onclick="sendQuick('메뉴 추천해줘')">☕ 메뉴 추천</button>
                <button onclick="sendQuick('매장 정보 알려줘')">📍 매장 정보</button>
                <button onclick="sendQuick('이벤트 알려줘')">🎁 이벤트</button>
                <button onclick="sendQuick('멤버십 혜택 알려줘')">⭐ 멤버십</button>
            </div>

            <!-- 메시지 목록 -->
            <div class="chat-messages" id="chat-messages">
                <div class="msg-bot">
                    <div class="msg-avatar bot-avatar">AI</div>
                    <div class="msg-bubble bot-bubble">
                        안녕하세요! 정성을 다한 커피 AI 어시스턴트입니다. ☕<br>
                        무엇을 도와드릴까요?
                    </div>
                </div>
            </div>

            <!-- 입력창 -->
            <div class="chat-input-area">
                <input type="text" id="chat-input" class="chat-input" placeholder="메시지를 입력하세요..." onkeydown="if(event.key==='Enter')sendMessage()">
                <button onclick="sendMessage()" class="chat-send-btn">→</button>
                <button onclick="clearChat()" class="chat-reset-btn" title="대화 초기화">↺</button>
            </div>
        </div>

    </div>
</main>

<script>
var ctx = '${pageContext.request.contextPath}';

var coffeeKnowledge = {
    '메뉴': '저희 메뉴는 에스프레소(3,500원), 아메리카노(4,000원), 카페라떼(4,500원), 카푸치노(4,500원), 바닐라라떼(5,000원), 카라멜마끼아또(5,000원), 아인슈페너(5,500원), 콜드브루(5,000원), 시그니처라떼(6,000원)가 있습니다.',
    '추천': '오늘 처음 오셨다면 저희 시그니처 라떼(6,000원)를 추천드립니다! 파나마 게이샤 원두로 만든 특별한 레시피예요. 진한 맛을 좋아하신다면 아인슈페너도 인기가 많아요 ☕',
    '매장': '저희 매장은 서울시 강남구 테헤란로 123, 역삼역 3번 출구 도보 5분 거리에 있습니다. 평일 08:00~22:00, 주말 09:00~23:00 영업하며 월요일은 휴무입니다.',
    '이벤트': '현재 3월 한 달간 아메리카노 1+1 이벤트를 진행 중입니다! SNS 팔로우 시 첫 방문 10% 할인 쿠폰도 제공해드려요.',
    '멤버십': '저희 멤버십은 베이직(무료), 실버(9,900원/월), 골드(19,900원/월) 3가지 플랜이 있습니다. 실버 이상 가입 시 전 메뉴 10~20% 할인과 포인트 적립 혜택을 받으실 수 있어요.',
    '디카페인': '네, 모든 에스프레소 베이스 음료에 디카페인 옵션을 선택하실 수 있어요. 추가 비용은 500원입니다.',
    '텀블러': '개인 텀블러를 지참하시면 500원 할인해 드립니다 😊',
};

function addMessage(text, isUser) {
    var messages = document.getElementById('chat-messages');
    var div = document.createElement('div');
    div.className = isUser ? 'msg-user' : 'msg-bot';
    div.innerHTML = isUser
        ? '<div class="msg-bubble user-bubble">' + escapeHtml(text) + '</div><div class="msg-avatar user-avatar">나</div>'
        : '<div class="msg-avatar bot-avatar">AI</div><div class="msg-bubble bot-bubble">' + text + '</div>';
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
}

function escapeHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function getBotResponse(msg) {
    var lower = msg.toLowerCase();
    for (var key in coffeeKnowledge) {
        if (msg.includes(key)) return coffeeKnowledge[key];
    }
    if (lower.includes('안녕') || lower.includes('hello')) return '안녕하세요! 오늘도 좋은 하루 되세요 ☕ 메뉴 추천이나 매장 정보 등 무엇이든 물어보세요!';
    if (lower.includes('감사') || lower.includes('고마')) return '천만에요! 더 궁금하신 점이 있으시면 언제든지 물어보세요 😊';
    return '죄송해요, 잘 이해하지 못했어요. 메뉴 추천, 매장 정보, 이벤트, 멤버십 혜택 등에 대해 물어보세요!';
}

function sendMessage() {
    var input = document.getElementById('chat-input');
    var text = input.value.trim();
    if (!text) return;
    addMessage(text, true);
    input.value = '';

    setTimeout(function() {
        addMessage(getBotResponse(text), false);
    }, 600);
}

function sendQuick(text) {
    addMessage(text, true);
    setTimeout(function() {
        addMessage(getBotResponse(text), false);
    }, 600);
}

function clearChat() {
    var m = document.getElementById('chat-messages');
    m.innerHTML = '<div class="msg-bot"><div class="msg-avatar bot-avatar">AI</div><div class="msg-bubble bot-bubble">안녕하세요! 정성을 다한 커피 AI 어시스턴트입니다. ☕<br>무엇을 도와드릴까요?</div></div>';
}
</script>

<%@ include file="../common/footer.jsp" %>
