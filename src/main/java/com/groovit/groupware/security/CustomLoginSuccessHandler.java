package com.groovit.groupware.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import com.groovit.groupware.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

//인증(로그인) 전에 접근을 시도한 URL로 리다이렉트하는 기능을 가지고 있음
//스프링 시큐리티에서 기본적으로 사용되는 구현 클래스임
@Slf4j
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

	// 요청파라미터 : {username=admin,password=java}
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth)
			throws ServletException, IOException {

		log.info("onAuthenticationSuccess");
		log.info("auth : {}", auth);

		// ******
		User customUser = (CustomUserDetails) auth.getPrincipal();

		// 사용자 아이디를 리턴
		log.info("username : {} ", customUser.getUsername()); // admin
		log.info("customUser : {}", customUser);

		// admin 아이디가 갖고 있는 권한(role) 목록
		// auth.getAuthorities() -> 권한들(ROLE_MEMBER,ROLE_ADMIN)
		// auth.getAuthority() : ROLE_MEMBER
		List<String> roleNames = new ArrayList<>();
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});

		log.info("roleNames : " + roleNames);

		// 로그인 성공 시 사용자 정보를 세션에 저장
		HttpSession session = request.getSession();
		session.setAttribute("username", customUser.getUsername());
		session.setAttribute("roleNames", roleNames);

		// 로그인 성공 로그 남기기
		log.info("User '{}' logged in with roles: {}", customUser.getUsername(), roleNames);

		if (roleNames.contains("ROLE_ADMIN")) {
			// 관리자
			response.sendRedirect("/main/index");
			return;
		}

		if (roleNames.contains("ROLE_MEMBER")) {
			// 회원 로그인
			response.sendRedirect("/main/index");
			return;
		}

		// 부모(super)에게 반납
		super.onAuthenticationSuccess(request, response, auth);
	}
}
