package com.groovit.groupware.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.SalaryVO;


@Repository
public class SalaryDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public EmployeeVO getEmpData(String empId) {
		return this.sqlSessionTemplate.selectOne("salary.empSelect",empId);
	}

	public SalaryVO getSalaryData(SalaryVO salaryVO) {
		return this.sqlSessionTemplate.selectOne("salary.getSalaryData", salaryVO);
	}
	
	
	
	
}
