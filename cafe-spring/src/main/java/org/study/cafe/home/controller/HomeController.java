package org.study.cafe.home.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.study.cafe.board.service.BoardService;

@Controller
public class HomeController {
    @Autowired private BoardService boardService;

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        model.addAttribute("popularList", boardService.getPopularList(3));
        model.addAttribute("recentList",  boardService.getRecentList(3));
        return "home/index";
    }
    @GetMapping("/about")           public String about()   { return "home/about"; }
    @GetMapping("/contact")         public String contact() { return "home/contact"; }
    @GetMapping("/faq")             public String faq()     { return "home/faq"; }
    @GetMapping("/privacy-policy")  public String privacy() { return "home/privacy"; }
    @GetMapping("/terms-of-service")public String terms()   { return "home/terms"; }
    @GetMapping("/chat")            public String chat()    { return "home/chat"; }
}
