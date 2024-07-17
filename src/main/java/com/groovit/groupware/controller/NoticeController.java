package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.groovit.groupware.service.EventBoardService;
import com.groovit.groupware.service.FreeBoardService;
import com.groovit.groupware.service.NoticeBoardService;
import com.groovit.groupware.vo.DeclarationBoardVO;
import com.groovit.groupware.vo.EventBoardVO;
import com.groovit.groupware.vo.FreeBoardVO;
import com.groovit.groupware.vo.MarriageVO;
import com.groovit.groupware.vo.NoticeBoardVO;
import com.groovit.groupware.vo.ObituaryVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/board")
@Controller
public class NoticeController extends BaseController {

	@Autowired
	private NoticeBoardService noticeBoardService;

	// 공지사항 게시판 이동
	@GetMapping("/noticeList")
	public String list(Model model) {
		return "noticeBoard/list";
	}
	
	// 공지사항 게시판 테이블 출력
	@GetMapping("/noticeTable")
	@ResponseBody
	public List<NoticeBoardVO> noticeTable() {
		
		List<NoticeBoardVO> noticeBoardVOList = this.noticeBoardService.noticeTable();
		log.info("공지사항 게시판 조회 : " + noticeBoardVOList);
		
		return noticeBoardVOList;
	}
	

	// 공지사항 게시판 게시물 상세보기
	@GetMapping("/noticeDetail")
	public String detail(NoticeBoardVO noticeBoardVO, Model model, Principal principal) {
		log.info("noticeBoardDetail");
		log.info("noticeBoardDetail -> noticeBoardVO : " + noticeBoardVO);

		String empId = principal.getName();
		log.info("로그인 정보 -> empId : " + empId);

		noticeBoardVO = this.noticeBoardService.detail(noticeBoardVO);
		log.info("조회 결과 -> noticeBoardVO : " + noticeBoardVO);

		model.addAttribute("empId", empId);
		model.addAttribute("noticeBoardVO", noticeBoardVO);

		return "noticeBoard/detail";
	}

	// 공지사항 게시판 게시물 등록
	@GetMapping("/noticeCreate")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String create() {
		return "noticeBoard/create";
	}

	@ResponseBody
	@PostMapping("/noticeCreatePost")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public NoticeBoardVO createPost(@RequestBody NoticeBoardVO noticeBoardVO, Principal principal) {
		log.info("noticeCreatePost => noticeBoardVO : " + noticeBoardVO);
		String empId = principal.getName();
		log.info("empId" + empId);
		noticeBoardVO.setNtcFrstRgtr(empId);
		noticeBoardVO.setNtcLastRgtr(empId);
		int result = this.noticeBoardService.createPost(noticeBoardVO);
		log.info("result : " + result);
		return noticeBoardVO;
	}

	// 공지사항 게시판 게시물 삭제
	@ResponseBody
	@PostMapping("/noticeDelete")
	public NoticeBoardVO delete(@RequestBody NoticeBoardVO noticeBoardVO) {
		log.info("noticeBoardDelete");
		log.info("noticeBoardDelete -> noticeBoardVO : " + noticeBoardVO);
		int result = this.noticeBoardService.delete(noticeBoardVO);
		log.info("결과 -> result : " + result);
		return noticeBoardVO;
	}

	// 공지사항 게시판 게시물 수정
	@GetMapping("/noticeUpdate")
	public String update(NoticeBoardVO noticeBoardVO, Model model) {
		log.info("noticeBoardUpdate");
		log.info("noticeBoardUpdate -> noticeBoardVO : " + noticeBoardVO);
		noticeBoardVO = this.noticeBoardService.detail(noticeBoardVO);
		model.addAttribute("noticeBoardVO", noticeBoardVO);
		log.info("noticeBoardVO : " + noticeBoardVO);
		return "noticeBoard/update";
	}

	@ResponseBody
	@PostMapping("/noticeUpdatePost")
	private NoticeBoardVO updatePost(@RequestBody NoticeBoardVO noticeBoardVO, Principal principal) {

		log.info("noticeUpdatePost");
		log.info("noticeUpdatePost -> noticeBoardVO :{}", noticeBoardVO);

		String empId = principal.getName();
		log.info("empId : {}", empId);

		// Null 체크 추가
		if (noticeBoardVO.getNtcNo() == null || noticeBoardVO.getNtcTtl() == null || noticeBoardVO.getNtcCn() == null) {
			throw new IllegalArgumentException("필수 값이 누락되었습니다.");
		}

		noticeBoardVO.setNtcLastRgtr(empId);
		log.info("noticeUpdatePost -> noticeBoardVO : {}", noticeBoardVO);

		log.info("noticeBoardService : {}", noticeBoardService);
		log.info("noticeBoardService : {}", this.noticeBoardService);

		int result = noticeBoardService.noticeUpdate(noticeBoardVO);

		log.info("noticeUpdatePost -> noticeBoardVO : ", noticeBoardVO);
		log.info("result : {}" + result);

		return noticeBoardVO;
	}

}
