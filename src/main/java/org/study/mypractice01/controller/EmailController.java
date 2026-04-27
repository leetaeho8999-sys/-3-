package org.study.mypractice01.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.study.mypractice01.service.EmailService;

@RestController
public class EmailController {

    @Autowired
    private EmailService emailService;

    // 화면(JSP)에서 AJAX로 이메일 주소를 넘겨주면 이 메서드가 실행됨
    @GetMapping("/mailCheck")
    @ResponseBody
    public String mailCheck(@RequestParam("email") String email) {
        System.out.println("이메일 인증 요청이 들어옴! 대상 이메일: " + email);

        // EmailService를 시켜서 메일을 보내고, 그 4자리 번호를 return 받아서 다시 화면으로 넘겨줌
        return emailService.sendSimpleMessage(email);
    }
}