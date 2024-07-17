package com.groovit.groupware.controller;

import java.security.Principal;
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

import com.groovit.groupware.service.AttendanceService;
import com.groovit.groupware.util.ArticlePage;
import com.groovit.groupware.vo.AttendanceVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.Leave1VO;
import com.groovit.groupware.vo.YearlyVacationVO;

import lombok.extern.slf4j.Slf4j;


@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/attendance")
@Controller
public class AttendanceController  extends BaseController {

	@Autowired
	AttendanceService attendanceService;

	Principal principal;


	//출퇴근 등록 및 관리 리스트-------------------------------------------------------------------------

	@GetMapping("/create")
	public String create() {
		log.info("create");

		return "attend/create";
	}

	//출근시간
	@ResponseBody
	@PostMapping("/createPost")
	public AttendanceVO createPost(Principal principal) {
		log.info("createPost");
		String empId = principal.getName();

		int result = this.attendanceService.createPost(empId);

		AttendanceVO attendanceVO = this.attendanceService.selectBgng(empId);
		log.info("result:"+ result);
		log.info("attendanceVO : " + attendanceVO);

		return attendanceVO;
	}
	//새로 고침해도 데이터 남아있어야해서 만들어진 리스트
		@ResponseBody
		@GetMapping("/createList")
		public AttendanceVO createList(Principal principal) {
			log.info("createPost");

			String empId = principal.getName();

			AttendanceVO attendanceVO = this.attendanceService.selectBgng(empId);

			log.info("attendanceVO : " + attendanceVO);

			return attendanceVO;
		}

		//일한시간
		@ResponseBody
		@GetMapping("/selectAttnList")
		public AttendanceVO selectAttnList(Principal principal) {
			log.info("createPost");

			String empId = principal.getName();

			AttendanceVO attendanceVO = this.attendanceService.selectAttnList(empId);

			log.info("attendanceVO : " + attendanceVO);

			return attendanceVO;
		}
		//퇴근시간
		@ResponseBody
		@PostMapping("/updatePost")
		public AttendanceVO updatePost(Principal principal) {

			String empId = principal.getName();

			int result = this.attendanceService.updatePost(empId);

			AttendanceVO attendanceVO = this.attendanceService.selectBgng(empId);

			log.info("attendanceVO : " + attendanceVO);
			log.info("result:"+ result);

			return attendanceVO;
		}

	// 내 근태 현황 페이지
	@GetMapping("/list")
	public String list() {
		return "attend/list";
	}

	// 내 근태 테이블 조회
	@PostMapping("/loadAttnTable")
	@ResponseBody
	public List<AttendanceVO> loadAttnTable(@RequestBody AttendanceVO attendanceVO, Principal principal) {
	    String empId = principal.getName();
	    attendanceVO.setEmpId(empId);

	    String selectMonth = attendanceVO.getSelectMonth();
	    log.info("내 근태 조회 접속 ID, 선택 날짜 체크 : " + empId + ", " + selectMonth);

	    List<AttendanceVO> attendanceVOList = attendanceService.loadAttnTable(attendanceVO);
	    log.info("선택한 날짜 내 근태 조회 전체 체크 : " + attendanceVOList);

	    return attendanceVOList;
	}

	// 내 근태 차트 조회
	@PostMapping("/loadAttnChart")
	@ResponseBody
	public List<Map<String, Object>> loadAttnChart(Principal principal) {

		String empId = principal.getName();

		List<Map<String, Object>> attnMonthMapList = attendanceService.loadAttnChart(empId);
		log.info("내 근태 차트 전체 값 체크 : " + attnMonthMapList);

		return attnMonthMapList;
	}




// ------------------------------------------------------------------------------------------------------------
	//휴가 연차 관리

	@GetMapping("/vacationList")
	public String vacationGetList(Model model,Principal principal) {

		return "vacation/list";
	}

	@ResponseBody
	@PostMapping("/vacationPostList")
	public List<Map<String, Object>> vacationPostList(@RequestBody Map<String, Object> map , Principal principal) {

		map.put("empId", principal.getName());

		List<Map<String,Object>> vacationPostList = this.attendanceService.vacationPostList(map);
		log.info("vacationPostList => " + vacationPostList);

		return vacationPostList;
	}

	@ResponseBody
	@PostMapping("/yearlyVacationList")
	public List<YearlyVacationVO> yearlyVacationList(Principal principal) {

		String empId = principal.getName();

		List<YearlyVacationVO> yearlyVacationList = this.attendanceService.yearlyVacationList(empId);
		log.info("vacationPostList => " + yearlyVacationList);

		return yearlyVacationList;
	}

	@ResponseBody
	@PostMapping("/yearlyVacationCount")
	public List<YearlyVacationVO> yearlyVacationCount(Principal principal) {

		String empId = principal.getName();

		List<YearlyVacationVO> yearlyVacationCount = this.attendanceService.listVct(empId);
		log.info("vacationPostList => " + yearlyVacationCount);

		return yearlyVacationCount;
	}


	// 휴가 신청
	@GetMapping("/leaveInsert")
	public String leaveCreate(Model model,Principal principal) {

		String empId = principal.getName();
		EmployeeVO employeeVO = this.attendanceService.getEmpData(empId);
		log.info("휴가 신청 페이지 접속 회원정보 체크 : " + employeeVO);

		model.addAttribute("employeeVO",employeeVO);

		return "vacation/create";
	}

	@PostMapping("/leaveInsertPost")
	public String leaveCreatePost(Principal principal,@RequestBody Leave1VO leave1VO) {

		log.info("leave1VO"+leave1VO);
		String empId = principal.getName();

		leave1VO.setEmpId(empId);

		int result = this.attendanceService.leaveInsert(leave1VO);
		log.info("result : " +result);

		return "vacation/list";
	}



//-------------------------------------------------------------------------------------------------------------------------
//부서 근태관리

	/**
	 * 부서 근태현황 페이지
	 * @return
	 */
	@GetMapping("/departList")
	public String departList() {

		log.info("departList");

		return "vacation/departList";
	}

	/**
	 * 해당 부서 월별 근태리스트 가져오기
	 * @param currentPage
	 * @param keyword
	 * @param month
	 * @param deptCd
	 * @param map
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getListBydepart")
	public ArticlePage<AttendanceVO> getListByDepart(int currentPage, String keyword, String month, String deptCd, Map<String,Object> map) {

		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("month", month);
		map.put("deptCd", deptCd);
		log.info("getListBydepart  {}", map);

		int total = this.attendanceService.getTotalByDepart(map);

		List<AttendanceVO> listByDepart = this.attendanceService.departList(map);

		return new ArticlePage<AttendanceVO>(total, currentPage, 10, listByDepart, keyword);
	}

	/**
	 * 부서별 부서원 목록 가져오기
	 * @param deptCd
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getEmployeeByDepart")
	public List<EmployeeVO> getEmployeeByDepart(String deptCd){

		log.info("getEmployeeByDepart  {}", deptCd);
		List<EmployeeVO> empListbyDepart = this.attendanceService.getEmployeeByDepart(deptCd);

		return empListbyDepart;
	}

	/**
	 * 근무상태별 오늘 날짜의 근무현황 통계
	 * @param deptCd
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getTodayStaticByStts")
	public  List<Map<String, Object>> getTodayStaticByStts(String deptCd){

		List<Map<String, Object>> todayStaticList = this.attendanceService.getTodayStaticByStts(deptCd);

		return todayStaticList;

	}

	/**
	 * 현재달까지의 월별 연차사용개수 통계
	 * @param deptCd
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getLeaveStaticByDepartAndMonth")
	public List<Map<String, Object>> getLeaveStaticByDepartAndMonth(String deptCd){

		log.info("getLeaveStaticByDepartAndMonth -> {}", deptCd);
		List<Map<String, Object>> leaveYearlyStaticList = this.attendanceService.getLeaveStaticByDepartAndMonth(deptCd);

		log.info("getLeaveStaticByDepartAndMonth -> {}", leaveYearlyStaticList);

		return leaveYearlyStaticList;
	}

	/**
	 * 월별 하루 근무시간평균 통계
	 * @param deptCd
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getAttendanceAvgByDepartAndMonth")
	public List<Map<String, Object>> getAttendanceAvgByDepartAndMonth(String deptCd){

		log.info("getAttendanceAvgByDepartAndMonth -> {}", deptCd);
		List<Map<String, Object>> attendanceAvgList = this.attendanceService.getAttendanceAvgByDepartAndMonth(deptCd);

		log.info("getAttendanceAvgByDepartAndMonth -> {}", attendanceAvgList);

		return attendanceAvgList;
	}

	/**
	 * 월별 연장근무개수 통계
	 * @param deptCd
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getOverTimeStaticByDepartAndMonth")
	public List<Map<String, Object>> getOverTimeStaticByDepartAndMonth(String deptCd){

		log.info("getOverTimeStaticByDepartAndMonth -> {}", deptCd);
		List<Map<String, Object>> overTimeStaticList = this.attendanceService.getOverTimeStaticByDepartAndMonth(deptCd);

		log.info("getOverTimeStaticByDepartAndMonth -> {}", overTimeStaticList);

		return overTimeStaticList;
	}





	/**
	 * 휴가수 카운트
	 * @param 
	 * @return
	 */
	@ResponseBody
	@PostMapping("/countVacDays")
	public Map<String, Object> countVacDays(Principal principal){

		String empId =  principal.getName();
		
		Map<String, Object> countVacDays = this.attendanceService.countVacDays(empId);


		return countVacDays;
	}
	





}
