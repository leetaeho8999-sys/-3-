package org.study.cafe.chat.service;

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
    private static final String MODEL   = "llama-3.3-70b-versatile";

    private static final String SYSTEM_PROMPT =
        "당신은 카페의 매니저 겸 안내원입니다. 다음 성격을 반드시 따라주세요.\n" +
        "1. 역할: 카페 매니저 총괄자 안내원으로서, 카페의 메뉴, 운영, 서비스 전반을 책임집니다.\n" +
        "2. 태도: 서비스 마인드를 갖추며 항상 친절하고 따뜻하게 응대합니다. 공손하면서도 친근한 말투를 사용합니다.\n" +
        "3. 말투: 공손하고 밝은 어조를 유지하며, 고객의 질문에 적극적으로 도움을 제공합니다.\n" +
        "4. ## 같은 마크다운 기호는 절대 사용하지 마세요. 중요한 정보는 **단어** 형식으로 강조하세요.\n" +
        "5. 답변은 3~5문장 이내로 적당히 작성하세요.\n" +
        "6. 상황에 어울리는 이모티콘을 1~2개 자연스럽게 포함하세요.\n" +
        "7. 반드시 한국어로만 응답하세요. 영어·중국어·일본어 등 다른 언어는 절대 사용하지 마세요.\n" +
        "8. 한국 카페 문화에 맞는 단어를 선택하세요. (예: Order→주문, Benefit→혜택)\n" +
        "9. 현지 직원처럼 따뜻하고 자연스러운 문장을 사용하세요.\n";

    public String ask(String userMessage) {
        String prompt = "역할에 맞게 아래 고객 질문에 답해주세요.\n\n고객 질문: " + userMessage;
        return callGroq(prompt);
    }

    public String askWithHint(String userMessage, String dbResponse) {
        String prompt =
            "아래 참고 정보를 바탕으로, 역할에 맞게 고객 질문에 자연스럽게 답해주세요. " +
            "참고 정보의 핵심 내용은 반드시 포함하세요.\n\n" +
            "고객 질문: " + userMessage + "\n" +
            "참고 정보: " + dbResponse;
        return callGroq(prompt);
    }

    @SuppressWarnings("unchecked")
    private String callGroq(String userPrompt) {
        Map<String, Object> body = Map.of(
            "model", MODEL,
            "messages", List.of(
                Map.of("role", "system", "content", SYSTEM_PROMPT),
                Map.of("role", "user",   "content", userPrompt)
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
            if (responseBody == null) return "답변이 없습니다.";

            List<Map<String, Object>> choices =
                (List<Map<String, Object>>) responseBody.get("choices");
            if (choices == null || choices.isEmpty()) return "답변을 생성하지 못했습니다.";

            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            if (message == null) return "답변 내용이 없습니다.";

            String text = (String) message.get("content");
            return text != null ? text : "답변 텍스트가 없습니다.";

        } catch (org.springframework.web.client.HttpClientErrorException e) {
            log.error("Groq API HTTP 오류: {} {}", e.getStatusCode(), e.getMessage());
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (org.springframework.web.client.RestClientException e) {
            log.error("Groq API 네트워크 오류: {}", e.getMessage());
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (Exception e) {
            log.error("Groq API 오류: {}", e.getMessage(), e);
            return "AI 답변 중 오류가 발생했습니다.";
        }
    }
}
