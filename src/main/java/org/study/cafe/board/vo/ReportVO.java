package org.study.cafe.board.vo;

import lombok.Data;

@Data
public class ReportVO {
    private int    rno;
    private int    b_idx;
    private String reporter;   // 신고자 m_id (세션 m_id 그대로 들어감)
    private String reason;     // 드롭다운 선택값
    private String content;    // 추가 사유 (선택)
    private String reg_date;
}
