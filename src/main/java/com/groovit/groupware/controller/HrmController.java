package com.groovit.groupware.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.groovit.groupware.service.HrmService;
import com.groovit.groupware.util.ArticlePage;
import com.groovit.groupware.vo.ComCodeDetailVO;
import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.JobGradeVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/hrm")
@Controller
public class HrmController extends BaseController {
	
	@Autowired
    PasswordEncoder passwordEncoder;
	
	@Autowired
	HrmService hrmService;
	
	@GetMapping("/createForm")
	public String hrmcreate(Model model) {
		
		List<DepartmentVO> DeptVOList = this.hrmService.DeptVOList();
		
		String empId = this.hrmService.empIdMax();
		log.info("empId >>>>>>" + empId);
		
		model.addAttribute("empId", empId);
		model.addAttribute("DeptVOList",DeptVOList);
		
		return "hrm/create";
	}
	
	@ResponseBody
	@PostMapping("/Team")
	public List<DepartmentVO> deptTeamList(Model model, @RequestBody Map<String, String> map) {
		
		String deptUpCd = map.get("deptUpCd");
		log.info("deptUpCd >>>>>>" + deptUpCd);
		
		List<DepartmentVO> deptVOList = this.hrmService.deptlist(deptUpCd);
		
		model.addAttribute("deptVOList", deptVOList);
		
		log.info("deptVOList :" + deptVOList);
		
		return deptVOList;
	}
	@ResponseBody
	@PostMapping("/ptpTeam")
	public List<DepartmentVO> ptpTeamList(Model model, @RequestBody Map<String, String> map) {
		
		String deptUpCd = map.get("deptUpCd");
		log.info("deptUpCd >>>>>>" + deptUpCd);
		
		List<DepartmentVO> deptVOList = this.hrmService.deptlist(deptUpCd);
		
		model.addAttribute("deptVOList", deptVOList);
		
		log.info("deptVOList :" + deptVOList);
		
		return deptVOList;
	}
	@ResponseBody
	@PostMapping("/ptpTeam2")
	public List<DepartmentVO> ptpTeamList2(Model model, @RequestBody Map<String, String> map) {
		
		String deptUpCdd = map.get("deptUpCdd");
		log.info("deptUpCd >>>>>>" + deptUpCdd);
		
		List<DepartmentVO> deptVOList = this.hrmService.deptlist(deptUpCdd);
		
		model.addAttribute("deptVOList", deptVOList);
		
		log.info("deptVOList :" + deptVOList);
		
		return deptVOList;
	}
	
	@PostMapping("/createPost")
	public String createPost(EmployeeVO employeeVO) {
		log.info("createPost왐");
		
		String pwd = "1234";
		
		String empPassEncode = passwordEncoder.encode(pwd);
		employeeVO.setEmpPass(empPassEncode);
		int result = this.hrmService.createPost(employeeVO);
		log.info("result >>> " + result);
		
		log.info("employeeVO : " + employeeVO);
		
		return "redirect:/hrm/list";
	}
	
	@GetMapping("/list")
	public ModelAndView list(ModelAndView mav,
			@RequestParam(value="currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword) {
		log.info("list 왔다");
		// map{"키값" : "value값"}
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("keyword >> " + keyword);
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		
		int total = this.hrmService.getTotal(map);
		
		List<EmployeeVO> employeeVOList = this.hrmService.hrmList(map);
		List<JobGradeVO> jobGradeList = this.hrmService.jobSelect();
		List<DepartmentVO> DeptVOList = this.hrmService.DeptVOList();
		log.info("jobGradeList >> " + jobGradeList);
		
		
		mav.addObject("title", "직원 목록");
		mav.addObject("articlePage",new ArticlePage<EmployeeVO>(total, currentPage, 10, employeeVOList, keyword));
		mav.addObject("jobGradeList", jobGradeList);
		mav.addObject("DeptVOList", DeptVOList);
		
		mav.setViewName("hrm/list");
		
		return mav;
	}
	@GetMapping("/ptplist")
	public ModelAndView ptplist(ModelAndView mav,
			@RequestParam(value="currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword) {
		log.info("list 왔다");
		
		// map{"키값" : "value값"}
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("keyword >> " + keyword);
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		
		int total = this.hrmService.getTotal(map);
		
		List<EmployeeVO> employeeVOList = this.hrmService.hrmList(map);
		List<JobGradeVO> jobGradeList = this.hrmService.jobSelect();
		List<DepartmentVO> DeptVOList = this.hrmService.DeptVOList();
		log.info("jobGradeList >> " + jobGradeList);
		
		
		mav.addObject("title", "직원 목록");
		mav.addObject("articlePage",new ArticlePage<EmployeeVO>(total, currentPage, 10, employeeVOList, keyword));
		mav.addObject("jobGradeList", jobGradeList);
		mav.addObject("DeptVOList", DeptVOList);
		
		mav.setViewName("hrm/ptp");
		
		return mav;
	}
	
	//{"keyword": "","currentPage": 1,"deptUpCd": "X001","deptCd": "D005"}
	//or
	//{"keyword": "","currentPage": 1,"jbgdCd": "J006"}
	@ResponseBody
	@PostMapping("/listAjax")
	public ArticlePage<EmployeeVO> listAjax(@RequestBody Map<String,Object> map) {
		log.info("listAjax에 왔다");
		log.info("listAjax->keyword : " + map);
		
		int total = this.hrmService.getTotal(map);
		
		List<EmployeeVO> employeeVOList = this.hrmService.hrmList(map);
		
		log.info("list->employeeVOList : "+employeeVOList);
		
		return new ArticlePage<EmployeeVO>(total, Integer.parseInt(map.get("currentPage").toString()), 10, employeeVOList, map.get("keyword").toString(), map);
		
	}
	@ResponseBody
	@PostMapping("/ptplistAjax")
	public ArticlePage<EmployeeVO> ptplistAjax(@RequestBody Map<String,Object> map) {
		log.info("listAjax에 왔다");
		log.info("listAjax->keyword : " + map);
		
		int total = this.hrmService.getTotal(map);
		
		List<EmployeeVO> employeeVOList = this.hrmService.hrmList(map);
		
		log.info("list->employeeVOList : "+employeeVOList);
		
		return new ArticlePage<EmployeeVO>(total, Integer.parseInt(map.get("currentPage").toString()), 10, employeeVOList, map.get("keyword").toString(), map);
		
	}
	
	@ResponseBody
	@PostMapping("/empDetail")
	public EmployeeVO empDetail(@RequestBody String empId) {
		log.info("empDetail~~~");
		
		log.info("empId >> " + empId);
		
		EmployeeVO employeeVO = this.hrmService.empDetail(empId);
		log.info("employeeVO >> " + employeeVO);
		
		return employeeVO;
		
	}
	@ResponseBody
	@PostMapping("/ptpEmpDetail")
	public EmployeeVO ptpEmpDetail(@RequestBody String empId) {
		log.info("empDetail~~~");
		
		log.info("empId >> " + empId);
		
		EmployeeVO employeeVO = this.hrmService.empDetail(empId);
		log.info("employeeVO >> " + employeeVO);
		
		return employeeVO;
	}
	
	
	@PostMapping("/ptpResig")
	public String ptpDelete(@RequestBody String empId) {
		
		int result = this.hrmService.ptpResig(empId);
		log.info("result : " + result);
		
		return "hrm/ptp";
	}
	
	@PostMapping("/deptUpdate")
	public String deptUpdate(@RequestBody Map<String, String> map) {
		
		log.info("map :" + map);
		
		int result = this.hrmService.deptUpdate(map);
		log.info("result : " + result);
		
		return "hrm/ptp";
	}
	
	@PostMapping("/jobUpdate")
	public String jobUpdate(@RequestBody Map<String, String> map) {
		
		log.info("map :" + map);
		
		int result = this.hrmService.jobUpdate(map);
		log.info("result : " + result);
		
		return "hrm/ptp";
	}
	
	@ResponseBody
	@PostMapping("/leaveSelect")
	public List<ComCodeDetailVO> leaveSelect(){
		
		List<ComCodeDetailVO> leaveList = this.hrmService.leaveSelect();
		log.info("leaveList : " + leaveList);
		
		return leaveList;
	}
	
	@PostMapping("/LeaveUpdate")
	public String LeaveUpdate(@RequestBody Map<String, String> map) {
			
		int result = this.hrmService.LeaveUpdate(map);
		log.info("map : " + map);
		
		return "hrm/ptp";
	}
	


}
