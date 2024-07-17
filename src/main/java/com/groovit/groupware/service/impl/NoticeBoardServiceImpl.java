package com.groovit.groupware.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.NoticeBoardDao;
import com.groovit.groupware.service.NoticeBoardService;
import com.groovit.groupware.vo.NoticeBoardVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeBoardServiceImpl implements NoticeBoardService {

	@Autowired
	NoticeBoardDao noticeBoardDao;
	
	//공지사항 게시판 게시물 상세보기
	@Override
	public NoticeBoardVO detail(NoticeBoardVO noticeBoardVO) {
		return this.noticeBoardDao.detail(noticeBoardVO);
	}

	//공지사항 게시판 게시물 등록
	@Override
	public int createPost(NoticeBoardVO noticeBoardVO) {
		return this.noticeBoardDao.createPost(noticeBoardVO);
	}
	
	//공지사항 게시판 게시물 삭제
	@Override
	public int delete(NoticeBoardVO noticeBoardVO) {
		return this.noticeBoardDao.delete(noticeBoardVO);
	}

	//공지사항 게시판 게시물 수정
	@Override
	public int noticeUpdate(NoticeBoardVO noticeBoardVO) {
		log.info("왔다");
		return this.noticeBoardDao.updatePost(noticeBoardVO);
	}

	@Override
	public List<NoticeBoardVO> noticeTable() {
		return this.noticeBoardDao.noticeTable();
	}




}
