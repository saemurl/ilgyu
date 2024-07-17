package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.SurveyResponseVO;
import com.groovit.groupware.vo.SurveyVO;

public interface SurveyService {

	int getTotal(Map<String, Object> map);

	List<SurveyVO> getList(Map<String, Object> map);

	SurveyVO detail(SurveyVO surveyVO);

	int resp(List<SurveyResponseVO> respList);

	int checkParticipate(SurveyResponseVO surveyResponseVO);

	SurveyVO result(SurveyVO surveyVO);

	int insert(SurveyVO surveyVO);

	int getMyTotal(Map<String, Object> map);

	int getManageTotal(Map<String, Object> map);

	List<SurveyVO> getManageList(Map<String, Object> map);

	int updateStop(String srvyNo);

	int delete(String srvyNo);

	int updateSurvey(SurveyVO surveyVO);
	
	int getAllEmpTotal();
	
	List<SurveyVO> mainSurveyList();

}
