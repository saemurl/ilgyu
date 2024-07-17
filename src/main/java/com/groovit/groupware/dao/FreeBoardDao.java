package com.groovit.groupware.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.DeclarationBoardVO;
import com.groovit.groupware.vo.FreeBoardVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class FreeBoardDao {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public List<FreeBoardVO> freeBoardList() {
		return this.sqlSessionTemplate.selectList("freeBoard.freeBoardList");
	}

	public int freeBoardDelete(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.delete("freeBoard.freeBoardDelete", freeBoardVO);
	}
	
	public FreeBoardVO freeBoardDetail(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.selectOne("freeBoard.freeBoardDetail", freeBoardVO);
	}

	public int freeBoardViewCount(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.update("freeBoard.freeBoardViewCount", freeBoardVO);
	}

	public int freeBoardCreatepost(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.insert("freeBoard.freeBoardCreatePost",freeBoardVO);
	}

	public int freeBoardUpdatePost(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.update("freeBoard.freeBoardUpdatePost", freeBoardVO);
	}

	public int freeReportBoard(DeclarationBoardVO declarationBoardVO) {
		return this.sqlSessionTemplate.insert("freeBoard.freeReportBoard", declarationBoardVO);
	}

	public int freeBoardLike(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.update("freeBoard.freeBoardLike", freeBoardVO);
	}

	public int freeBoardDisLike(FreeBoardVO freeBoardVO) {
		return this.sqlSessionTemplate.update("freeBoard.freeBoardDisLike", freeBoardVO);
	}

	public int freeReportBoardUpdata(DeclarationBoardVO declarationBoardVO) {
		return	this.sqlSessionTemplate.update("freeBoard.freeReportBoardUpdata", declarationBoardVO);
	}

}
