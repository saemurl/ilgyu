package com.groovit.groupware.controller;


import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.SalaryService;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.SalaryVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/salary")
@Controller
public class SalaryController  extends BaseController {

	@Autowired
	SalaryService salaryService;

	@GetMapping("/list")
	public String salary(Model model, Principal principal) {

		String empId = principal.getName();
		
		EmployeeVO employeeVO = this.salaryService.getEmpData(empId);
		log.info("급여명세서 페이지 조회 회원정보 : " + employeeVO);
		
		model.addAttribute("employeeVO", employeeVO);
		
		return "salary/statement";
	}
	
	@PostMapping("/getSalaryData")
	@ResponseBody
	public SalaryVO getSalaryData(@RequestBody SalaryVO salaryVO, Principal principal) {
		
		String empId = principal.getName();
		salaryVO.setEmpId(empId);
		
		log.info("Salary VO 체크 :" + salaryVO);
		
		SalaryVO selectSalaryVO = this.salaryService.getSalaryData(salaryVO);
		log.info("선택한 Salary VO 체크 : " + selectSalaryVO );
		
		return selectSalaryVO;
	}
	
	
	

}
