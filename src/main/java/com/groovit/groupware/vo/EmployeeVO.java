package com.groovit.groupware.vo;

import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import org.hibernate.validator.constraints.NotBlank;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;


import lombok.Data;

@Data
public class EmployeeVO {
	private String empId;
	private String empPass;
	private String empMng;
	private String atchfileSn;
	private String empStts;
	private String comCodeDetailNm; 	// 상태 이름
	private String empNm;
	private String empMail;
	private String empEml;
	private String empTelno;
	@NotBlank(message="주소를 입력해주세요.")
	private String empAddr;
	@NotBlank(message="상세 주소를 입력해주세요.")
	private String empDaddr;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date empBrdt;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date empJncmpYmd;
	private String deptCd;
	private String deptNm;
	private String jbgdCd;
	private String jbgdNm;

	private List<EmployeeAuthrtVO> employeeAuthrtVOList;
	private List<AtchfileDetailVO> atchfileDetailVOList;


	@Valid
	private JobGradeVO jobGradeVO;

	@Valid
	private DepartmentVO departmentVO;

	private MultipartFile picture;

	//프로필 첨부파일
	private MultipartFile uploadFile;

	@Valid
	private List<DepartmentVO> departVOList;

	private List<AttendanceVO> attendVOList;

}
