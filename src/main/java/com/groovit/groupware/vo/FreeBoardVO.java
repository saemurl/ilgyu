package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FreeBoardVO {
	private String fbNo;
	private String fbTtl;
	private String fbCn;
	private String atchfileSn;
	private Date fbFrstRegDt;
	private String fbFrstWrtr;
	private Date fbLastMdfcnDt;
	private String fbLastRgtr;
	private int fbLikeCnt;
	private int fbDisllikeCnt;
	private String fbStts;
	private int fbCnt;
	private String empNm;
}
