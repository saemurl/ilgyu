package com.groovit.groupware.config;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.util.Properties;

public class MailConfig {
	
	private static MailConfig instance = new MailConfig();
	private        MailConfig() {}
	public  static MailConfig getInstance() {
		return instance;
	}

    public JavaMailSender getJavaMailSender() {
    	JavaMailSenderImpl emailSender = new JavaMailSenderImpl();

    	emailSender.setHost("smtp.naver.com");  // SMTP 서버명
    	emailSender.setUsername("ohbj5687"); // 네이버 아이디
    	emailSender.setPassword("YTXZU9EG6TMG"); // 네이버 애플리케이션 비밀번호

    	emailSender.setPort(465); // SMTP 포트 (SSL)

    	emailSender.setJavaMailProperties(getMailProperties()); // 메일 인증서버 가져오기

        return emailSender;
    }

    // 메일 인증서버 정보 가져오기
	private Properties getMailProperties() {
		Properties properties = new Properties();
        properties.setProperty("mail.transport.protocol", "smtp"); // 프로토콜 설정
        properties.setProperty("mail.smtp.auth", "true"); // smtp 인증
        properties.setProperty("mail.smtp.starttls.enable", "true"); // smtp starttls 사용
        properties.setProperty("mail.debug", "true"); // 디버그 사용
        properties.setProperty("mail.smtp.ssl.trust", "smtp.naver.com"); // ssl 인증 서버 (smtp 서버명)
        properties.setProperty("mail.smtp.ssl.enable", "true"); // ssl 사용

        return properties;
	}
}
