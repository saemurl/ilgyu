package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.SurveyDao;
import com.groovit.groupware.service.SurveyService;
import com.groovit.groupware.vo.SurveyAnswerVO;
import com.groovit.groupware.vo.SurveyQuestionVO;
import com.groovit.groupware.vo.SurveyResponseVO;
import com.groovit.groupware.vo.SurveyVO;

@Service
public class SurveyServiceImpl implements SurveyService{
	
	@Autowired
	SurveyDao surveyDao; 

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.surveyDao.getTotal(map);
	}

	@Override
	public List<SurveyVO> getList(Map<String, Object> map) {
		return this.surveyDao.getList(map);
	}

	@Override
	public SurveyVO detail(SurveyVO surveyVO) {
		return this.surveyDao.detail(surveyVO);
	}

	@Override
	public int resp(List<SurveyResponseVO> respList) {
		int cnt = 0;
		for (SurveyResponseVO surveyResponseVO : respList) {
			this.surveyDao.resp(surveyResponseVO);
			cnt++;
		}
		return cnt;
	}

	@Override
	public int checkParticipate(SurveyResponseVO surveyResponseVO) {
		return this.surveyDao.checkParticipate(surveyResponseVO);
	}

	@Override
	public SurveyVO result(SurveyVO surveyVO) {
		return this.surveyDao.result(surveyVO);
	}

	@Override
	public int insert(SurveyVO surveyVO) {
		int result = 0;
		// 설문 등록
		result += this.surveyDao.insert(surveyVO);
		// 질문 등록
		for (SurveyQuestionVO surveyQuestionVO : surveyVO.getQuestionList()) {
			surveyQuestionVO.setSrvyNo(surveyVO.getSrvyNo());
			result += this.surveyDao.insertQuestion(surveyQuestionVO);
			for (SurveyAnswerVO surveyAnswerVO : surveyQuestionVO.getAnswerList()) {
				surveyAnswerVO.setSqSn(surveyQuestionVO.getSqSn());
				result += this.surveyDao.insertAnswer(surveyAnswerVO);
			}
		}
		return result;
	}

	@Override
	public int getMyTotal(Map<String, Object> map) {
		return this.surveyDao.getMyTotal(map);
	}

	@Override
	public int getManageTotal(Map<String, Object> map) {
		return this.surveyDao.getManageTotal(map);
	}

	@Override
	public List<SurveyVO> getManageList(Map<String, Object> map) {
		return this.surveyDao.getManageList(map);
	}

	@Override
	public int updateStop(String srvyNo) {
		return this.surveyDao.updateStop(srvyNo);
	}

	@Override
	public int delete(String srvyNo) {
		return this.surveyDao.delete(srvyNo);
	}

	@Override
	public int updateSurvey(SurveyVO surveyVO) {
		return this.surveyDao.updateSurvey(surveyVO);
	}

	@Override
	public int getAllEmpTotal() {
		return this.surveyDao.getAllEmpTotal();
	}

	@Override
	public List<SurveyVO> mainSurveyList() {
		return this.surveyDao.mainSurveyList();
	}

}
