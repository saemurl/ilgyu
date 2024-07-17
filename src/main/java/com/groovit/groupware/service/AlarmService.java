package com.groovit.groupware.service;

import java.util.List;
import java.util.Map;

import com.groovit.groupware.vo.AlarmVO;

public interface AlarmService {

	Map<String, Object> senderInfo(String alarmSender);

	Map<String, Object> receiverInfo(String alarmReceiver);

	int insertAlarm(AlarmVO alarmVO);

	List<AlarmVO> alarmList(Map<String, Object> map);

	int alarmDelete(Map<String, Object> map);

	int alarmRead(Map<String, Object> map);

	int allReadNotifi(String loginId);

	String countAlarm(String loginId);

	int allDelNotifi(String loginId);


}
