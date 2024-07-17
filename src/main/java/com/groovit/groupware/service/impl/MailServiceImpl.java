package com.groovit.groupware.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.mapper.MailMapper;
import com.groovit.groupware.service.MailService;
import com.groovit.groupware.util.UploadController;
import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MailBookmarkVO;
import com.groovit.groupware.vo.MailReceiver;
import com.groovit.groupware.vo.MailSenderVO;
import com.groovit.groupware.vo.MailVO;
import com.groovit.groupware.vo.WastebasketVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MailServiceImpl implements MailService{
	
	@Autowired
	UploadController uploadController;
	
	@Autowired
	MailMapper mailMapper;

	@Override
	public List<MailVO> mailR(Map<String, Object> map) {
		return this.mailMapper.mailR(map);
	}

	@Override
	public MailVO mailDetail(Map<String, String> map) {
		return this.mailMapper.mailDetail(map);
	}

	@Override
	public List<MailVO> mailS(Map<String, Object> map) {
		return this.mailMapper.mailS(map);
	}

	@Override
	public MailVO mailSDetail(Map<String, String> map) {
		return this.mailMapper.mailSDetail(map);
	}

	@Override
	public List<EmployeeVO> empList(String empId) {
		return this.mailMapper.empList(empId);
	}

	@Override
	public int mailInsert(Map<String, Object> map) {
		MailVO SmailVO = (MailVO) map.get("mailVO");
		
		MailVO mailVO = new MailVO();
		MailSenderVO mailSenderVO = new MailSenderVO();
		MailReceiver mailReceiverVO = new MailReceiver();
		
		List<String> empIdList = SmailVO.getEmpList();
		log.info("empIdList >> " + empIdList);
		
		String mlSn = (String) map.get("mlSn");
		String mlTtl = SmailVO.getMlTtl();
		String mlCn = SmailVO.getMlCn();
		String mlIptYn = SmailVO.getMlIptYn();
		String mlStts = SmailVO.getMlStts();
		
		String RempId = (String) map.get("RempId");
		
		mailVO.setMlSn(mlSn);
		mailVO.setMlTtl(mlTtl);
		mailVO.setMlCn(mlCn);
		mailVO.setMlIptYn(mlIptYn);
		
		
		MultipartFile[] file = SmailVO.getFile();
		
		// 첨부파일이 있으면 파일업로드 로직
		if(file.length > 0) {
			String atchfileSn = this.uploadController.uploadMulti(file, RempId);
			mailVO.setAtchfileSn(atchfileSn);
		}
		
		int result = this.mailMapper.mailInsert(mailVO);
		
		mailSenderVO.setMlSndpty(RempId);
		mailSenderVO.setMlSn(mlSn);
		mailSenderVO.setMlStts(mlStts);
		
		
		
		result += this.mailMapper.senderInsert(mailSenderVO);
		
		for (String empId : empIdList) {
			mailReceiverVO.setMlSn(mlSn);
			mailReceiverVO.setMlRcvr(empId);
			mailReceiverVO.setMlStts(mlStts);
			
			result += this.mailMapper.receiverInsert(mailReceiverVO);
		}
		
		
		
		return result;
	}

	@Override
	public String mlSn() {
		return this.mailMapper.mlSn();
	}
	
	// 휴지통(받은메일함)
	@Override
	public int Wastebasket(WastebasketVO wastebasketVO) {
		return this.mailMapper.Wastebasket(wastebasketVO);
	}

	@Override
	public List<MailVO> wbSelect(Map<String, Object> map) {
		return this.mailMapper.wbSelect(map);
	}

	@Override
	public int restore(Map<String, Object> map) {
		return this.mailMapper.restore(map);
	}

	@Override
	public int mlSttsUpdate(Map<String, Object> map) {
		return this.mailMapper.mlSttsUpdate(map);
	}

	@Override
	public int receiverCnt(String empId) {
		return this.mailMapper.receiverCnt(empId);
	}
	
	// 메일 답장
	@Override
	public int replyMailSend(Map<String, Object> map) {
		
		MailVO SmailVO = (MailVO) map.get("mailVO");
		
		MailVO mailVO = new MailVO();
		MailSenderVO mailSenderVO = new MailSenderVO();
		MailReceiver mailReceiverVO = new MailReceiver();
		
		
		String mlSn = (String) map.get("mlSn");
		String mlTtl = SmailVO.getMlTtl();
		String mlCn = SmailVO.getMlCn();
		String mlIptYn = SmailVO.getMlIptYn();
		String mlStts = SmailVO.getMlStts();
		
		String SempId = (String) map.get("SempId");	// 발신자
		String RempId = SmailVO.getEmpId();			// 수신자
		
		mailVO.setMlSn(mlSn);
		mailVO.setMlTtl(mlTtl);
		mailVO.setMlCn(mlCn);
		mailVO.setMlIptYn(mlIptYn);
		
		
		MultipartFile[] file = SmailVO.getFile();
		
		// 첨부파일이 있으면 파일업로드 로직
		if(file.length > 0) {
			String atchfileSn = this.uploadController.uploadMulti(file, SempId);
			mailVO.setAtchfileSn(atchfileSn);
		}
		
		int result = this.mailMapper.mailInsert(mailVO);
		
		mailSenderVO.setMlSndpty(SempId); 
		mailSenderVO.setMlSn(mlSn);
		mailSenderVO.setMlStts(mlStts);
		
		result += this.mailMapper.senderInsert(mailSenderVO);
		
		mailReceiverVO.setMlSn(mlSn);
		mailReceiverVO.setMlRcvr(RempId);
		mailReceiverVO.setMlStts(mlStts);
		
		result += this.mailMapper.receiverInsert(mailReceiverVO);
		
		
		return result;
	}
	
	
	@Override
	public List<MailVO> Tsave(Map<String, Object> map) {
		return this.mailMapper.Tsave(map);
	}

	@Override
	public List<AtchfileDetailVO> download(String mlSn) {
		return this.mailMapper.download(mlSn);
	}


	@Override
	public MailVO wbDetail(Map<String, Object> map) {
		return this.mailMapper.wbDetail(map);
	}

	@Override
	public int bookmark(Map<String, Object> map) {
		return this.mailMapper.bookmark(map);
	}

	@Override
	public List<MailVO> bookmarkList(String empId) {
		return this.mailMapper.bookmarkList(empId);
	}

	@Override
	public int removeBookmark(Map<String, Object> map) {
		return this.mailMapper.removeBookmark(map);
	}

	@Override
	public List<MailBookmarkVO> getBookmarks(String empId) {
		return this.mailMapper.getBookmarks(empId);
	}

	@Override
	public MailVO tsMailSend(Map<String, Object> map) {
		return this.mailMapper.tsMailSend(map);
	}

	@Override
	public List<AtchfileDetailVO> tsMailFiles(Map<String, Object> map) {
		return this.mailMapper.tsMailFiles(map);
	}

	@Override
	public List<MailReceiver> mailReceiverList(String mlSn) {
		return this.mailMapper.mailReceiverList(mlSn);
	}

	// 임시저장 보내기
	@Override
	public int tsMailSendReply(Map<String, Object> map) {
		
		int result = 0;
		
		String       SempId       = (String) map.get("SempId");				// 발신자 Id
		List<String> receiverList = (List<String>) map.get("receiverList"); // 수신자 여부
		MailVO       udMailVO     = (MailVO) map.get("mailVO"); 			// 메일
		List<String> empList 	  = udMailVO.getEmpList();					// 수신자 목록
		
		String 		 atchfileSn = udMailVO.getAtchfileSn();					// 삭제할 파일
		String		 mlSn = udMailVO.getMlSn();								// 수정할 메일 번호
		
		/*
		 *  1. 파일 삭제
		 *  2. 발신자 update
		 *  3. 수신자 update
		 *  4. 메일 update(파일 insert)
		 */
		
		// 파일 삭제
		result += this.mailMapper.atchfileDelete(atchfileSn); 
		
		Map<String, Object> updateMap = new HashMap<String, Object>();
		updateMap.put("mlSn", mlSn);
		updateMap.put("SempId", SempId);
		
		// 발신자 update
		result += this.mailMapper.senderUpdate(updateMap);		// 발신자 update
		
		// 수신자 update / insert
		for (String empId : empList) {
			if(receiverList.contains(empId)) {
				MailReceiver mailReceiverVO = new MailReceiver();
				mailReceiverVO.setMlSn(mlSn);
				mailReceiverVO.setMlRcvr(empId);
				result += this.mailMapper.receiverUpdate(mailReceiverVO);	// 수신자 상태 update
			}else {
				MailReceiver mailReceiverVO = new MailReceiver();
				mailReceiverVO.setMlSn(mlSn);
	        	mailReceiverVO.setMlRcvr(empId);
	    		log.info("포함안된 mlRcvr >> " + empId);
	    		result += this.mailMapper.receiverAdd(mailReceiverVO);		// 수신자 추가
			}
		}
		
		
		MultipartFile[] file = udMailVO.getFile();
		
		// 첨부파일이 있으면 파일업로드 로직
		if(file.length > 0) {
			String upAtchfileSn = this.uploadController.uploadMulti(file, SempId);
			udMailVO.setAtchfileSn(upAtchfileSn);
		}
		
		// 메일 update
		result += this.mailMapper.tsMailUpdate(udMailVO);	 		
		
		return result;
	}

	@Override
	public List<MailVO> nrMailList(Map<String, Object> map) {
		return this.mailMapper.nrMailList(map);
	}

	@Override
	public int wbDelete(Map<String, Object> map) {
		
		int result = 0;
		
		List<String> mlSnList = (List<String>) map.get("mlSnList");
		String empId = (String) map.get("empId");
		
		
		for (String mlSn : mlSnList) {
			WastebasketVO WastebasketVO = new WastebasketVO();
			
			WastebasketVO.setMlDeleter(empId);
			WastebasketVO.setMlSn(mlSn);
			
			result += this.mailMapper.wbDelete(WastebasketVO);
		}
		
		
		return result;
	}

	@Override
	public int unreadMail(Map<String, Object> map) {
		return this.mailMapper.unreadMail(map);
	}

	@Override
	public int mailRcnt(String empId) {
		return this.mailMapper.mailRcnt(empId);
	}

	@Override
	public int mailScnt(String empId) {
		return this.mailMapper.mailScnt(empId);
	}
	@Override
	public int tsMailcnt(String empId) {
		return this.mailMapper.tsMailcnt(empId);
	}
	
	@Override
	public int nrMailcnt(String empId) {
		return this.mailMapper.nrMailcnt(empId);
	}
	@Override
	public int wbMailcnt(String empId) {
		return this.mailMapper.wbMailcnt(empId);
	}

	@Override
	public int receiverDel(Map<String, Object> map) {
		return this.mailMapper.receiverDel(map);
	}

}
