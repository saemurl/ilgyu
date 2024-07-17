package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.HrmDao;
import com.groovit.groupware.service.HrmService;
import com.groovit.groupware.vo.ComCodeDetailVO;
import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.JobGradeVO;

@Service
public class HrmServiceImpl implements HrmService{
	
	@Autowired
	HrmDao hrmDao;

	@Override
	public List<DepartmentVO> deptlist(String deptUpCd) {
		return this.hrmDao.deptlist(deptUpCd);
	}

	@Override
	public int createPost(EmployeeVO employeeVO) {
		
		int result = this.hrmDao.createPost(employeeVO);
		
		String empId = employeeVO.getEmpId();
		
		result += this.hrmDao.insertEmpAuthrt(empId);
		
		return result;
	}

	@Override
	public String empIdMax() {
		return this.hrmDao.empIdMax();
	}

	@Override
	public List<EmployeeVO> hrmList(Map<String, Object> map) {
		return this.hrmDao.hrmList(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.hrmDao.getTotal(map);
	}

	@Override
	public List<JobGradeVO> jobSelect() {
		return this.hrmDao.jobSelect();
	}

	@Override
	public List<DepartmentVO> DeptVOList() {
		return this.hrmDao.DeptVOList();
	}

	@Override
	public EmployeeVO empDetail(String empId) {
		return this.hrmDao.empDetail(empId);
	}

	@Override
	public int ptpResig(String empId) {
		return this.hrmDao.ptpResig(empId);
	}

	@Override
	public int deptUpdate(Map<String, String> map) {
		return this.hrmDao.deptUpdate(map);
	}

	@Override
	public int jobUpdate(Map<String, String> map) {
		return this.hrmDao.jobUpdate(map);
	}

	@Override
	public List<ComCodeDetailVO> leaveSelect() {
		return this.hrmDao.leaveSelect();
	}

	@Override
	public int LeaveUpdate( Map<String, String> map) {
		return this.hrmDao.empStts(map);
	}
}
