package com.groovit.groupware.vo;

import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import lombok.Data;

@Data
public class AttendanceVO {
	private String attnNo;
	private String empId;
	private String selectMonth;
	private String attnBgng;
	private String attnEnd;
	private String attnStts;
	private Date attnFrstRegDt;
	private Date attnLastRegDt;

	private String attnBgngTime;
	private String attnEndTime;
	private String empNm;
	private String stts;
	private String worked;
	private String hours;

	
	@Valid
	private List<EmployeeVO> empVOList;

	@Valid
	private List<DepartmentVO> departVOList;


}
