package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.OrgChartDao;
import com.groovit.groupware.service.OrgChartService;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.OrgChartVO;

@Service
public class OrgChartServiceImpl implements OrgChartService{

	@Autowired
	OrgChartDao orgChartDao;
	
	@Override
	public List<OrgChartVO> list() {
		return this.orgChartDao.list();
	}
	
	@Override
	public EmployeeVO detail(Map<String, String> map) {
		return this.orgChartDao.detail(map);
	}

}
