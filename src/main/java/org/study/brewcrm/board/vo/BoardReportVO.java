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
}
