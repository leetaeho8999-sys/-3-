package org.study.cafe.chat.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.chat.vo.ChatVO;

import java.util.List;

@Mapper
public interface ChatMapper {
    void insertMessage(ChatVO vo);
    List<ChatVO> getHistory(String sessionId);
}
