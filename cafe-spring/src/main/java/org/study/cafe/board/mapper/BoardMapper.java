package org.study.cafe.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {
    int        getCount(String category);
    int        getSearchCount(Map<String,Object> map);
    List<BoardVO> getBoardList(Map<String,Object> map);
    List<BoardVO> searchBoard(Map<String,Object> map);
    List<BoardVO> getPopularList(int limit);
    List<BoardVO> getRecentList(int limit);
    BoardVO    getDetail(String b_idx);
    int        insertBoard(BoardVO vo);
    int        updateBoard(BoardVO vo);
    int        deleteBoard(String b_idx);
    int        addViews(String b_idx);
    // 댓글
    List<CommentVO> getComments(String b_idx);
    int        insertComment(CommentVO vo);
    int        deleteComment(String c_idx);
    int        addCommentCount(String b_idx);
    int        subtractCommentCount(String b_idx);
}
