package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.ChatRoomVO;
import com.groovit.groupware.vo.EmployeeVO;

public interface ChatService {

	List<EmployeeVO> employeeVOList();

	String chatRoomFind(Map<String, String> idList);


	int chatRoomCreate(Map<String, String> roomName);

	int createChat(Map<String, Object> messageData);

	List<Map<String, Object>> chatHistory(Map<String, Object> chatHistory);

}
