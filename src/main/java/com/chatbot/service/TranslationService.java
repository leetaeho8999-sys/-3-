package com.chatbot.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Map;

@Service
public class TranslationService {

    private static final Logger log = LoggerFactory.getLogger(TranslationService.class);

    private static final String API_URL = "https://api.mymemory.translated.net/get";

    private final RestTemplate restTemplate;

    public TranslationService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * 입력 텍스트의 언어를 간단히 감지합니다.
     * @return "ko", "zh", "ja", "en" 등
     */
    public String detectLanguage(String text) {
        if (text == null || text.isBlank()) return "ko";

        long chineseCount = text.chars()
            .filter(c -> c >= 0x4E00 && c <= 0x9FFF)
            .count();
        long japaneseCount = text.chars()
            .filter(c -> (c >= 0x3040 && c <= 0x30FF))
            .count();
        long koreanCount = text.chars()
            .filter(c -> c >= 0xAC00 && c <= 0xD7A3)
            .count();

        long total = text.length();
        if (koreanCount > total * 0.2) return "ko";
        if (japaneseCount > total * 0.1) return "ja";
        if (chineseCount > total * 0.1) return "zh";
        return "en";
    }

    /**
     * 텍스트를 번역합니다.
     * @param text 번역할 텍스트
     * @param fromLang 원본 언어 코드 (예: "ko")
     * @param toLang 목표 언어 코드 (예: "zh")
     * @return 번역된 텍스트 (실패 시 원본 반환)
     */
    @SuppressWarnings("unchecked")
    public String translate(String text, String fromLang, String toLang) {
        if (fromLang.equals(toLang)) return text;

        try {
            String url = UriComponentsBuilder.fromHttpUrl(API_URL)
                .queryParam("q", text)
                .queryParam("langpair", fromLang + "|" + toLang)
                .build()
                .toUriString();

            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            if (response == null) return text;

            Map<String, Object> responseData = (Map<String, Object>) response.get("responseData");
            if (responseData == null) return text;

            String translated = (String) responseData.get("translatedText");
            return (translated != null && !translated.isBlank()) ? translated : text;

        } catch (Exception e) {
            log.error("번역 실패: {}", e.getMessage());
            return text;
        }
    }
}
