package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.ChatService;
import com.groovit.groupware.vo.ChatRoomVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.FreeBoardVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@Controller
@RequestMapping("/chat")
public class ChatController extends BaseController {

	@Autowired
	ChatService chatService;
	
	@GetMapping("/list")		//jsp만 돌려주는 컨트롤러 메소드
	public String jmChat(Model model ,Principal principal) {
		log.info("chatController 에 왔다" );
		String loginEmpId = principal.getName();
		log.info("Chat = 로그인 한 아이디 =>" + loginEmpId );
		model.addAttribute("loginEmpId", loginEmpId);
		
		List<EmployeeVO> employeeVOList =  this.chatService.employeeVOList();
//		log.info("chatEmpList결과 => employeeVOList : " + employeeVOList);
		model.addAttribute("employeeVOList", employeeVOList);
		
		return "chat/list";
	}
	
//	@ResponseBody
//	@PostMapping("/chatEmpList")
//	public List<EmployeeVO> chatEmpList ( ) {
//		log.info("chatEmpList 에 왔다.");
//		
//		List<EmployeeVO> employeeVOList =  this.chatService.employeeVOList();
//		log.info("chatEmpList결과 => employeeVOList : " + employeeVOList);
//		
//		return employeeVOList;
//	}
	
	
	
	@ResponseBody
	@PostMapping("/findChatRoom")
	public String findChatRoom(Model model , @RequestBody Map<String, String> idList ) {
		log.info("chatRoomCreate 에 왔다" );
		String loginEmpId = idList.get("loginEmpId");
		log.info("loginEmpId : " + loginEmpId);
		
		String roomId =  this.chatService.chatRoomFind(idList);
		log.info("roomId : " + roomId);
		
		return roomId;
	}
	
	
	@ResponseBody
	@PostMapping("/createRoomNo")
	public String chatRoomCreate(@RequestBody Map<String, String> roomName) {
		
		int result =  this.chatService.chatRoomCreate(roomName);
		log.info("result : "+ result);
		
		return "OK";
	}
	
	@ResponseBody
	@PostMapping("/chatHistoryList")
	public List<Map<String,Object>> chatHistory(@RequestBody Map<String, Object> chatHistory) {
		
		List<Map<String, Object>> chatHistoryList =  this.chatService.chatHistory(chatHistory);
//		log.info("chatHistoryList : "+ chatHistoryList);
		
		return chatHistoryList;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

