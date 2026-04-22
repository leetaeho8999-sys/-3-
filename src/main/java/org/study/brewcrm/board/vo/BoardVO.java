package org.study.brewcrm.board.vo;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class BoardVO {
    private int    bIdx;
    private String title;
    private String category;
    private String content;
    private String author;
    private int    views;
    private int    comments;
    private String regDate;
    private int    active;
    private int    reportCount;
}
