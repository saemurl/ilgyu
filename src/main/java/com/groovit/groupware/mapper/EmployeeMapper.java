package com.groovit.groupware.mapper;

import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EmployeeMapper {
	//로그인
    public EmployeeVO detail(String empId);
    
    //직원 상세
    public EmployeeVO getEmployeeById(String empId);

    //정보 수정
	public int updateEmployee(EmployeeVO employeeVO);

	//사진 삭제
	public void updateEmployeeAtchfileSnNull(EmployeeVO employeeVO);

	//아이디 찾기
	public List<EmployeeVO> findEmployeeByNameBirthdateAndPhone(@Param("empNm") String empNm, 
            @Param("empBrdt") Date empBrdt, 
            @Param("empTelno") String empTelno);
	
	//비밀번호 찾기
	public EmployeeVO findEmployeeByIdAndEmail(@Param("empId") String empId, @Param("empEml") String empEml);

	
	//부서 조직도 조회
	public List<ScheduleCalendarVO> deptEmpListAjax(Map<String, Object> map);
}