package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.AttendanceVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.Leave1VO;
import com.groovit.groupware.vo.YearlyVacationVO;

public interface AttendanceService {

	public int createPost(String empId);

	public int updatePost(String empId);

	public int getTotal();

	public List<YearlyVacationVO> listVct(String empId);

	public List<Map<String, Object>> vacationPostList(Map<String, Object> map);

	public int leaveInsert(Leave1VO leave1vo);

	// 해당 부서 부서원들의 근태리스트 조회
	public List<AttendanceVO> departList(Map<String, Object> map);

	// 부서 근태리스트 총개수 조회
	public int getTotalByDepart(Map<String, Object> map);
	
	// 휴가신청 페이지 진입 전 회원정보 조회
	public EmployeeVO getEmpData(String empId);
		
	public List<YearlyVacationVO> yearlyVacationList(String empId);

	public AttendanceVO selectBgng(String empId);

	public AttendanceVO selectAttnList(String empId);
	
	// 해당 부서 부서원 리스트
	public List<EmployeeVO> getEmployeeByDepart(String deptCd);

	// 해당 부서 근무상태 별 통계 조회
	public List<Map<String, Object>> getTodayStaticByStts(String deptCd);

	// 해당 부서 월별 연차사용 현황 통계
	public List<Map<String, Object>> getLeaveStaticByDepartAndMonth(String deptCd);

	// 해당 부서 월별 하루평균 근무시간 통계
	public List<Map<String, Object>> getAttendanceAvgByDepartAndMonth(String deptCd);

	// 해당 부서 월별 연장근무 현황 통계
	public List<Map<String, Object>> getOverTimeStaticByDepartAndMonth(String deptCd);
	
	// 내 근태 현황 테이블 조회
	public List<AttendanceVO> loadAttnTable(AttendanceVO attendanceVO);

	// 내 근태 현황 차트 조회
	public List<Map<String, Object>> loadAttnChart(String empId);

	// 주차별 근무현황 통계
	public List<Map<String, Object>> getAttendanceSumByWeek(String empId);

	public Map<String, Object> countVacDays(String empId);


}
