package com.groovit.groupware.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.ScheduleCalendarDao;
import com.groovit.groupware.service.ScheduleCalendarService;
import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

@Service
public class ScheduleCalendarServiceImpl implements ScheduleCalendarService {
	
	@Autowired
	ScheduleCalendarDao scheduleCalendarDao;

	@Override
	public List<ScheduleCalendarVO> list(Map<String, Object> map) {
		return this.scheduleCalendarDao.list(map);
	}

	@Override
	public List<ScheduleCalendarVO> filteredList(Map<String, Object> map) {
		return this.scheduleCalendarDao.filteredList(map);
	}

	@Override
	public List<DepartmentVO> getDepartments(String empId) {
		return this.scheduleCalendarDao.getDepartments(empId);
	}

	@Override
	public List<MeetingRoomVO> getlocations() {
		return this.scheduleCalendarDao.getlocations();
	}

	@Override
    public Map<String, Object> create(ScheduleCalendarVO scheduleCalendarVO) {
        scheduleCalendarDao.create(scheduleCalendarVO);
        Map<String, Object> response = new HashMap<>();
        response.put("id", scheduleCalendarVO.getId());
        response.put("status", "success");
        return response;
    }

	@Override
	public int update(ScheduleCalendarVO scheduleCalendarVO) {
		return this.scheduleCalendarDao.update(scheduleCalendarVO);
	}

	@Override
	public int delete(ScheduleCalendarVO scheduleCalendarVO) {
		return this.scheduleCalendarDao.delete(scheduleCalendarVO);
	}

	@Override
	public EmployeeVO employee(String empId) {
		return this.scheduleCalendarDao.employee(empId);
	}

	@Override
	public List<ScheduleCalendarVO> todoListAjax(String empId) {
		return this.scheduleCalendarDao.todoListAjax(empId);
	}

	@Override
	public List<EmployeeVO> deptEmpList(String deptNmValue) {
		return this.scheduleCalendarDao.deptEmpList(deptNmValue);
	}
	
	
	
}
