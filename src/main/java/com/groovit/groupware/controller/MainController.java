package com.groovit.groupware.controller;

import java.security.Principal;
import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.mapper.EmployeeMapper;
import com.groovit.groupware.service.AttendanceService;
import com.groovit.groupware.service.EventBoardService;
import com.groovit.groupware.service.FreeBoardService;
import com.groovit.groupware.service.MailService;
import com.groovit.groupware.service.MainService;
import com.groovit.groupware.service.NoticeBoardService;
import com.groovit.groupware.service.ScheduleCalendarService;
import com.groovit.groupware.service.SurveyService;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.EventBoardVO;
import com.groovit.groupware.vo.FreeBoardVO;
import com.groovit.groupware.vo.MailVO;
import com.groovit.groupware.vo.NoticeBoardVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;
import com.groovit.groupware.vo.SurveyVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/main")
@Controller
public class MainController extends BaseController {
	
	@Autowired
    MainService mainService;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
    NoticeBoardService noticeBoardService;
	
	@Autowired
	FreeBoardService freeBoardService;
	
	@Autowired
	EventBoardService eventBoardService;
	
	@Autowired
    AttendanceService attendanceService;

	@Autowired
	ScheduleCalendarService scheduleCalendarService;
	
	@Autowired
	SurveyService surveyService;
	
	@Autowired
	MailService mailService;
	
    @GetMapping("/index")
    public String main(Locale locale, Model model, Principal principal, Authentication auth, HttpSession session) {

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
		
		// 공지사항 게시판 리스트 가져오기
		List<NoticeBoardVO> noticeBoardVOList = this.noticeBoardService.noticeTable();
		log.info("noticeBoardVOList : {}" + noticeBoardVOList);
		model.addAttribute("noticeBoardVOList", noticeBoardVOList);

		// 자유게시판 리스트 가져오기
		List<FreeBoardVO> freeBoardVOList = this.freeBoardService.freeBoardList();
		log.info("freeBoardVOList : {}" + freeBoardVOList);
		model.addAttribute("freeBoardVOList", freeBoardVOList);
		
		// 경조사 게시판 리스트 가져오기
		List<EventBoardVO> eventBoardVOList = this.eventBoardService.loadMarryTable();
		log.info("eventBoardVOList : {}" + eventBoardVOList);
		model.addAttribute("eventBoardVOList", eventBoardVOList);
		
		// 부서 조직도 직원 리스트 가져오기(메일)
		List<EmployeeVO> employeeList = this.mailService.empList(principal.getName());
		model.addAttribute("employeeList", employeeList);
		
		int empTotal = this.surveyService.getAllEmpTotal();
		model.addAttribute("empTotal", empTotal);
		
		List<SurveyVO> mainSurveyList = this.surveyService.mainSurveyList();
		model.addAttribute("mainSurveyList", mainSurveyList);
		
		return "main/index";
    }

    // 근태관리
    @PostMapping("/attendance/createPost")
	@ResponseBody
    public String createPost(Principal principal) {
        log.info("createPost");

        String empId = principal.getName();

        int result = this.attendanceService.createPost(empId);
        log.info("result: " + result);

        return result == 1 ? "success" : "fail";
    }
    
    // 근태관리
    @PostMapping("/attendance/updatePost")
    @ResponseBody
    public String updatePost(Principal principal) {
        log.info("updatePost");

        String empId = principal.getName();

        int result = this.attendanceService.updatePost(empId);
        log.info("result: " + result);

        return result == 1 ? "success" : "fail";
    }
    
    // 오늘의 일정 조회
    @GetMapping("/todoListAjax")
    @ResponseBody
    public List<ScheduleCalendarVO> todoListAjax(Principal principal) {
    	
    	String empId = principal.getName();
    	
    	List<ScheduleCalendarVO> scheduleList = this.scheduleCalendarService.todoListAjax(empId); 
    	log.info("메인 오늘의 일정 VOList 체크 : " + scheduleList);
    	
    	return scheduleList;
    }
    
    // 부서 조직도 조회
    @PostMapping("/deptEmpListAjax")
    @ResponseBody
    public List<ScheduleCalendarVO> deptEmpListAjax(@RequestBody Map<String, Object> map) {
    	
    	List<ScheduleCalendarVO> deptEmpListAjax = this.employeeMapper.deptEmpListAjax(map); 
    	log.info("부서 조직도VOList 체크 : " + deptEmpListAjax);
    	
    	return deptEmpListAjax;
    }
    
    // 부서 조직도_메일 보내기
    @PostMapping("/mailSend")
	public String mailSend(
	           @RequestPart("mailVO") MailVO mailVO,
	           @RequestPart("file") MultipartFile[] file,
	           Principal principal) {

        log.info("mailSend -> mailVO {}", mailVO);
        log.info("mailSend -> files {}", file);
       
        mailVO.setFile(file);
	        
	    Map<String, Object> map = new HashMap<String, Object>();
		
	  	String RempId = principal.getName();
		String mlSn = this.mailService.mlSn();
		log.info("mlSn >> " + mlSn);
		map.put("mlSn", mlSn);
		map.put("RempId", RempId);
		map.put("mailVO", mailVO);

		log.info("map >>>> " + map);
		
		
		int result = this.mailService.mailInsert(map);
		
		log.info("result : " + result);
		
		
		return "main/index";
	}
    
    // 읽지않은 메일 수
    @ResponseBody
	@PostMapping("/receiverCnt")
	public int receiverCnt(Principal principal) {
		
		String empId = principal.getName();
		
		int receiverCnt = this.mailService.receiverCnt(empId);
		
		return receiverCnt;
	}
    
    
    /**
     * 메인페이지 설문 가져오기
     * @return
     */
    @ResponseBody
    @GetMapping("/mainSurveyList")
    public List<SurveyVO> mainSurveyList(){
    	
    	List<SurveyVO> mainSurveyList = this.surveyService.mainSurveyList();
    	
    	return mainSurveyList;
    }
    
    /**
     * 로그인한 직원의 주차별 근무시간 합계
     * @param principal
     * @return
     */
    @ResponseBody
    @GetMapping("/getAttendanceSumByWeek")
    public List<Map<String, Object>> getAttendanceSumByWeek(Principal principal){
    	
    	String empId = principal.getName();
    	
    	List<Map<String, Object>> attendanceSumlist = this.attendanceService.getAttendanceSumByWeek(empId);
    	
    	return attendanceSumlist;
    }
    

}
