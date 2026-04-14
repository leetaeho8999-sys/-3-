package org.study.cafe.board.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Data
public class BoardVO {
    private String b_idx, title, category, content, author, regDate;
    private int    views, comments;
    private String active;
    private Long bno;            // 게시글 번호
    private String writer;       // 작성자
    private String tags;         // 태그 (쉼표로 구분된 문자열)
    private String regdate;      // 등록일
    private int viewcnt;         // 조회수
}
