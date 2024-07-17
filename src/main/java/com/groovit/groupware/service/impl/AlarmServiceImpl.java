package com.groovit.groupware.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.dao.AlarmDao;
import com.groovit.groupware.service.AlarmService;
import com.groovit.groupware.vo.AlarmVO;

@Service
public class AlarmServiceImpl implements AlarmService {

	@Autowired
	AlarmDao alarmDao;

	@Override
	public Map<String, Object> senderInfo(String alarmSender) {
		return this.alarmDao.senderInfo(alarmSender);
	}

	@Override
	public Map<String, Object> receiverInfo(String alarmReceiver) {
		// TODO Auto-generated method stub
		return this.alarmDao.receiverInfo(alarmReceiver);
	}

	@Override
	public int insertAlarm(AlarmVO alarmVO) {
		return this.alarmDao.insertAlarm(alarmVO);
	}

	@Override
	public List<AlarmVO> alarmList(Map<String, Object> map) {
		return this.alarmDao.alarmList(map);
	}

	@Override
	public int alarmDelete(Map<String, Object> map) {
		return this.alarmDao.alarmDelete(map);
	}

	@Override
	public int alarmRead(Map<String, Object> map) {
		return this.alarmDao.alarmRead(map);
	}

	@Override
	public int allReadNotifi(String loginId) {
		return this.alarmDao.allReadNotifi(loginId);
	}

	@Override
	public String countAlarm(String loginId) {
		return this.alarmDao.countAlarm(loginId);
	}

	@Override
	public int allDelNotifi(String loginId) {
		return this.alarmDao.allDelNotifi(loginId);
	}
	
	

	
	
	
}
