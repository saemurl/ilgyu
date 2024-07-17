package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatRoomVO {
	private String chatNo;
	private String chatRoomName;
	private Date chatCrtDt;
	private String chatDelYn;
	
}
