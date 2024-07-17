package com.groovit.groupware.vo;

import lombok.Data;

@Data
public class SurveyAnswerVO {
	private int saSn;//고객이 선택한 고유한 값
	private int sqSn;
	private String saCn;//고객에게 보여줌
	private int numOfResp;
}
