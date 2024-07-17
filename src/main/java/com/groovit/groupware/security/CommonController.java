package com.groovit.groupware.security;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.groovit.groupware.mapper.AtchfileMapper;
import com.groovit.groupware.mapper.EmployeeMapper;
import com.groovit.groupware.service.EmailService;
import com.groovit.groupware.service.MailServiceInter;
import com.groovit.groupware.service.impl.RegisterMail;
import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommonController {
	
	// DI / IoC
    // passwordEncoder 객체는 security-context.xml의 bean에 등록되어 있음
    @Autowired
    PasswordEncoder passwordEncoder;
    
    @Autowired
    EmployeeMapper employeeMapper;
    
    @Autowired
    EmailService emailService;
    
    //골뱅이Autowired
    //RegisterMail registerMail;
	
    @Autowired
    MailServiceInter registerMail;
    
    @Autowired 
    AtchfileMapper atchfileMapper;
    
    
	//접근 거부 처리
	//요청URI : /accessError
	//요청방식 : get
	@GetMapping("/accessError")
	public String accessError(Authentication auth, Model model) {
		log.info("accessError->auth : " + auth);
		model.addAttribute("msg", "Access Denied");
		
		//forwarding : jsp
		return "security/accessError";
	}
	
	/*사용자 정의 로그인 페이지 사용
	요청URL : /login
			 /login?error=error
			 /login?logout=logout
	요청방식 : get
	*/
	@GetMapping("/login")
	public String login(String error, String logout, Model model, Authentication authentication) {
				
		//오류 발생 시
		if(error!=null) {
			model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
		}
		
		if(logout!=null) {
			model.addAttribute("logout", "성공적으로 로그아웃되었습니다.");
		}
		
		if (authentication != null && authentication.isAuthenticated()) {
            User user = (User) authentication.getPrincipal();
            String username = user.getUsername();
            EmployeeVO employee = employeeMapper.getEmployeeById(username);
            if (employee != null) {
                String encodedPwd = employee.getEmpPass();
                log.info("encodedPwd : " + encodedPwd);
                model.addAttribute("encodedPwd", encodedPwd);
            }
        }
        
		//forwarding : jsp
		return "loginForm";
	}
	
	@GetMapping("/searchId")
    public String searchId(EmployeeVO employeeVO, Model model) {
		log.info("searchId -> {}", employeeVO);
		return "searchId";
    }
	
	@PostMapping("/searchId")
    public String searchIdPost(@RequestParam("empNm") String empNm, 
                               @RequestParam("empBrdt") String empBrdtStr, 
                               @RequestParam("empTelno") String empTelno, 
                               Model model) {
        try {
            // String을 java.sql.Date로 변환
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = sdf.parse(empBrdtStr);
            java.sql.Date empBrdt = new java.sql.Date(utilDate.getTime());

            //log.info("searchIdPost -> empNm: {}", empNm);
    		//log.info("searchIdPost -> empBrdt: {}", empBrdt);
    		//log.info("searchIdPost -> empTelno: {}", empTelno);
    		//empNm: 오병준
    		//empBrdt: 1995-11-03
    		//empTelno: 010-9894-5687
            List<EmployeeVO> employeeVOList = employeeMapper.findEmployeeByNameBirthdateAndPhone(empNm, empBrdt, empTelno);
            if (employeeVOList != null && !employeeVOList.isEmpty()) {
                model.addAttribute("employeeVO", employeeVOList.get(0));
            } else {
                model.addAttribute("message", "해당 정보와 일치하는 사용자를 찾을 수 없습니다");
            }
        } catch (ParseException e) {
            log.error("Error parsing date", e);
            model.addAttribute("message", "Invalid date format.");
        } catch (Exception e) {
            log.error("Error finding employee by name, birthdate, and phone", e);
            model.addAttribute("message", "Error occurred while searching for ID.");
        }
        return "searchId";
    }

    @GetMapping("/searchPw")
    public String searchPw() {
        return "searchPw";
    }
    
    @PostMapping("/searchPw")
    public String searchPwPost(@RequestParam("empId") String empId,
                               @RequestParam("empEml") String empEml,
                               Model model) {
    	log.info("searchPwPost->empId : " + empId + "searchPwPost->empEml : " + empEml);
        try {
        	//그 직원 1행
            EmployeeVO employee = employeeMapper.findEmployeeByIdAndEmail(empId, empEml);
            if (employee != null) {
                //String newPassword = generateRandomPassword();                
                //******* 메일 전송 *******
                //old => emailService.sendSimpleMessage(employee.getEmpMail(), "비밀번호 재설정", "새 비밀번호는: " + newPassword);
                String code = registerMail.sendSimpleMessage(empEml);
                System.out.println("사용자에게 발송한 인증코드 ==> " + code);
                
                //DB의 비밀번호 변경 시행
                employee.setEmpPass(passwordEncoder.encode(code));                
                employeeMapper.updateEmployee(employee);
                
                log.info("searchPwPost->employee : " + employee);

                model.addAttribute("message", "새 비밀번호가 이메일로 전송되었습니다");
            } else {
                model.addAttribute("message", "해당 정보와 일치하는 사용자를 찾을 수 없습니다");
            }
        } catch (Exception e) {
            log.error("Error resetting password", e);
            model.addAttribute("message", "비밀번호 재설정 중 오류가 발생했습니다");
        }
        return "searchPw";
    }

    //랜덤 비밀번호 생성 로직
    private String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[16];
        random.nextBytes(bytes);
        String password = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        return password.substring(0, 12);
    }
    
    
    @GetMapping(path = "/download/{id}/{dId}")
    public void fileDownload(@PathVariable(name = "id") String fileId, @PathVariable(name = "dId") String detailId, HttpServletResponse response, Map<String, Object> map) throws IOException {
        
    	map.put("atchfileSn", fileId);
    	map.put("atchfileDetailSn", detailId);
    	
    	// 파일 정보를 가지고 오기
    	AtchfileDetailVO atchfileDetailVO = this.atchfileMapper.getFileInfo(map);
    	
    	// 원본파일명
    	String originalName = atchfileDetailVO.getAtchfileDetailLgclfl();
    	
    	// 저장된 파일명
        String fileName = atchfileDetailVO.getAtchfileDetailPhyscl();
        
        // 폴더까지 지정되어 있는 파일명 가져와서
        StringBuilder sb = new StringBuilder("C:\\upload\\");
        // 파일 저장되어 있는 경로뒤에 붙여줘서
        sb.append(fileName);
        // saveFileName을 만든다.
        String saveFileName = sb.toString();
        
        File file = new File(saveFileName);
        // 데이터베이스에 없는 정보는 파일로 만들어서 가져온다. 이 경우엔 Content-Length 가져온 것
        long fileLength = file.length();
 
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(originalName, "UTF-8").replaceAll("\\+", "%20") + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary"); 
        response.setHeader("Content-Length", "" + fileLength);
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");
        // 그 정보들을 가지고 reponse의 Header에 세팅한 후
        
        try (FileInputStream fis = new FileInputStream(saveFileName); OutputStream out = response.getOutputStream();) {
            // saveFileName을 파라미터로 넣어 inputStream 객체를 만들고 
            // response에서 파일을 내보낼 OutputStream을 가져와서  
            int readCount = 0;
            byte[] buffer = new byte[1024];
            // 파일 읽을 만큼 크기의 buffer를 생성한 후 
            while ((readCount = fis.read(buffer)) != -1) {
                out.write(buffer, 0, readCount);
                // outputStream에 씌워준다
            }
        } catch (Exception ex) {
            throw new RuntimeException("file Load Error");
        }
 
    }
    
    @GetMapping("/view/{id}")
    public void viewFile(@PathVariable(name = "id") String empId, HttpServletResponse response) {
    	EmployeeVO employeeVO = this.employeeMapper.getEmployeeById(empId);
    	AtchfileDetailVO empFile = employeeVO.getAtchfileDetailVOList().get(0);
    	String fileName =  empFile.getAtchfileDetailPhysclPath();
    	if(fileName == null) fileName = "/default-profile.png";
        StringBuilder sb = new StringBuilder("C:\\upload");
        // 파일 저장되어 있는 경로뒤에 붙여줘서
        sb.append(fileName);
        // saveFileName을 만든다.
        String saveFileName = sb.toString();
        
        File file = new File(saveFileName);
    			
        BufferedInputStream bin = null;
        BufferedOutputStream bout = null;
        if(file.exists()) {	// 이미지 파일이 있을 때...
        	try {
        		// 출력용 스트림
        		bout = new BufferedOutputStream(response.getOutputStream());
    					
        		// 파일 입력용 스트림
        		bin = new BufferedInputStream(new FileInputStream(file));
    					
        		byte[] temp = new byte[1024];
        		int len = 0;
    					
        		while( (len = bin.read(temp)) > 0) {
        			bout.write(temp, 0, len);
        		}
        		bout.flush();
    					
        	} catch (Exception e) {
        		System.out.println("입출력 오류 : " + e.getMessage());
        	} finally {
        		if(bin!=null) try { bin.close(); }catch(IOException e) {}
        		if(bout!=null) try { bout.close(); }catch(IOException e) {}
        	}
        }
    }
    
}