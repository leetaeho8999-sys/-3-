package org.study.cafe.visit.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/** visit_t 매핑 VO — 결제 1건당 1행 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class VisitVO {
    private Integer       vIdx;
    private String        mId;
    private String        orderId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime visitDate;
    private Integer       cancelled;       // 0 = 유효 / 1 = 결제 취소되어 방문 무효
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime cancelDate;
}
