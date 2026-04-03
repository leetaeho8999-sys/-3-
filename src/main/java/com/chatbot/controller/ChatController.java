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
        if (userMessage == null || userMessage.isBlank()) {
            return Map.of("response", "메시지를 입력해주세요.");
        }
        String nickname = body.getOrDefault("nickname", "손님");
        String response = chatService.getResponse(userMessage.trim(), nickname);
        return Map.of("response", response);
    }

    @GetMapping("/history")
    public List<ChatHistoryVO> getHistory() {
        return chatService.getHistory();
    }
}
