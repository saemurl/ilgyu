package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

public interface ScheduleCalendarService {

	public List<ScheduleCalendarVO> list(Map<String, Object> map);

	public List<ScheduleCalendarVO> filteredList(Map<String, Object> map);

	public List<DepartmentVO> getDepartments(String empId);

	public List<MeetingRoomVO> getlocations();

	public Map<String, Object> create(ScheduleCalendarVO scheduleCalendarVO);
	
	public int update(ScheduleCalendarVO scheduleCalendarVO);

	public int delete(ScheduleCalendarVO scheduleCalendarVO);

	public EmployeeVO employee(String empId);

	public List<ScheduleCalendarVO> todoListAjax(String empId);

	public List<EmployeeVO> deptEmpList(String deptNmValue);

}
