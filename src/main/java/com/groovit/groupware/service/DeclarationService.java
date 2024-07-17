package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

public interface DeclarationService {

	List<Map<String, Object>> declareBoardList();

	Map<String, Object> declareBoardDetail(String dclrNo);

	int declareBoardCnt(Map<String, Object> dclrBoardInfo);

	List<Map<String, Object>> declareBoardCount();

	List<Map<String, Object>> declareCateList(Map<String, Object> declareCateList);

	List<Map<String, Object>> declareBoardCountType();

	List<Map<String, Object>> declareCommentList();

	List<Map<String, Object>> declareCommentCateList(Map<String, Object> commentCate);

	Map<String, Object> declareCommentDetail(String dcNo);

	int declareCommentCnt(Map<String, Object> map);

	List<Map<String, Object>> declareCommentCount();

	List<Map<String, Object>> declareCommentCountType();

}
