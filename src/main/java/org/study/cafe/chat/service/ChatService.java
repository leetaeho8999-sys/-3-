package org.study.cafe.chat.service;

import org.study.cafe.chat.vo.ChatVO;

import java.util.List;

public interface ChatService {
    String sendMessage(String userMessage, String sessionId, String mIdx);
    List<ChatVO> getHistory(String sessionId, String mIdx);
    void resetHistory(String sessionId, String mIdx);
    void saveRating(String botMessage, String rating);
}
