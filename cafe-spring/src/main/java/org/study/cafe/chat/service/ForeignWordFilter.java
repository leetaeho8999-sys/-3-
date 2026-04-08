package org.study.cafe.chat.service;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.study.cafe.chat.mapper.ForeignWordMapper;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 외국어 → 한국어 치환 필터
 * 앱 시작 시 DB(foreign_word_map)에서 전체 단어를 로드하여 메모리 Map에 보관.
 * 이후 요청은 메모리 Map으로 처리하므로 DB 쿼리 없이 빠르게 동작.
 */
@Service
public class ForeignWordFilter {

    private static final Logger log = LoggerFactory.getLogger(ForeignWordFilter.class);

    private final ForeignWordMapper foreignWordMapper;

    /** 치환 순서 보장 (긴 패턴 우선 — DB에서 LENGTH DESC로 정렬되어 들어옴) */
    private Map<String, String> wordMap = new LinkedHashMap<>();

    public ForeignWordFilter(ForeignWordMapper foreignWordMapper) {
        this.foreignWordMapper = foreignWordMapper;
    }

    /** 앱 시작 시 DB에서 단어 전체 로드 */
    @PostConstruct
    public void init() {
        try {
            List<Map<String, Object>> rows = foreignWordMapper.findAll();
            Map<String, String> loaded = new LinkedHashMap<>();
            for (Map<String, Object> row : rows) {
                String foreign = (String) row.get("foreignWord");
                String korean  = (String) row.get("koreanWord");
                if (foreign != null) {
                    loaded.put(foreign, korean != null ? korean : "");
                }
            }
            this.wordMap = loaded;
            log.info("외국어 치환 사전 로드 완료: {}개", loaded.size());
        } catch (Exception e) {
            log.error("외국어 치환 사전 로드 실패 — DB 확인 필요: {}", e.getMessage());
        }
    }

    /** DB에서 로드된 치환 사전을 반환합니다 (GroqService 프롬프트 생성용) */
    public Map<String, String> getWordMap() {
        return wordMap;
    }

    /**
     * 외국어 혼용 텍스트를 한국어로 정리합니다.
     * 1) DB에서 로드한 단어 치환
     * 2) 마크다운 링크 [텍스트](URL) 임시 보호 (URL이 제거되지 않도록)
     * 3) 외국 문자를 유니코드 범위로 제거
     * 4) 마크다운 링크 복원
     */
    public String filter(String text) {
        if (text == null || text.isBlank()) return text;

        String result = text;

        // 1) 단어 치환 (메모리 Map, DB 로드 순서 유지)
        for (Map.Entry<String, String> entry : wordMap.entrySet()) {
            result = result.replace(entry.getKey(), entry.getValue());
        }

        // 2) 마크다운 링크 URL만 보호 — label 텍스트는 필터를 거쳐 외국 문자가 제거됨
        //    [label](url) → [label](\uE000N\uE001) 로 치환 (URL만 placeholder)
        //    이렇게 하면 label의 한자·외국 문자는 step3에서 제거되고, URL은 보호됨
        java.util.regex.Pattern linkPat =
            java.util.regex.Pattern.compile("\\[([^\\]]+)\\]\\(([^)]+)\\)");
        java.util.regex.Matcher lm = linkPat.matcher(result);
        java.util.Map<String, String> linkHolder = new java.util.LinkedHashMap<>();
        StringBuffer lsb = new StringBuffer();
        int li = 0;
        while (lm.find()) {
            String label = lm.group(1); // label은 그대로 유지 → 외국 문자 필터 적용됨
            String url   = lm.group(2); // URL만 placeholder로 보호
            String ph = "\uE000" + li++ + "\uE001";
            linkHolder.put(ph, url);
            lm.appendReplacement(lsb, java.util.regex.Matcher.quoteReplacement("[" + label + "](" + ph + ")"));
        }
        lm.appendTail(lsb);
        result = lsb.toString();

        // 3) 외국 문자 유니코드 범위 제거

        // 일본어 (히라가나·가타카나) 제거 — 한글 호환 자모(\u3130-\u318F)는 유지
        result = result.replaceAll("[\\u3040-\\u312F\\u3190-\\u31FF]+", "");

        // CJK 한자 제거 (중국어·일본어 한자 전체)
        result = result.replaceAll("[\\u3400-\\u4DBF\\u4E00-\\u9FFF\\uF900-\\uFAFF]+", "");

        // 동남아시아 문자 제거 (태국어·라오스어·미얀마어·크메르어)
        result = result.replaceAll("[\\u0E00-\\u0EFF\\u1000-\\u109F\\u1780-\\u17FF]+", "");

        // 베트남어·유럽어 확장 라틴 제거
        result = result.replaceAll("[\\u00C0-\\u024F\\u1E00-\\u1EFF]+", "");

        // 중동 문자 제거 (아랍어·히브리어·시리아어·타나·나코 등)
        result = result.replaceAll("[\\u0590-\\u08FF]+", "");

        // 인도 계열 문자 전체 제거
        // 힌디어(데바나가리)·벵골어·구르무키(펀자브)·구자라트·오리야
        // ·타밀·텔루구·칸나다·말라얄람·싱할라
        result = result.replaceAll("[\\u0900-\\u0DFF]+", "");

        // 티베트어·몽골어 제거
        result = result.replaceAll("[\\u0F00-\\u0FFF\\u1800-\\u18AF]+", "");

        // 에티오피아어(암하라어) 제거 — 한글 자모(\u1100-\u11FF) 다음 범위부터
        result = result.replaceAll("[\\u1200-\\u137F]+", "");

        // 체로키·캐나다 원주민 음절·룬 문자 등 제거
        result = result.replaceAll("[\\u13A0-\\u16FF]+", "");

        // 키릴 문자 제거 (러시아어·우크라이나어·불가리아어·세르비아어 등)
        result = result.replaceAll("[\\u0400-\\u052F]+", "");

        // 그리스어·콥트어 제거
        result = result.replaceAll("[\\u0370-\\u03FF]+", "");

        // 아르메니아어·조지아어 제거
        result = result.replaceAll("[\\u0530-\\u058F\\u10A0-\\u10FF]+", "");

        // 기본 알파벳 제거 (placeholder는 \uE000~\uE001 범위라 영향 없음)
        result = result.replaceAll("[a-zA-Z]+", "");

        // 연속 공백 정리
        result = result.replaceAll(" {2,}", " ").trim();

        // 4) 마크다운 링크 URL 복원: placeholder → 원래 URL
        //    label 텍스트는 이미 위 필터를 거쳤으므로 외국 문자가 제거된 상태
        //    label 앞뒤 공백도 정리 (예: "[멤버십  ]" → "[멤버십]")
        for (Map.Entry<String, String> e : linkHolder.entrySet()) {
            result = result.replace(e.getKey(), e.getValue());
        }
        // label 앞뒤 공백 정리: [멤버십  ](url) → [멤버십](url), [ 멤버십](url) → [멤버십](url)
        // `[^\\]]*?` 으로 링크 label만 대상, \\]\\( 확인으로 실제 링크만 처리
        result = result.replaceAll("\\[([^\\]]*?)\\s+\\]\\(", "[$1](");
        result = result.replaceAll("\\[\\s+([^\\]]*?)\\]\\(", "[$1](");

        return result;
    }
}
