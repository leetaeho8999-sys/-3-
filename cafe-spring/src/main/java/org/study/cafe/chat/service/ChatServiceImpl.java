package org.study.cafe.chat.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.chat.mapper.ChatMapper;
import org.study.cafe.chat.vo.ChatHistoryVO;
import org.study.cafe.chat.vo.ChatRatingVO;
import org.study.cafe.chat.vo.ChatVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChatServiceImpl implements ChatService {

    private static final Logger log = LoggerFactory.getLogger(ChatServiceImpl.class);

    @Autowired private ChatMapper chatMapper;
    @Autowired private GroqService groqService;
    @Autowired private TranslationService translationService;

    @Override
    public String sendMessage(String userMessage, String sessionId, String mIdx) {
        // 1. 사용자 언어 감지
        String userLang = translationService.detectLanguage(userMessage);

        // 2. Groq 컨텍스트용 히스토리 조회 (현재 메시지 저장 전에 조회해야 중복 방지)
        //    로그인 회원: mIdx 기준 최근 40개(20쌍), 비로그인 손님: sessionId 기준 최근 20개(10쌍)
        List<ChatVO> contextHistory = List.of();
        try {
            boolean isLoggedIn = mIdx != null && !mIdx.isEmpty();
            Map<String, Object> histParams = new HashMap<>();
            histParams.put("sessionId", sessionId);
            histParams.put("mIdx",      isLoggedIn ? mIdx : null);
            histParams.put("limit",     isLoggedIn ? 40   : 20);
            contextHistory = chatMapper.getContextHistory(histParams);
        } catch (Exception e) {
            log.warn("컨텍스트 히스토리 조회 실패: {}", e.getMessage());
        }

        // 3. 사용자 메시지 저장 (chat_log_t)
        ChatVO userLog = new ChatVO();
        userLog.setSessionId(sessionId);
        userLog.setMIdx(mIdx);
        userLog.setSender("user");
        userLog.setMessage(userMessage);
        chatMapper.insertMessage(userLog);

        // 4. AI 챗봇용 사용자 기록 저장 (chat_history)
        try {
            ChatHistoryVO userHistory = new ChatHistoryVO();
            userHistory.setSender("손님");
            userHistory.setMessage(userMessage);
            chatMapper.saveHistory(userHistory);
        } catch (Exception e) {
            log.warn("chat_history 저장 실패 (테이블 미생성 가능): {}", e.getMessage());
        }

        // 5. DB 키워드 힌트 조회 후 Groq AI 응답 생성 (히스토리 포함)
        String botResponse;
        try {
            ChatVO hint = null;
            try { hint = chatMapper.findByKeyword(userMessage.trim()); }
            catch (Exception e) { log.warn("chat_keyword 조회 실패: {}", e.getMessage()); }

            if (hint != null) {
                botResponse = groqService.askWithHint(userMessage, hint.getMessage(), contextHistory);
                if (isErrorResponse(botResponse)) botResponse = hint.getMessage();
            } else {
                botResponse = groqService.ask(userMessage, contextHistory);
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

    @Override
    public void saveRating(String botMessage, String rating) {
        try {
            ChatRatingVO ratingVO = new ChatRatingVO();
            ratingVO.setBotMessage(botMessage);
            ratingVO.setRating(rating);
            chatMapper.saveRating(ratingVO);
        } catch (Exception e) {
            log.error("만족도 평가 저장 실패: {}", e.getMessage());
        }
    }

    private boolean isErrorResponse(String response) {
        return response.startsWith("AI 서버에 연결할 수 없습니다") ||
               response.startsWith("AI 답변 중 오류") ||
               response.startsWith("답변이 없습니다") ||
               response.startsWith("답변을 생성하지 못했습니다") ||
               response.startsWith("죄송합니다");
    }
}
