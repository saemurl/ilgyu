package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.ApprovalCorbonCopyVO;
import com.groovit.groupware.vo.ApprovalLineVO;
import com.groovit.groupware.vo.ApprovalTemplateVO;
import com.groovit.groupware.vo.ApprovalVO;
import com.groovit.groupware.vo.OrgChartVO;
import com.groovit.groupware.vo.RelatedApprovalVO;

public interface ApprovalService {
	
	// 최근 결재진행, 결재요청 문서 불러오기
	List<ApprovalVO> getAllList(ApprovalVO approvalVO);
	
	// 결재양식별 상세 불러오기
	ApprovalTemplateVO getTemplate(String atCd);

	// 전자결재 상세보기
	ApprovalVO detail(ApprovalVO approvalVO);

	// 전자결재 첨부파일 개수 가져오기
	int getFileTotal(ApprovalVO approvalVO);

	// 결재양식 jsTree로 불러오기
	List<OrgChartVO> getAllTemplate();

	// 결재승인
	int updateApprove(ApprovalLineVO approvalLineVO);

	// 결재반려
	int updateReject(ApprovalLineVO approvalLineVO);

	// 결재진행/결재완료 문서 개수 가져오기
	int getWriteTotalByStts(Map<String, Object> map);

	// 결재진행/결재완료 리스트 가져오기
	List<ApprovalVO> getWriteListByStts(Map<String, Object> map);

	// 결재요청/결재내역/결재예정 개수 가져오기
	int getApproveTotalByStts(Map<String, Object> map);

	// 결재요청/결재내역/결재예정 리스트 가져오기
	List<ApprovalVO> getApproveListByStts(Map<String, Object> map);

	// 결재상신
	int approveSubmit(ApprovalVO approvalVO);

	// 수신참조 문서 개수 가져오기
	int getCCTotalByStts(Map<String, Object> map);

	// 수신참조 문서 리스트 가져오기
	List<ApprovalVO> getCCListByStts(Map<String, Object> map);

	// 모든 문서 가져오기
	List<ApprovalVO> getDocument(String keyword);
	
	// 참조문서 확인으로 변경
	int updateCC(ApprovalCorbonCopyVO approvalCorbonCopyVO);

	// 해당문서의 참조문서리스트 가져오기
	List<RelatedApprovalVO> getRelatedApproval(ApprovalVO approvalVO);

	// 지난 일주일간 결재통계 가져오기
	List<Map<String, Object>> getLastWeekStatic();

	// 상신취소하면 해당 문서를 임시저장상태로 변경
	int approveCancel(ApprovalVO approvalVO);

}
