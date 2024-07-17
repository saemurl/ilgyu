package com.groovit.groupware.vo;

import lombok.Data;

@Data
public class FolderVO {
    private String fdNo;    // 폴더 고유 번호
    private String drNo;    // 자료실 번호
    private String fdNm;    // 폴더 이름
    private String fdUp;    // 상위 폴더 번호
    private String empId;   // 폴더를 생성한 직원 ID
}
