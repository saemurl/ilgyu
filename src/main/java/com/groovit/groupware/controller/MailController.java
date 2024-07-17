package com.groovit.groupware.controller;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.service.MailService;
import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MailBookmarkVO;
import com.groovit.groupware.vo.MailReceiver;
import com.groovit.groupware.vo.MailSenderVO;
import com.groovit.groupware.vo.MailVO;
import com.groovit.groupware.vo.WastebasketVO;

import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/mail")
@Slf4j
@Controller
public class MailController extends BaseController{
	
	@Autowired
	MailService mailService;
	
	SimpleDateFormat formatter = new SimpleDateFormat("hh:mm a", Locale.US);
	
	@GetMapping("/inbox")
	public String fileList(Model model, Principal principal) {
		
		String empId = principal.getName();
		log.info("empId : " + empId);
		
		
		List<EmployeeVO> employeeList = this.mailService.empList(empId);
		
		log.info("employeeList : " + employeeList);
		
		
		
		model.addAttribute("employeeList", employeeList);
		
		return "mail/inbox";
	}
	
	
	@ResponseBody
	@PostMapping("/mailDetail")
	public MailVO mailDetail(@RequestBody Map<String, String> map, Principal principal) {
		
		String empId = principal.getName();
		map.put("empId", empId);
		log.info("map : " + map);
		MailVO mailVO = this.mailService.mailDetail(map);
		
		SimpleDateFormat formatted0 = new SimpleDateFormat("MMMM dd yyyy, hh:mm a", Locale.ENGLISH);
		
		Date mlSndngYmd = mailVO.getMlSndngYmd();
		log.info("mlSndngYmd : " + mlSndngYmd);
		
		String strMlSndngYmd = formatted0.format(mlSndngYmd);
		mailVO.setStrMlSndngYmd(strMlSndngYmd);
		
		log.info("mailVO : " + mailVO);
			
		
		return mailVO;
		
	}
	
	@ResponseBody
	@PostMapping("/mailSDetail")
	public MailVO mailSDetail(@RequestBody Map<String, String> map, Principal principal) {
		
		String empId = principal.getName();
		map.put("empId", empId);
		log.info("map : " + map);
		MailVO mailVO = this.mailService.mailSDetail(map);
		log.info("mailVO : " + mailVO);
		
		SimpleDateFormat formatted = new SimpleDateFormat("MMMM dd yyyy, hh:mm a", Locale.ENGLISH);
		
		Date mlSndngYmd = mailVO.getMlSndngYmd();
		log.info("mlSndngYmd : " + mlSndngYmd);
		
		String strMlSndngYmd = formatted.format(mlSndngYmd);
		mailVO.setStrMlSndngYmd(strMlSndngYmd);
		
		log.info("mailVO : " + mailVO);
		
		
		return mailVO;
		
	}
	
	@PostMapping("/mailSend")
	 public String mailSend(
	            @RequestPart("mailVO") MailVO mailVO,
	            @RequestPart("file") MultipartFile[] file,
	            Principal principal) {

        log.info("mailSend -> mailVO {}", mailVO);
        log.info("mailSend -> files {}", file);
        
        mailVO.setFile(file);
	        
	    Map<String, Object> map = new HashMap<String, Object>();
		
		String RempId = principal.getName();
		String mlSn = this.mailService.mlSn();
		log.info("mlSn >> " + mlSn);
		map.put("mlSn", mlSn);
		map.put("RempId", RempId);
		map.put("mailVO", mailVO);

		log.info("map >>>> " + map);
		
		
		int result = this.mailService.mailInsert(map);
		
		log.info("result : " + result);
		
		
		return "mail/inbox";
	}
	
	@PostMapping("/receiverW")
	public String receiverW(@RequestBody Map<String, Object> map, Principal principal) {
		
		log.info("map >> " + map);
		
		String empId = principal.getName();
		String gubun = (String) map.get("gubun");
		
		WastebasketVO wastebasketVO = new WastebasketVO();
		
		List<String> mlSnList = (List<String>) map.get("mlSnList");
		
		int result = 0;
		
		for (String mlSn : mlSnList) {
			wastebasketVO.setMlDeleter(empId);
			wastebasketVO.setMlSn(mlSn);
			wastebasketVO.setMlRSType(gubun);
			
			result += this.mailService.Wastebasket(wastebasketVO);
		}
		
		
		log.info("result >> " + result);
		
		
		return "mail/inbox";
	}
	
	@PostMapping("/restore")
	public String restore(@RequestBody Map<String, Object> map, Principal principal) {
		
		String empId = principal.getName();
		
		map.put("empId", empId);
		log.info("map : " + map);
		
		List<String> mlSnList = (List<String>) map.get("mlSnList");
		
		for (String mlSn : mlSnList) {
			map.put("mlSn", mlSn);
			
			int result = this.mailService.restore(map);
		}
		
		return "mail/inbox";
	}
	
	@PostMapping("/mlSttsUpdate")
	public String mlSttsUpdate(@RequestBody Map<String, Object> map, Principal principal) {
		
		String empId = principal.getName();
		
		map.put("empId", empId);
		
		int result = this.mailService.mlSttsUpdate(map);
		
		log.info("result : " + result);
		
		return "mail/inbox";
	}
	
	@ResponseBody
	@PostMapping("/receiverCnt")
	public int receiverCnt(Principal principal) {
		
		String empId = principal.getName();
		
		int receiverCnt = this.mailService.receiverCnt(empId);
		
		return receiverCnt;
		
	}
	
	 // 메일 답장
	 @PostMapping("/replyMailSend")
	 public String replyMailSend(
	            @RequestPart("mailVO") MailVO mailVO,
	            @RequestPart("file") MultipartFile[] file,
	            Principal principal) {

        log.info("mailSend -> mailVO {}", mailVO);
        log.info("mailSend -> files {}", file);
        
        mailVO.setFile(file);
	        
	    Map<String, Object> map = new HashMap<String, Object>();
		
		String SempId = principal.getName();
		String mlSn = this.mailService.mlSn();
		log.info("mlSn >> " + mlSn);
		map.put("mlSn", mlSn);
		map.put("SempId", SempId);
		map.put("mailVO", mailVO);
		
		log.info("map >>>> " + map);
		
		
		int result = this.mailService.replyMailSend(map);
		
		log.info("result : " + result);
		
		
		return "mail/inbox";
	}
	 
	@ResponseBody
	@PostMapping("/download")
	public List<AtchfileDetailVO> downLoad(@RequestBody String mlSn){
		
		log.info("mlSn >> " + mlSn);
		
		List<AtchfileDetailVO> files = this.mailService.download(mlSn);
		
		log.info("files >> " + files);
				
		
		return files;
	}
	
	
	@PostMapping("/bookmark")
	public String bookmark(@RequestBody Map<String, Object> map, Principal principal) {
		
		log.info("bookmark_map >> " + map);
		
		String empId = principal.getName();
		String mlRSType = (String) map.get("gubun");
		
		map.put("empId", empId);
		map.put("mlRSType", mlRSType);
		
		int result = this.mailService.bookmark(map);
		
		return "mail/inbox";
	}
	
	@ResponseBody
	@PostMapping("/wbDetail")
	public MailVO wbDetail(@RequestBody Map<String, Object> map, Principal principal) {
		
		String empId = principal.getName();
		
		map.put("empId", empId);
		
		MailVO mailVO = this.mailService.wbDetail(map);
		log.info("wbDetail_mailVO >> " + mailVO);
		
		SimpleDateFormat formatted0 = new SimpleDateFormat("MMMM dd yyyy, hh:mm a", Locale.ENGLISH);
		
		Date mlSndngYmd = mailVO.getMlSndngYmd();
		log.info("mlSndngYmd : " + mlSndngYmd);
		
		String strMlSndngYmd = formatted0.format(mlSndngYmd);
		mailVO.setStrMlSndngYmd(strMlSndngYmd);
		
		return mailVO;
		
	}
	
	@ResponseBody
	@PostMapping("/bookmarkList")
	public List<MailVO> bookmarkList(Principal principal){
		
		String empId = principal.getName();
		
		List<MailVO> bookmarkList = this.mailService.bookmarkList(empId);
		
		
		for (MailVO mailVO : bookmarkList) {
			Date mlSndngYmd = mailVO.getMlSndngYmd();
			String formattedDate = formatter.format(mlSndngYmd);
			
			mailVO.setStrMlSndngYmd(formattedDate);
		}
		log.info("bookmarkList >> " + bookmarkList);
		
		return bookmarkList;
	}
	
	@ResponseBody
	@PostMapping("/wbSelectList")
	public List<MailVO> wbSelectList(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		map.put("empId", empId);
		
		List<MailVO> wbList = this.mailService.wbSelect(map);	
		
		
		for (MailVO mailVO : wbList) {
			Date mlSndngYmd = mailVO.getMlSndngYmd();
		    String formattedDate = formatter.format(mlSndngYmd);
		        
		    mailVO.setStrMlSndngYmd(formattedDate);
		}
		
		
		log.info("wbSelectList >> " + wbList);
		
		return wbList;
	}
	
	@ResponseBody
	@PostMapping("/mailRList")
	public List<MailVO> mailRList(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		map.put("empId", empId);
		log.info("mailRList_num >> " + map);
		
		List<MailVO> mailRList = this.mailService.mailR(map);
		
		
		for (MailVO mailVO : mailRList) {
			Date mlSndngYmd = mailVO.getMlSndngYmd();
		    String formattedDate = formatter.format(mlSndngYmd);
		        
		    mailVO.setStrMlSndngYmd(formattedDate);
		}
		
		log.info("mailRList >> " + mailRList);
		
		return mailRList;
	}
	
	@ResponseBody
	@PostMapping("/mailSList")
	public List<MailVO> mailSList(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		map.put("empId", empId);
		log.info("보낸 메일함 empId >> " + empId);
		
		List<MailVO> mailSList = this.mailService.mailS(map);
		
		
		for (MailVO mailVO : mailSList) {
			Date mlSndngYmd = mailVO.getMlSndngYmd();
		    String formattedDate = formatter.format(mlSndngYmd);
		        
		    mailVO.setStrMlSndngYmd(formattedDate);
		}
		
		log.info("mailSList >> " + mailSList);
		
		return mailSList;
		
		
	}
	
	@PostMapping("/removeBookmark")
	public String removeBookmark(@RequestBody Map<String, Object> map , Principal principal) {
		
		String empId = principal.getName();
		
		map.put("empId", empId);
		log.info("removeBookmark_map >> " + map);
		
		int result = this.mailService.removeBookmark(map);
		log.info("removeBookmark_result >>" + result);
		
		return "mail/inbox";
	}
	
	
	@ResponseBody
	@PostMapping("/getBookmarks")
	public List<MailBookmarkVO> getBookmarks(Principal principal){
		
		String empId = principal.getName();
		
		List<MailBookmarkVO> mailBookmarkVOList = this.mailService.getBookmarks(empId);
		
		return mailBookmarkVOList;
	}
	
	@ResponseBody
	@PostMapping("/tsSelectList")
	public List<MailVO> tsSelectList(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		map.put("empId", empId);
		
		List<MailVO> TsaveList = this.mailService.Tsave(map); // 임시저장 메일
		
		for (MailVO mailVO : TsaveList) {
			Date mlSndngYmd = mailVO.getMlSndngYmd();
	        String formattedDate = formatter.format(mlSndngYmd);
	        
	        mailVO.setStrMlSndngYmd(formattedDate);
	        
		}
		
		log.info("tsSelectList_TsaveList : " + TsaveList);
		
		
		return TsaveList;
	}
	
	@ResponseBody
	@PostMapping("/tsMailSend")
	public MailVO tsMailSend(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		
		map.put("empId", empId);
		
		MailVO tsMailVO = this.mailService.tsMailSend(map);
		
		log.info("tsMailVO >> " + tsMailVO);
		
		return tsMailVO;
	}
	
	@ResponseBody
	@PostMapping("/tsMailFiles")
	public List<AtchfileDetailVO> tsMailFiles(@RequestBody Map<String, Object> map){
		
		List<AtchfileDetailVO> tsMailFiles = this.mailService.tsMailFiles(map);
		
		log.info("tsMailFiles >> " + tsMailFiles);
		
		return tsMailFiles;
	}
	
	
	
	
	 @PostMapping("/tsMailSendReply")
	 public String tsMailSendReply(
	            @RequestPart("mailVO") MailVO mailVO,
	            @RequestPart("file") MultipartFile[] file,
	            Principal principal) {
		 
		String SempId = principal.getName();
		
        log.info("tsMailSendReply_mailVO -> " + mailVO);
        log.info("tsMailSendReply_file -> " + file);
       
        mailVO.setFile(file);
	    
        String mlSn = mailVO.getMlSn();
        log.info("tsMailSendReply_mlSn >> " + mlSn);
        
        List<MailReceiver> MailReceiverVO = this.mailService.mailReceiverList(mlSn);
        log.info("tsMailSendReply_mailReceiverList >> " + MailReceiverVO);
        
        List<String> receiverList = new ArrayList<String>();
        
        for (MailReceiver receiverVO : MailReceiverVO) {
        	receiverList.add(receiverVO.getMlRcvr());
		}
        
        // 임시저장한 수신자 목록
        log.info("receiverList >> " + receiverList);
        
	    Map<String, Object> map = new HashMap<String, Object>();
	    
	    map.put("mailVO", mailVO); // 임시저장한 값
		map.put("SempId", SempId); // 발신자 Id
		map.put("receiverList", receiverList); // 임시저장한 수신자 목록
		
		log.info("임시저장 map => " + map);
		
		int result = this.mailService.tsMailSendReply(map);
		
		log.info("result : " + result);
		
		
		return "mail/inbox";
	}
	 
	
	@ResponseBody
	@PostMapping("/nrMailList")
	public List<MailVO> nrMailList(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		map.put("empId", empId);
		log.info("nrMailList_map >> " + map);
		
		List<MailVO> nrMailList = this.mailService.nrMailList(map);
		
		for (MailVO mailVO : nrMailList) {
			Date mlSndngYmd = mailVO.getMlSndngYmd();
	        String formattedDate = formatter.format(mlSndngYmd);
	        
	        mailVO.setStrMlSndngYmd(formattedDate);
		}
		
		log.info("nrMailList >> " + nrMailList);
		
		return nrMailList;
		
	}
	
	@PostMapping("/wbDelete")
	public String wbDelete(@RequestBody Map<String, Object> map, Principal principal) {
		
		String empId = principal.getName();
		map.put("empId", empId);
		
		int result = this.mailService.wbDelete(map);
		
		log.info("wbDelete_map >> " + map);
		
		return "mail/inbox";
	}
	
	@PostMapping("/unreadMail")
	public String unreadMail(@RequestBody Map<String, Object> map, Principal principal) {
		
		String empId = principal.getName();
		log.info("unreadMail_map >> " + map);
		
		map.put("empId", empId);
		
		int result = this.mailService.unreadMail(map);
		
		
		return "mail/inbox";
	}
	
	@ResponseBody
	@PostMapping("/mailRcnt")
	public int mailRcnt(Principal principal) {
		
		String empId = principal.getName();
		
		int cnt = this.mailService.mailRcnt(empId);
		log.info("mailRcnt_cnt => " + cnt);
		
		return cnt;
		
	}
	
	@ResponseBody
	@PostMapping("/mailScnt")
	public int mailScnt(Principal principal) {
		
		String empId = principal.getName();
		
		int cnt = this.mailService.mailScnt(empId);
		log.info("mailRcnt_cnt => " + cnt);
		
		return cnt;
		
	}
	
	@ResponseBody
	@PostMapping("/tsMailcnt")
	public int tsMailcnt(Principal principal) {
		
		String empId = principal.getName();
		
		int cnt = this.mailService.tsMailcnt(empId);
		log.info("mailRcnt_cnt => " + cnt);
		
		return cnt;
		
	}
	
	@ResponseBody
	@PostMapping("/nrMailcnt")
	public int nrMailcnt(Principal principal) {
		
		String empId = principal.getName();
		
		int cnt = this.mailService.nrMailcnt(empId);
		log.info("mailRcnt_cnt => " + cnt);
		
		return cnt;
		
	}
	
	@ResponseBody
	@PostMapping("/wbMailcnt")
	public int wbMailcnt(Principal principal) {
		
		String empId = principal.getName();
		
		int cnt = this.mailService.wbMailcnt(empId);
		log.info("mailRcnt_cnt => " + cnt);
		
		return cnt;
		
	}
	
	
	@PostMapping("/receiverDel")
	public String receiverDel(@RequestBody Map<String, Object> map) {
		
		log.info("receiverDel_map => " + map);
		
		int result = this.mailService.receiverDel(map);
		
		log.info("receiverDel_result => " + result);
		
		
		return "mail/inbox";
	}
}
