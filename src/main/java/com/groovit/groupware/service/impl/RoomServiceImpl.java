package com.groovit.groupware.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.dao.RoomDao;
import com.groovit.groupware.service.RoomService;
import com.groovit.groupware.util.UploadController;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.EquipmentListVO;
import com.groovit.groupware.vo.MeetingRoomRentVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class RoomServiceImpl implements RoomService {

	@Autowired
	RoomDao roomDao;
	
	@Autowired
	UploadController uploadController;
	
	// 로그인 회원정보 조회
	@Override
	public EmployeeVO employee(String empId) {
		return this.roomDao.employee(empId);
	}

	// 회의실명 조회
	@Override
	public List<MeetingRoomVO> roomSearch() {
		return this.roomDao.roomSearch();
	}

	@Override
	public List<MeetingRoomRentVO> roomRentCheck(Map<String, Object> params) {
		return this.roomDao.roomRentCheck(params);
	}

	@Override
	public int rent(MeetingRoomRentVO meetingRoomRentVO) {
		
		// 1) 회의실 예약 ------------------------------------------------------------
		int result = this.roomDao.rent(meetingRoomRentVO);

		// 2) 회의실 예약 정보를 개인일정 캘린더에 추가 -----------------------------------------
		log.info("회의실 예약 시 개인 일정 캘린더에 추가하기 위한 값 중간체크 : " + meetingRoomRentVO);
		// mtgrNm=101실, empId=202406240022, empNm=null, rentDate=null, rentStts=null, 
		// rentBgng=20240622 10:00, rentEnd=20240622 11:00, rentRsn=ㄱㄱ
		
		
		ScheduleCalendarVO scheduleCalendarVO = new ScheduleCalendarVO();
		scheduleCalendarVO.setEmpId(meetingRoomRentVO.getEmpId());
		scheduleCalendarVO.setTitle("회의실 [ " + meetingRoomRentVO.getMtgrNm() + " ] 예약");
		scheduleCalendarVO.setDescription("[ "+ meetingRoomRentVO.getRentRsn() + " ] 목적으로 회의실 대여");
		
		String rentDateString = meetingRoomRentVO.getRentBgng();
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMdd HH:mm");
        try {
			Date rentDate = inputFormat.parse(rentDateString);
			scheduleCalendarVO.setStart(rentDate);
			scheduleCalendarVO.setEnd(rentDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		scheduleCalendarVO.setAllday("N");
		scheduleCalendarVO.setColor("#7367f0");
		scheduleCalendarVO.setLocation(meetingRoomRentVO.getMtgrNm());
		
		// 202406140008, 회의실 예약 일정, 회의실 예약, 2024/06/04,	2024/06/04,	N	#7367f0,	101실
	    log.info("회의실 예약 후 개인일정 캘린더에 추가할 VO 값 : " + scheduleCalendarVO);
		
	    result += this.roomDao.rentRoomCalAdd(scheduleCalendarVO);
	    
		return result;
	}

	@Override
	public List<MeetingRoomVO> roomList() {
		return this.roomDao.roomList();
	}

	@Override
	public List<MeetingRoomRentVO> myRentList(String empId) {
		return this.roomDao.myRentList(empId);
	}

	@Override
	public int rentalCancel(String rentNo) {
		
		int result = this.roomDao.rentalCancel(rentNo);
		
		result += this.roomDao.CalRoomRentCancel(rentNo);
		
		return result;
	}

	@Override
	public int rentalUpdate(MeetingRoomRentVO meetingRoomRentVO) {
		return this.roomDao.rentalUpdate(meetingRoomRentVO);
	}

	@Override
	public List<MeetingRoomRentVO> roomListAdmin() {
		return this.roomDao.roomListAdmin();
	}

	@Override
	public List<Map<String, Object>> getRentCounts() {
		return this.roomDao.getRentCounts();
	}

	@Override
	public int adminRentalCancel(String rentNo) {
		return this.roomDao.adminRentalCancel(rentNo);
	}

	@Override
	public List<MeetingRoomRentVO> selectRentList(String mtgrNm) {
		return this.roomDao.selectRentList(mtgrNm);
	}

	@Override
	public int createRoom(Map<String, Object> param) {
		
		String mtgrNm = (String) param.get("mtgrNm");
		int mtgrCpct = Integer.parseInt((String) param.get("mtgrCpct"));
		String mtgrExpln = (String) param.get("mtgrExpln");
		String eqpmntNm = (String) param.get("eqpmntNm");
		MultipartFile uploadFile = (MultipartFile) param.get("uploadFile");
		String empId = (String) param.get("empId");
		
	    log.info("서비스 임플에서 값 체크  mtgrNm : " + mtgrNm);
	    log.info("서비스 임플에서 값 체크  mtgrNm : " + mtgrCpct);
	    log.info("서비스 임플에서 값 체크  mtgrNm : " + mtgrExpln);
	    log.info("서비스 임플에서 값 체크  mtgrNm : " + eqpmntNm);
	    log.info("서비스 임플에서 값 체크  mtgrNm : " + uploadFile.getOriginalFilename());
		
	    // 1) 회의실 등록 ------------------------------------------------------------
	    MeetingRoomVO meetingRoomVO = new MeetingRoomVO();
	    meetingRoomVO.setMtgrNm(mtgrNm);
	    meetingRoomVO.setMtgrCpct(mtgrCpct);
	    meetingRoomVO.setMtgrExpln(mtgrExpln);
	    
	    log.info("서비스 임플 1) 회의실 등록 meetingRoomVO 값 담긴지 체크 : " + meetingRoomVO);
	    
	    int result = this.roomDao.createRoom(meetingRoomVO);
	    
	    // 2) 추가된 회의실 번호 값 조회 ---------------------------------------------------
	    String mtgrNo = this.roomDao.selectMaxMtgrNo();
	    
	    log.info("추가된 회의실 번호 : " + mtgrNo);
	    
	    // 3) 회의실 장비 등록 ---------------------------------------------------------
	    if (eqpmntNm != null && !eqpmntNm.isEmpty()) {
	    	String[] mtgrNmArray = eqpmntNm.split(",");
  
	    	for (String eqpmntCd : mtgrNmArray) {
	    		EquipmentListVO equipmentListVO = new EquipmentListVO();
	    		
                equipmentListVO.setMtgrNo(mtgrNo);
                equipmentListVO.setEqpmntCd(eqpmntCd.trim());
                
                result += this.roomDao.roomEquipmentAdd(equipmentListVO);
            }
        }
	    
	    // 4) 회의실 파일 업로드 --------------------------------------------------------
  		if(uploadFile.getOriginalFilename().length()>0) {
  			
  			String atchfileSn = this.uploadController.uploadOne(uploadFile, empId);
  			
  			log.info("등록된 atchfileSn 값 체크 : " + atchfileSn);
  			
  			meetingRoomVO.setMtgrNo(mtgrNo);
  			meetingRoomVO.setAtchfileSn(atchfileSn);
  		}
  		result += this.roomDao.roomAtchfileSn(meetingRoomVO);
	    
	    
		return result;
	}

	@Override
	public List<MeetingRoomVO> reloadRentRoom() {
		return this.roomDao.reloadRentRoom();
	}

	@Override
	public MeetingRoomVO selectRoomDetail(String mtgrNm) {
		return this.roomDao.selectRoomDetail(mtgrNm);
	}

	@Override
	public int updateRoom(MeetingRoomVO meetingRoomVO) {
		return this.roomDao.updateRoom(meetingRoomVO);
	}

	@Override
	public List<MeetingRoomVO> myRentRoomLabels(String empId) {
		return this.roomDao.myRentRoomLabels(empId);
	}

	@Override
	public List<MeetingRoomVO> myRentTop3(String empId) {
		return this.roomDao.myRentTop3(empId);
	}



}
