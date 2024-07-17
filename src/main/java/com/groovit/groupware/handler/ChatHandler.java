package com.groovit.groupware.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.groovit.groupware.service.ChatService;
import com.groovit.groupware.vo.ChatRoomVO;
import com.groovit.groupware.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ChatHandler extends TextWebSocketHandler {
	//로그인 한 인원 전체
		private List<WebSocketSession> sessions = new ArrayList<WebSocketSession>();
		// 1:1로 할 경우
		private Map<String, WebSocketSession> userSessionsMap = new HashMap<String, WebSocketSession>();

    @Autowired
	ChatService chatService;
    
    
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        log.info("## 누군가 접속");
        sessions.add(session);
		log.info(currentUserName(session));//현재 접속한 사람
		String senderId = currentUserName(session);
		userSessionsMap.put(senderId,session);
		log.info("채팅 전체 접속 인원" + userSessionsMap);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
        	Map<String, Object> messageData = objectMapper.readValue(message.getPayload(), Map.class);
            log.debug("받은 데이터 : {}", messageData);
            

            int result = this.chatService.createChat(messageData);
            
            
            
            
            for (WebSocketSession webSocketSession : sessions) {
                if (webSocketSession.isOpen()) {
                    webSocketSession.sendMessage(message);
                }
            }
        } catch (Exception e) {
            log.error("메시지 처리 중 오류 발생", e);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        log.info("## 누군가 떠남");
        sessions.remove(session);
    }
    
    private String currentUserName(WebSocketSession session) {
	    Map<String, Object> httpSession = session.getAttributes();
	    log.info("httpSession: " + httpSession);
	    
	    // loginVO 객체를 먼저 가져옴
	    EmployeeVO loginVO = (EmployeeVO) httpSession.get("loginVO");
	    log.info("loginVO: " + loginVO);

	    // loginVO가 null이 아닌지 확인
	    if (loginVO == null) {
	        String mid = session.getId();
	        return mid;
	    }

	    // EmployeeVO 객체에서 empId를 가져옴
	    String empId = loginVO.getEmpId();
	    log.info("loginUser empId: " + empId);

	    if (empId == null) {
	        String mid = session.getId();
	        return mid;
	    }
	    
	    log.info("mid: " + empId);
	    return empId;
	}
}
