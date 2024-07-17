package com.groovit.groupware.service;

import java.util.List;

import com.groovit.groupware.vo.CommentDeclarationVO;
import com.groovit.groupware.vo.CommentVO;

public interface CommentService {

	List<CommentVO> commentList(CommentVO commentVO);

	int commentCreate(CommentVO commentVO);

	int commentReport(CommentDeclarationVO commentDeclarationVO);

	int commentDelete(CommentVO commentVO);

}
