package org.study.cafe.chat.vo;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ChatVO {
    private String logIdx;
    private String sessionId;
    private String mIdx;
    private String sender;   // "user" or "bot"
    private String message;
    private String regDate;
}
