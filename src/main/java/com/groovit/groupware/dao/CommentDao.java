package com.groovit.groupware.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.CommentDeclarationVO;
import com.groovit.groupware.vo.CommentVO;

@Repository
public class CommentDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	

	public List<CommentVO> commentList(CommentVO commentVO) {
		return this.sqlSessionTemplate.selectList("comment.commentList", commentVO);
	}


	public int commentCreate(CommentVO commentVO) {
		return this.sqlSessionTemplate.insert("comment.commentCreate", commentVO);
	}


	public int commentReport(CommentDeclarationVO commentDeclarationVO) {
		return this.sqlSessionTemplate.insert("comment.commentReport", commentDeclarationVO);
	}


	public int commentDelete(CommentVO commentVO) {
		return this.sqlSessionTemplate.delete("comment.commentDelete", commentVO);
	}


	public int commentUpdate(CommentDeclarationVO commentDeclarationVO) {
		return this.sqlSessionTemplate.update("comment.commentUpdate",commentDeclarationVO);
	}

}
