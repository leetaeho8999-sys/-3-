package org.study.cafe.board.service;

import org.springframework.transaction.annotation.Transactional;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import org.study.cafe.board.vo.ReportVO;

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
    List<BoardVO> getMyPosts(String author);

    @Transactional
        // 신고 저장과 카운트 증가가 동시에 일어나야 함
    int reportBoard(ReportVO vo);
}
