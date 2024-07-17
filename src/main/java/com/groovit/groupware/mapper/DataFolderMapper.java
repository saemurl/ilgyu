package com.groovit.groupware.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.groovit.groupware.vo.DataFileVO;
import com.groovit.groupware.vo.FolderVO;
import com.groovit.groupware.vo.DataRoomVO;

@Mapper
public interface DataFolderMapper {
    // 모든 폴더 조회
    List<FolderVO> selectAllFolders();

    // 모든 데이터 파일 조회
    List<DataFileVO> selectAllDataFiles();

    // 모든 자료실 조회
    List<DataRoomVO> selectAllDataRooms();

    // 파일 ID로 데이터 파일 조회
    DataFileVO selectDataFileById(String fileId);

    // 폴더 ID로 폴더 조회
    FolderVO selectFolderById(String folderId);

    // 자료실 번호로 폴더 조회
    List<FolderVO> selectFoldersByDrNo(String drNo);

    // 폴더 추가
    void insertFolder(FolderVO folder);

    // 파일 추가
    void insertDataFile(DataFileVO dataFile);

    // 폴더 영구 삭제
    void deleteFolderById(String folderId);

    // 파일 영구 삭제
    // void deleteFileById(String fileId);
    void deleteDataFileById(String fileId);

    // 폴더 이름 변경
    void updateFolderName(FolderVO folder);

    // 파일 이름 변경
    void updateFileName(DataFileVO dataFile);

    // 파일 이름 변경
    void updateDataFile(DataFileVO dataFile);

    // 폴더 업데이트
    void updateFolder(FolderVO folder);
    
    // 휴지통에 있는 모든 파일 조회
    List<DataFileVO> selectTrashFiles(@Param("trashFolderId") String trashFolderId);

    // 휴지통에 있는 모든 폴더 조회
    List<FolderVO> selectTrashFolders(@Param("trashFolderId") String trashFolderId);
    
    // 파일을 휴지통으로 이동
    void moveFileToTrash(@Param("fileId") String fileId, @Param("trashId") String trashId);

    // 폴더를 휴지통으로 이동
    void moveFolderToTrash(@Param("folderId") String folderId, @Param("trashId") String trashId);
    
    // 파일 크기의 합계
    long getTotalFileSize();
}