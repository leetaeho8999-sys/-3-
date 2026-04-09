package org.study.cafe.menu.service;
import org.study.cafe.menu.vo.MenuVO;
import java.util.List;
public interface MenuService {
    List<MenuVO> getMenuList(String category);
    MenuVO       getMenuDetail(String m_idx);
}
