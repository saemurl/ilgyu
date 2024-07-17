package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.EventBoardVO;
import com.groovit.groupware.vo.MarriageVO;
import com.groovit.groupware.vo.ObituaryVO;

@Repository
public class EventBoardDao {

    @Autowired
    SqlSessionTemplate sqlSessionTemplate;

    // 결혼 테이블 출력
    public List<EventBoardVO> loadMarryTable() {
    	return this.sqlSessionTemplate.selectList("eventBoard.loadMarryTable");
	}
    
    // 부고 테이블 출력
    public List<EventBoardVO> loadRipTable() {
		return this.sqlSessionTemplate.selectList("eventBoard.loadRipTable");
	}

    // 경조사게시판 상세 출력
    public EventBoardVO detail(Map<String, Object> map) {
        return this.sqlSessionTemplate.selectOne("eventBoard.detail", map);
    }

    // 결혼 게시글 등록
    public int mrgCreateBoard(EventBoardVO eventBoardVO) {
		return this.sqlSessionTemplate.insert("eventBoard.mrgCreateBoard", eventBoardVO);
	}
    
    // 게시판 PK 값 가져오는 용도
    public String selectEvtbNo() {
		return this.sqlSessionTemplate.selectOne("eventBoard.selectEvtbNo");
	}
    
    // 결혼 게시글 내용 등록
    public int mrgInsertData(MarriageVO marriageVO) {
		return this.sqlSessionTemplate.insert("eventBoard.mrgInsertData", marriageVO);
	}
    
    // 경조사 게시글 파일업로드 (marriageVO)
    public int eventBoardAtchfileSn(MarriageVO marriageVO) {
		return this.sqlSessionTemplate.update("eventBoard.eventBoardAtchfileSn", marriageVO);
	}
    
    // 경조사 게시글 파일업로드 (obituaryVO)
    public int obtBoardAtchfileSn(ObituaryVO obituaryVO) {
		return this.sqlSessionTemplate.update("eventBoard.obtBoardAtchfileSn", obituaryVO);
	}
    
    // 부고 게시글 등록
    public int obtCreateBoard(EventBoardVO eventBoardVO) {
    	return this.sqlSessionTemplate.insert("eventBoard.obtCreateBoard", eventBoardVO);
	}
    // 부고 게시글 내용 등록
    public int obtInsertData(ObituaryVO obituaryVO) {
		return this.sqlSessionTemplate.insert("eventBoard.obtInsertData", obituaryVO);
	}

    // 결혼 게시글 상세
    public MarriageVO selectMrg(String evtbNo) {
    	return this.sqlSessionTemplate.selectOne("eventBoard.selectMrg", evtbNo);
    }

    // 부고 게시글 상세
    public ObituaryVO selectObt(String evtbNo) {
    	return this.sqlSessionTemplate.selectOne("eventBoard.selectObt", evtbNo);
	}

	public EventBoardVO selectBoard(String evtbNo) {
		return this.sqlSessionTemplate.selectOne("eventBoard.selectBoard", evtbNo);
	}

	public String selectObtImg(String obtIvt) {
		return this.sqlSessionTemplate.selectOne("eventBoard.selectObtImg", obtIvt);
	}

	public String selectMrgImg(String mrgIvt) {
		return this.sqlSessionTemplate.selectOne("eventBoard.selectMrgImg", mrgIvt);
	}

	public int clickCnt(String evtbNo) {
		return this.sqlSessionTemplate.update("eventBoard.clickCnt", evtbNo);
	}

	public int deleteMrg(String evtbNo) {
		return this.sqlSessionTemplate.delete("eventBoard.deleteMrg", evtbNo);
	}

	public int deleteTable(String evtbNo) {
		return this.sqlSessionTemplate.delete("eventBoard.deleteTable", evtbNo);
	}

	public int deleteObt(String evtbNo) {
		return this.sqlSessionTemplate.delete("eventBoard.deleteObt", evtbNo);
	}

	public int mrgUpdateData(MarriageVO marriageVO) {
		return this.sqlSessionTemplate.update("eventBoard.mrgUpdateData", marriageVO);
	}

	public int AtchfileSnUpdate(MarriageVO marriageVO) {
		return this.sqlSessionTemplate.update("eventBoard.AtchfileSnUpdate", marriageVO);
	}

	public int obtUpdatetData(ObituaryVO obituaryVO) {
		return this.sqlSessionTemplate.update("eventBoard.obtUpdatetData",obituaryVO);
	}

	public int obtAtchfileSnUpdate(ObituaryVO obituaryVO) {
		return this.sqlSessionTemplate.update("eventBoard.obtAtchfileSnUpdate",obituaryVO);
	}

   

    
    
    
    
    
    
    
    

	

	

	

	

}
