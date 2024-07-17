package com.groovit.groupware.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MarriageVO {
	private String evtbNo;
	private String mrgTtl;
	private String mrgDt;
	private String mrgAddr;
	private String mrgDaddr;
	private String mrgIvt;
	private String empId;
	private String mrgCon;
	private MultipartFile pictures;

	private String atchfileDetailPhysclPath;



}
