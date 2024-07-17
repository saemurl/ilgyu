package com.groovit.groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MailBookmarkVO;
import com.groovit.groupware.vo.MailReceiver;
import com.groovit.groupware.vo.MailSenderVO;
import com.groovit.groupware.vo.MailVO;
import com.groovit.groupware.vo.WastebasketVO;

import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;

@Mapper
public interface MailMapper {
	
	public List<MailVO> mailR(Map<String, Object> map); 

	public MailVO mailDetail(Map<String, String> map) ;

	public List<MailVO> mailS(Map<String, Object> map);

	public MailVO mailSDetail(Map<String, String> map) ;

	public List<EmployeeVO> empList(String empId) ;

	public String mlSn() ;
	
	// mail insert
	public int mailInsert(MailVO mailVO);
	
	// 수신자 insert
	public int senderInsert(MailSenderVO mailSenderVO) ;

	public int receiverInsert(MailReceiver mailReceiverVO) ;
	
	// 휴지통(받은메일함)
	public int Wastebasket(WastebasketVO wastebasketVO) ;
	
	// 휴지통 조회
	public List<MailVO> wbSelect(Map<String, Object> map) ;

	public int restore(Map<String, Object> map) ;

	public int mlSttsUpdate(Map<String, Object> map) ;

	public int receiverCnt(String empId) ;

	public List<MailVO> Tsave(Map<String, Object> map) ;

	public List<AtchfileDetailVO> download(String mlSn) ;

	public MailVO wbDetail(Map<String, Object> map);

	public int bookmark(Map<String, Object> map) ;

	public List<MailVO> bookmarkList(String empId) ;

	public int removeBookmark(Map<String, Object> map) ;

	public List<MailBookmarkVO> getBookmarks(String empId) ;

	public MailVO tsMailSend(Map<String, Object> map) ;

	public List<AtchfileDetailVO> tsMailFiles(Map<String, Object> map) ;

	public List<MailReceiver> mailReceiverList(String mlSn);
	
	// 안읽은 메일
	public List<MailVO> nrMailList(Map<String, Object> map);
	
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
	
	// 임시저장 파일 삭제
	public int atchfileDelete(String atchfileSn);
	
	// 임시저장 발신자 update
	public int senderUpdate(Map<String, Object> updateMap);
	
	// 임시저장 수신자 update
	public int receiverUpdate(MailReceiver mailReceiverVO);
	
	// 임시저장 수신자 추가
	public int receiverAdd(MailReceiver mailReceiverVO);
	
	// 임시저장 메일 update
	public int tsMailUpdate(MailVO udMailVO);
	
	// 영구 삭제(사용여부 : 'N')
	public int wbDelete(WastebasketVO wastebasketVO);
	
	
	
	
	
	
	
	
	
}
