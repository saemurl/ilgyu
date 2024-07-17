package com.groovit.groupware.util;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.groovit.groupware.mapper.AtchfileMapper;
import com.groovit.groupware.vo.AtchfileDetailVO;
import com.groovit.groupware.vo.AtchfileVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UploadController {

	//static String uploadFolder => null이 메모리에 올라가
	@Autowired
	String uploadFolder;

	//c:\\upload
	@Autowired
	String uploadFolderDirect;

	//static AttachDao attachDao => null이 메모리에 올라가
	@Autowired
	AtchfileMapper atchfileMapper;

	//첨부파일 1개 업로드								파일객체     ,	파일 등록자
	public String uploadOne(MultipartFile uploadFile, String empId) {
		String atchfileSn = "";
		int result = 0;

		log.info("------------------");
		log.info("파일명 : " + uploadFile.getOriginalFilename());
		log.info("파일크기 : " + uploadFile.getSize());
		log.info("MIME : " + uploadFile.getContentType());

		String uploadFileName = uploadFile.getOriginalFilename();

		//UUID : 랜덤값 생성
		UUID uuid = UUID.randomUUID();
		//asdfsafd_개똥이.jpg
		uploadFileName = uuid.toString() + "_" + uploadFileName;

		//복사 설계
		File saveFile = new File(uploadFolderDirect, uploadFileName);

		int index = 0;

		String extension = "";

		try {
			uploadFile.transferTo(saveFile);

			//웹경로
			//jsp에서는 img src="/upload달러{vo.웹경로}"
			String fileName = "/" + uploadFileName;

			//첨부 부모
			AtchfileVO atchfileVO = new AtchfileVO();
			atchfileVO.setAtchfileSn("");
			atchfileVO.setAtchfileId(empId);
			atchfileVO.setAtchfileYn("Y");
			log.info("uploadOne->atchfileVO : " + atchfileVO);
			result = atchfileMapper.insertAtchfile(atchfileVO);//atchfileSn이 세팅됨(selectKey)

			//*******
			atchfileSn = atchfileVO.getAtchfileSn();

			/*
			  // 2. 파일 이름 확인        String fileName = file.getName();
			   *   // 3. 파일명에서 가장 마지막에 오는 '.'의 index 확인        int index = fileName.lastIndexOf(".");
			   *    // 4. 확장자 추출        if (index > 0) {
			   *     // 파일이름에서 '.' 이후의 문자열이 확장자가 된다.
			   *      String extension = fileName.substring(index + 1);
			   *       // 결과 출력            System.out.println(extension);  // txt        }

			 */
			index = uploadFileName.lastIndexOf(".");
			if (index > 0) {
				extension = fileName.substring(index + 1);
			}

			//첨부자식
			AtchfileDetailVO atchfileDetailVO = new AtchfileDetailVO();
			atchfileDetailVO.setAtchfileDetailSn(1);
			atchfileDetailVO.setAtchfileSn(atchfileVO.getAtchfileSn());
			atchfileDetailVO.setAtchfileDetailLgclfl(uploadFile.getOriginalFilename());
			atchfileDetailVO.setAtchfileDetailPhyscl(uploadFileName);
			atchfileDetailVO.setAtchfileDetailPhysclPath(fileName);
			atchfileDetailVO.setAtchfileDetailSize(uploadFile.getSize());
			atchfileDetailVO.setAtchfileDetailExtsn(extension);
			atchfileDetailVO.setEmpId(empId);
			atchfileDetailVO.setAtchfileDetailRegDt(null);
			atchfileDetailVO.setAtchfileDetailYn("Y");
			atchfileDetailVO.setAtchfileDelyn("N");
			log.info("uploadOne->atchfileDetailVO : " + atchfileDetailVO);
			this.atchfileMapper.insertAtchfileDetail(atchfileDetailVO);

			log.info("uploadOne->result : " + result);

		} catch (IllegalStateException | IOException e) {
			log.info(e.getMessage());
		}

		return atchfileSn;
	}

	//첨부파일 N개 업로드								파일객체	, 등록자 아이디
	public String  uploadMulti(MultipartFile[] uploadFiles, String empId) {
		String atchfileSn = "";

		int result = 0;

		int index = 0;

		int counter = 1;

		String extension = "";

		String uploadFileName = "";

		try {
			//첨부 부모
			AtchfileVO atchfileVO = new AtchfileVO();
			atchfileVO.setAtchfileSn("");
			atchfileVO.setAtchfileId(empId);
			atchfileVO.setAtchfileYn("Y");
			log.info("uploadOne->atchfileVO : " + atchfileVO);
			result = atchfileMapper.insertAtchfile(atchfileVO);//atchfileSn이 세팅됨(selectKey)

			atchfileSn = atchfileVO.getAtchfileSn();

			//다중 파일업로드 시작 /////////////////////////
			for(MultipartFile uploadFile : uploadFiles) {
				uploadFileName = uploadFile.getOriginalFilename();

				//UUID : 랜덤값 생성
				UUID uuid = UUID.randomUUID();
				//asdfsafd_개똥이.jpg
				uploadFileName = uuid.toString() + "_" + uploadFileName;

				//복사 설계
				File saveFile = new File(uploadFolderDirect, uploadFileName);
				//복사 실행
				uploadFile.transferTo(saveFile);

				//웹경로
				//jsp에서는 img src="/upload달러{vo.웹경로}"
				String fileName = "/" + uploadFileName;

				index = uploadFileName.lastIndexOf(".");
				if (index > 0) {
					extension = fileName.substring(index + 1);
				}

				//첨부자식
				AtchfileDetailVO atchfileDetailVO = new AtchfileDetailVO();
				atchfileDetailVO.setAtchfileDetailSn(counter++);
				atchfileDetailVO.setAtchfileSn(atchfileVO.getAtchfileSn());
				atchfileDetailVO.setAtchfileDetailLgclfl(uploadFile.getOriginalFilename());
				atchfileDetailVO.setAtchfileDetailPhyscl(uploadFileName);
				atchfileDetailVO.setAtchfileDetailPhysclPath(fileName);
				atchfileDetailVO.setAtchfileDetailSize(uploadFile.getSize());
				atchfileDetailVO.setAtchfileDetailExtsn(extension);
				atchfileDetailVO.setEmpId(empId);
				atchfileDetailVO.setAtchfileDetailRegDt(null);
				atchfileDetailVO.setAtchfileDetailYn("Y");
				atchfileDetailVO.setAtchfileDelyn("N");
				log.info("uploadOne->atchfileDetailVO : " + atchfileDetailVO);
				this.atchfileMapper.insertAtchfileDetail(atchfileDetailVO);

				log.info("uploadOne->result : " + result);

			}//end for
			//다중 파일업로드 끝 /////////////////////////
		} catch (IllegalStateException | IOException e) {
			log.info(e.getMessage());
		}

		return atchfileSn;
	}

	//CKEditor5 파일업로드
	// /image/upload
	// ckeditor는 이미지 업로드 후 이미지 표시하기 위해 uploaded 와 url을 json 형식으로 받아야 함
	// modelandview를 사용하여 json 형식으로 보내기위해 모델앤뷰 생성자 매개변수로 jsonView 라고 써줌
	// jsonView 라고 쓴다고 무조건 json 형식으로 가는건 아니고 @Configuration 어노테이션을 단
	// WebConfig 파일에 MappingJackson2JsonView 객체를 리턴하는 jsonView 매서드를 만들어서 bean으로 등록해야 함
	@ResponseBody
    @PostMapping("/image/upload")
    public Map<String,Object> image(MultipartHttpServletRequest request) throws IllegalStateException, IOException{
       ModelAndView mav = new ModelAndView("jsonView");

       // ckeditor 에서 파일을 보낼 때 upload : [파일] 형식으로 해서 넘어오기 때문에 upload라는 키의 밸류를 받아서
       // uploadFile에 저장함
       MultipartFile uploadFile = request.getFile("upload");
       log.info("uploadFile : " + uploadFile);

       //파일명
       String originalFileName = uploadFile.getOriginalFilename();
       log.info("originalFileName : " + originalFileName);

       //originalFileName : 개똥이.jpg -> jpg
       String ext = originalFileName.substring(originalFileName.indexOf(".")); //확장자.의 위치

       // 서버에 저장될 때 중복된 파일 이름인 경우를 방지하기 위해 UUID에 확장자를 붙여 새로운 파일 이름을 생성
       // asfagasdfaf.jpg
       String newFileName = UUID.randomUUID() + "_" + originalFileName;

       File f = new File(uploadFolderDirect);
       if(f.exists()==false) {
    	   f.mkdirs();
       }

       //저장 경로로 파일 객체를 저장하겠다라는 계획
       // c:\\업로드경로\\asfagasdfaf.jpg
       File file = new File(uploadFolderDirect, newFileName);

       //파일복사
       uploadFile.transferTo(file);

       // 브라우저에서 이미지 불러올 때 절대 경로로 불러오면 보안의 위험 있어 상대경로를 쓰거나 이미지 불러오는 jsp 또는 클래스 파일을 만들어
       // 가져오는 식으로 우회해야 함
       // 때문에 savePath와 별개로 상대 경로인 uploadPath 만들어줌
       String uploadPath = "/upload/" + newFileName;

       // uploaded, url 값을 modelandview를 통해 보냄
//	      mav.addObject("uploaded", true); // 업로드 완료
//	      mav.addObject("url", uploadPath); // 업로드 파일의 경로

       Map<String, Object> map = new HashMap<String, Object>();
       map.put("uploaded", true);
       map.put("url", uploadPath);

       log.info("map : " + map);

       return map;
    }

	// 연/월/일 폴더 생성
	public static String getFolder() {
		// 2024-05-13 형식(format) 지정
		// 간단한 날짜 형식
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 날짜 객체 생성(java.util 패키지)
		Date date = new Date();
		// 2022-11-16
		String str = sdf.format(date);
		// 2024-01-30 -> 2024\\01\\30
		return str.replace("-", File.separator);
	}
}
