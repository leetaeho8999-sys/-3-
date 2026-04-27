package org.study.cafe.member.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

import java.security.SecureRandom;

/**
 * 회원가입 이메일 인증.
 * - 4자리 랜덤 코드 생성 (SecureRandom 사용 — Math.random 보다 예측 어려움)
 * - 네이버 SMTP 로 HTML 메일 발송
 * - 클라이언트에는 코드 문자열을 응답하여 클라이언트 변수에 보관 → 사용자 입력과 비교
 *
 * 보안 메모:
 * - 클라이언트가 코드를 알게 되므로 DevTools 로 우회 가능 (학습/개발용 패턴).
 * - 운영 강화 시 서버 세션에 보관하고 검증 endpoint 를 별도로 두는 것이 정석.
 *   (이번 PR 에서는 abcd 원본 호환 위해 클라이언트 보관 방식 유지)
 */
@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:}")
    private String fromAddress;

    private final SecureRandom random = new SecureRandom();

    /**
     * 인증 메일 발송 후 4자리 코드를 반환한다.
     * 메일 발송에 실패하면 빈 문자열 "" 을 반환 (호출자가 분기 처리).
     */
    public String sendAuthCode(String toEmail) {
        String code = String.format("%04d", random.nextInt(10000)); // 0000 ~ 9999

        if (fromAddress == null || fromAddress.isBlank()) {
            log.warn("MAIL_USERNAME 미설정 — 이메일 발송 스킵. 인증 코드만 응답: {}", code);
            return code; // dev 환경에서 SMTP 셋업 안 된 상태도 흐름 진행 가능하게
        }

        String subject = "[로운 카페] 회원가입 이메일 인증번호";
        String html =
                "<div style=\"font-family:'Malgun Gothic',sans-serif;color:#4A3B32;\">" +
                "<h2 style=\"color:#5D4037;\">로운 카페에 오신 것을 환영합니다 ☕</h2>" +
                "<p>아래 인증번호 4자리를 회원가입 화면에 입력해 주세요.</p>" +
                "<div style=\"font-size:28px;font-weight:bold;color:#8B5A2B;letter-spacing:6px;" +
                "padding:16px 0;\">" + code + "</div>" +
                "<p style=\"color:#888;font-size:12px;\">본 메일은 발신 전용입니다.</p>" +
                "</div>";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromAddress);
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(html, true);
            mailSender.send(message);
            log.info("이메일 인증 발송 완료 → {}", toEmail);
            return code;
        } catch (MessagingException e) {
            log.error("이메일 발송 실패 → {}", toEmail, e);
            return "";
        } catch (Exception e) {
            log.error("이메일 발송 중 예기치 못한 오류 → {}", toEmail, e);
            return "";
        }
    }
}
