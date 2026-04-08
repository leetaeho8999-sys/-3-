package org.study.cafe.chat.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.chat.vo.ChatHistoryVO;
import org.study.cafe.chat.vo.ChatRatingVO;
import org.study.cafe.chat.vo.ChatVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface ChatMapper {
    // 세션 기반 채팅 로그
    void insertMessage(ChatVO vo);
    List<ChatVO> getHistory(String sessionId);

    // AI 챗봇용 키워드 힌트 + 대화 기록
    ChatVO findByKeyword(String keyword);
    List<Map<String, Object>> findAllKeywords();
    void saveHistory(ChatHistoryVO history);
    List<ChatHistoryVO> getAiHistory();

    // 만족도 평가
    void saveRating(ChatRatingVO rating);
}
