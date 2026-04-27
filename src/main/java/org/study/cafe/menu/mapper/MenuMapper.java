package org.study.cafe.menu.mapper;
import org.apache.ibatis.annotations.Mapper;
import org.study.cafe.menu.vo.MenuVO;
import java.util.List;

@Mapper
public interface MenuMapper {
    List<MenuVO> getMenuList(String category);
    MenuVO       getMenuDetail(String m_idx);
    MenuVO       findByName(String name);
}
