<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="아메리 AI 상담 — 로운"/>
<%@ include file="../common/header.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat-page.css">

<div class="ac-page">

    <!-- 왼쪽 브랜드 패널 -->
    <aside class="ac-panel">
        <div>
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
                <div><div class="di-title">오늘의 추천</div><div class="di-desc">날씨와 취향에 맞는 메뉴</div></div>
            </div>
            <div class="ac-deco-item" onclick="sendQuick('매장 영업시간 알려줘')">
                <span class="di-icon">📍</span>
                <div><div class="di-title">매장 &amp; 영업 안내</div><div class="di-desc">위치 · 영업시간 · 주차</div></div>
            </div>
            <div class="ac-deco-item" onclick="sendQuick('멤버십 혜택 알려줘')">
                <span class="di-icon">⭐</span>
                <div><div class="di-title">멤버십 혜택</div><div class="di-desc">등급별 할인 · 포인트 적립</div></div>
            </div>
            <div class="ac-deco-item" onclick="sendQuick('이벤트 알려줘')">
                <span class="di-icon">🎁</span>
                <div><div class="di-title">이벤트 · 프로모션</div><div class="di-desc">진행 중인 혜택 안내</div></div>
            </div>
        </div>

        <div class="ac-panel-bottom">ROWOON CAFE · SINCE 2025</div>
    </aside>

    <!-- 오른쪽 채팅 -->
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
                    <div class="ac-chip" onclick="sendQuick('커피 추천해줘')">☕ 커피 추천</div>
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
var ctx      = '${pageContext.request.contextPath}';
var nickname = '${not empty sessionScope.m_name ? sessionScope.m_name : "손님"}';
</script>
<script src="${pageContext.request.contextPath}/js/chat-page.js"></script>

<%@ include file="../common/footer.jsp" %>
