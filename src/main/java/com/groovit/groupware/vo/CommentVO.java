package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class CommentVO {
	private String cmntNo;
	private String cmntContent;
	private String empId;
	private Date cmntWrtDt;
	private Date cmntMdfcnDt;
	private String cmntStts;
	private String cmntUp;
	private String fbNo;
	private String empNm;
}
