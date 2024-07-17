package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AtchfileDetailVO {
	private int atchfileDetailSn;
	private String atchfileSn;
	private String atchfileDetailLgclfl;
	private String atchfileDetailPhyscl;
	private String atchfileDetailPhysclPath;
	private long   atchfileDetailSize;
	private String atchfileDetailExtsn;
	private String empId;
	private Date   atchfileDetailRegDt;
	private String atchfileDetailYn;
	private String atchfileDelyn;
}
