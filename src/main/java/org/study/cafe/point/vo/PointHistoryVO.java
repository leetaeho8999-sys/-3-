package org.study.cafe.point.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/** point_history_t 매핑 VO */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class PointHistoryVO {
    private int           phIdx;
    private String        mId;
    private String        type;          // EARN / USE / CANCEL_EARN / RESTORE_USE / SIGNUP_BONUS
    private int           amount;        // 부호 포함 (+/-)
    private int           balanceAfter;
    private String        orderId;       // nullable
    private String        description;   // nullable
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDate;
}
