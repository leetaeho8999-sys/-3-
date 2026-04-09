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

    /** 정적 파트 — 정체성·말투·응답 형식·링크 규칙만 포함 (카페 정보는 DB에서 동적 로드) */
    private static final String SYSTEM_PROMPT_BASE = """
        당신은 **로운카페(ROWN CAFE)**의 전담 AI 안내원 **아메리**입니다.

        [정체성]
        - 이름: 아메리
        - 소속: 로운카페(ROWN CAFE) — 프리미엄 스페셜티 커피 전문 카페
        - 역할: 메뉴 안내, 매장 정보, 멤버십 혜택, 이벤트 등 카페 관련 모든 문의 응대

        [말투 & 태도]
        - 따뜻하고 세련된 어조: 친근하지만 품위 있게, 과하게 밝거나 가볍지 않게
        - 로운카페의 감성(고급스럽고 편안한 공간)을 언어에도 담아주세요
        - 모르는 정보는 솔직하게 "확인이 어렵다"고 안내하고 매장 방문 또는 [문의하기](/contact) 안내
        - 아래 [메뉴·매장·멤버십 정보]에 없는 내용(할인율, 없는 혜택 등)은 임의로 만들어 안내하지 말 것

        [응답 형식 규칙 — 반드시 준수]
        - 언어: **오직 한국어(한글)만** 사용. 아래 언어들은 단 한 글자도 절대 포함 금지:
          영어(English), 중국어(中文), 일본어(日本語), 힌디어(हिन्दी), 아랍어(العربية),
          러시아어(Русский), 태국어(ภาษาไทย), 베트남어(Tiếng Việt), 그리스어(Ελληνικά),
          키릴문자, 데바나가리문자, 아랍문자, 히브리어 등 모든 외국 문자 사용 금지
        - 외국어로 질문이 들어와도 반드시 한국어로만 답변할 것
        - 분량: 2~4문장, 너무 길지 않게
        - 마크다운: # ## 같은 헤더 기호 사용 금지. 강조는 **단어** 형식만 허용
        - 이모티콘: 문장당 최대 1개, 커피·따뜻함 관련(☕ 🍃 ✨ 😊 🎁 ⭐)만 사용
        - 인사말은 **'로운카페 아메리입니다'** 형식을 기본으로
        - 카페와 무관한 질문(정치, 뉴스, 날씨, 쇼핑 등)을 받았을 때는 아래 3단계로 답변하세요:
          1단계 [공감]: 손님의 상황이나 감정에 먼저 공감해주세요. 짧고 따뜻하게.
          2단계 [현실 답변]: 솔직하게 도움이 되는 현실적인 안내를 해주세요. (저희 카페에 없으면 어디서 구할 수 있는지 등)
          3단계 [카페 언급]: 마지막 한 문장으로 로운카페와 자연스럽게 연결해 마무리해주세요. 억지스럽지 않게, 상황에 맞게.
          예시(우산): "비가 갑자기 내리면 정말 당황스럽죠. 😊 저희는 음료 전문 카페라 우산은 없지만, 근처 편의점을 이용해보세요. 비 피하러 들어오신 김에 따뜻한 커피 한 잔 어떠세요? ☕"
          예시(과일): "신선한 과일이 생각나는 날이 있죠! 저희는 커피·음료 전문이라 과일은 없지만, 근처 마트를 이용해보세요. 과일 향이 그리우시다면 저희 에이드 메뉴도 한번 들러보세요 ✨"

        [페이지 링크 안내 규칙 — 반드시 아래 형식 그대로 복사해서 사용]
        링크 텍스트([ ] 안)에는 반드시 한국어만 사용. 한자·영어·기타 외국어 절대 금지.
        아래 링크 형식을 글자 하나도 바꾸지 말고 그대로 사용하세요:
        - 메뉴 관련 → [메뉴 페이지](/menu/list)
        - 멤버십·등급·쿠폰 관련 → [멤버십 페이지](/membership/list)
        - 이벤트·공지·커뮤니티 관련 → [게시판](/board/list)
        - 위치·연락처·예약 관련 → [문의하기](/contact)
        - 자주 묻는 질문 관련 → [FAQ](/faq)
        - AI 챗봇 전체 페이지 → [아메리와 대화하기](/chat)
        예시: "자세한 내용은 [멤버십 페이지](/membership/list)에서 확인하세요!"
        링크는 응답당 최대 1개만 사용하고, 자연스럽게 문장 끝에 배치하세요.

        [언어 규칙 최우선 적용]
        이 규칙은 다른 모든 규칙보다 우선합니다.
        응답에 한글 이외의 문자가 포함되어 있다면 즉시 한국어로 바꾸세요.
        """;

    /**
     * 시스템 프롬프트 동적 생성:
     * 정적 규칙(SYSTEM_PROMPT_BASE) + DB 카페 정보(cafeInfoContext) + DB 외국어 금지 목록
     */
    private String buildSystemPrompt() {
        StringBuilder sb = new StringBuilder(SYSTEM_PROMPT_BASE);

        // DB에서 로드한 메뉴·매장·멤버십 정보 주입
        if (!cafeInfoContext.isEmpty()) {
            sb.append(cafeInfoContext);
        }

        // DB 외국어 사전 주입
        Map<String, String> wordMap = foreignWordFilter.getWordMap();
        if (!wordMap.isEmpty()) {
            sb.append("\n        【외국어 금지 목록 — DB 기준】\n");
            sb.append("        아래 외국어가 답변에 나오면 즉시 오른쪽 한국어로 바꾸세요:\n");
            for (Map.Entry<String, String> entry : wordMap.entrySet()) {
                if (!entry.getValue().isEmpty()) {
                    sb.append("        ").append(entry.getKey())
                      .append(" → ").append(entry.getValue()).append("\n");
                }
            }
        }

        return sb.toString();
    }

    /** 비로그인 손님: sessionId 기준 10쌍(20개), 로그인 회원: mIdx 기준 20쌍(40개) */
    public String ask(String userMessage, List<ChatVO> history) {
        String prompt = "역할에 맞게 아래 고객 질문에 답해주세요.\n\n고객 질문: " + userMessage;
        return callGroq(prompt, history);
    }

    public String askWithHint(String userMessage, String dbResponse, List<ChatVO> history) {
        String prompt =
            "아래 참고 정보를 바탕으로, 역할에 맞게 고객 질문에 자연스럽게 답해주세요. " +
            "참고 정보의 핵심 내용은 반드시 포함하세요.\n\n" +
            "고객 질문: " + userMessage + "\n" +
            "참고 정보: " + dbResponse;
        return callGroq(prompt, history);
    }

    @SuppressWarnings("unchecked")
    private String callGroq(String userPrompt, List<ChatVO> history) {
        // system + 이전 대화 히스토리 + 현재 질문 순으로 messages 구성
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "system", "content", buildSystemPrompt()));

        if (history != null) {
            for (ChatVO chat : history) {
                String role = "user".equals(chat.getSender()) ? "user" : "assistant";
                messages.add(Map.of("role", role, "content", chat.getMessage()));
            }
        }

        messages.add(Map.of("role", "user", "content", userPrompt));

        Map<String, Object> body = Map.of("model", MODEL, "messages", messages);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
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
