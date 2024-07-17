package com.groovit.groupware.security;

import java.util.Collection;
import java.util.stream.Collectors;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import com.groovit.groupware.vo.EmployeeVO;

public class CustomUserDetails extends User {
	
	private EmployeeVO employeeVO;
	
	public CustomUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	public CustomUserDetails(EmployeeVO employeeVO) {
		super(employeeVO.getEmpId(),employeeVO.getEmpPass(),
				employeeVO.getEmployeeAuthrtVOList().stream()
				 .map(auth->new SimpleGrantedAuthority(auth.getEaAuthrt()))
				 .collect(Collectors.toList())
					);
		this.setEmployeeVO(employeeVO);
	}
	
	public EmployeeVO getEmployeeVO() {
		return employeeVO;
	}

	private void setEmployeeVO(EmployeeVO employeeVO) {
		this.employeeVO = employeeVO;
	}
}
