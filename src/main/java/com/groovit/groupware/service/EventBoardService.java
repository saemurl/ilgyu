package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.EventBoardVO;
import com.groovit.groupware.vo.MarriageVO;
import com.groovit.groupware.vo.ObituaryVO;

public interface EventBoardService {

	List<EventBoardVO> loadMarryTable();
	
	List<EventBoardVO> loadRipTable();
	
	int mrgCreate(Map<String, Object> param);
	
	int obtCreate(Map<String, Object> param);

	MarriageVO selectMrg(String evtbNo);

	ObituaryVO selectObt(String evtbNo);

	EventBoardVO selectBoard(String evtbNo);

	String selectMrgImg(String mrgIvt);

	String selectObtImg(String obtIvt);

	int deleteMrg(String evtbNo);

	int deleteObt(String evtbNo);

	int mrgUpdate(Map<String, Object> param);

	int obtUpdate(Map<String, Object> param);

	
	
	
	

	
	




	

	
}
