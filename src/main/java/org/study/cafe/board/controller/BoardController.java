package org.study.cafe.board.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.cafe.board.service.BoardService;
import org.study.cafe.board.vo.BoardVO;
import org.study.cafe.board.vo.CommentVO;
import org.study.cafe.common.Paging;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger log = LoggerFactory.getLogger(BoardController.class);
    private static final List<String> ALLOWED_EXT = List.of("jpg", "jpeg", "png", "gif", "webp");
    private static final long MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB

    @Autowired
    private BoardService boardService;

    @Autowired
    private org.study.cafe.config.WebUploadConfig webUploadConfig;

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
        if (session.getAttribute("m_id") == null) return "redirect:/member/login";
        return "board/write";
    }

    // 글쓰기 처리
    @PostMapping("/writeOk")
    public String writeOk(BoardVO vo, HttpSession session, RedirectAttributes rttr) {
        String mId = (String) session.getAttribute("m_id");
        if (mId == null) return "redirect:/member/login";
        vo.setAuthor(mId);
        try {
            boardService.insertBoard(vo);
            rttr.addFlashAttribute("msg", "게시글이 성공적으로 등록되었습니다.");
            return "redirect:/board/list";
        } catch (Exception e) {
            log.error("글 등록 실패", e);
            rttr.addFlashAttribute("errorMsg", "글 등록 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return "redirect:/board/write";
        }
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
    public String editOk(BoardVO vo, RedirectAttributes rttr) {
        try {
            boardService.updateBoard(vo);
            rttr.addFlashAttribute("msg", "수정되었습니다.");
            return "redirect:/board/detail?b_idx=" + vo.getB_idx();
        } catch (Exception e) {
            log.error("글 수정 실패", e);
            rttr.addFlashAttribute("errorMsg", "수정 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return "redirect:/board/edit?b_idx=" + vo.getB_idx();
        }
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
        String mId = (String) session.getAttribute("m_id");
        if (mId != null) vo.setAuthor(mId);
        boardService.insertComment(vo);
        return "redirect:/board/detail?b_idx=" + vo.getB_idx();
    }

    // 댓글 삭제
    @GetMapping("/commentDelete")
    public String commentDelete(@RequestParam String c_idx, @RequestParam String b_idx) {
        boardService.deleteComment(c_idx, b_idx);
        return "redirect:/board/detail?b_idx=" + b_idx;
    }

    // 게시글 신고 API
    @PostMapping("/report")
    @ResponseBody
    public String report(org.study.cafe.board.vo.ReportVO vo,
                         jakarta.servlet.http.HttpSession session) {

        // 우리 main 컨벤션: 세션 키는 "m_id" (String 그대로 보관)
        String m_id = (String) session.getAttribute("m_id");
        if (m_id == null) return "login_required";

        vo.setReporter(m_id);
        int result = boardService.reportBoard(vo);

        if (result == -1) return "duplicate";
        return result > 0 ? "success" : "fail";
    }

    // 이미지 업로드 API
    @PostMapping("/uploadImage")
    @ResponseBody
    public ResponseEntity<Map<String, String>> uploadImage(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {

        String originalName = file.getOriginalFilename();
        if (originalName == null || !originalName.contains(".")) {
            return ResponseEntity.badRequest().body(Map.of("error", "올바르지 않은 파일입니다."));
        }

        String ext = originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase();
        if (!ALLOWED_EXT.contains(ext)) {
            return ResponseEntity.badRequest().body(Map.of("error", "허용되지 않는 파일 형식입니다. (jpg, png, gif, webp만 가능)"));
        }

        if (file.getSize() > MAX_IMAGE_SIZE) {
            return ResponseEntity.badRequest().body(Map.of("error", "파일 크기는 5MB를 초과할 수 없습니다."));
        }

        try {
            // 외부 업로드 디렉토리 + 'board' 서브디렉토리
            java.nio.file.Path boardDir = webUploadConfig.getResolvedPath().resolve("board");
            java.io.File dir = boardDir.toFile();
            if (!dir.exists()) dir.mkdirs();

            String fileName = UUID.randomUUID().toString() + "." + ext;
            file.transferTo(new File(dir, fileName));

            // URL 은 기존 그대로 (DB 호환성). url-prefix 는 설정에서 가져옴
            String url = request.getContextPath()
                       + webUploadConfig.getUrlPrefix()
                       + "/board/" + fileName;
            return ResponseEntity.ok(Map.of("url", url));
        } catch (Exception e) {
            log.error("이미지 업로드 실패", e);
            return ResponseEntity.internalServerError().body(Map.of("error", "업로드 중 오류가 발생했습니다."));
        }
    }
}
