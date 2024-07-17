package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.ComCodeDetailVO;
import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.JobGradeVO;

public interface HrmService {
	
	// 팀 조회
	public List<DepartmentVO> deptlist(String deptUpCd);

	public int createPost(EmployeeVO employeeVO);

	public String empIdMax();
	
	// 직원조회
	public List<EmployeeVO> hrmList(Map<String, Object> map);
	
	public int getTotal(Map<String, Object> map);

	public List<JobGradeVO> jobSelect();
	
	// 부서 조회
	public List<DepartmentVO> DeptVOList();
	
	// 직원상세(모달)
	public EmployeeVO empDetail(String empId);
	
	// 퇴사
	public int ptpResig(String empId);
	
	// 부서이동
	public int deptUpdate(Map<String, String> map);
	
	// 승진
	public int jobUpdate(Map<String, String> map);
	
	// 휴직종류
	public List<ComCodeDetailVO> leaveSelect();
	
	// 휴직
	public int LeaveUpdate( Map<String, String> map);
	

}
