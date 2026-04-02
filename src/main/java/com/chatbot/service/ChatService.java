package com.chatbot.service;

import com.chatbot.vo.ChatHistoryVO;

import java.util.List;

public interface ChatService {
    String getResponse(String userMessage, String nickname);
    List<ChatHistoryVO> getHistory();
}
