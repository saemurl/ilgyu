package com.groovit.groupware.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.ModelAttribute;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class BaseController {
	
    @ModelAttribute("currentURI")
    public String getCurrentURI(HttpServletRequest request) {
        return request.getRequestURI();
    }
    
    @ModelAttribute
    public void logRequest(HttpServletRequest request) {
        log.info("Request URI: " + request.getRequestURI());
    }
}
