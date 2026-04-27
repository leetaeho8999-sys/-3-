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

    // Jakarta EL(Tomcat 10) 은 JavaBeans 규약에 따라 getter `getBIdx` 를 property name `BIdx` 로 해석
    // ($[b.bIdx]$ 접근 실패 → PropertyNotFoundException). 소문자-시작 getter/setter 로 property name `bIdx` 노출.
    public int  getbIdx()            { return bIdx; }
    public void setbIdx(int bIdx)    { this.bIdx = bIdx; }
}
