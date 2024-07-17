package com.groovit.groupware.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.groovit.groupware.vo.ApplicantsVO;
import com.groovit.groupware.vo.InterviewsVO;

public interface InterviewsMapper {
	// 면접 지원자 리스트
	List<InterviewsVO> getAllInterviews();
	// 상태 업데이트
	void updateStatus(@Param("intrvwId") int intrvwId, @Param("status") String status);
	// 엑셀로 내보내기
	List<InterviewsVO> getInterviewsByIds(@Param("ids") List<Integer> ids);
	// 지원자 등록
	void insertApplicant(ApplicantsVO applicantVO);
	// 면접 등록
	void insertInterview(InterviewsVO interviewVO);
}
