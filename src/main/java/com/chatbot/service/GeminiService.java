package com.chatbot.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
public class GeminiService {

    private static final Logger log = LoggerFactory.getLogger(GeminiService.class);

    @Value("${gemini.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate;

    public GeminiService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    private static final String API_URL =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=";

    private static final String SYSTEM_PROMPT =
        "당신은 카페의 매니저 겸 안내원입니다. 다음 성격과 역할을 반드시 유지하세요.\n" +
        "1. 역할: 카페 매니저 총괄이자 안내원으로서, 카페의 메뉴, 운영, 서비스 전반을 책임집니다.\n" +
        "2. 태도: 서비스 마인드가 뛰어나며 항상 친절하고 따뜻하게 응대합니다. " +
        "고객이 편안함을 느낄 수 있도록 정중하면서도 친근한 말투를 사용합니다.\n" +
        "3. 말투: 공손하고 밝은 어조로 답변하며, 고객의 질문에 적극적으로 도움을 제공합니다.\n";

    @SuppressWarnings("unchecked")
    public String ask(String userMessage) {
        String prompt = SYSTEM_PROMPT +
            "위 역할에 맞게 아래 고객 질문에 답변해주세요.\n\n" +
            "고객 질문: " + userMessage;
        return callGemini(prompt);
    }

    @SuppressWarnings("unchecked")
    public String askWithHint(String userMessage, String dbResponse) {
        String prompt = SYSTEM_PROMPT +
            "아래 참고 답변을 바탕으로, 위 역할에 맞게 고객 질문에 자연스럽게 답변해주세요. " +
            "참고 답변의 핵심 내용은 반드시 포함하세요.\n\n" +
            "고객 질문: " + userMessage + "\n" +
            "참고 답변: " + dbResponse;
        return callGemini(prompt);
    }

    @SuppressWarnings("unchecked")
    private String callGemini(String prompt) {
        Map<String, Object> body = Map.of(
            "contents", List.of(
                Map.of("parts", List.of(
                    Map.of("text", prompt)
                ))
            )
        );

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map<String, Object>> response =
                restTemplate.exchange(API_URL + apiKey, HttpMethod.POST, request,
                    (Class<Map<String, Object>>) (Class<?>) Map.class);

            Map<String, Object> responseBody = response.getBody();
            if (responseBody == null) {
                log.warn("Gemini API 응답 본문이 비어있습니다.");
                return "응답이 없습니다.";
            }

            List<Map<String, Object>> candidates = (List<Map<String, Object>>) responseBody.get("candidates");
            if (candidates == null || candidates.isEmpty()) {
                log.warn("Gemini API candidates가 비어있습니다. 응답: {}", responseBody);
                return "응답을 생성하지 못했습니다.";
            }

            Map<String, Object> content = (Map<String, Object>) candidates.get(0).get("content");
            if (content == null) {
                log.warn("Gemini API content가 null입니다.");
                return "응답 내용이 없습니다.";
            }

            List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
            if (parts == null || parts.isEmpty()) {
                log.warn("Gemini API parts가 비어있습니다.");
                return "응답 내용이 없습니다.";
            }

            String text = (String) parts.get(0).get("text");
            return text != null ? text : "응답 텍스트가 없습니다.";

        } catch (org.springframework.web.client.RestClientException e) {
            log.error("Gemini API 네트워크 오류: {}", e.getMessage(), e);
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (Exception e) {
            log.error("Gemini API 오류: {}", e.getMessage(), e);
            return "AI 응답 중 오류가 발생했습니다.";
        }
    }
}

