package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.mapper.ChatMapper;
import com.groovit.groupware.service.ChatService;
import com.groovit.groupware.vo.ChatRoomVO;
import com.groovit.groupware.vo.EmployeeVO;

@Service
public class ChatServiceImpl implements ChatService {

	@Autowired
	ChatMapper chatMapper;
	
	@Override
	public List<EmployeeVO> employeeVOList() {
		return this.chatMapper.employeeVOList();
	}

	@Override
	public String chatRoomFind(Map<String, String> idList) {
		return this.chatMapper.chatRoomFind(idList);
	}


	@Override
	public int chatRoomCreate(Map<String, String> roomName) {
		return this.chatMapper.chatRoomCreate(roomName);
	}


	@Override
	public int createChat(Map<String, Object> messageData) {
		int result = this.chatMapper.createDescription(messageData);
		 result += this.chatMapper.createSender(messageData);
		 result += this.chatMapper.createReceiver(messageData);
		return result;
	}

	@Override
	public List<Map<String, Object>> chatHistory(Map<String, Object> chatHistory) {
		return this.chatMapper.chatHistory(chatHistory);
	}

}
