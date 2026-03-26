<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="AI 상담 — 정성을 다한 커피"/>
<%@ include file="../common/header.jsp" %>
<main style="padding-top:64px">
  <div class="chat-layout">
    <div class="chat-sidebar">
      <div style="font-size:.75rem;font-weight:500;color:#717182;margin-bottom:.75rem">대화 내역</div>
      <div class="chat-conv-item active"><div style="font-size:.8rem;font-weight:500">새 대화</div><div style="font-size:.7rem;color:#9ca3af">오늘</div></div>
      <button class="chat-new-btn">+ 새 대화</button>
    </div>
    <div class="chat-main">
      <div style="padding:.75rem 1rem;border-bottom:1px solid rgba(0,0,0,.08);background:white;display:flex;align-items:center;gap:.75rem">
        <div style="font-size:.9rem;font-weight:500">🤖 AI 커피 어시스턴트</div>
        <div style="font-size:.7rem;padding:2px 8px;background:#dcfce7;color:#16a34a;border-radius:99px">온라인</div>
      </div>
      <div style="padding:.75rem 1rem;border-bottom:1px solid rgba(0,0,0,.06);display:flex;gap:.4rem;flex-wrap:wrap">
        <div style="padding:3px 10px;border:1px solid rgba(0,0,0,.1);border-radius:99px;font-size:.75rem;color:#717182;cursor:pointer">☕ 메뉴 추천</div>
        <div style="padding:3px 10px;border:1px solid rgba(0,0,0,.1);border-radius:99px;font-size:.75rem;color:#717182;cursor:pointer">📍 매장 정보</div>
        <div style="padding:3px 10px;border:1px solid rgba(0,0,0,.1);border-radius:99px;font-size:.75rem;color:#717182;cursor:pointer">🎁 이벤트</div>
      </div>
      <div class="chat-messages" id="chat-messages">
        <div class="msg-bot-row">
          <div class="chat-avatar avatar-bot">AI</div>
          <div class="msg-bot-bubble">안녕하세요! 정성을 다한 커피 AI 어시스턴트입니다. ☕<br>메뉴, 가격, 영업시간, 위치 등 궁금하신 점을 물어보세요!</div>
        </div>
      </div>
      <div class="chat-input-area">
        <input type="text" id="chat-input" class="chat-input" placeholder="메시지를 입력하세요...">
        <button class="chat-send-btn" onclick="sendChat()">→</button>
      </div>
    </div>
  </div>
</main>
<%@ include file="../common/footer.jsp" %>
