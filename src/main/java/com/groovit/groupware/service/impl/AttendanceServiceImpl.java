package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.mapper.AttendanceMapper;
import com.groovit.groupware.service.AttendanceService;
import com.groovit.groupware.vo.AttendanceVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.Leave1VO;
import com.groovit.groupware.vo.YearlyVacationVO;

@Service
public class AttendanceServiceImpl implements AttendanceService {

	@Autowired
	AttendanceMapper attendanceMapper;

	@Override
	public int createPost(String empId) {
		return this.attendanceMapper.createPost(empId);
	}

	@Override
	public int updatePost(String empId) {
		return this.attendanceMapper.updatePost(empId);
	}

	@Override
	public AttendanceVO selectBgng(String empId) {
		return this.attendanceMapper.selectBgng(empId);
	}


	@Override
	public int getTotal() {
		return this.attendanceMapper.getTotal();
	}

	@Override
	public AttendanceVO selectAttnList(String empId) {
		return this.attendanceMapper.selectAttnList(empId);
	}


//--------------------------------------------------------------------------
	@Override
	public List<YearlyVacationVO> listVct(String empId) {
		return this.attendanceMapper.listVct(empId);
	}

	@Override
	public List<Map<String,Object>> vacationPostList(Map<String, Object> map) {
		return this.attendanceMapper.vacationPostList(map);
	}

	@Override
	public int leaveInsert(Leave1VO leave1vo) {

		return this.attendanceMapper.leaveInsert(leave1vo);
	}


	//-------------------------------------------------------------------
	//부서근태
	@Override
	public List<AttendanceVO> departList(Map<String, Object> map) {
		return this.attendanceMapper.departList(map);
	}

	@Override
	public int getTotalByDepart(Map<String, Object> map) {
		return this.attendanceMapper.getTotalByDepart(map);
	}

	//—————————————————————————————————————————————————————————————————————————————————————————
	// 휴가신청 회원 정보조회
	@Override
	public EmployeeVO getEmpData(String empId) {
		return this.attendanceMapper.getEmpData(empId);
	}

	@Override
	public List<YearlyVacationVO> yearlyVacationList(String empId) {
		return this.attendanceMapper.yearlyVacationList(empId);
	}





	@Override
	public List<EmployeeVO> getEmployeeByDepart(String deptCd) {
		return this.attendanceMapper.getEmployeeByDepart(deptCd);
	}

	@Override
	public List<Map<String, Object>> getTodayStaticByStts(String deptCd) {
		return this.attendanceMapper.getTodayStaticByStts(deptCd);
	}

	@Override
	public List<Map<String, Object>> getLeaveStaticByDepartAndMonth(String deptCd) {
		return this.attendanceMapper.getLeaveStaticByDepartAndMonth(deptCd);
	}

	@Override
	public List<Map<String, Object>> getAttendanceAvgByDepartAndMonth(String deptCd) {
		return this.attendanceMapper.getAttendanceAvgByDepartAndMonth(deptCd);
	}

	@Override
	public List<Map<String, Object>> getOverTimeStaticByDepartAndMonth(String deptCd) {
		return this.attendanceMapper.getOverTimeStaticByDepartAndMonth(deptCd);
	}

	@Override
	public List<AttendanceVO> loadAttnTable(AttendanceVO attendanceVO) {
		return this.attendanceMapper.loadAttnTable(attendanceVO);
	}

	@Override
	public List<Map<String, Object>> loadAttnChart(String empId) {
		return this.attendanceMapper.loadAttnChart(empId);
	}

	@Override
	public List<Map<String, Object>> getAttendanceSumByWeek(String empId) {
		return this.attendanceMapper.getAttendanceSumByWeek(empId);
	}

	@Override
	public Map<String, Object> countVacDays(String empId) {
		return this.attendanceMapper.countVacDays(empId);
	}

}
