package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.mapper.ApprovalMapper;
import com.groovit.groupware.service.ApprovalService;
import com.groovit.groupware.util.UploadController;
import com.groovit.groupware.vo.ApprovalCorbonCopyVO;
import com.groovit.groupware.vo.ApprovalLineVO;
import com.groovit.groupware.vo.ApprovalTemplateVO;
import com.groovit.groupware.vo.ApprovalVO;
import com.groovit.groupware.vo.OrgChartVO;
import com.groovit.groupware.vo.RelatedApprovalVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ApprovalServiceImpl implements ApprovalService {

	@Autowired
	ApprovalMapper approvalMapper;
	
	@Autowired
	UploadController uploadController;
	
	@Override
	public List<ApprovalVO> getAllList(ApprovalVO approvalVO) {
		return this.approvalMapper.getAllList(approvalVO);
	}

	@Override
	public ApprovalTemplateVO getTemplate(String atCd) {
		return this.approvalMapper.getTemplate(atCd);
	}

	@Override
	public ApprovalVO detail(ApprovalVO approvalVO) {
		return this.approvalMapper.detail(approvalVO);
	}

	@Override
	public int getFileTotal(ApprovalVO approvalVO) {
		return this.approvalMapper.getFileTotal(approvalVO);
	}

	@Override
	public List<OrgChartVO> getAllTemplate() {
		return this.approvalMapper.getAllTemplate();
	}

	@Override
	public int updateApprove(ApprovalLineVO approvalLineVO) {
		// 다음 결재자가 있는지 확인
		int result = this.approvalMapper.existNext(approvalLineVO);
		
		if(result > 0) {
			// 있으면 다음 결재자의 결재상태를 결재예정 -> 결재대기로 변경
			this.approvalMapper.nextApprovalUpdateStts(approvalLineVO);
		}else {
			// 없다면(마지막 결재자이므로) 해당 결재문서의 상태를 결재완료로 변경
			this.approvalMapper.approvalDocUpdateStts(approvalLineVO);
		}
		// 결재 승인을 누른 결재자의 결재상태를 결재대기 -> 승인으로 변경 
		return this.approvalMapper.updateApprove(approvalLineVO);
	}

	@Override
	public int updateReject(ApprovalLineVO approvalLineVO) {
		int result = 0;
		
		// 반려를 누른 결재자의 결재상태를 결재대기 -> 반려로 변경
		result += this.approvalMapper.updateReject(approvalLineVO);
		
		// 해당 결재문서의 상태를 반려로 변경
		result += this.approvalMapper.approvalDocUpdateReject(approvalLineVO);
		
		return result;
	}

	@Override
	public int getWriteTotalByStts(Map<String, Object> map) {
		return this.approvalMapper.getWriteTotalByStts(map);
	}

	@Override
	public List<ApprovalVO> getWriteListByStts(Map<String, Object> map) {
		return this.approvalMapper.getWriteListByStts(map);
	}

	@Override
	public int getApproveTotalByStts(Map<String, Object> map) {
		return this.approvalMapper.getApproveTotalByStts(map);
	}

	@Override
	public List<ApprovalVO> getApproveListByStts(Map<String, Object> map) {
		return this.approvalMapper.getApproveListByStts(map);
	}

	@Override
	public int approveSubmit(ApprovalVO approvalVO) {
		int result = 0;
		
		MultipartFile[] file = approvalVO.getFile();
		
		log.info("approveSubmit -> {}", file);
		
		// 첨부파일이 있으면 파일업로드 로직
		if(file != null) {
			String atchfileSn = this.uploadController.uploadMulti(file, approvalVO.getEmpId());
			approvalVO.setAtchfileSn(atchfileSn);
		}
		
		int checkTemp = this.approvalMapper.checkTemp(approvalVO);
		// 임시저장 후 결재상신한 문서라면
		if(approvalVO.getAprvrDocNo() != null && checkTemp > 0) {
			// 기존 문서를 업데이트하고
			result += this.approvalMapper.update(approvalVO);
			// 결재자, 참조자, 관련문서 삭제
			result += this.approvalMapper.deleteAl(approvalVO);
			result += this.approvalMapper.deleteCc(approvalVO);
			result += this.approvalMapper.deleteRel(approvalVO);
    	}else {
    		result += this.approvalMapper.approveSubmit(approvalVO);
    	}
		
		// 결재자 등록
		for (ApprovalLineVO approvalLineVO : approvalVO.getApprovalLineList()) {
			approvalLineVO.setAprvrDocNo(approvalVO.getAprvrDocNo());
			result += this.approvalMapper.setApprovalLine(approvalLineVO);
		}
		
		// 만약 참조자가 있으면 참조자 등록
		if(approvalVO.getCorbonCopyList().size() > 0) {
	    	for (ApprovalCorbonCopyVO approvalCorbonCopyVO : approvalVO.getCorbonCopyList()) {
	    		approvalCorbonCopyVO.setAprvrDocNo(approvalVO.getAprvrDocNo());
	    		result += this.approvalMapper.setCorbonCopy(approvalCorbonCopyVO);
	    	}
		}
		
		// 만약 관련문서가 있다면 관련문서 등록
		if(approvalVO.getRelatedApprovalList().size() > 0) {
			for (RelatedApprovalVO relatedApprovalVO : approvalVO.getRelatedApprovalList()) {
				relatedApprovalVO.setAprvrDocNo(approvalVO.getAprvrDocNo());
				result += this.approvalMapper.setRelatedApproval(relatedApprovalVO);
    		}
		}
		return result;
	}

	@Override
	public int getCCTotalByStts(Map<String, Object> map) {
		return this.approvalMapper.getCCTotalByStts(map);
	}

	@Override
	public List<ApprovalVO> getCCListByStts(Map<String, Object> map) {
		return this.approvalMapper.getCCListByStts(map);
	}

	@Override
	public List<ApprovalVO> getDocument(String keyword) {
		return this.approvalMapper.getDocument(keyword);
	}

	@Override
	public int updateCC(ApprovalCorbonCopyVO approvalCorbonCopyVO) {
		return this.approvalMapper.updateCC(approvalCorbonCopyVO);
	}

	@Override
	public List<RelatedApprovalVO> getRelatedApproval(ApprovalVO approvalVO) {
		return this.approvalMapper.getRelatedApproval(approvalVO);
	}

	@Override
	public List<Map<String, Object>> getLastWeekStatic() {
		return this.approvalMapper.getLastWeekStatic();
	}

	@Override
	public int approveCancel(ApprovalVO approvalVO) {
		return this.approvalMapper.approveCancel(approvalVO);
	}

}
