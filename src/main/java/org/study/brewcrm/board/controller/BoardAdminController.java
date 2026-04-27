package org.study.brewcrm.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.brewcrm.board.mapper.BoardAdminMapper;
import org.study.brewcrm.board.vo.BoardReportVO;
import org.study.brewcrm.board.vo.BoardVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/customer/board")
public class BoardAdminController {

    @Autowired private BoardAdminMapper boardAdminMapper;

    private static final int PAGE_SIZE = 15;

    // ── 메인 (탭: board / reports / users) ──────────────────────
    @GetMapping
    public String board(@RequestParam(defaultValue = "board") String tab,
                        @RequestParam(defaultValue = "1")     int    page,
                        @RequestParam(defaultValue = "")      String keyword,
                        @RequestParam(defaultValue = "")      String status,
                        @RequestParam(defaultValue = "")      String targetType,
                        Model model) {

        int offset = (page - 1) * PAGE_SIZE;

        // ── 게시판 관리 탭 ──────────────────────────────────────
        // board_report_t 가 미생성된 환경에서도 페이지 로드를 보장하기 위해 try/catch.
        // (getBoardList 가 LEFT JOIN board_report_t 를 포함하므로 테이블 미존재 시 실패)
        if ("board".equals(tab)) {
            Map<String, Object> params = new HashMap<>();
            params.put("keyword",  keyword);
            params.put("status",   status);
            params.put("offset",   offset);
            params.put("pageSize", PAGE_SIZE);

            try {
                int total = boardAdminMapper.getBoardCount(params);
                List<BoardVO> boards = boardAdminMapper.getBoardList(params);
                model.addAttribute("boards",    boards);
                model.addAttribute("total",     total);
                model.addAttribute("totalPage", (int) Math.ceil((double) total / PAGE_SIZE));
            } catch (Exception e) {
                model.addAttribute("boards",    new ArrayList<>());
                model.addAttribute("total",     0);
                model.addAttribute("totalPage", 0);
            }
        }

        // ── 신고 관리 탭 ────────────────────────────────────────
        if ("reports".equals(tab)) {
            Map<String, Object> params = new HashMap<>();
            params.put("status",     "PENDING".equals(status) || "PROCESSED".equals(status)
                                     || "DISMISSED".equals(status) ? status : "");
            params.put("targetType", targetType);
            params.put("offset",     offset);
            params.put("pageSize",   PAGE_SIZE);

            try {
                int total = boardAdminMapper.getReportCount(params);
                List<BoardReportVO> reports = boardAdminMapper.getReportList(params);
                model.addAttribute("reports",    reports);
                model.addAttribute("total",      total);
                model.addAttribute("totalPage",  (int) Math.ceil((double) total / PAGE_SIZE));
            } catch (Exception e) {
                model.addAttribute("reports",    new ArrayList<>());
                model.addAttribute("total",      0);
                model.addAttribute("totalPage",  0);
            }
        }

        // ── 신고 유저 탭 ────────────────────────────────────────
        if ("users".equals(tab)) {
            try { model.addAttribute("reportedUsers", boardAdminMapper.getReportedUsers()); }
            catch (Exception e) { model.addAttribute("reportedUsers", new ArrayList<>()); }
        }

        // ── 공통 요약 수치 (각각 독립 try/catch — 테이블 하나 미존재 해도 나머지는 표시) ──
        try { model.addAttribute("pendingReportCount", boardAdminMapper.getPendingReportCount()); }
        catch (Exception e) { model.addAttribute("pendingReportCount", 0); }
        try { model.addAttribute("totalBoardCount",    boardAdminMapper.getTotalBoardCount()); }
        catch (Exception e) { model.addAttribute("totalBoardCount",    0); }
        try { model.addAttribute("deletedBoardCount",  boardAdminMapper.getDeletedBoardCount()); }
        catch (Exception e) { model.addAttribute("deletedBoardCount",  0); }

        model.addAttribute("tab",        tab);
        model.addAttribute("page",       page);
        model.addAttribute("keyword",    keyword);
        model.addAttribute("status",     status);
        model.addAttribute("targetType", targetType);

        return "customer/board";
    }

    // ── 게시글 삭제 ─────────────────────────────────────────────
    @PostMapping("/delete")
    public String delete(@RequestParam int bIdx,
                         @RequestParam(defaultValue = "1") int page,
                         @RequestParam(defaultValue = "") String keyword) {
        boardAdminMapper.deleteBoard(bIdx);
        return "redirect:/customer/board?tab=board&page=" + page + "&keyword=" + keyword + "&deleted=true";
    }

    // ── 게시글 복구 ─────────────────────────────────────────────
    @PostMapping("/restore")
    public String restore(@RequestParam int bIdx,
                          @RequestParam(defaultValue = "1") int page) {
        boardAdminMapper.restoreBoard(bIdx);
        return "redirect:/customer/board?tab=board&status=deleted&page=" + page + "&restored=true";
    }

    // ── 신고 처리 (PROCESSED / DISMISSED) ──────────────────────
    @PostMapping("/processReport")
    public String processReport(@RequestParam int    rIdx,
                                @RequestParam String action,
                                @RequestParam(defaultValue = "1") int page) {
        if ("process".equals(action) || "dismiss".equals(action)) {
            Map<String, Object> params = new HashMap<>();
            params.put("rIdx",   rIdx);
            params.put("status", "process".equals(action) ? "PROCESSED" : "DISMISSED");
            boardAdminMapper.processReport(params);
        }
        return "redirect:/customer/board?tab=reports&page=" + page + "&done=true";
    }

    // ── 신고된 게시글 바로 삭제 ─────────────────────────────────
    @PostMapping("/deleteReported")
    public String deleteReported(@RequestParam int rIdx,
                                 @RequestParam(defaultValue = "1") int page) {
        boardAdminMapper.deleteReportedPost(rIdx);
        return "redirect:/customer/board?tab=reports&page=" + page + "&deleted=true";
    }
}
