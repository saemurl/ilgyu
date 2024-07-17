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

import com.groovit.groupware.service.DeclarationService;

import lombok.extern.slf4j.Slf4j;


@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@Controller
@RequestMapping("/declare")
public class DeclarationController extends BaseController{

	@Autowired
	DeclarationService declarationService;
	
	@GetMapping("/boardList")
	public String declareBoardList(Model model) {
		log.info("declareBoardList 에 왔다");
		
		List<Map<String, Object>> declareBoardList = this.declarationService.declareBoardList();
		log.debug("declareBoardList"+declareBoardList);
		model.addAttribute("declareBoardList",declareBoardList);
		
		return "declare/boardList";
	}
	
	
	@ResponseBody
	@PostMapping("/declareBoardDetail")
	public Map<String, Object> declareBoardDetail(Model model , @RequestBody String dclrNo) {
		log.info("dclrNo" + dclrNo);
		
		Map<String, Object> declareBoardDetail = this.declarationService.declareBoardDetail(dclrNo);
		log.info("declareBoardDetail" + declareBoardDetail);
		
		return declareBoardDetail;
	}
	
	
	@ResponseBody
	@PostMapping("/declareBoardCnt")
	public int declareBoardCnt(@RequestBody Map<String, Object> dclrBoardInfo) {
		log.info("dclrBoardInfo" + dclrBoardInfo);
		
		int result = this.declarationService.declareBoardCnt(dclrBoardInfo);
		log.info("result" + result);
		
		return result;
	}
	
	
	@ResponseBody
	@PostMapping("/declareBoardCount")
	public List<Map<String, Object>> declareBoardCount() {
		
		List<Map<String, Object>> declareBoardCountList = this.declarationService.declareBoardCount();
		log.info("declareBoardCount => result" + declareBoardCountList);
		
		return declareBoardCountList;
	}
	
	@ResponseBody
	@PostMapping("/declareBoardCountType")
	public List<Map<String, Object>> declareBoardCountType() {
		
		List<Map<String, Object>> declareBoardCountTypeList = this.declarationService.declareBoardCountType();
		log.info("declareBoardCount => result" + declareBoardCountTypeList);
		
		return declareBoardCountTypeList;
	}
	
	
	
	
	
	@ResponseBody
	@PostMapping("/declareDefaultList")
	public List<Map<String, Object>> declareDefaultList() {
		
		List<Map<String, Object>> declareDefaultList = this.declarationService.declareBoardList();
		log.info("declareCateList => result" + declareDefaultList);
		
		return declareDefaultList;
	}
	
	@ResponseBody
	@PostMapping("/declareCateList")
	public List<Map<String, Object>> declareCateList(@RequestBody Map<String, Object> declareCateList) {
		
		List<Map<String, Object>> declareResultList = this.declarationService.declareCateList(declareCateList);
		log.info("declareCateList => result" + declareResultList);
		
		return declareResultList;
	}
	
	
	
	
	
	
	
	
	
	
	
	@ResponseBody
	@PostMapping("/declareCommentCount")
	public List<Map<String, Object>> declareCommentCount() {
		
		List<Map<String, Object>> declareCommentCount = this.declarationService.declareCommentCount();
		log.info("declareBoardCount => result" + declareCommentCount);
		
		return declareCommentCount;
	}
	
	@ResponseBody
	@PostMapping("/declareCommentCountType")
	public List<Map<String, Object>> declareCommentCountType() {
		
		List<Map<String, Object>> declareCommentCountType = this.declarationService.declareCommentCountType();
		log.info("declareBoardCount => result" + declareCommentCountType);
		
		return declareCommentCountType;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@GetMapping("/commentList")
	public String commentList() {
		log.info("declareCommentList 에 왔다");
		
		return "declare/commentList";
	}
	
	@ResponseBody
	@PostMapping("/declareCommentList")
	public List<Map<String, Object>> declareCommentList() {
		
		List<Map<String, Object>> declareCommentList = this.declarationService.declareCommentList();
		log.info("declareCateList => result" + declareCommentList);
		
		return declareCommentList;
	}
	
	@ResponseBody
	@PostMapping("/declareCommentCateList")
	public List<Map<String, Object>> declareCommentCateList(@RequestBody Map<String, Object> commentCate) {
		
		List<Map<String, Object>> declareCommentCate = this.declarationService.declareCommentCateList(commentCate);
		log.info("declareCateList => result" + declareCommentCate);
		
		return declareCommentCate;
	}
	
	
	@ResponseBody
	@PostMapping("/declareCommentDetail")
	public Map<String, Object> declareCommentDetail(@RequestBody String dcNo) {
		
		Map<String, Object> declareCommentDetail = this.declarationService.declareCommentDetail(dcNo);
		log.info("declareCateList => result" + declareCommentDetail);
		
		return declareCommentDetail;
	}
	
	@ResponseBody
	@PostMapping("/declareCommentCnt")
	public int declareCommentCnt(@RequestBody Map<String, Object> map) {
		
		int result = this.declarationService.declareCommentCnt(map);
		log.info("declareCateList => result" + result);
		
		return result;
	}
	
	
	
	
	
	
}
