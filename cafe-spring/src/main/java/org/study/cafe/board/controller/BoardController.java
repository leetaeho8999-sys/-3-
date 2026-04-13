package org.study.cafe.board.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.board.service.BoardService;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import org.study.cafe.common.Paging;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired private BoardService boardService;

    // 게시판 목록
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue="1")  int    nowPage,
                       @RequestParam(defaultValue="")   String keyword,
                       @RequestParam(defaultValue="전체") String category,
                       Model model) {
        String cat = "전체".equals(category) ? null : category;

        Paging pg = new Paging(); pg.setNowPage(nowPage);
        int total = keyword.isEmpty() ? boardService.getCount(cat) : boardService.getSearchCount(keyword, cat);
        pg.setTotalRecord(total);
        int tp = total <= pg.getNumPerPage() ? 1 : (total / pg.getNumPerPage() + (total % pg.getNumPerPage() != 0 ? 1 : 0));
        pg.setTotalPage(tp);
        pg.setOffset((nowPage - 1) * pg.getNumPerPage());
        int bb = (int)(((nowPage-1) / pg.getPagePerBlock()) * pg.getPagePerBlock() + 1);
        int eb = Math.min(bb + pg.getPagePerBlock() - 1, pg.getTotalPage());
        pg.setBeginBlock(bb); pg.setEndBlock(eb);

        model.addAttribute("list",     keyword.isEmpty()
                ? boardService.getBoardList(pg.getNumPerPage(), pg.getOffset(), cat)
                : boardService.searchBoard(keyword, cat, pg.getNumPerPage(), pg.getOffset()));
        model.addAttribute("paging",   pg);
        model.addAttribute("keyword",  keyword);
        model.addAttribute("category", category);
        return "board/list";
    }

    // 게시글 상세
    @GetMapping("/detail")
    public String detail(@RequestParam String b_idx, Model model) {
        boardService.addViews(b_idx);
        model.addAttribute("board",    boardService.getDetail(b_idx));
        model.addAttribute("comments", boardService.getComments(b_idx));
        return "board/detail";
    }

    // 글쓰기 폼
    @GetMapping("/write")
    public String writeForm(HttpSession session) {
        if (session.getAttribute("m_id") == null) return "redirect:/member/login";
        return "board/write";
    }

    // 글쓰기 처리
    @PostMapping("/writeOk")
    public String writeOk(BoardVO vo, HttpSession session) {
        String author = (String) session.getAttribute("m_name");
        if (author != null) vo.setAuthor(author);
        boardService.insertBoard(vo);
        return "redirect:/board/list";
    }

    // 수정 폼
    @GetMapping("/edit")
    public String editForm(@RequestParam String b_idx, Model model, HttpSession session) {
        if (session.getAttribute("m_id") == null) return "redirect:/member/login";
        model.addAttribute("board", boardService.getDetail(b_idx));
        return "board/edit";
    }

    // 수정 처리
    @PostMapping("/editOk")
    public String editOk(BoardVO vo) {
        boardService.updateBoard(vo);
        return "redirect:/board/detail?b_idx=" + vo.getB_idx();
    }

    // 삭제
    @GetMapping("/delete")
    public String delete(@RequestParam String b_idx) {
        boardService.deleteBoard(b_idx);
        return "redirect:/board/list";
    }

    // 댓글 등록
    @PostMapping("/commentOk")
    public String commentOk(CommentVO vo, HttpSession session) {
        String author = (String) session.getAttribute("m_name");
        if (author != null) vo.setAuthor(author);
        boardService.insertComment(vo);
        return "redirect:/board/detail?b_idx=" + vo.getB_idx();
    }

    // 댓글 삭제
    @GetMapping("/commentDelete")
    public String commentDelete(@RequestParam String c_idx, @RequestParam String b_idx) {
        boardService.deleteComment(c_idx, b_idx);
        return "redirect:/board/detail?b_idx=" + b_idx;
    }
}
