package com.groovit.groupware.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.AlarmService;
import com.groovit.groupware.vo.AlarmVO;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@RequestMapping("/alarm")
@Controller
public class AlarmController {

	
	@Autowired
	AlarmService alarmService;
	
	@GetMapping("/list")
	public String alarmList() {
		
		return "alarm/list";
	}
	
	
	
	@PostMapping("/alarmList")
	@ResponseBody
	public List<AlarmVO> alarmList(@RequestBody Map<String, Object> map) {
		
		List<AlarmVO> alarmVOList = this.alarmService.alarmList(map);
		
		log.info("결과 alarmVOList => " + alarmVOList);
		
		return alarmVOList;
	}
	
	
	
	
	
	
	
	
	
	
	
	@PostMapping("/allReadNotifi")
	@ResponseBody
	public int allReadNotifi(Principal principal) {
		
		String loginId = principal.getName();
		log.info("loginId : "+loginId);
		int result = this.alarmService.allReadNotifi(loginId);
		
		log.info("결과 allReadNotifi => " + result);
		
		return result;
	}
	
	@PostMapping("/allDelNotifi")
	@ResponseBody
	public int allDelNotifi(Principal principal) {
		
		String loginId = principal.getName();
		log.info("loginId : "+loginId);
		int result = this.alarmService.allDelNotifi(loginId);
		
		log.info("결과 allDelNotifi => " + result);
		
		return result;
	}
	
	
	
	@PostMapping("/alarmRead")
	@ResponseBody
	public int alarmRead(@RequestBody Map<String, Object> map) {
		log.info("map : "+map);
		int result = this.alarmService.alarmRead(map);
		
		log.info("결과 alarmRead => " + result);
		
		return result;
	}
	@PostMapping("/alarmDelete")
	@ResponseBody
	public int alarmDelete(@RequestBody Map<String, Object> map) {
		log.info("map : "+map);
		int result = this.alarmService.alarmDelete(map);
		
		log.info("결과 alarmDelete => " + result);
		
		return result;
	}
	
	@PostMapping("/countAlarm")
	@ResponseBody
	public String countAlarm(Principal principal) {
		
		String loginId = principal.getName();
		log.info("loginId : "+loginId);
		String result = this.alarmService.countAlarm(loginId);
		
		log.info("결과 allReadNotifi => " + result);
		
		return result;
	}
	
}
