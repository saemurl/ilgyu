package com.groovit.groupware.vo;

import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class EventBoardVO {
	private String evtbNo;
    private String evtbSe;
    private int evtbCnt;
    private String empId;
    @DateTimeFormat(pattern = "yyyy/MM/dd")
    private Date evtbDt;
    private String strEvtbDt;

    private String evtbTtl;

    private String empNm;

    @Valid
    private List<MarriageVO> marriageVOList;
    @Valid
    private List<ObituaryVO> obituaryVOList;

    private String atchfileDetailPhysclPath;
}
