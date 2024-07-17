package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.HashMap;
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
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.service.RoomService;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MeetingRoomRentVO;
import com.groovit.groupware.vo.MeetingRoomVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/room")
@Controller
@Slf4j
public class RoomController extends BaseController{

	@Autowired
	RoomService roomService;
	
	// 회의실 예약 메인 페이지 --------------------------------------------------------
	@GetMapping("/list")
	public String list(Model model, Principal principal) {
		
		String empId = principal.getName();
		EmployeeVO employeeVOList = this.roomService.employee(empId);

		List<MeetingRoomVO> meetingRoomVOList = this.roomService.roomList();
		
		model.addAttribute("employeeVOList",employeeVOList);
		model.addAttribute("meetingRoomVOList", meetingRoomVOList);
		
		log.info("관리자 로그인 사원정보 : " + employeeVOList);
		log.info("관리자 회의실 전체조회 : " + meetingRoomVOList);
		
		return "room/list";
	}
	
	// 전체 회의실 조회 Ajax --------------------------------------------------------
	@GetMapping("/roomSearch")
	@ResponseBody
	public List<MeetingRoomVO> roomSearch(){
		
	    List<MeetingRoomVO> chooseRoomList = this.roomService.roomSearch();
	    
	    log.info("대여 가능 회의실 컨트롤러 반환 값 체크 : " + chooseRoomList);
	    
	    return chooseRoomList;    
	}
	
	// 선택 회의실 예약현황 조회
	@PostMapping("/roomRentCheck")
    @ResponseBody
    public List<MeetingRoomRentVO> roomRentCheck(@RequestBody Map<String, Object> map) {
        
        String dateOrgin = (String) map.get("date");
        String date = dateOrgin.replace("-", "");
   
        log.info("date : " + date);
        
        String room = (String) map.get("room");
        
        Map<String, Object> params = new HashMap<>();
        params.put("date", date);
        params.put("room", room);
        
        List<MeetingRoomRentVO> meetingRoomRentVOList = roomService.roomRentCheck(params);
        
        log.info("meetingRoomRentVOList 체크 : " + meetingRoomRentVOList);
        
        return meetingRoomRentVOList;
    }
	
	@PostMapping("rent")
	@ResponseBody
	public int rent(@RequestBody MeetingRoomRentVO meetingRoomRentVO) {
		
		// log.info("아작스 값 넘어온거 체크 : " + meetingRoomRentVO );
		
		String setRentBgng = meetingRoomRentVO.getRentBgng().replace("-", "").replace(" ", " ");
		String setRentEnd = meetingRoomRentVO.getRentEnd().replace("-", "").replace(" ", " ");
		
		meetingRoomRentVO.setRentBgng(setRentBgng);
		meetingRoomRentVO.setRentEnd(setRentEnd);
		
		log.info("날짜 사이에 - 있던거 제거한 VO값 체크 : " + meetingRoomRentVO );
		
		int result = roomService.rent(meetingRoomRentVO);
		log.info("예약 결과 : " + result);
		
		return result;
	}
	
	// 회의실 예약 관리 조회 페이지 --------------------------------------------------------
	@GetMapping("/adminList")
	public String managementList(Model model, Principal principal) {
		
		String empId = principal.getName();
		EmployeeVO employeeVOList = this.roomService.employee(empId);

		List<MeetingRoomVO> meetingRoomVOList = this.roomService.roomList();
		
		List<MeetingRoomRentVO> meetingRoomRentVOList = this.roomService.roomListAdmin();
		
		for (MeetingRoomRentVO rentDate : meetingRoomRentVOList) {

			String rentBgngDate = rentDate.getRentBgng().substring(0, 4) + "-" 
							+ rentDate.getRentBgng().substring(4, 6) + "-" 
							+ rentDate.getRentBgng().substring(6, 8);
	        
	        // 변환된 날짜와 시간 설정
			rentDate.setRentDate(rentBgngDate);
		}
		
		model.addAttribute("employeeVOList",employeeVOList);
		model.addAttribute("meetingRoomVOList", meetingRoomVOList);
		model.addAttribute("meetingRoomRentVOList", meetingRoomRentVOList);
		
		log.info("관리자 회의실 , 장비 값 체크 : " + meetingRoomVOList);
		log.info("관리자 회의실 전체 예약 조회 : " + meetingRoomRentVOList);
		
		return "room/adminList";
	}

	// 회의실 예약 조회 페이지 이동 ----------------------------------------------------
	@GetMapping("/rentList")
	public String rentListPage() {
		return "room/rentList";
	}
	
	// 회의실 예약 조회 페이지 --------------------------------------------------------
	@GetMapping("/rentTable")
	@ResponseBody
	public Map<String, Object> rentTable(Principal principal) {
	    String empId = principal.getName();
	    EmployeeVO employeeVOList = this.roomService.employee(empId);

	    List<MeetingRoomRentVO> meetingRoomRentVOList = this.roomService.myRentList(empId);
	    log.info("회의실예약 VO 리스트 값 체크 : " + meetingRoomRentVOList);
	    
	    for (MeetingRoomRentVO rentDate : meetingRoomRentVOList) {
	        String rentBgngDate = rentDate.getRentBgng().substring(0, 4) + "-"
	                + rentDate.getRentBgng().substring(4, 6) + "-"
	                + rentDate.getRentBgng().substring(6, 8);

	        rentDate.setRentDate(rentBgngDate);
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("employeeVOList", employeeVOList);
	    result.put("meetingRoomRentVOList", meetingRoomRentVOList);

	    log.info("체크체크체크 : " + meetingRoomRentVOList);

	    return result;
	}
	
	// 회의실 예약 취소 -----------------------------------------------------------------
	@PostMapping("/rentalCancel")
	@ResponseBody
	public List<MeetingRoomRentVO> rentalCancel(@RequestBody MeetingRoomRentVO meetingRoomRentVO, Principal principal) {
	
		log.info("넘어온 예약취소 rentNo 값 : " + meetingRoomRentVO);
		
		String empId = principal.getName();
		String rentNo = meetingRoomRentVO.getRentNo();
		
		int result = roomService.rentalCancel(rentNo);
		List<MeetingRoomRentVO> meetingRoomRentVOList = this.roomService.myRentList(empId);
		
		for (MeetingRoomRentVO rentDate : meetingRoomRentVOList) {

			String rentBgngDate = rentDate.getRentBgng().substring(0, 4) + "-" 
							+ rentDate.getRentBgng().substring(4, 6) + "-" 
							+ rentDate.getRentBgng().substring(6, 8);
	        
	        // 변환된 날짜와 시간 설정
			rentDate.setRentDate(rentBgngDate);
		}
		
		log.info("예약 취소 결과 체크 : " + result);
		log.info("예약 취소 meetingRoomRentVOList 체크 : " + meetingRoomRentVOList);
		
		return meetingRoomRentVOList;
	}
	
	// 회의실 예약 수정 -----------------------------------------------------------------
	@PostMapping("/rentalUpdate")
	@ResponseBody
	public int rentalUpdate(@RequestBody MeetingRoomRentVO meetingRoomRentVO) {
		
		log.info("넘어온 예약 수정 값 meetingRoomRentVO 체크 : " + meetingRoomRentVO);
		
		int result = roomService.rentalUpdate(meetingRoomRentVO);
		
		log.info("예약 수정 결과 체크 : " + result);
		
		return result;
	}
	
	@GetMapping("/rentCount")
	@ResponseBody
	public String rentCount() {
		
		
		List<Map<String, Object>> rentCounts = roomService.getRentCounts(); 
		
		String allCount = "";
        
        for (int i = 0; i < rentCounts.size(); i++) {
            Map<String, Object> count = rentCounts.get(i);
            allCount += count.get("RENT_COUNT");
            if (i < rentCounts.size() - 1) {
                allCount += ",";
            }
        }
        
		log.info("최종 반환 값 체크" + allCount);
        
        return allCount;
	}
	
	@GetMapping("/reloadRentRoom")
	@ResponseBody
	public List<MeetingRoomVO> reloadRentRoom() {
		
		List<MeetingRoomVO> roomNameList = roomService.reloadRentRoom();
		log.info("재갱신된 회의실 : " + roomNameList);
		
		return roomNameList;
	}
	
	@PostMapping("/adminRentalCancel")
	@ResponseBody
	public int adminRentalCancel(@RequestBody Map<String, String> map) {
		
		String rentNo = map.get("rentNo");
	    log.info("이쪽 아작스 타는지 체크: " + rentNo);
	    
	    int result = roomService.adminRentalCancel(rentNo);
	    log.info("관리자 예약 수정 결과 체크 : " + result);
		
		return result;
	}
	
	@PostMapping("/selectRentList")
	@ResponseBody
	public List<MeetingRoomRentVO> selectRentList(@RequestBody Map<String, String> map){
	    
		String mtgrNm = map.get("mtgrNm");
	    log.info("아작스 선택회의실 예약 조회 넘어온 mtgrNm 값 체크 : " + mtgrNm);
	    
	    List<MeetingRoomRentVO> rentList = roomService.selectRentList(mtgrNm);
	    
	    for (MeetingRoomRentVO rentDate : rentList) {

			String rentBgngDate = rentDate.getRentBgng().substring(0, 4) + "-" 
							+ rentDate.getRentBgng().substring(4, 6) + "-" 
							+ rentDate.getRentBgng().substring(6, 8);
	        
	        // 변환된 날짜와 시간 설정
			rentDate.setRentDate(rentBgngDate);
		}
	    
	    log.info("가져온 오늘의 예약 리스트 : " + rentList);
	    
	    return rentList;
	}
	
	
	@PostMapping("/createRoom")
	@ResponseBody
	public int createRoom(
	        @RequestParam("mtgrNm") String mtgrNm,
	        @RequestParam("mtgrCpct") String mtgrCpct,
	        @RequestParam("mtgrExpln") String mtgrExpln,
	        @RequestParam("eqpmntNm") String eqpmntNm,
	        @RequestParam("UploadFile") MultipartFile file,
	        Principal principal) {
	    
	    log.info("값 체크 mtgrNm : " + mtgrNm);
	    log.info("값 체크 mtgrCpct : " + mtgrCpct);
	    log.info("값 체크 mtgrExpln : " + mtgrExpln);
	    log.info("값 체크 eqpmntNm : " + eqpmntNm);
	    log.info("업로드된 파일 이름: " + file.getOriginalFilename());
	    String empId = principal.getName();
	    
	    Map<String, Object> param = new HashMap<>();
	    param.put("mtgrNm", mtgrNm);
	    param.put("mtgrCpct", mtgrCpct);
	    param.put("mtgrExpln", mtgrExpln);
	    param.put("eqpmntNm", eqpmntNm);
	    param.put("uploadFile", file);
	    param.put("empId", empId);
	    
	    int result = this.roomService.createRoom(param);

	    return result;
	}
	
	@GetMapping("/reloadTopTable")
	@ResponseBody
	public List<MeetingRoomVO> reloadTopTable (){
		List<MeetingRoomVO> meetingRoomVOList = this.roomService.roomList();
		return meetingRoomVOList;
	}
	
	@GetMapping("/reloadBottomTable")
	@ResponseBody
	public List<MeetingRoomRentVO> reloadBottomTable(){
		List<MeetingRoomRentVO> meetingRoomRentVOList = this.roomService.roomListAdmin();
		
		for (MeetingRoomRentVO rentDate : meetingRoomRentVOList) {

			String rentBgngDate = rentDate.getRentBgng().substring(0, 4) + "-" 
							+ rentDate.getRentBgng().substring(4, 6) + "-" 
							+ rentDate.getRentBgng().substring(6, 8);
	        
			rentDate.setRentDate(rentBgngDate);
		}
		return meetingRoomRentVOList;
	}
	
	@PostMapping("/selectRoomDetail")
	@ResponseBody
	public MeetingRoomVO selectRoomDetail(@RequestBody Map<String, String> map) {
		
		String mtgrNm = map.get("mtgrNm");
		
		log.info("선택한 회의실 컨트롤러로 값 넘어왔는지 체크 : " + mtgrNm);
		
		MeetingRoomVO SelectRoomVO = this.roomService.selectRoomDetail(mtgrNm);
		log.info("선택한 회의실 VO : " + SelectRoomVO);
		
		return SelectRoomVO;
	}
	
	@PostMapping("/updateRoom")
	@ResponseBody
	public int updateRoom(@RequestBody MeetingRoomVO meetingRoomVO) {

		log.info("값 체크 : " + meetingRoomVO);
		
		int result = this.roomService.updateRoom(meetingRoomVO);
		
		return result;
	}
	
	// 내 예약 조회 상단 차트 라벨 값 전체 가져오기
	@GetMapping("/myRentRoomLabels")
	@ResponseBody
	public List<MeetingRoomVO> myRentRoomLabels(Principal principal) {
		
		String empId = principal.getName();
		log.info("예약 조회하려는 회원 ID : " + empId);
		
		List<MeetingRoomVO> nameLabels = this.roomService.myRentRoomLabels(empId);
		log.info("회의실 전체 이름 labels 용도 : " + nameLabels);
			
		return nameLabels;
	}
	
	// 내 예약 토글용 TOP3 가져오기
	@GetMapping("/myRentTop3")
	@ResponseBody
	public List<MeetingRoomVO> myRentTop3(Principal principal) {
		
		String empId = principal.getName();
		log.info("예약 TOP3 조회하려는 회원 ID : " + empId);
		
		List<MeetingRoomVO> rentTopThree = this.roomService.myRentTop3(empId);
		log.info("예약 TOP3 체크 : " + rentTopThree);
		
		return rentTopThree; 
	}
	
	
}
