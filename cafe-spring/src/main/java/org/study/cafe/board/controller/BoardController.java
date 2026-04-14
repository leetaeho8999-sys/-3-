package org.study.cafe.board.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.cafe.board.service.BoardService;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import org.study.cafe.common.Paging;
import org.study.cafe.member.vo.MemberVO;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor // final 필드인 boardService를 자동으로 주입합니다.
public class BoardController {

    // @Autowired를 삭제하고 final로 선언하여 중복 정의 오류를 해결했습니다.
    private final BoardService boardService;

    // 게시판 목록
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       @RequestParam(defaultValue = "") String keyword,
                       @RequestParam(defaultValue = "전체") String category,
                       Model model) {
        String cat = "전체".equals(category) ? null : category;

        Paging pg = new Paging();
        pg.setNowPage(nowPage);

        int total = keyword.isEmpty() ? boardService.getCount(cat) : boardService.getSearchCount(keyword, cat);
        pg.setTotalRecord(total);

        int tp = total <= pg.getNumPerPage() ? 1 : (total / pg.getNumPerPage() + (total % pg.getNumPerPage() != 0 ? 1 : 0));
        pg.setTotalPage(tp);
        pg.setOffset((nowPage - 1) * pg.getNumPerPage());

        int bb = (int) (((nowPage - 1) / pg.getPagePerBlock()) * pg.getPagePerBlock() + 1);
        int eb = Math.min(bb + pg.getPagePerBlock() - 1, pg.getTotalPage());
        pg.setBeginBlock(bb);
        pg.setEndBlock(eb);

        model.addAttribute("list", keyword.isEmpty()
                ? boardService.getBoardList(pg.getNumPerPage(), pg.getOffset(), cat)
                : boardService.searchBoard(keyword, cat, pg.getNumPerPage(), pg.getOffset()));

        model.addAttribute("paging", pg);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);
        return "board/list";
    }

    // 게시글 상세
    @GetMapping("/detail")
    public String detail(@RequestParam String b_idx, Model model) {
        boardService.addViews(b_idx);
        model.addAttribute("board", boardService.getDetail(b_idx));
        model.addAttribute("comments", boardService.getComments(b_idx));
        return "board/detail";
    }

    // 글쓰기 폼
    @GetMapping("/write")
    public String writeForm(HttpSession session) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";
        return "board/write";
    }

    // 글쓰기 처리
    @PostMapping("/writeOk")
    public String writeOk(BoardVO vo, HttpSession session, RedirectAttributes rttr) {
        MemberVO m = (MemberVO) session.getAttribute("loginMember");
        if (m != null) {
            // MemberVO의 필드명이 username인지 userId인지 확인 필요 (일반적으로 username 사용)
            vo.setAuthor(m.getUsername());
        }

        int result = boardService.insertBoard(vo);
        if (result > 0) {
            rttr.addFlashAttribute("msg", "게시글이 성공적으로 등록되었습니다.");
        }
        return "redirect:/board/list";
    }

    // 수정 폼
    @GetMapping("/edit")
    public String editForm(@RequestParam String b_idx, Model model, HttpSession session) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";
        model.addAttribute("board", boardService.getDetail(b_idx));
        return "board/edit";
    }

    // 수정 처리
    @PostMapping("/editOk")
    public String editOk(BoardVO vo, RedirectAttributes rttr) {
        int result = boardService.updateBoard(vo);
        if (result > 0) {
            rttr.addFlashAttribute("msg", "수정되었습니다.");
        }
        return "redirect:/board/detail?b_idx=" + vo.getB_idx();
    }

    // 삭제
    @GetMapping("/delete")
    public String delete(@RequestParam String b_idx, RedirectAttributes rttr) {
        int result = boardService.deleteBoard(b_idx);
        if (result > 0) {
            rttr.addFlashAttribute("msg", "삭제되었습니다.");
        }
        return "redirect:/board/list";
    }

    // 댓글 등록
    @PostMapping("/commentOk")
    public String commentOk(CommentVO vo, HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("loginMember");
        if (m != null) vo.setAuthor(m.getUsername());
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