package org.study.cafe.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.cafe.board.mapper.BoardMapper;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import org.study.cafe.board.vo.ReportVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired private BoardMapper boardMapper;

    @Override public int getCount(String category) { return boardMapper.getCount(category); }

    @Override public int getSearchCount(String keyword, String category) {
        Map<String,Object> m = new HashMap<>();
        m.put("keyword","%" + keyword + "%"); m.put("category", category);
        return boardMapper.getSearchCount(m);
    }

    @Override public List<BoardVO> getBoardList(int n, int o, String cat) {
        Map<String,Object> m = new HashMap<>();
        m.put("numPerPage",n); m.put("offset",o); m.put("category",cat);
        return boardMapper.getBoardList(m);
    }

    @Override public List<BoardVO> searchBoard(String kw, String cat, int n, int o) {
        Map<String,Object> m = new HashMap<>();
        m.put("keyword","%" + kw + "%"); m.put("category",cat); m.put("numPerPage",n); m.put("offset",o);
        return boardMapper.searchBoard(m);
    }

    @Override public List<BoardVO> getPopularList(int limit) { return boardMapper.getPopularList(limit); }
    @Override public List<BoardVO> getRecentList(int limit)  { return boardMapper.getRecentList(limit); }
    @Override public BoardVO getDetail(String b_idx)         { return boardMapper.getDetail(b_idx); }
    @Override public int insertBoard(BoardVO vo)             { return boardMapper.insertBoard(vo); }
    @Override public int updateBoard(BoardVO vo)             { return boardMapper.updateBoard(vo); }
    @Override public int deleteBoard(String b_idx)           { return boardMapper.deleteBoard(b_idx); }
    @Override public int addViews(String b_idx)              { return boardMapper.addViews(b_idx); }

    @Override public List<CommentVO> getComments(String b_idx) { return boardMapper.getComments(b_idx); }

    @Override public int insertComment(CommentVO vo) {
        int r = boardMapper.insertComment(vo);
        if (r > 0) boardMapper.addCommentCount(vo.getB_idx());
        return r;
    }

    @Override public int deleteComment(String c_idx, String b_idx) {
        int r = boardMapper.deleteComment(c_idx);
        if (r > 0) boardMapper.subtractCommentCount(b_idx);
        return r;
    }

    @Override public List<BoardVO> getMyPosts(String author) {
        return boardMapper.getMyPosts(author);
    }

    @Transactional
    @Override
    public int reportBoard(ReportVO vo) {
        // 1. 중복 신고 확인
        int count = boardMapper.checkDuplicateReport(vo);

        if (count > 0) {
            return -1; // 이미 신고한 경우 -1 반환
        }

        // 2. 신고 정보 저장
        int result = boardMapper.insertReport(vo);

        // 3. 게시글 테이블의 신고 카운트 증가
        if (result > 0) {
            boardMapper.updateReportCnt(vo.getB_idx());
        }
        return result;
    }
}
