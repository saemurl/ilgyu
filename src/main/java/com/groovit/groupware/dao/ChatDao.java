package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.ChatRoomVO;
import com.groovit.groupware.vo.EmployeeVO;

@Repository
public class ChatDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public List<EmployeeVO> employeeVOList() {
		return this.sqlSessionTemplate.selectList("chat.employeeVOList");
	}

	public String chatRoomFind(Map<String, String> idList) {
		return this.sqlSessionTemplate.selectOne("chat.chatRoomFind", idList);
	}


	public int chatRoomCreate(Map<String, String> roomName) {
		return this.sqlSessionTemplate.insert("chat.chatRoomCreate", roomName);
	}
	
	
	/*------------------------ 채팅 정보 입력 ----------------*/

	public int createDescription(Map<String, Object> messageData) {
		return this.sqlSessionTemplate.insert("chat.createDescription",messageData);
	}

	public int createSender(Map<String, Object> messageData) {
		return this.sqlSessionTemplate.insert("chat.createSender",messageData);
	}

	public int createReceiver(Map<String, Object> messageData) {
		return this.sqlSessionTemplate.insert("chat.createReceiver",messageData);
	}

	public List<Map<String, Object>> chatHistory(Map<String, Object> chatHistory) {
		return this.sqlSessionTemplate.selectList("chat.chatHistory", chatHistory);
	}

}
