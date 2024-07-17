package com.groovit.groupware.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.SurveyService;
import com.groovit.groupware.util.ArticlePage;
import com.groovit.groupware.vo.SurveyResponseVO;
import com.groovit.groupware.vo.SurveyVO;
import com.sun.org.apache.xml.internal.resolver.helpers.Debug;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/survey")
@Controller
public class SurveyController extends BaseController{
	
	@Autowired
	SurveyService surveyService;
	
	/**
	 * 설문하기 페이지
	 * @param model
	 * @return
	 */
	@GetMapping("/list")
	public String surveyList() {
		
		return "survey/list";
	}
	
	/**
	 * 설문관리 페이지
	 * @return
	 */
	@GetMapping("/manage")
	public String surveyManage() {
		
		return "survey/manage";
	}
	
	/**
	 * 나의 설문내역 페이지
	 * @return
	 */
	@GetMapping("/myList")
	public String surveymyList() {
		
		return "survey/myList";
	}
	
	/**
	 * 전체 설문 리스트 가져오기
	 * @param currentPage
	 * @param model
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getList")
	public ArticlePage<SurveyVO> getList(int currentPage, String stts, String keyword, Map<String, Object> map){
		
		map.put("currentPage", currentPage);
		map.put("stts", stts);
		map.put("keyword", keyword);
		log.info("getList -> {}", map);
		
		int total = this.surveyService.getTotal(map);
		
		List<SurveyVO> surveyList = this.surveyService.getList(map);
		log.info("getList -> surveyList : " + surveyList);
		
		return new ArticlePage<SurveyVO>(total, currentPage, 6, surveyList, keyword);
	}
	
	/**
	 * 내가 답변한 설문목록 가져오기
	 * @param currentPage
	 * @param stts
	 * @param keyword
	 * @param empId
	 * @param map
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getMyList")
	public ArticlePage<SurveyVO> getMyList(int currentPage, String stts, String keyword, String empId, Map<String, Object> map){
		map.put("currentPage", currentPage);
		map.put("stts", stts);
		map.put("keyword", keyword);
		map.put("empId", empId);
		log.info("getList -> {}", map);
		
		int total = this.surveyService.getMyTotal(map);
		
		List<SurveyVO> myList = this.surveyService.getList(map);
		
		return new ArticlePage<SurveyVO>(total, currentPage, 6, myList, keyword);
		
	}
	
	@ResponseBody
	@GetMapping("/getManageList")
	public ArticlePage<SurveyVO> getManageList(int currentPage, String stts, String keyword, String empId, Map<String, Object> map){
		map.put("currentPage", currentPage);
		map.put("stts", stts);
		map.put("keyword", keyword);
		map.put("empId", empId);
		log.info("getList -> {}", map);
		
		int total = this.surveyService.getManageTotal(map);
		
		List<SurveyVO> manageList = this.surveyService.getManageList(map);
		
		return new ArticlePage<SurveyVO>(total, currentPage, 10, manageList, keyword);
		
	}
	
	/**
	 * 설문답변 페이지
	 * @param surveyVO
	 * @param model
	 * @return
	 */
	@GetMapping("/detail")
	public String detail(SurveyVO surveyVO, Model model) {
 		
		surveyVO = this.surveyService.detail(surveyVO);
		log.info("detail -> surveyVO : " + surveyVO);
		
		model.addAttribute("surveyVO", surveyVO);
		
		return "survey/detail";
	}
	
	/**
	 * 답변내용 DB저장
	 * @param respList
	 * @return
	 */
	@ResponseBody
	@PostMapping("/resp")
	public String response(@RequestBody List<SurveyResponseVO> respList) {
		log.info("response : " + respList);
		int cnt = this.surveyService.resp(respList);
		log.info("{}", cnt);
		return "OK";
	}
	
	/**
	 * 로그인한 사용자의 해당 설문완료 여부 확인
	 * @param surveyResponseVO
	 * @return
	 */
	@ResponseBody
	@PostMapping("/checkParticipate")
	public String checkParticipate(@RequestBody SurveyResponseVO surveyResponseVO) {
		log.info("checkParticipate -> surveyResponseVO : {}", surveyResponseVO);
		int cnt = this.surveyService.checkParticipate(surveyResponseVO);
		log.info("checkParticipate -> cnt : {}", cnt);
		String result = "FALSE";
		if(cnt>0) {
			result = "TRUE";
		}
	
		return result;
	}
	
	/**
	 * 설문 결과보기 페이지
	 * @param model
	 * @param surveyVO
	 * @return
	 */
	@GetMapping("/result")
	public String viewResult(Model model, SurveyVO surveyVO) {
		
		surveyVO = this.surveyService.result(surveyVO);
		log.info("viewResult -> {}", surveyVO);
		model.addAttribute("surveyVO", surveyVO);
		
		return "survey/result";
	}
	
	/**
	 * 설문결과 가져오기
	 * @param surveyVO
	 * @param srvyNo
	 * @return
	 */
	@ResponseBody
	@GetMapping("/getResult")
	public SurveyVO getResult(SurveyVO surveyVO, String srvyNo) {
		surveyVO.setSrvyNo(srvyNo);
		
		surveyVO = this.surveyService.result(surveyVO);
		log.info("getResult -> {}",surveyVO);
		
		return surveyVO;
	}
	
	/**
	 * 설문 등록 페이지
	 * @return
	 */
	@GetMapping("/insert")
	public String insert() {
		
		return "survey/insert";
	}
	
	/**
	 * 설문 등록을 눌렀을 때 수행되는 메서드
	 * @param surveyVO
	 * @return
	 */
	@ResponseBody
	@PostMapping("/insertAjax")
	public String insertAjax(@RequestBody SurveyVO surveyVO) {
		log.info("survey insert -> surveyVO {}", surveyVO);
		
		int result = this.surveyService.insert(surveyVO);
		log.info("survey insert -> result {}", result);
		
		return "OK";
	}
	
	/**
	 * 진행중인 설문 마감
	 * @param srvyNo
	 * @return
	 */
	@ResponseBody
	@PostMapping("/updateStop")
	public String updateStop(@RequestBody String srvyNo) {
		
		int result = this.surveyService.updateStop(srvyNo);
		
		return "OK";
	}
	
	@ResponseBody
	@PostMapping("/delete")
	public String delete(@RequestBody String srvyNo) {
		log.info("delete -> {} , ", srvyNo);
		
		int result = this.surveyService.delete(srvyNo);
		
		return "OK";
	}
	
	@GetMapping("/update")
	public String update(SurveyVO surveyVO, Model model) {
		log.info("update -> srvyNo {}", surveyVO.getSrvyNo());
		
		surveyVO = this.surveyService.detail(surveyVO);
		
		model.addAttribute("surveyVO", surveyVO);
		
		return "survey/update";
	}
	
	@ResponseBody
	@PostMapping("/updateAjax")
	public String updateAjax(@RequestBody SurveyVO surveyVO) {
		log.info("updateAjax -> surveyVO {}", surveyVO);
		
		int result = this.surveyService.updateSurvey(surveyVO);
		
		return "OK";
	}
	
}
