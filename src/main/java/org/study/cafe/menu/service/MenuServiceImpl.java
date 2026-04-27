package org.study.cafe.menu.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.cafe.menu.mapper.MenuMapper;
import org.study.cafe.menu.vo.MenuVO;
import java.util.List;

@Service
public class MenuServiceImpl implements MenuService {
    @Autowired private MenuMapper menuMapper;
    @Override public List<MenuVO> getMenuList(String category) { return menuMapper.getMenuList(category); }
    @Override public MenuVO getMenuDetail(String m_idx)        { return menuMapper.getMenuDetail(m_idx); }
    @Override public MenuVO findByName(String name)            { return menuMapper.findByName(name); }
}
