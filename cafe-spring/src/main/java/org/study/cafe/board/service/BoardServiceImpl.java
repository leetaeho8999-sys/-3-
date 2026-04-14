package org.study.cafe.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.cafe.board.mapper.BoardMapper;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardMapper boardMapper;

    @Override public int getCount(String category) { return boardMapper.getCount(category); }

    @Override public int getSearchCount(String keyword, String category) {
        Map<String, Object> m = new HashMap<>();
        m.put("keyword", "%" + keyword + "%");
        m.put("category", category);
        return boardMapper.getSearchCount(m);
    }

    @Override public List<BoardVO> getBoardList(int n, int o, String cat) {
        Map<String, Object> m = new HashMap<>();
        m.put("numPerPage", n);
        m.put("offset", o);
        m.put("category", cat);
        return boardMapper.getBoardList(m);
    }

    @Override public List<BoardVO> searchBoard(String kw, String cat, int n, int o) {
        Map<String, Object> m = new HashMap<>();
        m.put("keyword", "%" + kw + "%");
        m.put("category", cat);
        m.put("numPerPage", n);
        m.put("offset", o);
        return boardMapper.searchBoard(m);
    }

    @Override public List<BoardVO> getPopularList(int limit) { return boardMapper.getPopularList(limit); }
    @Override public List<BoardVO> getRecentList(int limit)  { return boardMapper.getRecentList(limit); }

    @Override
    public BoardVO getDetail(String b_idx) {
        // 상세 보기 시 조회수 증가와 조회를 하나의 흐름으로 처리 가능 (필요 시)
        return boardMapper.getDetail(b_idx);
    }

    @Transactional // 글 등록 실패 시 DB 롤백 보장
    @Override
    public int insertBoard(BoardVO vo) {
        // 고도화 UI 대응: 제목/내용 공백 체크
        if (vo.getTitle() == null || vo.getTitle().trim().isEmpty()) return 0;
        return boardMapper.insertBoard(vo);
    }

    @Transactional
    @Override
    public int updateBoard(BoardVO vo) { return boardMapper.updateBoard(vo); }

    @Transactional
    @Override
    public int deleteBoard(String b_idx) { return boardMapper.deleteBoard(b_idx); }

    @Override public int addViews(String b_idx) { return boardMapper.addViews(b_idx); }

    @Override public List<CommentVO> getComments(String b_idx) { return boardMapper.getComments(b_idx); }

    @Transactional // 댓글 작성과 게시글 댓글 수 증가는 반드시 동시에 성공해야 함
    @Override public int insertComment(CommentVO vo) {
        int r = boardMapper.insertComment(vo);
        if (r > 0) {
            boardMapper.addCommentCount(vo.getB_idx());
        }
        return r;
    }

    @Transactional // 댓글 삭제와 댓글 수 감소 동기화
    @Override public int deleteComment(String c_idx, String b_idx) {
        int r = boardMapper.deleteComment(c_idx);
        if (r > 0) {
            boardMapper.subtractCommentCount(b_idx);
        }
        return r;
    }
}