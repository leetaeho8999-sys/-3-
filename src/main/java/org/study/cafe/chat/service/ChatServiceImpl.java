package org.study.cafe.chat.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.chat.mapper.ChatMapper;
import org.study.cafe.chat.vo.ChatHistoryVO;
import org.study.cafe.chat.vo.ChatVO;

import java.util.List;

@Service
public class ChatServiceImpl implements ChatService {

    private static final Logger log = LoggerFactory.getLogger(ChatServiceImpl.class);

    @Autowired private ChatMapper chatMapper;
    @Autowired private GeminiService geminiService;
    @Autowired private TranslationService translationService;

    @Override
    public String sendMessage(String userMessage, String sessionId, String mIdx) {
        // 1. 사용자 언어 감지
        String userLang = translationService.detectLanguage(userMessage);

        // 2. 사용자 메시지 저장 (chat_log_t)
        ChatVO userLog = new ChatVO();
        userLog.setSessionId(sessionId);
        userLog.setMIdx(mIdx);
        userLog.setSender("user");
        userLog.setMessage(userMessage);
        chatMapper.insertMessage(userLog);

        // 3. AI 챗봇용 사용자 기록 저장 (chat_history)
        try {
            ChatHistoryVO userHistory = new ChatHistoryVO();
            userHistory.setSender("손님");
            userHistory.setMessage(userMessage);
            chatMapper.saveHistory(userHistory);
        } catch (Exception e) {
            log.warn("chat_history 저장 실패 (테이블 미생성 가능): {}", e.getMessage());
        }

        // 4. DB 키워드 힌트 조회 후 Groq AI 응답 생성
        String botResponse;
        try {
            ChatVO hint = null;
            try { hint = chatMapper.findByKeyword(userMessage.trim()); }
            catch (Exception e) { log.warn("chat_keyword 조회 실패: {}", e.getMessage()); }

            if (hint != null) {
                botResponse = geminiService.askWithHint(userMessage, hint.getMessage());
                if (isErrorResponse(botResponse)) botResponse = hint.getMessage();
            } else {
                botResponse = geminiService.ask(userMessage);
            }
        } catch (Exception e) {
            log.error("Groq AI 응답 생성 실패: {}", e.getMessage());
            botResponse = "죄송합니다. 잠시 후 다시 시도해주세요. 😊";
        }

        // 5. 한국어 외 언어면 번역
        if (!"ko".equals(userLang) && !isErrorResponse(botResponse)) {
            botResponse = translationService.translate(botResponse, "ko", userLang);
        }

        // 6. 봇 응답 저장 (chat_log_t)
        ChatVO botLog = new ChatVO();
        botLog.setSessionId(sessionId);
        botLog.setMIdx(mIdx);
        botLog.setSender("bot");
        botLog.setMessage(botResponse);
        chatMapper.insertMessage(botLog);

        // 7. AI 챗봇용 봇 기록 저장 (chat_history)
        try {
            ChatHistoryVO botHistory = new ChatHistoryVO();
            botHistory.setSender("아메리");
            botHistory.setMessage(botResponse);
            chatMapper.saveHistory(botHistory);
        } catch (Exception e) {
            log.warn("chat_history 봇 저장 실패: {}", e.getMessage());
        }

        return botResponse;
    }

    @Override
    public List<ChatVO> getHistory(String sessionId) {
        return chatMapper.getHistory(sessionId);
    }

    private boolean isErrorResponse(String response) {
        return response.startsWith("AI 서버에 연결할 수 없습니다") ||
               response.startsWith("AI 답변 중 오류") ||
               response.startsWith("답변이 없습니다") ||
               response.startsWith("답변을 생성하지 못했습니다") ||
               response.startsWith("죄송합니다");
    }
}
