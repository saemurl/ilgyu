package com.groovit.groupware.service;

import java.util.List;

import com.groovit.groupware.vo.DataFileVO;
import com.groovit.groupware.vo.DataRoomVO;
import com.groovit.groupware.vo.FolderVO;

public interface DataFolderService {
    // 모든 파일 조회
    List<DataFileVO> getAllDataFiles();

    // 모든 폴더 조회
    List<FolderVO> getAllFolders();
    
    // 모든 자료실 조회
    List<DataRoomVO> getAllDataRooms();

    // 폴더 ID로 폴더 조회
    FolderVO getFolderById(String folderId);

    // 자료실 번호로 폴더 조회
    List<FolderVO> getFoldersByDrNo(String drNo);

    // 파일 ID로 데이터 파일 조회
    DataFileVO getDataFileById(String fileId);

    // 데이터 파일 저장
    void saveDataFile(DataFileVO dataFile);

    // 폴더 추가
    void addFolder(FolderVO folder);

    // 폴더 영구 삭제
    void deleteFolderById(String folderId);

    // 파일 영구 삭제
    void deleteFileById(String fileId);

    // 폴더 이름 변경
    void updateFolderName(FolderVO folder);

    // 파일 이름 변경
    void updateFileName(DataFileVO dataFile);

    // 파일을 휴지통으로 이동
    void moveFileToTrash(String fileId, String trashId);

    // 폴더를 휴지통으로 이동
    void moveFolderToTrash(String folderId, String trashId);

    // 휴지통 비우기 메서드
    void emptyTrash(String folderId);
    
    // 파일 크기의 합계
    long getTotalFileSize();
}
