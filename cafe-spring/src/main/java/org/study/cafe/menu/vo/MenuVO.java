package org.study.cafe.menu.vo;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MenuVO {
    private String  m_idx, name, description, category, imageUrl, story, origin;
    private int     price;
    private boolean available;
}
