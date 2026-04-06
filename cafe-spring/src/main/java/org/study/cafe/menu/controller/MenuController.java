package org.study.cafe.menu.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.cafe.menu.service.MenuService;

@Controller
@RequestMapping("/menu")
public class MenuController {
    @Autowired private MenuService menuService;

    @GetMapping({"","list"})
    public String menu(@RequestParam(defaultValue="전체") String category, Model model) {
        model.addAttribute("menuList", menuService.getMenuList("전체".equals(category)?null:category));
        model.addAttribute("category", category);
        return "menu/list";
    }
    @GetMapping("/detail")
    public String detail(@RequestParam String m_idx, Model model) {
        model.addAttribute("menu", menuService.getMenuDetail(m_idx));
        return "menu/detail";
    }
}
