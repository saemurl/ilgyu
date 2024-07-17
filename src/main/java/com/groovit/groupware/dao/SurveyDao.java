package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.SurveyAnswerVO;
import com.groovit.groupware.vo.SurveyQuestionVO;
import com.groovit.groupware.vo.SurveyResponseVO;
import com.groovit.groupware.vo.SurveyVO;

@Repository
public class SurveyDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public int getTotal(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectOne("survey.getTotal", map);
	}

	public List<SurveyVO> getList(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectList("survey.getList", map);
	}

	public SurveyVO detail(SurveyVO surveyVO) {
		return this.sqlSessionTemplate.selectOne("survey.detail", surveyVO);
	}

	public int resp(SurveyResponseVO surveyResponseVO) {
		return this.sqlSessionTemplate.insert("survey.resp", surveyResponseVO);
	}

	public int checkParticipate(SurveyResponseVO surveyResponseVO) {
		return this.sqlSessionTemplate.selectOne("survey.checkParticipate", surveyResponseVO);
	}

	public SurveyVO result(SurveyVO surveyVO) {
		return this.sqlSessionTemplate.selectOne("survey.result", surveyVO);
	}

	public int insert(SurveyVO surveyVO) {
		return this.sqlSessionTemplate.insert("survey.insertSurvey", surveyVO);
	}

	public int insertQuestion(SurveyQuestionVO surveyQuestionVO) {
		return this.sqlSessionTemplate.insert("survey.insertQuestion", surveyQuestionVO);
	}

	public int insertAnswer(SurveyAnswerVO surveyAnswerVO) {
		return this.sqlSessionTemplate.insert("survey.insertAnswer", surveyAnswerVO);
	}

	public int getMyTotal(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectOne("survey.getMyTotal", map);
	}

	public int getManageTotal(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectOne("survey.getManageTotal", map);
	}

	public List<SurveyVO> getManageList(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectList("survey.getManageList", map);
	}

	public int updateStop(String srvyNo) {
		return this.sqlSessionTemplate.update("survey.updateStop", srvyNo);
	}

	public int delete(String srvyNo) {
		return this.sqlSessionTemplate.update("survey.delete", srvyNo);
	}

	public int updateSurvey(SurveyVO surveyVO) {
		return this.sqlSessionTemplate.update("survey.updateSurvey", surveyVO);
	}

	public int getAllEmpTotal() {
		return this.sqlSessionTemplate.selectOne("survey.getAllEmpTotal");
	}

	public List<SurveyVO> mainSurveyList() {
		return this.sqlSessionTemplate.selectList("survey.mainSurveyList");
	}

}
