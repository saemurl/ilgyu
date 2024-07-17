package com.groovit.groupware.mapper;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.EmployeeVO;

public interface ChatMapper {

	List<EmployeeVO> employeeVOList();

	String chatRoomFind(Map<String, String> idList);

	int chatRoomCreate(Map<String, String> roomName);

	int createDescription(Map<String, Object> messageData);

	int createSender(Map<String, Object> messageData);

	int createReceiver(Map<String, Object> messageData);

	List<Map<String, Object>> chatHistory(Map<String, Object> chatHistory);


}
