package com.groovit.groupware.vo;

import java.util.List;

import lombok.Data;

@Data
public class SurveyVO {
	private String srvyNo;
	private String empId;
	private String empNm;
	private String srvyTtl;
	private String srvyCn;
	private String srvyWrtYmd;
	private String srvyBgngYmd;
	private String srvyEndYmd;
	private String delYn;
	
	private String writerDept;
	private String writerJob;
	private int participantCount;
	
	List<SurveyQuestionVO> questionList;
	
	List<SurveyResponseVO> respList;
}
