package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class MailReceiver {
	private String mlRcvr;
	private String mlSn;
	private String mlStts;
	private Date mlRDt;
	
	private String empId;
	private String empNm; // 발신자명
	private String empMail; // 발신자 이메일
	private String empAtchfileSn; // 발신자 사진
	private String atchfileSn;
}
