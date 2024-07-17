package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeBoardVO {
	private String ntcNo;		// 공지사항게시판글번호
	private String ntcTtl;      // 공지사항게시판제목
	private String ntcCn;       // 공지사항게시판내용
	private String atchfileSn;  // 첨부파일
	private Date ntcFrstRegYmd; // 최초등록일자
	private Date ntcLastRegYmd; // 최종등록일자
	private String ntcFrstRgtr; // 최초등록자
	private String ntcLastRgtr; // 최종등록자
	private String empNm;		// 직원 이름
}
