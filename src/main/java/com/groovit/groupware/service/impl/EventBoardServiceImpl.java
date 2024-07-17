package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.dao.EventBoardDao;
import com.groovit.groupware.service.EventBoardService;
import com.groovit.groupware.util.UploadController;
import com.groovit.groupware.vo.EventBoardVO;
import com.groovit.groupware.vo.MarriageVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ObituaryVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class EventBoardServiceImpl implements EventBoardService {

    @Autowired
    EventBoardDao eventBoardDao;

    @Autowired
    UploadController uploadController;

    // 결혼 테이블 출력
    @Override
	public List<EventBoardVO> loadMarryTable() {
		return this.eventBoardDao.loadMarryTable();
	}
    
    // 부고 테이블 출력
    @Override
	public List<EventBoardVO> loadRipTable() {
		return this.eventBoardDao.loadRipTable();
	}
    
    // 결혼 게시글 등록
    @Override
	public int mrgCreate(Map<String, Object> param) {

    	String empId = (String) param.get("empId");
    	String title = (String) param.get("title");
		String mrgDt = (String) param.get("mrgDt");
		String mrgAddress = (String) param.get("mrgAddress");
		String mrgDaddr = (String) param.get("mrgDaddr");
		String mrgCon = (String) param.get("mrgCon");
		MultipartFile uploadFile = (MultipartFile) param.get("uploadFile");
    	
		log.info("서비스 임플에서 값 체크  empId : " + empId);
	    log.info("서비스 임플에서 값 체크  title : " + title);
	    log.info("서비스 임플에서 값 체크  mrgDt : " + mrgDt);
	    log.info("서비스 임플에서 값 체크  mrgAddress : " + mrgAddress);
	    log.info("서비스 임플에서 값 체크  mrgDaddr : " + mrgDaddr);
	    log.info("서비스 임플에서 값 체크  mrgCon : " + mrgCon);
	    log.info("서비스 임플에서 값 체크  mtgrNm : " + uploadFile.getOriginalFilename());
    	
	    // 1) 경조사 게시판에 등록
	    EventBoardVO eventBoardVO = new EventBoardVO();
	    eventBoardVO.setEmpId(empId);
	    
	    log.info("체에에에에에에크 : " + eventBoardVO);
	    
	    int result = this.eventBoardDao.mrgCreateBoard(eventBoardVO);
	    
	    // 2) 등록된 경조사 테이블 PK 값 가져오기
	    String evtbNo = this.eventBoardDao.selectEvtbNo();
	    log.info("등록된 경조사 테이블 PK 값 evtbNo : " + evtbNo);
	    
	    // 3) 결혼 게시글 내용 등록
	    MarriageVO marriageVO = new MarriageVO();
	    marriageVO.setEvtbNo(evtbNo);
	    marriageVO.setMrgTtl(title);
	    marriageVO.setMrgDt(mrgDt);
	    marriageVO.setMrgAddr(mrgAddress);
	    marriageVO.setMrgDaddr(mrgDaddr);
	    marriageVO.setMrgCon(mrgCon);
	    
	    result += this.eventBoardDao.mrgInsertData(marriageVO);
	    
	    // 4) 게시글 파일 업로드
	    if(uploadFile.getOriginalFilename().length()>0) {
  			
  			String atchfileSn = this.uploadController.uploadOne(uploadFile, empId);
  			
  			log.info("등록된 atchfileSn 값 체크 : " + atchfileSn);

  			marriageVO.setMrgIvt(atchfileSn);
  		}
  		result += this.eventBoardDao.eventBoardAtchfileSn(marriageVO);
	    
    	return 0;
	}
    
    // 부고 게시글 등록
    @Override
	public int obtCreate(Map<String, Object> param) {

    	String empId = (String) param.get("empId");
    	String title = (String) param.get("title");
		String obtDmDt = (String) param.get("obtDmDt");
		String obtFpDt = (String) param.get("obtFpDt");
		String obtAddress = (String) param.get("obtAddress");
		String obtDaddr = (String) param.get("obtDaddr");
		String obtCon = (String) param.get("obtCon");
		MultipartFile uploadFile = (MultipartFile) param.get("uploadFile");
		
		log.info("서비스 임플에서 값 체크  empId : " + empId);
		log.info("서비스 임플에서 값 체크  title : " + title);
		log.info("서비스 임플에서 값 체크  obtDmDt : " + obtDmDt);
		log.info("서비스 임플에서 값 체크  obtFpDt : " + obtFpDt);
		log.info("서비스 임플에서 값 체크  obtAddress : " + obtAddress);
		log.info("서비스 임플에서 값 체크  obtDaddr : " + obtDaddr);
		log.info("서비스 임플에서 값 체크  obtCon : " + obtCon);
		log.info("서비스 임플에서 값 체크  uploadFile : " + uploadFile.getOriginalFilename());

		// 1) 경조사 게시판에 등록
	    EventBoardVO eventBoardVO = new EventBoardVO();
	    eventBoardVO.setEmpId(empId);
	    
	    int result = this.eventBoardDao.obtCreateBoard(eventBoardVO);
		
	    // 2) 등록된 경조사 테이블 PK 값 가져오기
	    String evtbNo = this.eventBoardDao.selectEvtbNo();
	    log.info("등록된 경조사 테이블 PK 값 evtbNo : " + evtbNo);
	    
	    // 3) 부고 게시글 내용 등록
	    ObituaryVO obituaryVO = new ObituaryVO();
	    obituaryVO.setEvtbNo(evtbNo);
	    obituaryVO.setObtTtl(title);
	    obituaryVO.setObtDmDt(obtDmDt);
	    obituaryVO.setObtFpDt(obtFpDt);
	    obituaryVO.setObtAddr(obtAddress);
	    obituaryVO.setObtDaddr(obtDaddr);
	    obituaryVO.setObtCon(obtCon);
	    
	    result += this.eventBoardDao.obtInsertData(obituaryVO);
	    
	    // 4) 게시글 파일 업로드
	    if(uploadFile.getOriginalFilename().length()>0) {
  			
  			String atchfileSn = this.uploadController.uploadOne(uploadFile, empId);
  			
  			log.info("등록된 atchfileSn 값 체크 : " + atchfileSn);

  			obituaryVO.setObtIvt(atchfileSn);;
  		}
  		result += this.eventBoardDao.obtBoardAtchfileSn(obituaryVO);
	    
    	return result;
	}

    // 결혼 게시판 상세
	@Override
	public MarriageVO selectMrg(String evtbNo) {
		
		// 조회수
		int result = eventBoardDao.clickCnt(evtbNo);
		
		return this.eventBoardDao.selectMrg(evtbNo);
	}
	
	// 부고 게시판 상세
	@Override
	public ObituaryVO selectObt(String evtbNo) {
		
		// 조회수
		int result = eventBoardDao.clickCnt(evtbNo);
		
		return this.eventBoardDao.selectObt(evtbNo);
	}

	@Override
	public EventBoardVO selectBoard(String evtbNo) {
		return this.eventBoardDao.selectBoard(evtbNo);
	}

	@Override
	public String selectObtImg(String obtIvt) {
		return this.eventBoardDao.selectObtImg(obtIvt);
	}

	@Override
	public String selectMrgImg(String mrgIvt) {
		return this.eventBoardDao.selectMrgImg(mrgIvt);
	}

	@Override
	public int deleteMrg(String evtbNo) {
		
		int result = this.eventBoardDao.deleteMrg(evtbNo);
		result += this.eventBoardDao.deleteTable(evtbNo);
		
		return result;
	}

	@Override
	public int deleteObt(String evtbNo) {
		
		int result = this.eventBoardDao.deleteObt(evtbNo);
		result += this.eventBoardDao.deleteTable(evtbNo);
		
		return result;
	}

	@Override
	public int mrgUpdate(Map<String, Object> param) {
		String evtbNo = (String) param.get("evtbNo");
		String empId = (String) param.get("empId");
    	String title = (String) param.get("title");
		String mrgDt = (String) param.get("mrgDt");
		String mrgAddress = (String) param.get("mrgAddress");
		String mrgDaddr = (String) param.get("mrgDaddr");
		String mrgCon = (String) param.get("mrgCon");
		MultipartFile uploadFile = (MultipartFile) param.get("uploadFile");
    	
		log.info("서비스 임플에서 값 체크  evtbNo : " + evtbNo);
		log.info("서비스 임플에서 값 체크  empId : " + empId);
	    log.info("서비스 임플에서 값 체크  title : " + title);
	    log.info("서비스 임플에서 값 체크  mrgDt : " + mrgDt);
	    log.info("서비스 임플에서 값 체크  mrgAddress : " + mrgAddress);
	    log.info("서비스 임플에서 값 체크  mrgDaddr : " + mrgDaddr);
	    log.info("서비스 임플에서 값 체크  mrgCon : " + mrgCon);
	    if (uploadFile != null) {
	        log.info("서비스 임플에서 값 체크  fileNm : " + uploadFile.getOriginalFilename());
	    }
	    
	    // 1) 결혼 게시글 내용 등록
	    MarriageVO marriageVO = new MarriageVO();
	    marriageVO.setEvtbNo(evtbNo);
	    marriageVO.setMrgTtl(title);
	    marriageVO.setMrgDt(mrgDt);
	    marriageVO.setMrgAddr(mrgAddress);
	    marriageVO.setMrgDaddr(mrgDaddr);
	    marriageVO.setMrgCon(mrgCon);
	    
	    int result = this.eventBoardDao.mrgUpdateData(marriageVO);
	    
	    // 2) 게시글 파일 업로드
	    if (uploadFile != null && !uploadFile.isEmpty()) {
	        String atchfileSn = this.uploadController.uploadOne(uploadFile, empId);
	        log.info("등록된 atchfileSn 값 체크 : " + atchfileSn);
	        marriageVO.setMrgIvt(atchfileSn);

	        result += this.eventBoardDao.AtchfileSnUpdate(marriageVO);
	    }
	    
    	return result;
	}

	@Override
	public int obtUpdate(Map<String, Object> param) {
		String evtbNo = (String) param.get("evtbNo");
		String empId = (String) param.get("empId");
    	String title = (String) param.get("title");
		String obtDmDt = (String) param.get("obtDmDt");
		String obtFpDt = (String) param.get("obtFpDt");
		String obtAddress = (String) param.get("obtAddress");
		String obtDaddr = (String) param.get("obtDaddr");
		String obtCon = (String) param.get("obtCon");
		MultipartFile uploadFile = (MultipartFile) param.get("uploadFile");
		
		log.info("서비스 임플에서 값 체크  evtbNo : " + evtbNo);
		log.info("서비스 임플에서 값 체크  empId : " + empId);
		log.info("서비스 임플에서 값 체크  title : " + title);
		log.info("서비스 임플에서 값 체크  obtDmDt : " + obtDmDt);
		log.info("서비스 임플에서 값 체크  obtFpDt : " + obtFpDt);
		log.info("서비스 임플에서 값 체크  obtAddress : " + obtAddress);
		log.info("서비스 임플에서 값 체크  obtDaddr : " + obtDaddr);
		log.info("서비스 임플에서 값 체크  obtCon : " + obtCon);
		if (uploadFile != null) {
			log.info("서비스 임플에서 값 체크  fileNm : " + uploadFile.getOriginalFilename());
	    }
	    
	    // 1) 부고 게시글 내용 등록
	    ObituaryVO obituaryVO = new ObituaryVO();
	    obituaryVO.setEvtbNo(evtbNo);
	    obituaryVO.setObtTtl(title);
	    obituaryVO.setObtDmDt(obtDmDt);
	    obituaryVO.setObtFpDt(obtFpDt);
	    obituaryVO.setObtAddr(obtAddress);
	    obituaryVO.setObtDaddr(obtDaddr);
	    obituaryVO.setObtCon(obtCon);
	    
	    log.info("임플에서 담긴 부고VO 값 : " +  obituaryVO);
	    
	    int result = this.eventBoardDao.obtUpdatetData(obituaryVO);
	    
	    // 2) 게시글 파일 업로드
	    if (uploadFile != null && !uploadFile.isEmpty()) {
	        String atchfileSn = this.uploadController.uploadOne(uploadFile, empId);
	        log.info("등록된 atchfileSn 값 체크 : " + atchfileSn);
	        obituaryVO.setObtIvt(atchfileSn);

	        result += this.eventBoardDao.obtAtchfileSnUpdate(obituaryVO);
	    }
	    
    	return result;
	
	}
    
    
    
    
    
    
    
    

}
