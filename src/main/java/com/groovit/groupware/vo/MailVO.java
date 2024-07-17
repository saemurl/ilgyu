package com.groovit.groupware.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MailVO {
	private String mlSn;
	private String mlTtl;
	private String mlCn;
	
	@DateTimeFormat(pattern = "yyyy/MM/dd")
	private Date mlSndngYmd;
	
	private String strMlSndngYmd;
	
	private String mlIptYn;
	private String atchfileSn;
	
	private List<String> empList;
	private String empId;
	private String mlStts;
	
	private String empAtchfileSn;
	private String atchfileDetailPhysclPath;
	
	
	private List<MailReceiver> mailReceiverList;		// 수신자
	private List<MailSenderVO> mailSenderVOList;		// 발신자
	private List<WastebasketVO> wastebasketVOList;		// 휴지통
	private List<MailBookmarkVO> mailBookmarkVOList;	// 즐겨찾기
	
	// 첨부파일
	private MultipartFile[] file;
	
	// 첨부파일 리스트
	List<AtchfileDetailVO> fileList;
	
}
