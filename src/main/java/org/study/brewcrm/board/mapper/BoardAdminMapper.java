package org.study.brewcrm.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.brewcrm.board.vo.BoardReportVO;
import org.study.brewcrm.board.vo.BoardVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardAdminMapper {

    // ── 게시판 관리 ───────────────────────────────────────────
    int getBoardCount(Map<String, Object> params);
    List<BoardVO> getBoardList(Map<String, Object> params);
    BoardVO getBoardDetail(int bIdx);
    int deleteBoard(int bIdx);
    int restoreBoard(int bIdx);

    // ── 신고 관리 ─────────────────────────────────────────────
    int getReportCount(Map<String, Object> params);
    List<BoardReportVO> getReportList(Map<String, Object> params);
    int processReport(Map<String, Object> params);
    int deleteReportedPost(int rIdx);

    // ── 신고 유저 통계 ─────────────────────────────────────────
    List<Map<String, Object>> getReportedUsers();

    // ── 요약 카운트 ────────────────────────────────────────────
    int getPendingReportCount();
    int getTotalBoardCount();
    int getDeletedBoardCount();
}
