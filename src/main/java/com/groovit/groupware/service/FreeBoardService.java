package com.groovit.groupware.service;

import java.util.List;

import com.groovit.groupware.vo.DeclarationBoardVO;
import com.groovit.groupware.vo.FreeBoardVO;

public interface FreeBoardService {

	List<FreeBoardVO> freeBoardList();

	FreeBoardVO freeBoardDetail(FreeBoardVO freeBoardVO);
	
	
	
	
	
	
	
	
	
	
	

	int freeBoardDelete(FreeBoardVO freeBoardVO);

	int freeBoardViewCount(FreeBoardVO freeBoardVO);

	int freeBoardCreatepost(FreeBoardVO freeBoardVO);

	int freeBoardUpdatePost(FreeBoardVO freeBoardVO);

	int freeReportBoard(DeclarationBoardVO declarationBoardVO);

	int freeBoardLike(FreeBoardVO freeBoardVO);

	int freeBoardDisLike(FreeBoardVO freeBoardVO);

}
