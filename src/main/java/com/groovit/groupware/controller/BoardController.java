package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.FreeBoardService;
import com.groovit.groupware.vo.DeclarationBoardVO;
import com.groovit.groupware.vo.FreeBoardVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/board")
@Controller
public class BoardController extends BaseController {

	@Autowired
	private FreeBoardService freeBoardService;
	
	// 자유게시판 이동
	@GetMapping("/freeList")
	public String freeBoardAllList(Model model) {
		return "freeBoard/list";
	}
	
	// 자유게시판 테이블 출력
	@GetMapping("/freeTable")
	@ResponseBody
	public List<FreeBoardVO> freeTable(){
		
		List<FreeBoardVO> freeBoardVOList = this.freeBoardService.freeBoardList();
		log.info("자유 게시판 조회 : " + freeBoardVOList);
		
		return freeBoardVOList;
	}
	
	

	// --------------------------자유게시판 디테일 시작--------------------------
	@GetMapping("/freeDetail")
	public String freeBoardDetail(Model model, FreeBoardVO freeBoardVO, Principal principal) {
		log.info("freeBoardDetail 에 왔다.");
		log.info("freeBoardDetail => freeBoardVO : " + freeBoardVO);

		String empId = principal.getName();
		log.info("로그인 정보 => empId : " + empId);

		freeBoardVO = this.freeBoardService.freeBoardDetail(freeBoardVO);
		log.info("조회 결과 => freeBoardVO : " + freeBoardVO);
//		int result = this.freeBoardService.freeBoardViewCount(freeBoardVO);
//		log.info("조회 결과 => result : " + result);
		model.addAttribute("empId", empId);
		model.addAttribute("freeBoardVO", freeBoardVO);

		return "freeBoard/detail";
	}
	// --------------------------자유게시판 디테일 끝--------------------------

	// --------------------------자유게시판 업데이트 시작--------------------------
	@GetMapping("/freeUpdate")
	public String freeBoardUpdate(

			Model model, FreeBoardVO freeBoardVO

	) {
		log.info("freeBoardUpdate 에 왔다.");
		log.info("freeBoardUpdate => freeBoardVO : " + freeBoardVO);

		freeBoardVO = this.freeBoardService.freeBoardDetail(freeBoardVO);

		log.info("조회 결과 => freeBoardVO : " + freeBoardVO);
		model.addAttribute("freeBoardVO", freeBoardVO);

		return "freeBoard/update";
	}

	@ResponseBody
	@PostMapping("/freeUpdatePost")
	public FreeBoardVO freeBoardUpdatePost(@RequestBody FreeBoardVO freeBoardVO, Principal principal) {
		log.info("freeUpdatePost 에 왔다.");
		log.info("freeUpdatePost => freeBoardVO : " + freeBoardVO);

		String empId = principal.getName();
		log.info("로그인 정보 => empId : " + empId);
		freeBoardVO.setFbLastRgtr(empId);
		int result = this.freeBoardService.freeBoardUpdatePost(freeBoardVO);
		log.info("freeUpdatePost결과 => freeBoardVO : " + freeBoardVO);
		log.info("결과 => result : " + result);

		return freeBoardVO;
	}

	// --------------------------자유게시판 업데이트 끝--------------------------

	// --------------------------자유게시판 삭제 시작--------------------------
	@ResponseBody
	@PostMapping("/freeDelete")
	public FreeBoardVO freeBoardDelete(@RequestBody FreeBoardVO freeBoardVO) {
		log.info("freeBoardDelete 에 왔다.");
		log.info("freeBoardDelete => freeBoardVO : " + freeBoardVO);

		int result = this.freeBoardService.freeBoardDelete(freeBoardVO);

		log.info("결과 => result : " + result);

		return freeBoardVO;
	}

	// --------------------------자유게시판 삭제 끝--------------------------

	// --------------------------자유게시판 생성 시작--------------------------
	@GetMapping("/freeCreate")
	public String freeBoardCreate() {
		return "freeBoard/create";
	}

	@ResponseBody
	@PostMapping("/freeCreatePost")
	public FreeBoardVO freeBoardCreatePost(@RequestBody FreeBoardVO freeBoardVO, Principal principal) {
		log.info("freeBoardCreatePost => freeBoardVO : " + freeBoardVO);
		String empId = principal.getName();
		log.info("empId" + empId);
		freeBoardVO.setFbFrstWrtr(empId);
		freeBoardVO.setFbLastRgtr(empId);
		int result = this.freeBoardService.freeBoardCreatepost(freeBoardVO);
		log.info("result : " + result);
		return freeBoardVO;
	}

	// --------------------------자유게시판 생성 끝--------------------------

	// --------------------------자유게시판 신고 시작--------------------------
	@ResponseBody
	@PostMapping("/freeReportBoard")
	public DeclarationBoardVO freeReportBoard(@RequestBody DeclarationBoardVO declarationBoardVO, Principal principal) {
		log.info("freeBoardCreatePost => declarationBoardVO : " + declarationBoardVO);
		String empId = principal.getName();
		log.info("empId" + empId);
		declarationBoardVO.setEmpId(empId);

		int result = this.freeBoardService.freeReportBoard(declarationBoardVO);
		log.info("result : " + result);

		return declarationBoardVO;
	}
	// --------------------------자유게시판 신고 끝--------------------------

	// --------------------------자유게시판 좋아요 시작--------------------------
	@ResponseBody
	@PostMapping("/freeBoardLike")
	public FreeBoardVO freeBoardLike(@RequestBody FreeBoardVO freeBoardVO) {
		log.info("freeBoardLike 에 왔다.");
		log.info("freeBoardLike => freeBoardVO : " + freeBoardVO);

		int result = this.freeBoardService.freeBoardLike(freeBoardVO);

		log.info("결과 => result : " + result);

		return freeBoardVO;
	}
	// --------------------------자유게시판 좋아요 끝--------------------------

	// --------------------------자유게시판 싫어요 시작--------------------------
	@ResponseBody
	@PostMapping("/freeBoardDisLike")
	public FreeBoardVO freeBoardDisLike(@RequestBody FreeBoardVO freeBoardVO) {
		log.info("freeBoardDisLike 에 왔다.");
		log.info("freeBoardDisLike => freeBoardVO : " + freeBoardVO);

		int result = this.freeBoardService.freeBoardDisLike(freeBoardVO);

		log.info("결과 => result : " + result);

		return freeBoardVO;
	}
	// --------------------------자유게시판 싫어요 끝--------------------------

	// --------------------------아작스 디테일 끝--------------------------
	@ResponseBody
	@PostMapping("/ajaxDetail")
	public FreeBoardVO ajaxDetail(@RequestBody FreeBoardVO freeBoardVO) {
		log.info("ajaxDetail 에 왔다.");
		log.info("ajaxDetail => freeBoardVO : " + freeBoardVO);

		freeBoardVO = this.freeBoardService.freeBoardDetail(freeBoardVO);
		log.info("ajaxDetail 조회 결과 => freeBoardVO : " + freeBoardVO);

		return freeBoardVO;
	}
	// --------------------------아작스 디테일 끝--------------------------
}
