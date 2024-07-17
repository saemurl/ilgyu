package com.groovit.groupware.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.FreeBoardVO;
import com.groovit.groupware.vo.NoticeBoardVO;

@Repository
public class NoticeBoardDao {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	//공지사항 게시판 게시물 상세보기
	public NoticeBoardVO detail(NoticeBoardVO noticeBoardVO) {
		return this.sqlSessionTemplate.selectOne("noticeBoard.detail", noticeBoardVO);
	}
	
	//공지사항 게시판 게시물 등록
	public int createPost(NoticeBoardVO noticeBoardVO) {
		return this.sqlSessionTemplate.insert("noticeBoard.createPost", noticeBoardVO);
	}

	//공지사항 게시판 게시물 삭제
	public int delete(NoticeBoardVO noticeBoardVO) {
		return this.sqlSessionTemplate.delete("noticeBoard.delete", noticeBoardVO);
	}

	//공지사항 게시판 게시물 수정
	public int updatePost(NoticeBoardVO noticeBoardVO) {
		return this.sqlSessionTemplate.update("noticeBoard.updatePost", noticeBoardVO);
	}

	public List<NoticeBoardVO> noticeTable() {
		return this.sqlSessionTemplate.selectList("noticeBoard.noticeTable");
	}
}
