package com.groovit.groupware.vo;

import lombok.Data;

@Data
public class ApplicantsVO {
	private String applicantId;			//지원자 아이디
	private String applicantNm;			//지원자 이름
	private String contact;				//지원자 연락처
	private String university;			//출신 대학
	private String major;				//세부 전공
	private String applicantEmail;		//지원자 이메일
	
	private String intrvwId; // 면접 ID
}
