package com.groovit.groupware.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class Leave1VO {
	private int leNo;
	private String leMngCd;
	private String leCn;
	private String leBgngYmd;
	private String leEndYmd;
	private Date leFrstRegDt;
	private Date leLastRegDt;
	private String leAgent;
	private String empId;
	private String aprvrDocNo;

	private List<LeaveManagementVO> leaveManagementVOList;
}
