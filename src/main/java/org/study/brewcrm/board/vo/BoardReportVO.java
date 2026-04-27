package org.study.brewcrm.board.vo;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class BoardReportVO {
    private int    rIdx;
    private String targetType;   // POST | COMMENT
    private int    targetIdx;
    private String reporter;
    private String reason;
    private String status;       // PENDING | PROCESSED | DISMISSED
    private String regDate;
    // JOIN 결과
    private String targetTitle;
    private String targetContent;
    private String targetAuthor;

    // Jakarta EL strict JavaBeans 규약 호환용 소문자-시작 getter/setter (BoardVO 와 동일 사유)
    public int  getrIdx()         { return rIdx; }
    public void setrIdx(int rIdx) { this.rIdx = rIdx; }
}
