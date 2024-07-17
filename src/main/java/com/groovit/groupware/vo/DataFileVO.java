package com.groovit.groupware.vo;

import java.util.Date;
import lombok.Data;

@Data
public class DataFileVO {
    private String dfNo;            // 파일 고유 번호
    private String dfFilePath;      // 파일 경로
    private Date dfUldDt;           // 파일 업로드 날짜
    private String dfOrgnlFileNm;   // 원본 파일 이름
    private String dfChgFileNm;     // 변경된 파일 이름
    private long dfFileSz;          // 파일 크기
    private String dfFileStts;      // 파일 상태
    private String empId;           // 파일을 업로드한 직원 ID
    private String dfExtn;          // 파일 확장자
    private String fdNo;            // 폴더 번호
    private String drNo;            // 자료실 번호
}
