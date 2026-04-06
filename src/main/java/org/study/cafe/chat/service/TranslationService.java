package org.study.cafe.chat.service;

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

    /** 입력 텍스트의 언어를 간단히 감지합니다. @return "ko", "zh", "ja", "en" */
    public String detectLanguage(String text) {
        if (text == null || text.isBlank()) return "ko";
        long chinese = text.chars().filter(c -> c >= 0x4E00 && c <= 0x9FFF).count();
        long japanese = text.chars().filter(c -> c >= 0x3040 && c <= 0x30FF).count();
        long korean  = text.chars().filter(c -> c >= 0xAC00 && c <= 0xD7A3).count();
        long total   = text.length();
        if (korean  > total * 0.2) return "ko";
        if (japanese > total * 0.1) return "ja";
        if (chinese  > total * 0.1) return "zh";
        return "en";
    }

    /** 텍스트를 번역합니다. 실패 시 원본을 반환합니다. */
    @SuppressWarnings("unchecked")
    public String translate(String text, String fromLang, String toLang) {
        if (fromLang.equals(toLang)) return text;
        try {
            String url = UriComponentsBuilder.fromHttpUrl(API_URL)
                .queryParam("q", text)
                .queryParam("langpair", fromLang + "|" + toLang)
                .build().toUriString();
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            if (response == null) return text;
            Map<String, Object> data = (Map<String, Object>) response.get("responseData");
            if (data == null) return text;
            String translated = (String) data.get("translatedText");
            return (translated != null && !translated.isBlank()) ? translated : text;
        } catch (Exception e) {
            log.error("번역 실패: {}", e.getMessage());
            return text;
        }
    }
}
