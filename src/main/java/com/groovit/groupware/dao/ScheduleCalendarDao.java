package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

@Repository
public class ScheduleCalendarDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	// 캘린더 전체 최초 조회
	public List<ScheduleCalendarVO> list(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectList("scheduleCalendar.list", map);
	}

	// 캘린더 필터 조회
	public List<ScheduleCalendarVO> filteredList(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectList("scheduleCalendar.filteredList", map);
	}

	public List<DepartmentVO> getDepartments(String empId) {
		return this.sqlSessionTemplate.selectList("scheduleCalendar.getDepartments", empId);
	}

	public List<MeetingRoomVO> getlocations() {
		return this.sqlSessionTemplate.selectList("scheduleCalendar.getlocations");
	}

	public int create(ScheduleCalendarVO scheduleCalendarVO) {
		return this.sqlSessionTemplate.insert("scheduleCalendar.create", scheduleCalendarVO);
	}

	public int update(ScheduleCalendarVO scheduleCalendarVO) {
		return this.sqlSessionTemplate.insert("scheduleCalendar.update", scheduleCalendarVO);
	}

	public int delete(ScheduleCalendarVO scheduleCalendarVO) {
		return this.sqlSessionTemplate.delete("scheduleCalendar.delete", scheduleCalendarVO);
	}

	// 로그인 회원정보 조회
	public EmployeeVO employee(String empId) {
		return this.sqlSessionTemplate.selectOne("scheduleCalendar.employee", empId);
	}

	// 메인 로비화면 오늘의 일정 데이터 조회
	public List<ScheduleCalendarVO> todoListAjax(String empId) {
		return this.sqlSessionTemplate.selectList("scheduleCalendar.todoListAjax", empId);
	}

	public List<EmployeeVO> deptEmpList(String deptNmValue) {
		return this.sqlSessionTemplate.selectList("scheduleCalendar.deptEmpList",deptNmValue);
	}

	
	
	
	
}
