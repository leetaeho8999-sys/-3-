package org.study.cafe.chat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.chat.mapper.ChatMapper;
import org.study.cafe.chat.vo.ChatVO;

import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired private ChatMapper chatMapper;

    private static final Map<String, String> KNOWLEDGE = new LinkedHashMap<>();

    static {
        KNOWLEDGE.put("메뉴", "저희 메뉴는 에스프레소(3,500원), 아메리카노(4,000원), 카페라떼(4,500원), 카푸치노(4,500원), 바닐라라떼(5,000원), 카라멜마끼아또(5,000원), 아인슈페너(5,500원), 콜드브루(5,000원), 시그니처라떼(6,000원)가 있습니다.");
        KNOWLEDGE.put("추천", "처음 오셨다면 시그니처 라떼(6,000원)를 추천드려요! 파나마 게이샤 원두로 만든 특별한 레시피예요. 진한 맛을 좋아하신다면 아인슈페너도 인기가 많아요 ☕");
        KNOWLEDGE.put("가격", "아메리카노 4,000원 / 라떼류 4,500~5,000원 / 스페셜 5,000~6,000원입니다. 개인 텀블러 지참 시 500원 할인됩니다!");
        KNOWLEDGE.put("매장", "서울시 강남구 테헤란로 123, 역삼역 3번 출구 도보 5분 거리에 있습니다. 평일 08:00~22:00, 주말 09:00~23:00 영업하며 월요일은 휴무입니다.");
        KNOWLEDGE.put("영업", "평일 08:00~22:00, 주말 09:00~23:00 영업합니다. 월요일은 정기 휴무입니다.");
        KNOWLEDGE.put("위치", "서울시 강남구 테헤란로 123입니다. 역삼역 3번 출구에서 도보 5분 거리에 있어요.");
        KNOWLEDGE.put("이벤트", "현재 3월 한 달간 아메리카노 1+1 이벤트 진행 중입니다! SNS 팔로우 시 첫 방문 10% 할인 쿠폰도 제공해드려요.");
        KNOWLEDGE.put("멤버십", "멤버십은 베이직(무료), 실버(9,900원/월), 골드(19,900원/월) 3가지 플랜이 있습니다. 실버 이상 가입 시 10~20% 상시 할인과 포인트 적립 혜택을 받으실 수 있어요.");
        KNOWLEDGE.put("디카페인", "모든 에스프레소 베이스 음료에 디카페인 옵션을 선택하실 수 있어요. 추가 비용은 500원입니다.");
        KNOWLEDGE.put("텀블러", "개인 텀블러를 지참하시면 500원 할인해 드립니다 😊 환경도 지키고 혜택도 받으세요!");
        KNOWLEDGE.put("원두", "에티오피아 예가체프, 콜롬비아 수프리모, 브라질 산토스 등 세계 각지의 프리미엄 원두를 사용합니다.");
        KNOWLEDGE.put("주차", "매장 인근 공영주차장을 이용하시거나, 지하철(역삼역 3번 출구)을 이용하시면 편리합니다.");
        KNOWLEDGE.put("와이파이", "무료 와이파이를 제공합니다. 비밀번호는 매장 내 안내판을 확인해 주세요.");
    }

    @Override
    public String sendMessage(String userMessage, String sessionId, String mIdx) {
        // 유저 메시지 저장
        ChatVO userLog = new ChatVO();
        userLog.setSessionId(sessionId);
        userLog.setMIdx(mIdx);
        userLog.setSender("user");
        userLog.setMessage(userMessage);
        chatMapper.insertMessage(userLog);

        // 봇 응답 생성
        String botResponse = generateResponse(userMessage);

        // 봇 응답 저장
        ChatVO botLog = new ChatVO();
        botLog.setSessionId(sessionId);
        botLog.setMIdx(mIdx);
        botLog.setSender("bot");
        botLog.setMessage(botResponse);
        chatMapper.insertMessage(botLog);

        return botResponse;
    }

    @Override
    public List<ChatVO> getHistory(String sessionId) {
        return chatMapper.getHistory(sessionId);
    }

    private String generateResponse(String msg) {
        String lower = msg.toLowerCase();
        for (Map.Entry<String, String> entry : KNOWLEDGE.entrySet()) {
            if (msg.contains(entry.getKey())) {
                return entry.getValue();
            }
        }
        if (lower.contains("안녕") || lower.contains("hello") || lower.contains("hi")) {
            return "안녕하세요! 로운 AI 어시스턴트입니다 ☕ 메뉴 추천, 매장 정보, 이벤트 등 무엇이든 물어보세요!";
        }
        if (lower.contains("감사") || lower.contains("고마")) {
            return "천만에요! 더 궁금하신 점이 있으시면 언제든지 물어보세요 😊";
        }
        if (lower.contains("맛있") || lower.contains("좋아")) {
            return "감사합니다! 저희 로운은 최고의 원두와 정성으로 만든 커피를 제공합니다 ☕";
        }
        return "죄송해요, 잘 이해하지 못했어요. 메뉴, 가격, 매장 위치, 영업시간, 이벤트, 멤버십 혜택 등에 대해 물어보세요!";
    }
}
