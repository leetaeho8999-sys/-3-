package com.chatbot.mapper;

import com.chatbot.vo.ChatHistoryVO;
import com.chatbot.vo.ChatVO;

import java.util.List;

public interface ChatMapper {
    ChatVO findByKeyword(String keyword);
    void saveHistory(ChatHistoryVO history);
    List<ChatHistoryVO> getHistory();
}
