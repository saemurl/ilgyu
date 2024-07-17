package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MailBookmarkVO;
import com.groovit.groupware.vo.MailReceiver;
import com.groovit.groupware.vo.MailVO;
import com.groovit.groupware.vo.WastebasketVO;

public interface MailService {
	// 받은메일
	public List<MailVO> mailR(Map<String, Object> map);
	
	// 받은메일 상세
	public MailVO mailDetail(Map<String, String> map);
	
	// 보낸메일
	public List<MailVO> mailS(Map<String, Object> map);
	
	// 보낸메일 상세
	public MailVO mailSDetail(Map<String, String> map);
	
	// 메일 작성 직원 리스트
	public List<EmployeeVO> empList(String empId);
	
	// 메일 작성
	public int mailInsert(Map<String, Object> map);
	
	// 메일번호
	public String mlSn();
	
	// 휴지통(받은메일함)
	public int Wastebasket(WastebasketVO wastebasketVO);
	
	// 휴지통 조회
	public List<MailVO> wbSelect(Map<String, Object> map);
	
	// 휴지통 복원
	public int restore(Map<String, Object> map);
	
	// 받은메일 읽음
	public int mlSttsUpdate(Map<String, Object> map);
	
	// 안읽은 메일 수
	public int receiverCnt(String empId);
	
	// 메일 답장
	public int replyMailSend(Map<String, Object> map);
	
	// 임시저장 메일
	public List<MailVO> Tsave(Map<String, Object> map);
	
	// 다운로드 파일 list
	public List<AtchfileDetailVO> download(String mlSn);
	
	// 휴지통 메일 상세정보
	public MailVO wbDetail(Map<String, Object> map);
	
	// 즐겨찾기 insert
	public int bookmark(Map<String, Object> map);
	
	// 즐겨찾기 list
	public List<MailVO> bookmarkList(String empId);
	
	// 즐겨찾기 delete
	public int removeBookmark(Map<String, Object> map);
	
	// 즐겨찾기 활성화 유지(즐겨찾기 목록)
	public List<MailBookmarkVO> getBookmarks(String empId);
	
	// 임시메일 다시 보내기
	public MailVO tsMailSend(Map<String, Object> map);
	
	// 임시메일 files
	public List<AtchfileDetailVO> tsMailFiles(Map<String, Object> map);
	
	// 수신자 존재여부
	public List<MailReceiver> mailReceiverList(String mlSn);
	
	// 임시저장 메일 보내기
	public int tsMailSendReply(Map<String, Object> map);
	
	// 안읽은 메일
	public List<MailVO> nrMailList(Map<String, Object> map);
	
	// 영구삭제
	public int wbDelete(Map<String, Object> map);
	
	// 안읽은 메일로 변경
	public int unreadMail(Map<String, Object> map);
	
	// 받은 메일 수
	public int mailRcnt(String empId);
	
	// 보낸 메일 수
	public int mailScnt(String empId);
	
	// 임시저장 메일 수
	public int tsMailcnt(String empId);
	
	// 읽지않은 메일 수
	public int nrMailcnt(String empId);
	
	// 휴지통 메일 수
	public int wbMailcnt(String empId);
	
	// 임시저장 수신자 삭제
	public int receiverDel(Map<String, Object> map);
	
	

}
