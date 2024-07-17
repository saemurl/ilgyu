package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class DepartmentVO {
	private String deptCd;
	private String deptUpCd;
	private String deptUpCdd; // up_cd
	
	private String deptNm;		// 팀
	
	private String deptUseYn;
	private Date deptFrstRegDt;
	private String deptFrstRgtr;
	private Date deptLastRegDt;
	private String deptLastRgtr;
	
}
