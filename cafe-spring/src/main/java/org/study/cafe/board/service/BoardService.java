package org.study.cafe.board.service;

import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import java.util.List;

public interface BoardService {
    // 게시글 관련
    int           getCount(String category);
    int           getSearchCount(String keyword, String category);
    List<BoardVO> getBoardList(int numPerPage, int offset, String category);
    List<BoardVO> searchBoard(String keyword, String category, int numPerPage, int offset);
    List<BoardVO> getPopularList(int limit);
    List<BoardVO> getRecentList(int limit);
    BoardVO       getDetail(String b_idx);

    int           insertBoard(BoardVO vo); // 고도화된 UI 데이터(category, tags 등) 포함
    int           updateBoard(BoardVO vo);
    int           deleteBoard(String b_idx);
    int           addViews(String b_idx);

    // 댓글 관련
    List<CommentVO> getComments(String b_idx);
    int           insertComment(CommentVO vo);
    int           deleteComment(String c_idx, String b_idx);
}