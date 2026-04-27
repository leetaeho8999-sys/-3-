package org.study.mypractice01.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    // 4자리 랜덤 인증번호 생성 및 이메일 전송 메서드
    public String sendSimpleMessage(String toEmail) {
        // 1. 1111 ~ 9999 사이의 4자리 랜덤 숫자 생성
        int authNumber = (int)(Math.random() * 8888) + 1111;

        // 🚨 중요: 보내는 사람 주소를 사용자님의 네이버 메일 주소로 설정했습니다.
        String setFrom = "aaju-4753@naver.com";

        String title = "[카페 단골손님] 회원가입 인증 번호입니다.";
        String content = "방문해주셔서 감사합니다." +
                "<br><br>" +
                "인증 번호는 <b>" + authNumber + "</b> 입니다." +
                "<br>" +
                "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");

            helper.setFrom(setFrom);
            helper.setTo(toEmail);
            helper.setSubject(title);
            helper.setText(content, true); // true를 전달해야 html 형식으로 전송됨

            mailSender.send(message); // 네이버 서버를 통해 메일 발송!
            System.out.println("메일 전송 성공! 인증번호: " + authNumber);

        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("메일 전송 실패 ㅠㅠ 콘솔창의 에러 메시지를 확인해주세요.");
        }

        return Integer.toString(authNumber); // 생성된 4자리 번호를 화면(JSP)으로 전달
    }
}