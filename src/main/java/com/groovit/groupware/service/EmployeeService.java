package com.groovit.groupware.service;

import com.groovit.groupware.vo.EmployeeVO;

public interface EmployeeService {
	
	public EmployeeVO read01(String empId);

	public int updateEmployee(EmployeeVO employeeVO);
	
}
