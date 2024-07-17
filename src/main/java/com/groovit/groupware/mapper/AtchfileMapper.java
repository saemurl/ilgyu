package com.groovit.groupware.mapper;

import java.util.Map;

import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.AtchfileVO;

public interface AtchfileMapper {
	
	//1) 첨부 부모
	public int insertAtchfile(AtchfileVO atchfileVO);
	
	//2) 첨부 자식
	public int insertAtchfileDetail(AtchfileDetailVO atchfileDetailVO);

	// atchfileSn, atchfileDetailSn로 파일 하나 가져오기
	public AtchfileDetailVO getFileInfo(Map<String, Object> map);
	
	
}
