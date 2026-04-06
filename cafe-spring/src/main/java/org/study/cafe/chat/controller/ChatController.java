package org.study.cafe.chat.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.chat.service.ChatService;
import org.study.cafe.chat.vo.ChatVO;
import org.study.cafe.member.vo.MemberVO;

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
        MemberVO login     = (MemberVO) session.getAttribute("loginMember");
        String mIdx        = login != null ? login.getM_idx() : null;

        Map<String, String> result = new HashMap<>();
        if (userMessage.isEmpty()) {
            result.put("response", "");
            return result;
        }
        String botResponse = chatService.sendMessage(userMessage, sessionId, mIdx);
        result.put("response", botResponse);
        return result;
    }

    // 현재 세션 채팅 내역 조회
    @GetMapping("/history")
    public List<ChatVO> history(HttpSession session) {
        return chatService.getHistory(session.getId());
    }
}
