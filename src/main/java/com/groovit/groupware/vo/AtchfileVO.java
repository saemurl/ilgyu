package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AtchfileVO {
	private String atchfileSn;//자동생성
	private String atchfileId;//등록자
	private Date atchfileFrstRegDt;//SYSDATE
	private String atchfileYn;//"Y"
}
