package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.OrgChartVO;

@Repository
public class OrgChartDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public List<OrgChartVO> list() {
		return this.sqlSessionTemplate.selectList("orgChart.list");
	}

	public EmployeeVO detail(Map<String, String> map) {
		return this.sqlSessionTemplate.selectOne("orgChart.detail", map);
	}
}
