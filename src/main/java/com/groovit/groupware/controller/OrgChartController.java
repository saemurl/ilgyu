package com.groovit.groupware.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.OrgChartService;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.OrgChartVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/orgchart")
@Controller
public class OrgChartController extends BaseController{
	
	
	@Autowired
	OrgChartService orgchartService;
	
	@GetMapping("/list")
	public String OrgChartList() {
		
		return "orgChart/list";
	}
	
	@ResponseBody
	@GetMapping("/select")
	public List<OrgChartVO> OrgCartList(Model model) {
		
		List<OrgChartVO> orgChartList = this.orgchartService.list();
		
		
		
		return orgChartList;
	}
	
	@ResponseBody
	@PostMapping("/detail")
	public EmployeeVO detail(@RequestBody Map<String, String> map) {
		log.info("detail옴");
		log.info("detail_map : " + map);
		
		EmployeeVO employeeVO = this.orgchartService.detail(map);
		
		log.info("employeeVO : " + employeeVO);
		
		return employeeVO;
	}
}
