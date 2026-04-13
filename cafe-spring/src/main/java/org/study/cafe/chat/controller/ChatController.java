package org.study.cafe.chat.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.chat.service.ChatService;
import org.study.cafe.chat.vo.ChatVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/chat")
public class ChatController {

    @Autowired private ChatService chatService;

    // 메시지 전송 + 봇 응답 반환
    @PostMapping("/send")
    public Map<String, String> send(@RequestBody Map<String, String> body, HttpSession session) {
        String userMessage = body.getOrDefault("message", "").trim();
        String sessionId   = session.getId();
        String mId         = (String) session.getAttribute("m_id");

        Map<String, String> result = new HashMap<>();
        if (userMessage.isEmpty()) {
            result.put("response", "");
            return result;
        }
        String botResponse = chatService.sendMessage(userMessage, sessionId, mId);
        result.put("response", botResponse);
        return result;
    }

    // 현재 세션 채팅 내역 조회
    @GetMapping("/history")
    public List<ChatVO> history(HttpSession session) {
        return chatService.getHistory(session.getId());
    }

    // 만족도 평가 저장
    @PostMapping("/rate")
    public ResponseEntity<Void> rate(@RequestBody Map<String, String> body) {
        String botMessage = body.get("botMessage");
        String rating     = body.get("rating");
        if (botMessage == null || botMessage.isBlank() || rating == null) {
            return ResponseEntity.badRequest().build();
        }
        if (!rating.equals("good") && !rating.equals("bad")) {
            return ResponseEntity.badRequest().build();
        }
        chatService.saveRating(botMessage, rating);
        return ResponseEntity.ok().build();
    }
}
