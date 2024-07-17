package com.groovit.groupware.service;

public interface EmailService {
    void sendSimpleMessage(String to, String subject, String text);
}