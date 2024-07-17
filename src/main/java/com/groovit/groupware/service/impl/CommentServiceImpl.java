package com.groovit.groupware.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.CommentDao;
import com.groovit.groupware.service.CommentService;
import com.groovit.groupware.vo.CommentDeclarationVO;
import com.groovit.groupware.vo.CommentVO;


@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	CommentDao commentDao;
	
	
	@Override
	public List<CommentVO> commentList(CommentVO commentVO) {
		return this.commentDao.commentList(commentVO);
	}



	@Override
	public int commentCreate(CommentVO commentVO) {
		return this.commentDao.commentCreate(commentVO);
	}



	@Override
	public int commentReport(CommentDeclarationVO commentDeclarationVO) {
		int result = this.commentDao.commentReport(commentDeclarationVO);
		if (result > 0 ) {
			this.commentDao.commentUpdate(commentDeclarationVO);
		}
		return result;
	}



	@Override
	public int commentDelete(CommentVO commentVO) {
		return this.commentDao.commentDelete(commentVO);
	}

}
