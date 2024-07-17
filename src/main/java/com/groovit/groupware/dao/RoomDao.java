package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.EquipmentListVO;
import com.groovit.groupware.vo.EquipmentVO;
import com.groovit.groupware.vo.MeetingRoomRentVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
public class RoomDao {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	// 로그인 회원정보 조회
	public EmployeeVO employee(String empId) {
		return this.sqlSessionTemplate.selectOne("room.employee", empId);
	}

	// 회의실명 조회
	public List<MeetingRoomVO> roomSearch() {
		return this.sqlSessionTemplate.selectList("room.roomSearch");
	}

	public List<MeetingRoomRentVO> roomRentCheck(Map<String, Object> params) {
		return this.sqlSessionTemplate.selectList("room.roomRentCheck", params);
	}

	public int rent(MeetingRoomRentVO meetingRoomRentVO) {
		return this.sqlSessionTemplate.insert("room.rent", meetingRoomRentVO);
	}

	public List<MeetingRoomVO> roomList() {
		return this.sqlSessionTemplate.selectList("room.roomList");
	}

	public List<MeetingRoomRentVO> myRentList(String empId) {
		return this.sqlSessionTemplate.selectList("room.myRentList", empId);
	}

	public int rentalCancel(String rentNo) {
		return this.sqlSessionTemplate.update("room.rentalCancel", rentNo);
	}

	public int rentalUpdate(MeetingRoomRentVO meetingRoomRentVO) {
		return this.sqlSessionTemplate.update("room.rentalUpdate", meetingRoomRentVO);
	}

	public List<MeetingRoomRentVO> roomListAdmin() {
		return this.sqlSessionTemplate.selectList("room.roomListAdmin");
	}

	public List<Map<String, Object>> getRentCounts() {
		return this.sqlSessionTemplate.selectList("room.getRentCounts");
	}

	public int adminRentalCancel(String rentNo) {
		log.info("타는지 확인" + rentNo);
		return this.sqlSessionTemplate.update("room.adminRentalCancel", rentNo);
	}

	public List<MeetingRoomRentVO> selectRentList(String mtgrNm) {
		
		log.info("가는지 확인" + mtgrNm);
		
		return this.sqlSessionTemplate.selectList("room.selectRentList", mtgrNm);
	}

	public int createRoom(MeetingRoomVO meetingRoomVO) {
		return this.sqlSessionTemplate.insert("room.createRoom", meetingRoomVO);
	}

	public String selectMaxMtgrNo() {
		return this.sqlSessionTemplate.selectOne("room.selectMaxMtgrNo");
	}

	public int roomEquipmentAdd(EquipmentListVO equipmentListVO) {
		return this.sqlSessionTemplate.insert("room.roomEquipmentAdd", equipmentListVO);
	}

	public int roomAtchfileSn(MeetingRoomVO meetingRoomVO) {
		return this.sqlSessionTemplate.update("room.roomAtchfileSn", meetingRoomVO);
	}

	public List<MeetingRoomVO> reloadRentRoom() {
		return this.sqlSessionTemplate.selectList("room.reloadRentRoom");
	}

	public MeetingRoomVO selectRoomDetail(String mtgrNm) {
		return this.sqlSessionTemplate.selectOne("room.selectRoomDetail",mtgrNm);
	}

	public int updateRoom(MeetingRoomVO meetingRoomVO) {
		return this.sqlSessionTemplate.update("room.updateRoom", meetingRoomVO);
	}

	public int rentRoomCalAdd(ScheduleCalendarVO scheduleCalendarVO) {
		return this.sqlSessionTemplate.insert("room.rentRoomCalAdd", scheduleCalendarVO);
	}

	public int CalRoomRentCancel(String rentNo) {
		return this.sqlSessionTemplate.delete("room.CalRoomRentCancel", rentNo);
	}

	public List<MeetingRoomVO> myRentRoomLabels(String empId) {
		return this.sqlSessionTemplate.selectList("room.myRentRoomLabels", empId);
	}

	public List<MeetingRoomVO> myRentTop3(String empId) {
		return this.sqlSessionTemplate.selectList("room.myRentTop3", empId);
	}



}
