package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.mapper.EmployeeMapper;
import com.groovit.groupware.service.EmployeeService;
import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/mypage")
@Controller
public class MyPageController {

    @Autowired
    PasswordEncoder passwordEncoder;
    
	//의존성 주입(Dependency Injection)
	@Autowired
	EmployeeVO employeeVO;
   
	@Autowired
	EmployeeService employeeService;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	//1) MyPage 화면(jsp)
	/*
	 요청URI : /mypage/profile
	 요청파라미터 : 없음
	 요청방식 : get
	 */
	@GetMapping("/profile")
	public String profile(Principal principal, Model model) {
		String empId = principal.getName();//로그인 된 회원아이디
		log.info("empId : " + empId);
		
		//쿼리를 통해 직원 정보를 가져오자(조건)
		EmployeeVO employeeVO = employeeMapper.getEmployeeById(empId);
		if (employeeVO != null) {
	        // 첨부파일이 없을 경우(NULL) 기본 프로필 이미지를 설정
	        if (employeeVO.getAtchfileDetailVOList() == null || employeeVO.getAtchfileDetailVOList().isEmpty()) {
	            AtchfileDetailVO defaultProfile = new AtchfileDetailVO();
	            defaultProfile.setAtchfileDetailPhysclPath("/resources/images/default-profile.png");
	            employeeVO.setAtchfileDetailVOList(Collections.singletonList(defaultProfile));
	        }
	    }
        model.addAttribute("employeeVO", employeeVO);
        log.info("employeeVO : " + employeeVO);
		
		//forwarding
		//MyPage 폴더에 profile.jsp가 보이는가?
		return "mypage/profile";
	}
	
	//요청URI : /mypage/profilePost
	@PostMapping("/profilePost")
	public String profilePost(EmployeeVO employeeVO, Principal principal, HttpSession session) {
		log.info("employeeVO : " + employeeVO);

		String empId = principal.getName();
		EmployeeVO existingEmployee = employeeMapper.getEmployeeById(empId);

		if (employeeVO.getEmpPass() == null || employeeVO.getEmpPass().isEmpty()) {
			// 기존 비밀번호를 유지
			employeeVO.setEmpPass(existingEmployee.getEmpPass());
		} else {
			// 새 비밀번호 암호화
			String empPassEncode = passwordEncoder.encode(employeeVO.getEmpPass());
			employeeVO.setEmpPass(empPassEncode);
		}

		employeeVO.setEmpId(empId);
		log.info("employeeVO->result : " + employeeVO);
		int result = employeeService.updateEmployee(employeeVO);
		log.info("employeeVO->result : " + result);

		// 로그인 된 회원아이디
		log.info("empId : " + principal.getName());
		// 쿼리를 통해 직원 정보를 가져오자(조건)
		employeeVO = employeeMapper.getEmployeeById(principal.getName());
		//정보를 가져오는지 확인
		log.info("home : {}",employeeVO);
		session.setAttribute("loginVO", employeeVO);
		
		//redirect
		return "redirect:/mypage/profile";
	}
	
	@PostMapping("/deletePhoto")
    @ResponseBody
    public Map<String, Object> deletePhoto(Principal principal) {
        Map<String, Object> response = new HashMap<>();
        String empId = principal.getName();
        EmployeeVO employeeVO = employeeMapper.getEmployeeById(empId);
        
        if (employeeVO != null) {
            log.info("deletePhoto -> employeeVO {}", employeeVO);
            employeeVO.setAtchfileSn(null);
            employeeMapper.updateEmployeeAtchfileSnNull(employeeVO);
            response.put("success", true);
        } else {
            response.put("success", false);
        }
        return response;
    }
}
