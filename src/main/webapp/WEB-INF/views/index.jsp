<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Chat Bot</title>
    <style>
        /* 챗봇 열기 버튼 */
        #openBtn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #4a3728;
            color: #f7f2ea;
            border: none;
            border-radius: 50px;
            padding: 14px 24px;
            font-size: 14px;
            letter-spacing: 1px;
            cursor: pointer;
            box-shadow: 0 4px 16px rgba(74, 55, 40, 0.35);
            transition: background 0.2s, transform 0.2s;
            z-index: 100;
        }
        #openBtn:hover {
            background-color: #6b4f3a;
            transform: translateY(-2px);
        }

        /* 챗봇 창 */
        #chatContainer {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 360px;
            background-color: #faf7f2;
            border: 1px solid #ddd4c4;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(74, 55, 40, 0.18);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            z-index: 100;
        }

        /* 헤더 */
        #chatHeader {
            background-color: #4a3728;
            color: #f7f2ea;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .header-avatar {
            width: 32px;
            height: 32px;
            background: #c8a97e;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
            color: #4a3728;
            flex-shrink: 0;
        }
        .header-info .header-name {
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .header-info .header-status {
            font-size: 11px;
            color: #c8a97e;
            margin-top: 1px;
        }

        /* 인사 영역 */
        #greetingBox {
            padding: 18px 16px 10px;
            border-bottom: 1px solid #ede8e0;
            background: #faf7f2;
        }
        .greeting-bubble {
            background: #ede8e0;
            color: #2c1a0e;
            padding: 10px 14px;
            border-radius: 16px 16px 16px 4px;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 10px;
        }
        .greeting-bubble .greeting-name {
            font-weight: 600;
            color: #6b4f3a;
            margin-bottom: 4px;
            font-size: 12px;
        }

        /* 메시지 영역 */
        #chatBox {
            height: 220px;
            overflow-y: auto;
            padding: 12px 16px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            background-color: #faf7f2;
        }
        #chatBox::-webkit-scrollbar { width: 4px; }
        #chatBox::-webkit-scrollbar-thumb { background: #d4c4b0; border-radius: 4px; }

        .msg-user {
            align-self: flex-end;
            background-color: #4a3728;
            color: #f7f2ea;
            padding: 9px 14px;
            border-radius: 16px 16px 4px 16px;
            font-size: 13px;
            max-width: 75%;
            line-height: 1.5;
            word-break: break-word;
        }
        .msg-bot {
            align-self: flex-start;
            background-color: #ede8e0;
            color: #2c1a0e;
            padding: 9px 14px;
            border-radius: 16px 16px 16px 4px;
            font-size: 13px;
            max-width: 75%;
            line-height: 1.5;
            word-break: break-word;
        }
        .msg-waiting {
            align-self: flex-start;
            color: #9e8c7a;
            font-size: 12px;
            padding: 6px 12px;
            background: #f0ebe3;
            border-left: 3px solid #c8a97e;
            border-radius: 4px;
            font-style: italic;
        }

        /* 입력 영역 */
        #chatInputArea {
            display: flex;
            border-top: 1px solid #ddd4c4;
            background-color: #f5f0e8;
            padding: 10px 12px;
            gap: 8px;
        }
        #userInput {
            flex: 1;
            border: 1px solid #d4c4b0;
            border-radius: 20px;
            padding: 9px 14px;
            font-size: 13px;
            background: #faf7f2;
            color: #2c1a0e;
            outline: none;
            transition: border 0.2s;
        }
        #userInput::placeholder { color: #b0a090; }
        #userInput:focus { border-color: #a07850; }
        #sendBtn {
            background-color: #4a3728;
            color: #f7f2ea;
            border: none;
            border-radius: 20px;
            padding: 9px 16px;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s;
            white-space: nowrap;
        }
        #sendBtn:hover { background-color: #6b4f3a; }
    </style>
</head>
<body>

    <button id="openBtn" onclick="openChat()">☕ 챗봇 상담</button>

    <div id="chatContainer" style="display:none;">

        <!-- 헤더 -->
        <div id="chatHeader">
            <div class="header-avatar">☕</div>
            <div class="header-info">
                <div class="header-name">아메리</div>
                <div class="header-status">● 로운카페 AI 안내원</div>
            </div>
        </div>

        <!-- 인사말 + 빠른 질문 -->
        <div id="greetingBox">
            <div class="greeting-bubble">
                <div class="greeting-name">아메리</div>
                안녕하세요 😊<br>
                로운카페 AI 안내원 <b>아메리</b>입니다.<br>
                궁금한 점을 편하게 물어보세요!
            </div>
        </div>

        <!-- 메시지 영역 -->
        <div id="chatBox"></div>

        <!-- 입력 영역 -->
        <div id="chatInputArea">
            <input type="text" id="userInput" placeholder="어떤 도움이 필요하신가요?" />
            <button id="sendBtn" onclick="sendMessage()">전송</button>
        </div>
    </div>

    <script>
        function openChat() {
            document.getElementById('openBtn').style.display = 'none';
            document.getElementById('chatContainer').style.display = 'flex';
        }

function sendMessage() {
            const input = document.getElementById('userInput');
            const message = input.value.trim();
            if (!message) return;

            appendMessage('손님', message);
            input.value = '';

            const waiting = document.createElement('div');
            waiting.id = 'waitingMsg';
            waiting.className = 'msg-waiting';
            waiting.textContent = '⏳ 잠시만 기다려 주세요...';
            const box = document.getElementById('chatBox');
            box.appendChild(waiting);
            box.scrollTop = box.scrollHeight;

            fetch('/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message, nickname: '손님' })
            })
            .then(res => { if (!res.ok) throw new Error('오류'); return res.json(); })
            .then(data => {
                document.getElementById('waitingMsg')?.remove();
                appendMessage('아메리', data.response);
            })
            .catch(() => {
                document.getElementById('waitingMsg')?.remove();
                appendMessage('아메리', '메시지 전송 중 오류가 발생했습니다.');
            });
        }

        function appendMessage(sender, text) {
            const box = document.getElementById('chatBox');
            const div = document.createElement('div');
            div.className = sender === '손님' ? 'msg-user' : 'msg-bot';
            const escaped = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            div.innerHTML = escaped.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>').replace(/\n/g, '<br>');
            box.appendChild(div);
            box.scrollTop = box.scrollHeight;
        }

        document.getElementById('userInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') sendMessage();
        });

        document.addEventListener('click', function(e) {
            const container = document.getElementById('chatContainer');
            const openBtn   = document.getElementById('openBtn');
            if (container.style.display !== 'none'
                && !container.contains(e.target)
                && e.target !== openBtn) {
                container.style.display = 'none';
                openBtn.style.display = 'block';
            }
        });
    </script>
</body>
</html>
