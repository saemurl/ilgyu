package com.groovit.groupware.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.FreeBoardDao;
import com.groovit.groupware.service.FreeBoardService;
import com.groovit.groupware.vo.DeclarationBoardVO;
import com.groovit.groupware.vo.FreeBoardVO;


@Service
public class FreeBoardServiceImpl implements FreeBoardService {

	@Autowired
	FreeBoardDao freeBoardDao;
	
	
	@Override
	public List<FreeBoardVO> freeBoardList() {
		return this.freeBoardDao.freeBoardList();
	}


	@Override
	public FreeBoardVO freeBoardDetail(FreeBoardVO freeBoardVO) {
		int result = this.freeBoardDao.freeBoardViewCount(freeBoardVO);
		
		if (result != 0) {
			return this.freeBoardDao.freeBoardDetail(freeBoardVO);
		}
		return this.freeBoardDao.freeBoardDetail(freeBoardVO);
	}


	@Override
	public int freeBoardDelete(FreeBoardVO freeBoardVO) {
		return this.freeBoardDao.freeBoardDelete(freeBoardVO);
	}


	@Override
	public int freeBoardViewCount(FreeBoardVO freeBoardVO) {
		return this.freeBoardDao.freeBoardViewCount(freeBoardVO);
	}


	@Override
	public int freeBoardCreatepost(FreeBoardVO freeBoardVO) {
		return this.freeBoardDao.freeBoardCreatepost(freeBoardVO);
	}


	@Override
	public int freeBoardUpdatePost(FreeBoardVO freeBoardVO) {
		return this.freeBoardDao.freeBoardUpdatePost(freeBoardVO);
	}


	@Override
	public int freeReportBoard(DeclarationBoardVO declarationBoardVO) {
		int result = this.freeBoardDao.freeReportBoard(declarationBoardVO);
		if (result >0) {
			this.freeBoardDao.freeReportBoardUpdata(declarationBoardVO);
		}
		
		return result; 
	}


	@Override
	public int freeBoardLike(FreeBoardVO freeBoardVO) {
		return this.freeBoardDao.freeBoardLike(freeBoardVO);
	}


	@Override
	public int freeBoardDisLike(FreeBoardVO freeBoardVO) {
		return this.freeBoardDao.freeBoardDisLike(freeBoardVO);
	}

}
