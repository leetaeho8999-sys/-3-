package org.study.cafe.cart.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor
public class CartVO {
    private int    cartIdx;
    private String mId;
    private String menuName;
    private String temperature; // HOT / ICE / NONE
    private String size;        // TALL / GRANDE / VENTI / NONE
    private int    quantity;
    private int    unitPrice;   // 옵션 반영된 잔당 가격 (서버 재계산값)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDate;

    // 계산 필드 — DB 컬럼 아님 (unitPrice * quantity)
    private int subtotal;
}
