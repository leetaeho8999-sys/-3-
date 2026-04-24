package org.study.cafe.chat.service;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.study.cafe.chat.mapper.ChatMapper;
import org.study.cafe.menu.mapper.MenuMapper;
import org.study.cafe.menu.vo.MenuVO;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.study.cafe.chat.vo.ChatVO;

@Service
public class GroqService {

    private static final Logger log = LoggerFactory.getLogger(GroqService.class);

    /** 기본값 "" — null 주입 방지 (미설정 시 API 호출 실패로 처리됨) */
    @Value("${groq.api.key:}")
    private String apiKey;

    private final RestTemplate restTemplate;
    private final ForeignWordFilter foreignWordFilter;
    private final MenuMapper menuMapper;
    private final ChatMapper chatMapper;

    /** 앱 시작 시 DB에서 로드한 카페 정보 컨텍스트 (메뉴·매장·멤버십) */
    private volatile String cafeInfoContext = "";

    public GroqService(RestTemplate restTemplate,
                       ForeignWordFilter foreignWordFilter,
                       MenuMapper menuMapper,
                       ChatMapper chatMapper) {
        this.restTemplate    = restTemplate;
        this.foreignWordFilter = foreignWordFilter;
        this.menuMapper      = menuMapper;
        this.chatMapper      = chatMapper;
    }

    /** 앱 시작 시 DB에서 메뉴 + 키워드 정보를 로드하여 시스템 프롬프트 컨텍스트 생성 */
    @PostConstruct
    public void loadCafeInfo() {
        try {
            StringBuilder sb = new StringBuilder();

            // ── 1. menu_t → 카테고리별 메뉴·가격 ──────────────────────────────
            try {
                List<MenuVO> menus = menuMapper.getMenuList(null);
                if (!menus.isEmpty()) {
                    sb.append("\n        [메뉴 정보 — DB 기준, 현재 판매 중인 메뉴만]\n");
                    Map<String, List<MenuVO>> byCategory = menus.stream()
                            .collect(Collectors.groupingBy(MenuVO::getCategory,
                                     LinkedHashMap::new, Collectors.toList()));
                    for (Map.Entry<String, List<MenuVO>> entry : byCategory.entrySet()) {
                        String items = entry.getValue().stream()
                                .map(m -> m.getName() + " "
                                        + String.format("%,d", m.getPrice()) + "원")
                                .collect(Collectors.joining(", "));
                        sb.append("        - ").append(entry.getKey())
                          .append(": ").append(items).append("\n");
                    }
                    sb.append("        - 텀블러 지참 시 1,000원 할인\n");
                    sb.append("        - 자세한 메뉴는 [메뉴 페이지](/menu/list) 참고\n");
                }
            } catch (Exception e) {
                log.warn("menu_t 로드 실패: {}", e.getMessage());
            }

            // ── 2. chat_keyword → 매장·운영·멤버십 정보 ────────────────────────
            try {
                List<Map<String, Object>> keywords = chatMapper.findAllKeywords();
                // 프롬프트에 주입할 핵심 키워드 (순서 중요)
                String[] targetKeys = {"매장", "영업", "영업시간", "멤버십", "주차", "24시간"};
                Map<String, String> kwMap = new LinkedHashMap<>();
                for (Map<String, Object> row : keywords) {
                    String kw = String.valueOf(row.get("keyword"));
                    String resp = String.valueOf(row.get("response"));
                    kwMap.put(kw, resp);
                }

                sb.append("\n        [매장·운영·멤버십 정보 — DB 기준, 반드시 이 정보만 사용]\n");
                for (String key : targetKeys) {
                    if (kwMap.containsKey(key)) {
                        // 마크다운 링크 제거 후 순수 텍스트만 추출
                        String plain = kwMap.get(key)
                                .replaceAll("\\[([^\\]]+)\\]\\([^)]+\\)", "$1")
                                .replaceAll("[☕🍃✨😊🎁⭐]", "").trim();
                        sb.append("        - ").append(key).append(": ")
                          .append(plain).append("\n");
                    }
                }
                sb.append("        - 존재하지 않는 등급(브론즈, 플래티넘 등)은 절대 언급 금지\n");
                sb.append("        - 확인되지 않은 할인율·혜택을 임의로 안내하지 말 것\n");
            } catch (Exception e) {
                log.warn("chat_keyword 로드 실패: {}", e.getMessage());
            }

            cafeInfoContext = sb.toString();
            log.info("카페 정보 컨텍스트 로드 완료 ({} chars)", cafeInfoContext.length());
        } catch (Exception e) {
            log.error("카페 정보 컨텍스트 로드 실패: {}", e.getMessage());
        }
    }

    private static final String     API_URL     = "https://api.groq.com/openai/v1/chat/completions";
    private static final String     MODEL       = "llama-3.3-70b-versatile";
    /** HttpMethod.POST는 null이 될 수 없는 상수 — @NonNull 명시로 IDE 경고 제거 */
    @NonNull
    private static final HttpMethod HTTP_POST   = java.util.Objects.requireNonNull(HttpMethod.POST);

    /** 정적 파트 — 경량화 버전 (~800 토큰, CLAUDE.md 규칙 5 준수) */
    private static final String SYSTEM_PROMPT_BASE = """
        당신은 로운카페(ROWN CAFE)의 AI 안내원 **아메리**입니다.

        [말투] 따뜻하고 세련되게, 2~4문장으로 간결하게. 이모티콘은 문장당 최대 1개 (☕🍃✨😊🎁⭐).
        [언어] 오직 한국어(한글)만. 외국 문자 일체 금지. 외국어 질문도 한국어로 답변.
        [금지] 확인 안 된 할인율·혜택·없는 등급(브론즈·플래티넘 등) 임의 안내 금지.

        [링크 규칙 — 주제에 맞는 것 1~2개만 자연스럽게 배치]
        메뉴/가격/음료/원두        → [메뉴 페이지](/menu/list)
        멤버십/쿠폰/등급/혜택      → [멤버십 페이지](/membership/list)
        이벤트/공지/후기/커뮤니티  → [게시판](/board/list)
        회원가입/신규 가입          → [회원가입](/member/register)
        로그인/아이디·비밀번호 찾기 → [로그인](/member/login)
        내 정보/내 글/탈퇴/개인설정 → [마이페이지](/member/mypage)
        위치/영업시간/주차/예약    → [문의하기](/contact)
        자주 묻는 질문              → [FAQ](/faq)

        [문의하기]는 매장 운영 관련에만 사용. 다른 주제의 도피처로 쓰지 말 것.
        링크 텍스트는 한국어만, URL 경로(/menu/list 등)는 그대로 복사. 수정·번역 금지.

        [카페 외 질문] 3단계: 공감 → 현실 답변 → 카페 자연스럽게 언급.
        예: "비 오면 당황스럽죠 😊 저희는 우산은 없어요. 따뜻한 커피 한 잔 어떠세요 ☕"

        [예시 3가지]
        - "아메리카노 얼마?" → "아메리카노는 4,500원입니다 ☕ 전체 메뉴는 [메뉴 페이지](/menu/list)에서 확인하세요."
        - "비밀번호 잊었어요" → "[로그인](/member/login) 페이지의 '비밀번호 찾기'에서 재설정하실 수 있어요 😊"
        - "내가 쓴 글 보고 싶어" → "작성하신 글은 [마이페이지](/member/mypage)의 '내가 쓴 글'에서 확인 가능합니다 ☕"
        """;

    /**
     * 시스템 프롬프트 동적 생성:
     * 정적 규칙(SYSTEM_PROMPT_BASE) + 로그인 상태별 짧은 가이드 + DB 카페 정보(cafeInfoContext)
     * ※ 외국어 사전(wordMap) 프롬프트 주입은 제거 — foreignWordFilter.filter() 후처리로 충분, 토큰 절약
     */
    private String buildSystemPrompt(boolean isLoggedIn) {
        StringBuilder sb = new StringBuilder(SYSTEM_PROMPT_BASE);

        // 로그인 상태별 짧은 가이드
        sb.append("\n[고객 상태] ");
        if (isLoggedIn) {
            sb.append("로그인 회원 — [로그인]·[회원가입] 링크 사용 금지. 개인 기능은 [마이페이지]로 안내.");
        } else {
            sb.append("비로그인 손님 — [마이페이지] 링크 사용 금지. 회원 기능은 [로그인] 또는 [회원가입]으로 안내.");
        }

        // DB 메뉴·매장·멤버십 정보 (cafeInfoContext) 는 유지
        if (!cafeInfoContext.isEmpty()) {
            sb.append(cafeInfoContext);
        }

        return sb.toString();
    }

    /** 비로그인 손님: sessionId 기준 10쌍(20개), 로그인 회원: mIdx 기준 20쌍(40개) */
    public String ask(String userMessage, List<ChatVO> history, boolean isLoggedIn) {
        String prompt = "역할에 맞게 아래 고객 질문에 답해주세요.\n\n고객 질문: " + userMessage;
        return callGroq(prompt, history, isLoggedIn);
    }

    public String askWithHint(String userMessage, String dbResponse, List<ChatVO> history, boolean isLoggedIn) {
        String prompt =
            "아래 참고 정보를 바탕으로, 역할에 맞게 고객 질문에 자연스럽게 답해주세요. " +
            "참고 정보의 핵심 내용은 반드시 포함하세요.\n\n" +
            "고객 질문: " + userMessage + "\n" +
            "참고 정보: " + dbResponse;
        return callGroq(prompt, history, isLoggedIn);
    }

    @SuppressWarnings("unchecked")
    private String callGroq(String userPrompt, List<ChatVO> history, boolean isLoggedIn) {
        // system + 이전 대화 히스토리 + 현재 질문 순으로 messages 구성
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "system", "content", buildSystemPrompt(isLoggedIn)));

        if (history != null) {
            for (ChatVO chat : history) {
                String msg = chat.getMessage();
                if (msg == null || msg.isBlank()) continue;
                String role = "user".equals(chat.getSender()) ? "user" : "assistant";
                messages.add(Map.of("role", role, "content", msg));
            }
        }

        messages.add(Map.of("role", "user", "content", userPrompt));

        Map<String, Object> body = Map.of("model", MODEL, "messages", messages);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType("application", "json", java.nio.charset.StandardCharsets.UTF_8));
        headers.setBearerAuth(apiKey);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map<String, Object>> response =
                restTemplate.exchange(API_URL, HTTP_POST, request,
                    (Class<Map<String, Object>>) (Class<?>) Map.class);

            Map<String, Object> responseBody = response.getBody();
            if (responseBody == null) return "답변이 없습니다.";

            List<Map<String, Object>> choices =
                (List<Map<String, Object>>) responseBody.get("choices");
            if (choices == null || choices.isEmpty()) return "답변을 생성하지 못했습니다.";

            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            if (message == null) return "답변 내용이 없습니다.";

            String text = (String) message.get("content");
            return text != null ? foreignWordFilter.filter(text) : "답변 텍스트가 없습니다.";

        } catch (org.springframework.web.client.HttpClientErrorException e) {
            if (e.getStatusCode().value() == 429) {
                log.warn("Groq API 사용량 한도 초과 (429): {}", e.getMessage());
                return "지금 문의가 많아 조금 기다려 주세요 ☕ 잠시 후 다시 여쭤봐 주시면 감사하겠습니다.";
            }
            log.error("Groq API HTTP 오류 status={}", e.getStatusCode());
            log.error("Groq API 응답 본문: {}", e.getResponseBodyAsString());
            log.error("Groq API 응답 헤더: {}", e.getResponseHeaders());
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (org.springframework.web.client.HttpServerErrorException e) {
            log.error("Groq API 5xx 오류 status={}", e.getStatusCode());
            log.error("Groq API 응답 본문: {}", e.getResponseBodyAsString());
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (org.springframework.web.client.RestClientException e) {
            log.error("Groq API 네트워크 오류 (스택 전체): ", e);
            return "AI 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.";
        } catch (Exception e) {
            log.error("Groq API 오류 (스택 전체): ", e);
            return "AI 답변 중 오류가 발생했습니다.";
        }
    }
}
