package com.groovit.groupware.service;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.SalaryVO;

public interface SalaryService {

	EmployeeVO getEmpData(String empId);	// 회원 정보 조회

	SalaryVO getSalaryData(SalaryVO salaryVO);


	
	
}
