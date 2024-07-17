package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SurveyResponseVO {
	private String srCd;
	private String srvyNo;
	private int sqSn;
	private int saSn;
	private String empId;
	private Date srDt;
}
