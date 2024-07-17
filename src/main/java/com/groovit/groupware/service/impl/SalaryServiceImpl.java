package com.groovit.groupware.service.impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.SalaryDao;
import com.groovit.groupware.service.SalaryService;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.SalaryVO;



@Service
public class SalaryServiceImpl implements SalaryService {
	
	@Autowired
	SalaryDao salaryDao;

	@Override
	public EmployeeVO getEmpData(String empId) {
		return this.salaryDao.getEmpData(empId);
	}

	@Override
	public SalaryVO getSalaryData(SalaryVO salaryVO) {
		return this.salaryDao.getSalaryData(salaryVO);
	}

	
	
}
