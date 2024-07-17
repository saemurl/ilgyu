package com.groovit.groupware.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.groovit.groupware.mapper.ApprovalMapper;
import com.groovit.groupware.service.AlarmService;
import com.groovit.groupware.vo.AlarmVO;
import com.groovit.groupware.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AlramHandler extends TextWebSocketHandler {
	//로그인 한 인원 전체
	private List<WebSocketSession> sessions = new ArrayList<WebSocketSession>();
	// 1:1로 할 경우
	private Map<String, WebSocketSession> userSessionsMap = new HashMap<String, WebSocketSession>();
	
	@Autowired
	AlarmService alarmService;
	
	@Autowired
	ApprovalMapper approvalMapper;
	
	
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {//클라이언트와 서버가 연결
		// TODO Auto-generated method stub
		log.info("Socket 연결");
		sessions.add(session);
		log.info(currentUserName(session));//현재 접속한 사람
		String senderId = currentUserName(session);
		userSessionsMap.put(senderId,session);
		log.info("전체 접속 인원" + userSessionsMap);
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {// 메시지
		 ObjectMapper objectMapper = new ObjectMapper();
		 Map<String, Object> socketMsg = objectMapper.readValue(message.getPayload(), Map.class);
         log.debug("받은 데이터 : {}", socketMsg);
         
        AlarmVO alarmVO = new AlarmVO();
        
        
        //알람 필수 요소
        String title =  socketMsg.get("title") == null ? "" : socketMsg.get("title").toString();
		String alarmSender = socketMsg.get("senderId") == null ? "" :socketMsg.get("senderId").toString();
		String alarmReceiver =   socketMsg.get("receiverId") == null ? "" : socketMsg.get("receiverId").toString();
		
		//댓글 알람
		String fbNo =   socketMsg.get("fbNo") == null ? "" : socketMsg.get("fbNo").toString();
		String fbTtl =   socketMsg.get("fbTtl") == null ? "" : socketMsg.get("fbTtl").toString();
		
		//스케쥴 알림
		//스케쥴 제목
		String scheduleNm =   socketMsg.get("scheduleNm") == null ? "" : socketMsg.get("scheduleNm").toString();
		String deptNm =   socketMsg.get("deptNm") == null ? "" : socketMsg.get("deptNm").toString();
		
		//결재 알람
		String apprTitle =   socketMsg.get("apprTitle") == null ? "" : socketMsg.get("apprTitle").toString();
		String alStts =   socketMsg.get("alStts") == null ? "" : socketMsg.get("alStts").toString();
		
		//메일 알람
		String mlTtl =   socketMsg.get("mlTtl") == null ? "" : socketMsg.get("mlTtl").toString();
		
		
		alarmVO.setAlarmType(title);
		alarmVO.setAlarmRcvr(alarmReceiver);
		alarmVO.setAlarmSndpty(alarmSender);
		
		
		if (socketMsg != null) {
			log.info("if문 들어옴?");
			if(true) {
				
				
				Map<String, Object> senderInfo = this.alarmService.senderInfo(alarmSender);
				log.info("senderInfo" + senderInfo);
				String senderEmpNm = (String)senderInfo.get("EMP_NM");
				log.info(senderEmpNm);
				
				
				Map<String, Object> receiverInfo = this.alarmService.receiverInfo(alarmReceiver);
				log.info("receiverInfo" + receiverInfo);
				String receiverEmpNm = (String)receiverInfo.get("EMP_NM");
				log.info(receiverEmpNm);
				
				
				WebSocketSession senderSession = userSessionsMap.get(alarmSender);
				WebSocketSession receiverSession = userSessionsMap.get(alarmReceiver);
				log.info("senderSession : "+ userSessionsMap.get(alarmSender));
				log.info("receiverSession : " + receiverSession);
				
				//상대방이 세션연결되어있는경우  
				if (receiverSession != null) {
					
					alarmVO.setAlarmStts("1");
					
//					채팅 알람
					if ("chat".equals(title) ) {
						log.info("onmessage되나?");
						
						String str = "<a href='/chat/list?empId="+alarmSender+"'>"+senderEmpNm+" 님으로 부터 채팅이 도착했습니다</a>";
						alarmVO.setAlarmUrl(str);
						
						
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);
						receiverSession.sendMessage(tmpMsg);
					}
					
					//자유게시판 댓글
					else if("freeBoard".equals(title) ) {
						
						String str = "<a href='/board/freeDetail?fbNo="+ fbNo +" '>" +senderEmpNm+" 님이 " + fbTtl + "글에 댓글을 등록했습니다.</a>";
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//스케쥴 등록
					else if("schedule".equals(title) ) {
						
						String str = "<a href='/schedule/list' >" + deptNm + " " + scheduleNm + " 일정이 등록되었습니다.</a>";
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//결재 참조자
					else if("approvalCC".equals(title) ) {
						
						String str = "<a href='/approval/reference' >"+ senderEmpNm +" 님이 작성한 '" + apprTitle + "' 의 참조자로 등록되었습니다.</a>";
//						'김지연 부장'이(가) 작성한 'ddd'의 참조자로 등록되었습니다.
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//결재자
					else if("approvalAL".equals(title) ) {
						String str = "";
						log.info("alStts =>" + alStts);
						if (alStts.equals("A04")) {
							str = "<a href='/approval/request' >"+ senderEmpNm +" 님이 작성한 '" + apprTitle + "' 의 결재자로 등록되었습니다.</a>";
						}else {
							str = "<a href='/approval/upcoming' >"+ senderEmpNm +" 님이 작성한 '" + apprTitle + "' 의 결재자로 등록되었습니다.</a>";
						}
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//반려 알람
					else if("approvalRJ".equals(title) ) {
						String str = "<a href='/approval/completed' > '"+ apprTitle +"' 이(가) '" + senderEmpNm + "' 님에 의해 반려 되었습니다.</a>";
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//승인 알람
					else if("approve".equals(title) ) {
						String str = "<a href='/approval/completed' > '"+ apprTitle +"' 이(가) '" + senderEmpNm + "' 님에 의해 승인 되었습니다.</a>";
						
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//상신취소
					else if("approveCL".equals(title) ) {
						String str = "<p> '"+ apprTitle +"' 이(가) '" + senderEmpNm + "' 님에 의해 회수 되었습니다.</p>";
						
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					//메일
					else if("mail".equals(title) ) {
						String str = "<a href='/mail/inbox' > '"+ senderEmpNm +"' 님이 '" + mlTtl + "' 의 메일을 보냈습니다.</a>";
						
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
						TextMessage tmpMsg = new TextMessage(str);	
						receiverSession.sendMessage(tmpMsg);
						
					}
					
					
				
					
	//				
	//				//좋아요
	//				else if("like".equals(cmd) && boardWriterSession != null) {
	//					//replyWriter = 좋아요누른사람 , boardWriter = 게시글작성자
	//					TextMessage tmpMsg = new TextMessage(replyWriter + "님이 "
	//							+ "<a href='/board/readView?bno=" + bno + "&bgno="+bgno+"'  style=\"color: black\"><strong>"
	//							+ title+"</strong> 에 작성한 글을 좋아요했습니다!</a>");
	//
	//					boardWriterSession.sendMessage(tmpMsg);
	//					
	//				}
	//				
	//				//DEV
	//				else if("Dev".equals(cmd) && boardWriterSession != null) {
	//					//replyWriter = 좋아요누른사람 , boardWriter = 게시글작성자
	//					TextMessage tmpMsg = new TextMessage(replyWriter + "님이 "
	//							+ "<a href='/board/readView?bno=" + bno + "&bgno="+bgno+"'  style=\"color: black\"><strong>"
	//							+ title+"</strong> 에 작성한 글을 DEV했습니다!</a>");
	//
	//					boardWriterSession.sendMessage(tmpMsg);
	//					
	//				}
	//				
	//				//댓글채택
	//				else if("questionCheck".equals(cmd) && replyWriterSession != null) {
	//					//replyWriter = 댓글작성자 , boardWriter = 글작성자
	//					TextMessage tmpMsg = new TextMessage(boardWriter + "님이 "
	//							+ "<a href='/board/readView?bno=" + bno + "&bgno="+bgno+"'  style=\"color: black\"><strong>"
	//							+ title+"</strong> 에 작성한 댓글을 채택했습니다!</a>");
	//
	//					replyWriterSession.sendMessage(tmpMsg);
	//					
	//				}
	//				
	//				//댓글좋아요
	//				else if("commentLike".equals(cmd) && replyWriterSession != null) {
	//					logger.info("좋아요onmessage되나?");
	//					logger.info("result=board="+boardWriter+"//"+replyWriter+"//"+bno+"//"+bgno+"//"+title);
	//					//replyWriter=댓글작성자 , boardWriter=좋아요누른사람 
	//					TextMessage tmpMsg = new TextMessage(boardWriter + "님이 "
	//							+ "<a href='/board/readView?bno=" + bno + "&bgno="+bgno+"'  style=\"color: black\"><strong>"
	//							+ title+"</strong> 에 작성한 댓글을 추천했습니다!</a>");
	//
	//					replyWriterSession.sendMessage(tmpMsg);
	//				}
	//				
	//				
	//				//댓글DEV
	//				else if("commentDev".equals(cmd) && replyWriterSession != null) {
	//					logger.info("좋아요onmessage되나?");
	//					logger.info("result=board="+boardWriter+"//"+replyWriter+"//"+bno+"//"+bgno+"//"+title);
	//					//replyWriter=댓글작성자 , boardWriter=좋아요누른사람 
	//					TextMessage tmpMsg = new TextMessage(boardWriter + "님이 "
	//							+ "<a href='/board/readView?bno=" + bno + "&bgno="+bgno+"'  style=\"color: black\"><strong>"
	//							+ title+"</strong> 에 작성한 댓글을 DEV했습니다!</a>");
	//
	//					replyWriterSession.sendMessage(tmpMsg);
	//				}
				
					//상대방이 세션연결이 없을경우 DB 에 저장
				}else {
					alarmVO.setAlarmStts("0");
					
					
//					채팅 알람
					if ("chat".equals(title) ) {
						log.info("onmessage되나?");
						
						String str = "<a href='/chat/list?empId="+alarmSender+"'>"+senderEmpNm+" 님으로 부터 채팅이 도착했습니다</a>";
						alarmVO.setAlarmUrl(str);
						
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("상대방 세션 없을때 저장 확인 : " + result);
						
					}else if("freeBoard".equals(title) ) {
						
						String str = "<a href='/board/freeDetail?fbNo="+ fbNo +" '>" +senderEmpNm+" 님이 " + fbTtl + "글에 댓글을 등록했습니다.</a>";
						alarmVO.setAlarmUrl(str);
						
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("상대방 세션 없을때 저장 확인 : " + result);
						
					}else if("schedule".equals(title) ) {
						
						String str = "<a href='/schedule/list' >" + deptNm + " " + scheduleNm + " 일정이 등록되었습니다.</a>";
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					//결재 참조
					else if("approvalCC".equals(title) ) {
						
						String str = "<a href='/approval/reference' >"+ senderEmpNm +" 님이 작성한 '" + apprTitle + "' 의 참조자로 등록되었습니다.</a>";
//						'김지연 부장'이(가) 작성한 'ddd'의 참조자로 등록되었습니다.
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					
					//결재자
					else if("approvalAL".equals(title) ) {
						String str = "";
						log.info("alStts =>" + alStts);
						if (alStts.equals("A04")) {
							str = "<a href='/approval/request' >"+ senderEmpNm +" 님이 작성한 '" + apprTitle + "' 의 결재자로 등록되었습니다.</a>";
						}else {
							str = "<a href='/approval/upcoming' >"+ senderEmpNm +" 님이 작성한 '" + apprTitle + "' 의 결재자로 등록되었습니다.</a>";
						}
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					
					//반려 알람
					else if("approvalRJ".equals(title) ) {
						String str = "<a href='/approval/completed' > '"+ apprTitle +"' 이(가) '" + senderEmpNm + "' 님에 의해 반려 되었습니다.</a>";
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					
					//승인 알람
					else if("approve".equals(title) ) {
						String str = "<a href='/approval/completed' > '"+ apprTitle +"' 이(가) '" + senderEmpNm + "' 님에 의해 승인 되었습니다.</a>";
						
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					
					//상신취소
					else if("approveCL".equals(title) ) {
						String str = "<p> '"+ apprTitle +"' 이(가) '" + senderEmpNm + "' 님에 의해 회수 되었습니다.</p>";
						
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					
					//메일
					else if("mail".equals(title) ) {
						String str = "<a href='/mail/inbox' > '"+ senderEmpNm +"' 님이 '" + mlTtl + "' 의 메일을 보냈습니다.</a>";
						
						alarmVO.setAlarmUrl(str);
						log.info("저장된 alarmVO" + alarmVO);
						int result = this.alarmService.insertAlarm(alarmVO);
						log.info("알람 저장 확인" + result);
						
					}
					
				}
					
				
			}
			
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {//연결 해제
		// TODO Auto-generated method stub
		log.info("Socket 끊음");
		sessions.remove(session);
		userSessionsMap.remove(currentUserName(session),session);
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