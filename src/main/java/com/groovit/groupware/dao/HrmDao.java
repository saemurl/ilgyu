package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.ComCodeDetailVO;
import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.JobGradeVO;

@Repository
public class HrmDao {
	
	@Autowired
	SqlSessionTemplate SqlSessionTemplate;

	public List<DepartmentVO> deptlist(String deptUpCd) {
		return this.SqlSessionTemplate.selectList("hrm.deptlist", deptUpCd);
	}

	public int createPost(EmployeeVO employeeVO) {
		return this.SqlSessionTemplate.insert("hrm.createPost", employeeVO);
	}

	public String empIdMax() {
		return this.SqlSessionTemplate.selectOne("hrm.empIdMax");
	}

	public List<EmployeeVO> hrmList(Map<String, Object> map) {
		return this.SqlSessionTemplate.selectList("hrm.hrmList", map);
	}

	public int getTotal(Map<String, Object> map) {
		return this.SqlSessionTemplate.selectOne("hrm.getTotal", map);
	}

	public List<JobGradeVO> jobSelect() {
		return this.SqlSessionTemplate.selectList("hrm.jobSelect");
	}

	public List<DepartmentVO> DeptVOList() {
		return this.SqlSessionTemplate.selectList("hrm.DeptList");
	}

	public EmployeeVO empDetail(String empId) {
		return this.SqlSessionTemplate.selectOne("hrm.empDetail", empId);
	}

	public int insertEmpAuthrt(String empId) {
		return this.SqlSessionTemplate.insert("hrm.insertEmpAuthrt", empId);
	}

	public int ptpResig(String empId) {
		return this.SqlSessionTemplate.update("hrm.ptpResig", empId);
	}

	public int deptUpdate(Map<String, String> map) {
		return this.SqlSessionTemplate.update("hrm.deptUpdate", map);
	}

	public int jobUpdate(Map<String, String> map) {
		return this.SqlSessionTemplate.update("hrm.jobUpdate", map);
	}

	public List<ComCodeDetailVO> leaveSelect() {
		return this.SqlSessionTemplate.selectList("hrm.leaveSelect");
	}

	public int empStts(Map<String, String> map) {
		return this.SqlSessionTemplate.update("hrm.empStts", map);
	}

}
