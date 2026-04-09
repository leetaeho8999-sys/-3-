package org.study.cafe.chat.vo;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class ChatHistoryVO {
    private int id;
    private String sender;
    private String message;
    private LocalDateTime createdAt;
}
