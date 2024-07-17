package com.groovit.groupware.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groovit.groupware.mapper.DataFolderMapper;
import com.groovit.groupware.service.DataFolderService;
import com.groovit.groupware.vo.DataFileVO;
import com.groovit.groupware.vo.FolderVO;

import com.groovit.groupware.vo.DataRoomVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DataFolderServiceImpl implements DataFolderService {
    @Autowired
    private DataFolderMapper dataFolderMapper;

    // 모든 파일 조회
    @Override
    public List<DataFileVO> getAllDataFiles() {
        return dataFolderMapper.selectAllDataFiles();
    }

    // 모든 폴더 조회
    @Override
    public List<FolderVO> getAllFolders() {
        return dataFolderMapper.selectAllFolders();
    }

    // 모든 자료실 조회
    @Override
    public List<DataRoomVO> getAllDataRooms() {
        return dataFolderMapper.selectAllDataRooms();
    }

    // 폴더 ID로 폴더 조회
    @Override
    public FolderVO getFolderById(String id) {
        return dataFolderMapper.selectFolderById(id);
    }

    // 자료실 번호로 폴더 조회
    @Override
    public List<FolderVO> getFoldersByDrNo(String drNo) {
        return dataFolderMapper.selectFoldersByDrNo(drNo);
    }

    // 파일 ID로 데이터 파일 조회
    @Override
    public DataFileVO getDataFileById(String fileId) {
        return dataFolderMapper.selectDataFileById(fileId);
    }

    // 데이터 파일 저장
    @Override
    public void saveDataFile(DataFileVO dataFile) {
        dataFolderMapper.insertDataFile(dataFile);
    }

    // 폴더 추가
    @Override
    public void addFolder(FolderVO folder) {
        dataFolderMapper.insertFolder(folder);
    }

    // 폴더 영구 삭제
    @Override
    public void deleteFolderById(String folderId) {
        log.info("Permanently deleting folder with id: {}", folderId);
        dataFolderMapper.deleteFolderById(folderId);
    }

    // 파일 영구 삭제
    @Override
    public void deleteFileById(String fileId) {
        log.info("Permanently deleting file with id: {}", fileId);
        dataFolderMapper.deleteDataFileById(fileId);
    }

    // 폴더 이름 변경
    @Override
    public void updateFolderName(FolderVO folder) {
        dataFolderMapper.updateFolderName(folder);
    }

    // 파일 이름 변경
    @Override
    public void updateFileName(DataFileVO dataFile) {
        log.debug("Updating file name to: {}", dataFile.getDfOrgnlFileNm()); // 추가된 디버깅 로그

        if (dataFile.getDfOrgnlFileNm() == null || dataFile.getDfOrgnlFileNm().trim().isEmpty()) {
            throw new IllegalArgumentException("Changed file name cannot be null or empty");
        }
        dataFolderMapper.updateFileName(dataFile);
    }

    /**
     * 파일을 휴지통으로 이동
     * @param fileId 파일 ID
     * @param trashId 휴지통 ID
     */
    @Override
    public void moveFileToTrash(String fileId, String trashId) {
        DataFileVO file = dataFolderMapper.selectDataFileById(fileId);
        if (file != null) {
            file.setDrNo(trashId);  // 휴지통 ID 설정
            file.setDfFileStts("1");  // 파일 상태를 휴지통으로 변경
            file.setFdNo(null);  // 폴더 번호를 null로 설정 (휴지통에는 폴더 구조가 없음)
            dataFolderMapper.updateDataFile(file);
            log.info("File with id: {} has been moved to trash with id: {}.", fileId, trashId);
        } else {
            log.warn("File not found with id: {}", fileId);
        }
    }

    /**
     * 폴더를 휴지통으로 이동
     * @param folderId 폴더 ID
     * @param trashId 휴지통 ID
     */
    @Override
    public void moveFolderToTrash(String folderId, String trashId) {
        FolderVO folder = dataFolderMapper.selectFolderById(folderId);
        if (folder != null) {
            folder.setDrNo(trashId);
            folder.setFdUp(null);
            dataFolderMapper.updateFolder(folder);
            log.info("Folder with id: {} has been moved to trash with id: {}.", folderId, trashId);
        } else {
            log.warn("Folder not found with id: {}", folderId);
        }
    }

    // 휴지통 비우기
    @Override
    public void emptyTrash(String folderId) {
        List<DataFileVO> trashFiles = dataFolderMapper.selectTrashFiles(folderId);
        if (trashFiles != null) {
            for (DataFileVO file : trashFiles) {
                dataFolderMapper.deleteDataFileById(file.getDfNo());
            }
        }
        List<FolderVO> trashFolders = dataFolderMapper.selectTrashFolders(folderId);
        if (trashFolders != null) {
            for (FolderVO folder : trashFolders) {
                dataFolderMapper.deleteFolderById(folder.getFdNo());
            }
        }
    }
    
    // 파일 크기의 합계
    @Override
    public long getTotalFileSize() {
        return dataFolderMapper.getTotalFileSize();
    }

}
