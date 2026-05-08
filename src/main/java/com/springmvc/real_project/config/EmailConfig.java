package com.springmvc.real_project.config;

import java.util.Properties;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

public class EmailConfig {
    
    
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "yashtailor78@gmail.com";  // 🔥 CHANGE THIS
    private static final String EMAIL_PASSWORD = "zetb oqpa lwtv unxu";
    
    public static Session getEmailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        
        return Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
    }
}