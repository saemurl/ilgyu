package com.groovit.groupware.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.dao.EmployeeDao;
import com.groovit.groupware.mapper.EmployeeMapper;
import com.groovit.groupware.service.EmployeeService;
import com.groovit.groupware.util.UploadController;
import com.groovit.groupware.vo.EmployeeVO;

@Service
public class EmployeeServiceImpl implements EmployeeService {

	// DI, IoC
	@Autowired
	EmployeeDao employeeDao;
	
	@Autowired
	UploadController uploadController;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Override
	public EmployeeVO read01(String empId) {
		return this.employeeDao.read01(empId);
	}

	@Transactional
	@Override
	public int updateEmployee(EmployeeVO employeeVO) {
		int result = 0;
		
		//프로필 첨부파일
		MultipartFile uploadfile = employeeVO.getUploadFile();
		
		//첨부파일이 있어야만 파일업로드 로직 실행
		if(uploadfile.getOriginalFilename().length()>0) {
			//1) 첨부파일 업로드 및 파일테이블 들에 insert한 후에 ATCHFILE_SN를 받음
			String atchfileSn = this.uploadController.uploadOne(uploadfile, employeeVO.getEmpId());
			
			//2) 받은 ATCHFILE_SN를 EMPLOYEE테이블의 ATCHFILE_SN에 넣어준다
			employeeVO.setAtchfileSn(atchfileSn);
		}
		result += this.employeeMapper.updateEmployee(employeeVO);
		
		return result;
	}
}
