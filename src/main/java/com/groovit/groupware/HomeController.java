package com.groovit.groupware;

import java.security.Principal;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.groovit.groupware.controller.BaseController;
import com.groovit.groupware.mapper.EmployeeMapper;
import com.groovit.groupware.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

/**
 * Handles requests for the application home page.
 */
@Slf4j
@Controller
public class HomeController extends BaseController {

	@Autowired
	EmployeeMapper employeeMapper;

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
	@RequestMapping(value = { "/", "/home"}, method = RequestMethod.GET)
	public String home(

			Locale locale, Model model, Principal principal, Authentication auth
			, HttpSession session
	) {

		log.info("Welcome home! The client locale is {}.", locale);

		// 로그인 된 회원아이디
		log.info("empId : " + principal.getName());
		// 쿼리를 통해 직원 정보를 가져오자(조건)
		EmployeeVO employeeVO = employeeMapper.getEmployeeById(principal.getName());
		//정보를 가져오는지 확인
		log.info("home : {}",employeeVO);
		session.setAttribute("loginVO", employeeVO);

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

		String formattedDate = dateFormat.format(date);

		// 권한 정보
		String loginId = SecurityContextHolder.getContext().getAuthentication().getName();
		// 권한 여부
		boolean authenticated = SecurityContextHolder.getContext().getAuthentication().isAuthenticated();

		log.debug("authenticated : {} ", authenticated);
		log.debug("로그인한 사용자 아이디 : {} ", loginId);

		model.addAttribute("serverTime", formattedDate);

		return "main/index";
	}
}
