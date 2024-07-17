package com.groovit.groupware.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.groovit.groupware.vo.AlarmVO;


@Repository
public class AlarmDao {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	public Map<String, Object> senderInfo(String alarmSender) {
		return this.sqlSessionTemplate.selectOne("alarm.senderInfo", alarmSender);
	}

	public Map<String, Object> receiverInfo(String alarmReceiver) {
		return this.sqlSessionTemplate.selectOne("alarm.receiverInfo", alarmReceiver);
	}

	public int insertAlarm(AlarmVO alarmVO) {
		return this.sqlSessionTemplate.insert("alarm.insertAlarm", alarmVO);
	}

	public List<AlarmVO> alarmList(Map<String, Object> map) {
		return this.sqlSessionTemplate.selectList("alarm.alarmList", map);
	}

	public int alarmDelete(Map<String, Object> map) {
		return this.sqlSessionTemplate.delete("alarm.alarmDelete", map);
	}

	public int alarmRead(Map<String, Object> map) {
		return this.sqlSessionTemplate.update("alarm.alarmRead", map);
	}

	public int allReadNotifi(String loginId) {
		return this.sqlSessionTemplate.update("alarm.allReadNotifi", loginId);
	}

	public String countAlarm(String loginId) {
		return this.sqlSessionTemplate.selectOne("alarm.countAlarm", loginId);
	}

	public int allDelNotifi(String loginId) {
		return this.sqlSessionTemplate.delete("alarm.allDelNotifi", loginId);
	}

}
