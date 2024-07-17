package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.OrgChartVO;

public interface OrgChartService {

	// 조직도
	public List<OrgChartVO> list();

	// 직원 상세
	public EmployeeVO detail(Map<String, String> map);
	

}
