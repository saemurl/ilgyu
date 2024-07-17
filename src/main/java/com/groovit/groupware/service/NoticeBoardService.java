package com.groovit.groupware.service;

import java.util.List;

import com.groovit.groupware.vo.NoticeBoardVO;

public interface NoticeBoardService {

	//공지사항 게시판 게시물 상세보기
	public NoticeBoardVO detail(NoticeBoardVO noticeBoardVO);
	
	//공지사항 게시판 게시말 등록
	public int createPost(NoticeBoardVO noticeBoardVO);

	//공지사항 게시판 게시물 삭제
	public int delete(NoticeBoardVO noticeBoardVO);

	//공지사항 게시판 게시물 수정
	public int noticeUpdate(NoticeBoardVO noticeBoardVO);

	public List<NoticeBoardVO> noticeTable();
}
