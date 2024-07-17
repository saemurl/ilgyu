package com.groovit.groupware.vo;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class InterviewsVO {
	private String intrvwId;				//면접 아이디
	private String applicantId;				//지원자 아이디
	private String status;					//면접 상태
	private String applicationType;			//지원 구분
	private String jobType;					//지원 직종
	private String applicationSource;		//지원 동기
	private Date firstIntrvwDate;			//1차 면접일
	private Date secondIntrvwDate;			//2차 면접일
	private Date registrationDate;			//등록일
	
	private List<ApplicantsVO> applicantsVOList = new ArrayList<>(); // 초기화 추가;
}
