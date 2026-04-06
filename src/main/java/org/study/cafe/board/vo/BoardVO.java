package org.study.cafe.board.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class BoardVO {
    private String b_idx, title, category, content, author, regDate;
    private int    views, comments;
    private String active;
}
