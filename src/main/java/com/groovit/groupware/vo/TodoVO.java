package com.groovit.groupware.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TodoVO {
	private String todoId;
    private String empId;
    private String todoTtl;
    private String todoCn;
    private String todoStts;
    private Date todoStart;
    private Date todoDdln;
    private String todoCtgr;
}
