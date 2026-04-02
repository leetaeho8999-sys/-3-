package com.chatbot.controller;

import com.chatbot.service.ChatService;
import com.chatbot.vo.ChatHistoryVO;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/chat")
public class ChatController {

    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @PostMapping("/send")
    public Map<String, String> send(@RequestBody Map<String, String> body) {
        String userMessage = body.get("message");
        String nickname = body.getOrDefault("nickname", "손님"); // 로그인 구현 시 세션에서 가져올 것
        String response = chatService.getResponse(userMessage, nickname);
        return Map.of("response", response);
    }

    @GetMapping("/history")
    public List<ChatHistoryVO> getHistory() {
        return chatService.getHistory();
    }
}
