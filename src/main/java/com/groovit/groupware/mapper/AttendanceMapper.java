package com.groovit.groupware.mapper;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.AttendanceVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.Leave1VO;
import com.groovit.groupware.vo.YearlyVacationVO;

public interface AttendanceMapper {

	public int createPost(String empId);

	public int updatePost(String empId);

	public int getTotal();

	public List<YearlyVacationVO> listVct(String empId);

	public List<Map<String,Object>> vacationPostList(Map<String, Object> map);

	public int leaveInsert(Leave1VO leave1vo);

	public List<AttendanceVO> departList(Map<String, Object> map);

	public int getTotalByDepart(Map<String, Object> map);
	
	public EmployeeVO getEmpData(String empId);
	
	public List<YearlyVacationVO> yearlyVacationList(String empId);

	public AttendanceVO selectBgng(String empId);

	public AttendanceVO selectAttnList(String empId);
	
	public List<EmployeeVO> getEmployeeByDepart(String deptCd);

	public List<Map<String, Object>> getTodayStaticByStts(String deptCd);

	public List<Map<String, Object>> getLeaveStaticByDepartAndMonth(String deptCd);

	public List<Map<String, Object>> getAttendanceAvgByDepartAndMonth(String deptCd);

	public List<Map<String, Object>> getOverTimeStaticByDepartAndMonth(String deptCd);

	public List<AttendanceVO> loadAttnTable(AttendanceVO attendanceVO);

	public List<Map<String, Object>> loadAttnChart(String empId);

	public List<Map<String, Object>> getAttendanceSumByWeek(String empId);

	public Map<String, Object> countVacDays(String empId);

}
