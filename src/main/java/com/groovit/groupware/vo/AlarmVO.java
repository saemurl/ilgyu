package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AlarmVO {
	private String alarmNo;
	private String alarmType;
	private String alarmRcvr;
	private String alarmSndpty;
	private String alarmStts;
	private String alarmUrl;
	private String alarmOcrnTm;
}
