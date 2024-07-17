package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.groovit.groupware.service.EventBoardService;
import com.groovit.groupware.vo.EventBoardVO;
import com.groovit.groupware.vo.MarriageVO;
import com.groovit.groupware.vo.ObituaryVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/board")
@Controller
public class EventBoardController extends BaseController {

	@Autowired
	EventBoardService eventBoardService;
	
	// 경조사 게시판 입장
	@GetMapping("/eventList")
	public String eventList(Model model, Principal principal) {
		String empId = principal.getName();
		log.info("경조사게시판 접속 회원 ID 체크 : " + empId);
		
		model.addAttribute("empId", empId);
		
		return "eventBoard/list";
	}
	
	// 결혼 게시판 테이블 출력용 ----------------------------------------------------------------------------------------------
	@GetMapping("/loadMarryTable")
	@ResponseBody
	public List<EventBoardVO> loadMarryTable() {
		
		List<EventBoardVO> eventBoardVOList = this.eventBoardService.loadMarryTable();
		
		log.info("컨트롤러 _ 경조사 결혼 테이블 값 출력 : " + eventBoardVOList);
		
		return eventBoardVOList; 
	};
	
	// 부고 게시판 테이블 출력용 ----------------------------------------------------------------------------------------------
	@GetMapping("/loadRipTable")
	@ResponseBody
	public List<EventBoardVO> loadRipTable() {
		
		List<EventBoardVO> eventBoardVOList = this.eventBoardService.loadRipTable();
		
		log.info("컨트롤러 _ 경조사 부고 테이블 값 출력 : " + eventBoardVOList);
		
		return eventBoardVOList; 
	};
	
	// 게시판 등록 페이지 이동 ------------------------------------------------------------------------------------------------
	@GetMapping("/eventCreate")
	public String create(Model model) {
		log.info("경조사 게시판 create 페이지 이동 체크");
		return "eventBoard/create";
	}

	// 결혼 게시글 등록 ----------------------------------------------------------------------------------------------------
	@PostMapping("/mrgCreate")
	@ResponseBody
	public int mrgCreate(
			@RequestParam("title") String title,
	        @RequestParam("mrgDt") String mrgDt,
	        @RequestParam("mrgAddress") String mrgAddress,
	        @RequestParam("mrgDaddr") String mrgDaddr,
	        @RequestParam("mrgCon") String mrgCon,
	        @RequestParam("UploadFile") MultipartFile file, Principal principal) {
		
		String empId = principal.getName();
		
		Map<String, Object> param = new HashMap<>();
	    param.put("title", title);
	    param.put("mrgDt", mrgDt);
	    param.put("mrgAddress", mrgAddress);
	    param.put("mrgDaddr", mrgDaddr);
	    param.put("mrgCon", mrgCon);
	    param.put("uploadFile", file);
	    param.put("empId", empId);
	    
	    int result = this.eventBoardService.mrgCreate(param);
		
		return result;
	}
	
	// 부고 게시글 등록 -------------------------------------------------------------------------------------------------------
	@PostMapping("/obtCreate")
	@ResponseBody
	public int obtCreate(
			@RequestParam("title") String title,
			@RequestParam("obtDmDt") String obtDmDt,
			@RequestParam("obtFpDt") String obtFpDt,
			@RequestParam("obtAddress") String obtAddress,
			@RequestParam("obtDaddr") String obtDaddr,
			@RequestParam("obtCon") String obtCon,
			@RequestParam("UploadFile") MultipartFile file, Principal principal
			) {
		
		String empId = principal.getName();
		
		Map<String, Object> param = new HashMap<>();
		param.put("empId", empId);
	    param.put("title", title);
	    param.put("obtDmDt", obtDmDt);
	    param.put("obtFpDt", obtFpDt);
	    param.put("obtAddress", obtAddress);
	    param.put("obtDaddr", obtDaddr);
	    param.put("obtCon", obtCon);
	    param.put("uploadFile", file);
	    
	    int result = this.eventBoardService.obtCreate(param);
	    
		return result;
	}
	
	// 게시글 상세 페이지 --------------------------------------------------------------------------------------------------------
	@GetMapping("/detail")
    public String detail(@RequestParam("evtbNo") String evtbNo
    					,@RequestParam("evtbSe") String evtbSe 
    					,Model model, Principal principal) {

	   String empId = principal.getName();
       
       log.info("상세페이지로 접속한 아이디 : " + empId + ", 상세페이지 글 번호 : " + evtbNo + ", 해당 글 분류 코드 : " + evtbSe);
       
       model.addAttribute("evtbSe", evtbSe);	// detail 페이지에서 구분하려고 챙겨가는 용도
       model.addAttribute("loginEmpId", empId);
       
       // 결혼 글일 때
       if ("E01".equals(evtbSe)) { 
           
    	   EventBoardVO eventBoardVO = new EventBoardVO();
    	   eventBoardVO = this.eventBoardService.selectBoard(evtbNo);
    	   log.info("선택된 게시글 정보 : " + eventBoardVO);
    	   model.addAttribute("eventBoardVO", eventBoardVO);
    	   
           MarriageVO marriageVO = new MarriageVO();
           marriageVO = this.eventBoardService.selectMrg(evtbNo);
           log.info("선택된 결혼 글 내용 : " + marriageVO);
           model.addAttribute("marriageVO", marriageVO);
           
           String mrgIvt = marriageVO.getMrgIvt();
           String imgPath = this.eventBoardService.selectMrgImg(mrgIvt);
           model.addAttribute("imgPath", imgPath);
       }

       // 부고 글일 때
       if ("E02".equals(evtbSe)) {

    	   EventBoardVO eventBoardVO = new EventBoardVO();
    	   eventBoardVO = this.eventBoardService.selectBoard(evtbNo);
    	   log.info("선택된 게시글 정보 : " + eventBoardVO);
    	   model.addAttribute("eventBoardVO", eventBoardVO);
    	   
    	   ObituaryVO obituaryVO = new ObituaryVO();
    	   obituaryVO = this.eventBoardService.selectObt(evtbNo);
    	   log.info("선택된 결혼 글 내용 : " + obituaryVO);
    	   model.addAttribute("obituaryVO", obituaryVO);
    	   
    	   String obtIvt = obituaryVO.getObtIvt() ;
    	   String imgPath = this.eventBoardService.selectObtImg(obtIvt);
    	   model.addAttribute("imgPath", imgPath);
       }
    	
       
       
       return "eventBoard/detail";
    }
	
	// 결혼 게시글 삭제 --------------------------------------------------------------------------------------------------------
	@PostMapping("/deleteMrg")
	@ResponseBody
	public int deleteMrg(@RequestBody EventBoardVO eventBoardVO) {
		
		String evtbNo = eventBoardVO.getEvtbNo();
		log.info("결혼 게시글 삭제 번호 체크 : " + evtbNo);
		
		int result = this.eventBoardService.deleteMrg(evtbNo);
		
		return result;
	}
		
	// 부고 게시글 삭제 --------------------------------------------------------------------------------------------------------
	@PostMapping("/deleteObt")
	@ResponseBody
	public int deleteObt(@RequestBody EventBoardVO eventBoardVO) {
		
		String evtbNo = eventBoardVO.getEvtbNo();
		log.info("부고 게시글 삭제 번호 체크 : " + evtbNo);
		
		int result = this.eventBoardService.deleteObt(evtbNo);
		
		return result;
	}

	// 경조사 게시글 수정 페이지 이동 --------------------------------------------------------------------------------------------------
	@GetMapping("/update")
	public String mrgUpdate(@RequestParam String evtbNo, Model model) {
		
		EventBoardVO eventBoardVO = this.eventBoardService.selectBoard(evtbNo);
		model.addAttribute("eventBoardVO", eventBoardVO);
		
		if("E01".equals(eventBoardVO.getEvtbSe())) {
			MarriageVO marriageVO = this.eventBoardService.selectMrg(evtbNo);
			model.addAttribute("marriageVO", marriageVO);
			
			String mrgIvt = marriageVO.getMrgIvt();
			String imgPath = this.eventBoardService.selectMrgImg(mrgIvt);
			model.addAttribute("imgPath", imgPath);
		}
		
		if("E02".equals(eventBoardVO.getEvtbSe())) {
			ObituaryVO obituaryVO = this.eventBoardService.selectObt(evtbNo);
			model.addAttribute("obituaryVO", obituaryVO);
			
			String obtIvt = obituaryVO.getObtIvt() ;
			String imgPath = this.eventBoardService.selectObtImg(obtIvt);
    	   	model.addAttribute("imgPath", imgPath);
		}
		
		return "eventBoard/update";
	}
	
	// 결혼 게시글 수정  --------------------------------------------------------------------------------------------------
	@PostMapping("/mrgUpdate")
	@ResponseBody
	public int mrgUpdate(
			@RequestParam("evtbNo") String evtbNo,
			@RequestParam("title") String title,
	        @RequestParam("mrgDt") String mrgDt,
	        @RequestParam("mrgAddress") String mrgAddress,
	        @RequestParam("mrgDaddr") String mrgDaddr,
	        @RequestParam("mrgCon") String mrgCon,
	        @RequestPart(value = "UploadFile", required = false) MultipartFile file, Principal principal) {
		
		String empId = principal.getName();
		
		Map<String, Object> param = new HashMap<>();
		param.put("evtbNo", evtbNo);
	    param.put("title", title);
	    param.put("mrgDt", mrgDt);
	    param.put("mrgAddress", mrgAddress);
	    param.put("mrgDaddr", mrgDaddr);
	    param.put("mrgCon", mrgCon);
	    param.put("empId", empId);

	    if (file != null && !file.isEmpty()) {
	    	param.put("uploadFile", file);
	    }
	    
	    int result = this.eventBoardService.mrgUpdate(param);
		
		return result;
	}
	
	// 부고 게시글 수정  --------------------------------------------------------------------------------------------------
	@PostMapping("/obtUpdate")
	@ResponseBody
	public int obtUpdate(
			@RequestParam("evtbNo") String evtbNo,
			@RequestParam("title") String title,
			@RequestParam("obtDmDt") String obtDmDt,
			@RequestParam("obtFpDt") String obtFpDt,
			@RequestParam("obtAddress") String obtAddress,
			@RequestParam("obtDaddr") String obtDaddr,
			@RequestParam("obtCon") String obtCon,
			@RequestPart(value = "UploadFile", required = false) MultipartFile file, Principal principal ) {
		
		String empId = principal.getName();
		
		log.info("evtbNo 값 오나요? " + evtbNo);
		
		Map<String, Object> param = new HashMap<>();
		param.put("evtbNo", evtbNo);
	    param.put("title", title);
	    param.put("obtDmDt", obtDmDt);
	    param.put("obtFpDt", obtFpDt);
	    param.put("obtAddress", obtAddress);
	    param.put("obtDaddr", obtDaddr);
	    param.put("obtCon", obtCon);
	    param.put("empId", empId);

	    if (file != null && !file.isEmpty()) {
	    	param.put("uploadFile", file);
	    }

	    int result = this.eventBoardService.obtUpdate(param);
		
		return result;
	}
			
	
	
	
}