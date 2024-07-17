package com.groovit.groupware.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ApprovalVO {
	private String aprvrDocNo;
	private String aprvrDocTtl;
	private String aprvrDocCn;
	private String atchfileSn;
	private String aprvrSttsCd;
	private String empId;
	private String writer;
	private String writerDept;
	private Date aprvrWrtYmd;
	private String strWrtYmd;
	private String atCd;
	private String atNm;
	private String aprvrEmgyn;
	
	private int requestTotal;
	private int progressTotal;
	private int referenceTotal;
	
	// 결재선 리스트
	List<ApprovalLineVO> approvalLineList;
	
	// 참조자 리스트
	List<ApprovalCorbonCopyVO> corbonCopyList;
	
	// 첨부파일 리스트
	List<AtchfileDetailVO> fileList;
	
	List<RelatedApprovalVO> relatedApprovalList;
	
	// 첨부파일
	private MultipartFile[] file;
}
