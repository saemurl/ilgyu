package com.groovit.groupware.vo;

import java.util.List;

import lombok.Data;

@Data
public class MeetingRoomVO {
	private String mtgrNo;
	private String mtgrNm;
	private int mtgrCpct;
	private String mtgrExpln;
	private String atchfileSn;
	private String mtgrChck;
	// 중첩자바빈즈
	private List<EquipmentVO> equipments;
	private String imgPath;
	private String count;
}
