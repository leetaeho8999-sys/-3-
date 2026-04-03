package com.chatbot.service;

import com.chatbot.mapper.ChatMapper;
import com.chatbot.vo.ChatHistoryVO;
import com.chatbot.vo.ChatVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class ChatServiceImpl implements ChatService {

    private static final Logger log = LoggerFactory.getLogger(ChatServiceImpl.class);

    private final ChatMapper chatMapper;
    private final GeminiService geminiService;
    private final TranslationService translationService;

    public ChatServiceImpl(ChatMapper chatMapper, GeminiService geminiService, TranslationService translationService) {
        this.chatMapper = chatMapper;
        this.geminiService = geminiService;
        this.translationService = translationService;
    }

    @Override
    public String getResponse(String userMessage, String nickname) {
        // 0. 사용자 입력 언어 감지
        String userLang = translationService.detectLanguage(userMessage);

        // 1. 사용자 메시지 저장 (실패해도 응답은 계속 진행)
        try {
            ChatHistoryVO userHistory = new ChatHistoryVO();
            userHistory.setSender(nickname);
            userHistory.setMessage(userMessage);
            chatMapper.saveHistory(userHistory);
        } catch (Exception e) {
            log.error("사용자 메시지 저장 실패: {}", e.getMessage());
        }

        // 2. DB에서 키워드 조회 (실패하면 Gemini 직접 호출로 fallback)
        ChatVO result = null;
        try {
            result = chatMapper.findByKeyword(userMessage.trim());
        } catch (Exception e) {
            log.error("키워드 조회 실패: {}", e.getMessage());
        }

        String response;
        if (result != null) {
            response = geminiService.askWithHint(userMessage, result.getResponse());
            if (isErrorResponse(response)) {
                response = result.getResponse();
            }
        } else {
            response = geminiService.ask(userMessage);
        }

        // 3. 아메리 응답 저장 (에러 메시지는 저장하지 않음)
        boolean isErrorResponse = isErrorResponse(response);
        if (!isErrorResponse) {
            try {
                ChatHistoryVO botHistory = new ChatHistoryVO();
                botHistory.setSender("아메리");
                botHistory.setMessage(response);
                chatMapper.saveHistory(botHistory);
            } catch (Exception e) {
                log.error("아메리 응답 저장 실패: {}", e.getMessage());
            }
        }

        // 4. 한국어가 아닌 경우 손님 언어로 번역
        if (!isErrorResponse && !"ko".equals(userLang)) {
            response = translationService.translate(response, "ko", userLang);
        }

        return response;
    }

    private boolean isErrorResponse(String response) {
        return response.startsWith("AI 서버에 연결할 수 없습니다") ||
               response.startsWith("AI 응답 중 오류") ||
               response.startsWith("응답이 없습니다") ||
               response.startsWith("응답을 생성하지 못했습니다") ||
               response.startsWith("응답 내용이 없습니다") ||
               response.startsWith("응답 텍스트가 없습니다");
    }

    @Override
    public List<ChatHistoryVO> getHistory() {
        try {
            return chatMapper.getHistory();
        } catch (Exception e) {
            log.error("채팅 기록 조회 실패: {}", e.getMessage());
            return Collections.emptyList();
        }
    }
}
