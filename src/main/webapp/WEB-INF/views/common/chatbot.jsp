<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chatbot.css">

<button id="openBtn" onclick="openChat()">☕ AI 상담</button>

<div id="chatContainer" style="display:none;">
    <div id="chatHeader">
        <div class="header-avatar">☕</div>
        <div class="header-info">
            <div class="header-name">아메리</div>
            <div class="header-status">☕ 로운카페 AI 안내원</div>
        </div>
        <button type="button" id="resetBtn" onclick="resetChat()" aria-label="대화 초기화" title="대화 초기화">↺</button>
        <button type="button" id="closeBtn" onclick="closeChat()" aria-label="챗봇 닫기">✕</button>
    </div>
    <div id="greetingBox">
        <div class="greeting-bubble">
            <div class="greeting-name">아메리</div>
            안녕하세요 😊<br>
            로운카페 AI 안내원 <b>아메리</b>입니다.<br>
            궁금한 것을 편하게 물어보세요!
        </div>
    </div>
    <div id="chatBox"></div>
    <div id="chatInputArea">
        <input type="text" id="userInput" placeholder="어떤 것이 궁금하신가요?" />
        <button id="sendBtn" onclick="sendChatbotMessage()">전송</button>
    </div>
</div>

<script>var chatCtx = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/resources/js/chatbot.js"></script>
