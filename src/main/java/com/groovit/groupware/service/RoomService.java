package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MeetingRoomRentVO;
import com.groovit.groupware.vo.MeetingRoomVO;

public interface RoomService {

	// 로그인 회원정보 조회
	public EmployeeVO employee(String empId);

	// 회의실명 조회
	public List<MeetingRoomVO> roomSearch();

	// 회의실 예약현황 조회
	public List<MeetingRoomRentVO> roomRentCheck(Map<String, Object> params);

	public int rent(MeetingRoomRentVO meetingRoomRentVO);

	public List<MeetingRoomVO> roomList();

	public List<MeetingRoomRentVO> myRentList(String empId);

	public int rentalCancel(String rentNo);

	public int rentalUpdate(MeetingRoomRentVO meetingRoomRentVO);

	public List<MeetingRoomRentVO> roomListAdmin();

	public List<Map<String, Object>> getRentCounts();

	public int adminRentalCancel(String rentNo);

	public List<MeetingRoomRentVO> selectRentList(String mtgrNm);

	int createRoom(Map<String, Object> param);

	List<MeetingRoomVO> reloadRentRoom();

	public MeetingRoomVO selectRoomDetail(String mtgrNm);

	public int updateRoom(MeetingRoomVO meetingRoomVO);

	public List<MeetingRoomVO> myRentRoomLabels(String empId);

	public List<MeetingRoomVO> myRentTop3(String empId);






}
