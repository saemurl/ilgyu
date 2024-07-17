package com.groovit.groupware.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.groovit.groupware.vo.ApprovalCorbonCopyVO;
import com.groovit.groupware.vo.ApprovalLineVO;
import com.groovit.groupware.vo.ApprovalTemplateVO;
import com.groovit.groupware.vo.ApprovalVO;
import com.groovit.groupware.vo.OrgChartVO;
import com.groovit.groupware.vo.RelatedApprovalVO;

@Mapper
public interface ApprovalMapper {
	
	// 진행중인 최근 문서들 불러오기
	List<ApprovalVO> getAllList(ApprovalVO approvalVO);

	// 해당하는 결재양식 불러오기
	ApprovalTemplateVO getTemplate(String atCd);

	// 전자결재 상세보기
	ApprovalVO detail(ApprovalVO approvalVO);

	// 해당 문서의 첨부파일 개수 가져오기
	int getFileTotal(ApprovalVO approvalVO);
	
	// 결재양식 jsTree로 불러오기
	List<OrgChartVO> getAllTemplate();
	
	// 해당 결재자의 결재상태를 승인으로 업데이트
	int updateApprove(ApprovalLineVO approvalLineVO);
	
	// 다음 결재자가 있는지 확인
	int existNext(ApprovalLineVO approvalLineVO);

	// 다음 결재자의 결재상태를 결재예정 -> 결재대기로 변경
	void nextApprovalUpdateStts(ApprovalLineVO approvalLineVO);

	// 결재문서의 문서상태를 결재진행 -> 결재완료로 변경
	void approvalDocUpdateStts(ApprovalLineVO approvalLineVO);

	// 해당 결재자의 결재상태를 반려로 업데이트
	int updateReject(ApprovalLineVO approvalLineVO);

	// 결재 문서의 문서상태를 결재진행 -> 반려로 변경
	int approvalDocUpdateReject(ApprovalLineVO approvalLineVO);

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

	// 결재자 등록
	int setApprovalLine(ApprovalLineVO approvalLineVO);

	// 참조자 등록
	int setCorbonCopy(ApprovalCorbonCopyVO approvalCorbonCopyVO);

	// 수신참조 문서 개수 가져오기
	int getCCTotalByStts(Map<String, Object> map);

	// 수신참조 문서 리스트 가져오기
	List<ApprovalVO> getCCListByStts(Map<String, Object> map);

	// 모든 문서 리스트 가져오기
	List<ApprovalVO> getDocument(String keyword);

	// 관련문서 등록
	int setRelatedApproval(RelatedApprovalVO relatedApprovalVO);

	// 참조문서 확인으로 변경
	int updateCC(ApprovalCorbonCopyVO approvalCorbonCopyVO);

	// 해당문서의 참조문서리스트 가져오기
	List<RelatedApprovalVO> getRelatedApproval(ApprovalVO approvalVO);

	// 지난 일주일간 결재통계 가져오기 
	List<Map<String, Object>> getLastWeekStatic();

	// 임시저장 후 결재상신하는 문서인지 확인
	int checkTemp(ApprovalVO approvalVO);

	// 임시저장 문서를 결재상신으로 변경
	int update(ApprovalVO approvalVO);

	// 결재자 삭제
	int deleteAl(ApprovalVO approvalVO);

	// 참조자 삭제
	int deleteCc(ApprovalVO approvalVO);

	// 관련문서 삭제
	int deleteRel(ApprovalVO approvalVO);

	// 상신취소하면 해당 문서를 임시저장상태로 변경
	int approveCancel(ApprovalVO approvalVO);

	
}
