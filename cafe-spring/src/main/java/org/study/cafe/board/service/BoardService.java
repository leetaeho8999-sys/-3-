package org.study.cafe.board.service;

import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import java.util.List;

public interface BoardService {
    int           getCount(String category);
    int           getSearchCount(String keyword, String category);
    List<BoardVO> getBoardList(int numPerPage, int offset, String category);
    List<BoardVO> searchBoard(String keyword, String category, int numPerPage, int offset);
    List<BoardVO> getPopularList(int limit);
    List<BoardVO> getRecentList(int limit);
    BoardVO       getDetail(String b_idx);
    int           insertBoard(BoardVO vo);
    int           updateBoard(BoardVO vo);
    int           deleteBoard(String b_idx);
    int           addViews(String b_idx);
    List<CommentVO> getComments(String b_idx);
    int           insertComment(CommentVO vo);
    int           deleteComment(String c_idx, String b_idx);
}
