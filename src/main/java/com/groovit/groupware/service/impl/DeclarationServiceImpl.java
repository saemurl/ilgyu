package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.DeclarationDao;
import com.groovit.groupware.service.DeclarationService;


@Service
public class DeclarationServiceImpl implements DeclarationService {

	@Autowired
	DeclarationDao declarationDao;
	
	
	
	@Override
	public List<Map<String, Object>> declareBoardList() {
		return this.declarationDao.declareBoardList();
	}



	@Override
	public Map<String, Object> declareBoardDetail(String dclrNo) {
		return this.declarationDao.declareBoardDetail(dclrNo);
	}



	@Override
	public int declareBoardCnt(Map<String, Object> dclrBoardInfo) {
		int result = this.declarationDao.declareBoardCnt(dclrBoardInfo);
		if (result > 0) {
			result += this.declarationDao.declarefreeBoardCnt(dclrBoardInfo);
		}
		return result;
	}



	@Override
	public List<Map<String, Object>> declareBoardCount() {
		return this.declarationDao.declareBoardCount();
	}



	@Override
	public List<Map<String, Object>> declareCateList(Map<String, Object> declareCateList) {
		return this.declarationDao.declareResultList(declareCateList);
	}



	@Override
	public List<Map<String, Object>> declareBoardCountType() {
		return this.declarationDao.declareBoardCountTypeList();
	}



	@Override
	public List<Map<String, Object>> declareCommentList() {
		return this.declarationDao.declareCommentList();
	}



	@Override
	public List<Map<String, Object>> declareCommentCateList(Map<String, Object> commentCate) {
		return this.declarationDao.declareCommentCateList(commentCate);
	}



	@Override
	public Map<String, Object> declareCommentDetail(String dcNo) {
		return this.declarationDao.declareCommentDetail(dcNo);
	}



	@Override
	public int declareCommentCnt(Map<String, Object> map) {
		int result = this.declarationDao.declareCommentCnt(map);
			if (result >0) {
				result += this.declarationDao.declareCommentSttsCnt(map);
			}
			
		return result;
	}



	@Override
	public List<Map<String, Object>> declareCommentCount() {
		return this.declarationDao.declareCommentCount();
	}



	@Override
	public List<Map<String, Object>> declareCommentCountType() {
		return this.declarationDao.declareCommentCountType();
	}

}
