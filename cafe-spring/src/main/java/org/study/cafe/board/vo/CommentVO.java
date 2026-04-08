package org.study.cafe.board.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class CommentVO {
    private String c_idx, b_idx, author, content, regDate;
}
