package org.study.cafe.menu.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MenuVO {
    private String  m_idx, name, description, category, imageUrl, story, origin;
    private int     price;
    private int     icePrice;               // ice_extra_price AS icePrice
    private int     sizeUpchargeGrande;     // size_upcharge_grande AS sizeUpchargeGrande
    private int     sizeUpchargeVenti;      // size_upcharge_venti  AS sizeUpchargeVenti
    private boolean available;
}
