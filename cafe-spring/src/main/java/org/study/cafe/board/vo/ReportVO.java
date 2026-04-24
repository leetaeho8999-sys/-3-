package org.study.cafe.board.vo;
import lombok.Data;

@Data
public class ReportVO {
    private int rno;
    private int b_idx;
    private String reporter;
    private String reason;
    private String content;
    private String regdate;
}