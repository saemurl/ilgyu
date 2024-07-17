package com.groovit.groupware.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.groovit.groupware.mapper.EmployeeMapper;
import com.groovit.groupware.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Primary
public class CustomUserDetailsService implements UserDetailsService {

	@Autowired
	private EmployeeMapper employeeMapper;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("CustomUserDetailsService->username : " + username);

		// select
		EmployeeVO employeeVO = this.employeeMapper.detail(username);
		log.info("CustomUserDetailsService->employeeVO : " + employeeVO);
		if (employeeVO == null) {
			throw new UsernameNotFoundException("User not found");
		}
		return employeeVO == null ? null : new CustomUserDetails(employeeVO);
	}
}
