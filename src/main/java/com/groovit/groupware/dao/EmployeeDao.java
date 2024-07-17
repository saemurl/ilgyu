package com.groovit.groupware.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.EmployeeVO;

@Repository
public class EmployeeDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	public EmployeeVO read01(String empId) {
		return this.sqlSessionTemplate.selectOne("employeeVO.read", empId);
	}
}
