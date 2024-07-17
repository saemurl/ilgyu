package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.CommentService;
import com.groovit.groupware.vo.CommentDeclarationVO;
import com.groovit.groupware.vo.CommentVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/comment")
@Controller
public class CommentController extends BaseController{

	@Autowired
	CommentService commentService;
	
	
	@ResponseBody
	@PostMapping("/create")
	public CommentVO commentCreate(@RequestBody CommentVO commentVO , Principal principal) {
		log.info("commentList 에 왔다.");
		log.info("commentList => freeBoardVO : " + commentVO);
		
		String empId = principal.getName();
		log.info("로그인 정보 => empId : " + empId);
		commentVO.setEmpId(empId);
		
		int result = this.commentService.commentCreate(commentVO);
		log.info("commentList => result : " + result);
		
		return commentVO;
	}
	
	@ResponseBody
	@PostMapping("/list")
	public List<CommentVO> commentList(@RequestBody CommentVO commentVO ) {
		log.info("commentList 에 왔다.");
		log.info("commentList => freeBoardVO : " + commentVO);
		
		List<CommentVO>  CommentVOList= this.commentService.commentList(commentVO);
		log.info("commentList => CommentVOList : " + CommentVOList);
		
		return CommentVOList;
	}
	
	@ResponseBody
	@PostMapping("/delete")
	public CommentVO commentDelete(@RequestBody CommentVO commentVO) {
		log.info("commentList 에 왔다.");
		log.info("commentList => freeBoardVO : " + commentVO);
		
		int result = this.commentService.commentDelete(commentVO);
		log.info("commentList => result : " + result);
		
		return commentVO;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
//	--------------------------------------------댓글 신고 시작--------------------------------------------
	@ResponseBody
	@PostMapping("/declaration")
	public CommentDeclarationVO Declaration(@RequestBody CommentDeclarationVO commentDeclarationVO , Principal principal) {
		log.info("commentList 에 왔다.");
		log.info("commentList => freeBoardVO : " + commentDeclarationVO);
		
		String empId = principal.getName();
		log.info("로그인 정보 => empId : " + empId);
		commentDeclarationVO.setEmpId(empId);
		
		int result = this.commentService.commentReport(commentDeclarationVO);
		log.info("commentList => result : " + result);
		
		return commentDeclarationVO;
	}
//	--------------------------------------------댓글 신고 끝--------------------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
