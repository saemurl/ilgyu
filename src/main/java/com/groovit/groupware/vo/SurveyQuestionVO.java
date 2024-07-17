package com.groovit.groupware.vo;

import java.util.List;

import lombok.Data;

@Data
public class SurveyQuestionVO {
	private int sqSn;
	private String srvyNo;
	private String sqQstnCn;
	private String sqEsntlYn;
	
	private List<SurveyAnswerVO> answerList;
}
