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

    @Value("${groq.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate;

    public GeminiService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL = "llama-3.3-70b-versatile";

    private static final String SYSTEM_PROMPT =
        "당신은 카페의 매니저 겸 안내원입니다. 다음 성격과 역할을 반드시 유지하세요.\n" +
        "1. 역할: 카페 매니저 총괄이자 안내원으로서, 카페의 메뉴, 운영, 서비스 전반을 책임집니다.\n" +
        "2. 태도: 서비스 마인드가 뛰어나며 항상 친절하고 따뜻하게 응대합니다. " +
        "고객이 편안함을 느낄 수 있도록 정중하면서도 친근한 말투를 사용합니다.\n" +
        "3. 말투: 공손하고 밝은 어조로 답변하며, 고객의 질문에 적극적으로 도움을 제공합니다.\n" +
        "4. ## 같은 마크다운 기호는 절대 사용하지 마세요.\n" +
        "   단, 핵심 단어나 중요한 정보는 **단어** 형식으로 강조하세요. (예: **24시간** 운영)\n" +
        "5. 답변은 너무 길지 않게, 3~5문장 내외로 적당히 작성하세요.\n" +
        "6. 답변에 상황에 어울리는 이모티콘을 1~2개 자연스럽게 포함하세요.\n" +
        "7. 반드시 한국어로만 답변하세요. 영어, 중국어, 일본어 등 다른 언어는 절대 사용하지 마세요. " +
        "번역투(예: '~하는 것을 가지다', '그것은 ~이다')를 지양하고 자연스러운 구어체를 사용하세요.\n" +
        "8. 한국 카페 문화에 맞는 단어를 선택하세요. (예: 'Order' 대신 '주문', 'Benefit' 대신 '혜택', 'Point' 대신 '포인트')\n" +
        "9. 답변 예시처럼 따뜻하고 자연스러운 문장을 사용하세요.\n" +
        "   (예: '고객님의 현재 잔여 포인트는 5,000점입니다. 맛있게 사용하세요! ☕')\n";

    public String ask(String userMessage) {
        String userPrompt = "위 역할에 맞게 아래 고객 질문에 답변해주세요.\n\n고객 질문: " + userMessage;
        return callGroq(userPrompt);
    }

    public String askWithHint(String userMessage, String dbResponse) {
        String userPrompt =
            "아래 참고 답변을 바탕으로, 위 역할에 맞게 고객 질문에 자연스럽게 답변해주세요. " +
            "참고 답변의 핵심 내용은 반드시 포함하세요.\n\n" +
            "고객 질문: " + userMessage + "\n" +
            "참고 답변: " + dbResponse;
        return callGroq(userPrompt);
    }

    @SuppressWarnings("unchecked")
    private String callGroq(String userPrompt) {
        Map<String, Object> body = Map.of(
            "model", MODEL,
            "messages", List.of(
                Map.of("role", "system", "content", SYSTEM_PROMPT),
                Map.of("role", "user", "content", userPrompt)
            )
        );

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map<String, Object>> response =
                restTemplate.exchange(API_URL, HttpMethod.POST, request,
                    (Class<Map<String, Object>>) (Class<?>) Map.class);

            Map<String, Object> responseBody = response.getBody();
            if (responseBody == null) {
                log.warn("Groq API 응답 본문이 비어있습니다.");
                return "응답이 없습니다.";
            }

            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
            if (choices == null || choices.isEmpty()) {
                log.warn("Groq API choices가 비어있습니다. 응답: {}", responseBody);
                return "응답을 생성하지 못했습니다.";
            }

            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            if (message == null) {
                log.warn("Groq API message가 null입니다.");
                return "응답 내용이 없습니다.";
            }

            String text = (String) message.get("content");
            return text != null ? text : "응답 텍스트가 없습니다.";

        } catch (org.springframework.web.client.HttpClientErrorException e) {
            log.error("Groq API HTTP 오류: {} {}", e.getStatusCode(), e.getMessage());
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (org.springframework.web.client.RestClientException e) {
            log.error("Groq API 네트워크 오류: {}", e.getMessage());
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (Exception e) {
            log.error("Groq API 오류: {}", e.getMessage(), e);
            return "AI 응답 중 오류가 발생했습니다.";
        }
    }
}
