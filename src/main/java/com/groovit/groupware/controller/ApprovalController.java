package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.service.ApprovalService;
import com.groovit.groupware.service.MainService;
import com.groovit.groupware.util.ArticlePage;
import com.groovit.groupware.vo.ApprovalCorbonCopyVO;
import com.groovit.groupware.vo.ApprovalLineVO;
import com.groovit.groupware.vo.ApprovalTemplateVO;
import com.groovit.groupware.vo.ApprovalVO;
import com.groovit.groupware.vo.OrgChartVO;
import com.groovit.groupware.vo.RelatedApprovalVO;

import lombok.extern.slf4j.Slf4j;

/**
 * @author PC-02
 *
 */
@Slf4j
@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/approval")
@Controller
public class ApprovalController extends BaseController{
    @Autowired
    ApprovalService approvalService;
    
    
    /**
     * 전자결재 홈
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/index")
    public String approvalIndex() {
    	
        return "approval/index";
    }
    
    /**
     * 결재진행, 결재요청, 수신참조 건수 가져오기
     * @param map
     * @param approvalVO
     * @return
     */
    @ResponseBody
    @GetMapping("/getTotalBySubmenu")
    public ApprovalVO getTotalBySubmenu(Map<String, Object> map, ApprovalVO approvalVO, Principal principal) {
    	
    	String empId = principal.getName();
    	
    	String stts = "progress";
    	map.put("stts", stts);
    	map.put("empId", empId);
    	int progressTotal = this.approvalService.getWriteTotalByStts(map);
    	
    	stts = "request";
    	map.put("stts", stts);
    	int requestTotal = this.approvalService.getApproveTotalByStts(map);
    	
    	stts = "unchecked";
    	map.put("stts", stts);
    	int referenceTotal = this.approvalService.getCCTotalByStts(map);
    	
    	approvalVO.setRequestTotal(requestTotal);
    	approvalVO.setProgressTotal(progressTotal);
    	approvalVO.setReferenceTotal(referenceTotal);
    	
    	return approvalVO;
    	
    }
    
    /**
     * 결재내역 페이지
     * @param model
     * @return
     */
    @GetMapping("/details")
    public String approvalDetails(Model model) {
    	return "approval/details";
    }

    /**
     * 결재진행 페이지
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/progress")
    public String approvalProgress(Model model) {
        return "approval/progress";
    }

    /**
     * 결재완료(반려, 완료) 페이지
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/completed")
    public String approvalCompleted(Model model) {
        return "approval/completed";
    }

    /**
     * 임시저장 페이지
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/tempsave")
    public String approvalTempSave(Model model) {
        return "approval/tempSave";
    }

    /**
     * 결재요청 페이지
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/request")
    public String approvalRequest(Model model) {
        return "approval/request";
    }

    /**
     * 결재문서 상세보기
     * @param model
     * @param approvalVO
     * @return
     */
    @GetMapping("/detail")
    public String approvalDetail(Model model, ApprovalVO approvalVO) {
    	log.info("approvalDetail -> approvalVO {}", approvalVO );
    	
    	int fileTotal = this.approvalService.getFileTotal(approvalVO);
    	log.info("approvalDetail -> fileTotal {}", fileTotal );
    	
    	approvalVO = this.approvalService.detail(approvalVO);
    	log.info("approvalDetail -> approvalVO {}",approvalVO );
    	
    	List<RelatedApprovalVO> relatedApprovalList = this.approvalService.getRelatedApproval(approvalVO);
    	
    	
    	model.addAttribute("approvalVO", approvalVO);         
    	model.addAttribute("fileTotal", fileTotal);         
    	model.addAttribute("relatedApprovalList", relatedApprovalList);         
    	
        return "approval/detail";
    }

    /**
     * 결재예정 페이지
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/upcoming")
    public String approvalUpcoming(Model model, HttpServletRequest request) {
        return "approval/upcoming";
    }

    @GetMapping("/proxy")
    public String approvalProxy(Model model, HttpServletRequest request) {
        return "approval/proxy";
    }

    /**
     * 수신참조 페이지
     * @param model
     * @param request
     * @return
     */
    @GetMapping("/reference")
    public String approvalReference(Model model) {
        return "approval/reference";
    }

    @GetMapping("/docbox")
    public String approvalDocBox(Model model, HttpServletRequest request) {
        return "approval/docbox";
    }
    
    /**
     * 최근 문서 리스트 조회  
     * @return
     */
    @ResponseBody
    @GetMapping("/getAllList")
    public List<ApprovalVO> getAllList(Principal principal){
    	ApprovalVO approvalVO = new ApprovalVO();
    	String empId = principal.getName();
    	approvalVO.setEmpId(empId);
    	List<ApprovalVO> list = this.approvalService.getAllList(approvalVO);
    	log.info("getAllList -> {}", list);
    	return list;
    }
    
    /**
     * 결재진행 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getProgressList")
    public ArticlePage<ApprovalVO> getProgressList(int currentPage, String keyword, Map<String, Object> map, Principal principal){
    	String stts = "progress";
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	//{currentURI=/approval/getProgressList, empId=202312310004, stts=progress, currentPage=1}
    	log.info("getProgressList->map : " + map);
    	
    	int total = this.approvalService.getWriteTotalByStts(map);
    	//total : 4
    	log.info("getProgressList->total : " + total);
    	
    	List<ApprovalVO> progressList = this.approvalService.getWriteListByStts(map);
    	log.info("getProgressList->progressList : " + progressList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, progressList, keyword);
    }
    
    /**
     * 결재완료 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getCompletedList")
    public ArticlePage<ApprovalVO> getCompletedList(int currentPage, String keyword, String stts, Map<String, Object> map, Principal principal){
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	log.info("getCompletedList->map : " + map);
    	
    	int total = this.approvalService.getWriteTotalByStts(map);
    	log.info("getCompletedList->total : " + total);
    	
    	List<ApprovalVO> completedList = this.approvalService.getWriteListByStts(map);
    	log.info("getCompletedList->progressList : " + completedList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, completedList, keyword, map);
    }
    
    /**
     * 임시저장 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getTempSaveList")
    public ArticlePage<ApprovalVO> getTempSaveList(int currentPage, String keyword, String stts, Map<String, Object> map, Principal principal){
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	log.info("getTempSaveList->map : " + map);
    	
    	int total = this.approvalService.getWriteTotalByStts(map);
    	log.info("getTempSaveList->total : " + total);
    	
    	List<ApprovalVO> tempSaveList = this.approvalService.getWriteListByStts(map);
    	log.info("getTempSaveList->tempSaveList : " + tempSaveList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, tempSaveList, keyword);
    }
    
    /**
     * 결재요청 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getRequestList")
    public ArticlePage<ApprovalVO> getRequestList(int currentPage, String keyword, Map<String, Object> map, Model model, Principal principal){
    	String stts = "request";
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	log.info("getRequestList->map : " + map);
    	
    	int total = this.approvalService.getApproveTotalByStts(map);
    	log.info("getRequestList->total : " + total);
    	model.addAttribute("requestTotal", total);
    	
    	List<ApprovalVO> requestList = this.approvalService.getApproveListByStts(map);
    	log.info("getRequestList->requestList : " + requestList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, requestList, keyword);
    }
    
    /**
     * 결재예정 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getUpcomingList")
    public ArticlePage<ApprovalVO> getUpcomingList(int currentPage, String keyword, Map<String, Object> map, Principal principal){
    	String stts = "pending";
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	log.info("getUpcomingList->map : " + map);
    	
    	int total = this.approvalService.getApproveTotalByStts(map);
    	log.info("getUpcomingList->total : " + total);
    	
    	List<ApprovalVO> upcomingList = this.approvalService.getApproveListByStts(map);
    	log.info("getUpcomingList->upcomingList : " + upcomingList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, upcomingList, keyword, map);
    }
    
    /**
     * 결재내역 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getDetailsList")
    public ArticlePage<ApprovalVO> getDetailsList(int currentPage, String keyword, String stts,  Map<String, Object> map, Principal principal){
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	log.info("getDetailsList->map : " + map);
    	
    	int total = this.approvalService.getApproveTotalByStts(map);
    	log.info("getDetailsList->total : " + total);
    	
    	List<ApprovalVO> detailsList = this.approvalService.getApproveListByStts(map);
    	log.info("getDetailsList->detailsList : " + detailsList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, detailsList, keyword, map);
    }
    
    /**
     * 수신참조 리스트 가져오기
     * @param currentPage
     * @param map
     * @return
     */
    @ResponseBody
    @GetMapping("/getReferenceList")
    public ArticlePage<ApprovalVO> getReferenceList(int currentPage, String keyword, String stts,  Map<String, Object> map, Principal principal){
    	String empId = principal.getName();
    	map.put("empId", empId);
    	map.put("stts", stts);
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	log.info("getReferenceList->map : " + map);
    	
    	int total = this.approvalService.getCCTotalByStts(map);
    	log.info("getReferenceList->total : " + total);
    	
    	List<ApprovalVO> referenceList = this.approvalService.getCCListByStts(map);
    	log.info("getReferenceList->referenceList : " + referenceList);
    	
    	return new ArticlePage<ApprovalVO>(total, currentPage, 6, referenceList, keyword, map);
    }
    
    /**
     * 새 결재 페이지
     * @return
     */
    @GetMapping("/new")
    public String newForm() {
    	
    	return "approval/new";
    }
    
    /**
     * 완료된 결재문서 가져오기
     * @param keyword
     * @return
     */
    @ResponseBody
    @GetMapping("/getDocument")
    public List<ApprovalVO> getDocument(String keyword) {
    	log.info("getDocument keyword -> {} ", keyword);
    	
    	 List<ApprovalVO> approvalVOList = this.approvalService.getDocument(keyword);
    	 log.info("getDocument approvalVOList -> {} ", approvalVOList);
    	
    	return approvalVOList;
    	
    }
    
    /**
     * 결재상신했을 때 실행되는 메서드
     * @param av
     * @param approvalVO
     * @return
     */
    @ResponseBody
    @PostMapping("/submit")
    public String approveSubmit(ApprovalVO av, @RequestPart("approvalVO") ApprovalVO approvalVO) {
    	log.info("approveSubmit -> approvalVO {}", approvalVO);
    	log.info("approveSubmit -> av {}", av);
    	approvalVO.setFile(av.getFile());
    	
    	for (ApprovalLineVO approvalLineVO : approvalVO.getApprovalLineList()) {
    		log.info("approveSubmit -> approvalLineVO {}", approvalLineVO);
		}
    	
    	if(approvalVO.getCorbonCopyList().size() > 0) {
	    	for (ApprovalCorbonCopyVO approvalCorbonCopyVO : approvalVO.getCorbonCopyList()) {
	    		log.info("approveSubmit -> approvalCorbonCopyVO {}", approvalCorbonCopyVO);
	    	}
    	}
    	
    	if(approvalVO.getRelatedApprovalList().size() > 0) {
    		for (RelatedApprovalVO relatedApprovalVO : approvalVO.getRelatedApprovalList()) {
    			log.info("approveSubmit -> relatedApprovalVO {}", relatedApprovalVO);
    		}
    	}
    	
    	if(approvalVO.getAprvrDocNo() != null) {
    		log.info("임시저장/재기안 문서");
    	}else {
    		log.info("새결재 문서");
    	}
    	
    	int result = this.approvalService.approveSubmit(approvalVO);
    	log.info("approveSubmit -> result {}", result);
    	return "OK";
    }
    
    
    
    /**
     * 모든 결재양식 불러오기
     * @return
     */
    @ResponseBody
    @GetMapping("/getTemplateList")
    public List<OrgChartVO> getTemplateList(){
    	List<OrgChartVO> templateList = this.approvalService.getAllTemplate();
    	log.info("getTemplateList -> {}", templateList);
    	return templateList;
    }
    
    /**
     * atCd별로 결재양식 불러오기
     * @param atCd
     * @return
     */
    @ResponseBody
    @GetMapping(value = "/{atCd}")
    public ApprovalTemplateVO getTemplate(@PathVariable String atCd) {
    	log.info("getTemplate -> {}",atCd);
    	ApprovalTemplateVO approvalTemplateVO = this.approvalService.getTemplate(atCd);
    	
    	return approvalTemplateVO;
    }
    
    /**
     * 결재승인을 눌렀을 때 수행되는 메서드
     * @param approvalLineVO
     * @return
     */
    @ResponseBody
    @PostMapping("/approve")
    public String approve(@RequestBody ApprovalLineVO approvalLineVO) {
    	log.info("approve -> approvalLineVO {}", approvalLineVO);
    	
    	int result = this.approvalService.updateApprove(approvalLineVO);
    	log.info("approve -> result {}", result);
    	return "OK";
    }
    
    /**
     * 결재반려를 눌렀을 때 수행되는 메서드
     * @param approvalLineVO
     * @return
     */
    @ResponseBody
    @PostMapping("/reject")
    public String reject(@RequestBody ApprovalLineVO approvalLineVO) {
    	log.info("approve -> approvalLineVO {}", approvalLineVO);
    	
    	int result = this.approvalService.updateReject(approvalLineVO);
    	log.info("approve -> result {}", result);
    	return "OK";
    }
    
    /**
     * 수신참조 문서 클릭하면 확인으로 변경
     * @param approvalCorbonCopyVO
     * @return
     */
    @ResponseBody
    @PostMapping("/updateCC")
    public String updateCC(@RequestBody ApprovalCorbonCopyVO approvalCorbonCopyVO) {
    	
    	log.info("reference -> approvalCorbonCopyVO {}", approvalCorbonCopyVO);
    	int result = this.approvalService.updateCC(approvalCorbonCopyVO);
    	
    	return "OK";
    }
    
    /**
     * 재기안 페이지
     * @param aprvrDocNo
     * @param approvalVO
     * @param model
     * @return
     */
    @GetMapping("/reapply/{aprvrDocNo}")
    public String reapply(@PathVariable(name = "aprvrDocNo") String aprvrDocNo, ApprovalVO approvalVO, Model model) {
    	approvalVO.setAprvrDocNo(aprvrDocNo);
    	
    	approvalVO = this.approvalService.detail(approvalVO);
    	log.info("reapply -> {}", approvalVO);
    	
    	model.addAttribute("approvalVO", approvalVO);
    	
    	return "approval/recreate";
    }
    
    @ResponseBody
    @GetMapping("/getLastWeekStatic")
    public List<Map<String, Object>> getLastWeekStatic(){
    	List<Map<String, Object>> staticList = this.approvalService.getLastWeekStatic();
    	
    	log.info("getLastWeekStatic {}",staticList);
    	
    	return staticList;
    }
    
    @ResponseBody
    @PostMapping("/approveCancel")
    public String approveCancel(@RequestBody ApprovalVO approvalVO) {
    	log.info("approveCancel {}",approvalVO.getAprvrDocNo());
    	
    	int result = this.approvalService.approveCancel(approvalVO);
    	log.info("approveCancel -> 결과 {}", result);
    	
    	return "OK";
    }
    
}
