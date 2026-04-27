package org.study.cafe.board.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Data
public class BoardVO {
    private String b_idx, title, category, content, author, regDate;
    private int    views, comments;
    private String active;
    private Long bno;
    private String writer;
    private String tags;
    private String regdate;
    private int viewcnt;
}
