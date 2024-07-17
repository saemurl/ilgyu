package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DeclarationDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String, Object>> declareBoardList() {
		return this.sqlSessionTemplate.selectList("declare.declareBoardList");
	}

	public Map<String, Object> declareBoardDetail(String dclrNo) {
		return this.sqlSessionTemplate.selectOne("declare.declareBoardDetail", dclrNo);
	}

	public int declareBoardCnt(Map<String, Object> dclrBoardInfo) {
		return this.sqlSessionTemplate.update("declare.declareBoardCnt", dclrBoardInfo);
	}

	public int declarefreeBoardCnt(Map<String, Object> dclrBoardInfo) {
		return this.sqlSessionTemplate.update("declare.declarefreeBoardCnt", dclrBoardInfo);
	}

	public List<Map<String, Object>> declareBoardCount() {
		return this.sqlSessionTemplate.selectList("declare.declareBoardCount");
	}

	public List<Map<String, Object>> declareResultList(Map<String, Object> declareCateList) {
		return this.sqlSessionTemplate.selectList("declare.declareResultList", declareCateList);
	}

	public List<Map<String, Object>> declareBoardCountTypeList() {
		return this.sqlSessionTemplate.selectList("declare.declareBoardCountTypeList");
	}

	public List<Map<String, Object>> declareCommentList() {
		return this.sqlSessionTemplate.selectList("declare.declareCommentList");
	}

	public List<Map<String, Object>> declareCommentCateList(Map<String, Object> commentCate) {
		return this.sqlSessionTemplate.selectList("declare.declareCommentCateList", commentCate);
	}

	public Map<String, Object> declareCommentDetail(String dcNo) {
		return this.sqlSessionTemplate.selectOne("declare.declareCommentDetail", dcNo);
	}

	public int declareCommentCnt(Map<String, Object> map) {
		return this.sqlSessionTemplate.update("declare.declareCommentCnt", map);
	}

	public int declareCommentSttsCnt(Map<String, Object> map) {
		return this.sqlSessionTemplate.update("declare.declareCommentSttsCnt", map);
	}

	public List<Map<String, Object>> declareCommentCount() {
		return this.sqlSessionTemplate.selectList("declare.declareCommentCount");
	}

	public List<Map<String, Object>> declareCommentCountType() {
		return this.sqlSessionTemplate.selectList("declare.declareCommentCountType");
	}

}
