package com.groovit.groupware.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.groovit.groupware.service.DataFolderService;
import com.groovit.groupware.vo.DataFileVO;
import com.groovit.groupware.vo.FolderVO;
import com.groovit.groupware.vo.DataRoomVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/dataFolder")
@Controller
@Slf4j
public class DataFolderController extends BaseController {

    @Autowired
    private DataFolderService dataFolderService;

    /**
     * 파일 목록
     *
     * @param model Model 객체
     * @return 파일 목록 페이지
     */
    @GetMapping("/list")
    public String fileList(Model model) {
        List<DataFileVO> dataFiles = dataFolderService.getAllDataFiles();
        model.addAttribute("dataFiles", dataFiles);
        return "dataFolder/list";
    }

    /**
     * 파일 및 폴더 목록을 JSON 형태로 반환
     *
     * @return 파일 및 폴더 목록을 포함한 Map 객체
     */
    @GetMapping("/listFiles")
    @ResponseBody
    public Map<String, Object> listFiles() {
        Map<String, Object> response = new HashMap<>();
        List<DataFileVO> dataFiles = dataFolderService.getAllDataFiles();
        List<FolderVO> folders = dataFolderService.getAllFolders();
        List<DataRoomVO> dataRooms = dataFolderService.getAllDataRooms();
        response.put("dataFiles", dataFiles);
        response.put("folders", folders);
        response.put("dataRooms", dataRooms);
        log.info("DataFiles: {}", dataFiles);
        log.info("Folders: {}", folders);
        log.info("DataRooms: {}", dataRooms);
        return response;
    }

    /**
     * 폴더 ID로 폴더 정보를 반환, 없으면 자료실 번호로 조회
     *
     * @param id 폴더 ID 또는 자료실 번호
     * @return 폴더 정보 리스트
     */
    @GetMapping("/getFolder")
    @ResponseBody
    public ResponseEntity<List<FolderVO>> getFolderById(@RequestParam("id") String id) {
        log.debug("Fetching folder with id: {}", id);
        if (id.startsWith("TRASH")) {
            FolderVO folder = new FolderVO();
            folder.setFdNo(id);
            folder.setFdNm("휴지통");
            return ResponseEntity.ok(Collections.singletonList(folder));
        }
        FolderVO folder = dataFolderService.getFolderById(id);
        if (folder != null) {
            log.debug("Folder found: {}", folder);
            return ResponseEntity.ok(Collections.singletonList(folder));
        } else {
            List<FolderVO> folders = dataFolderService.getFoldersByDrNo(id);
            if (!folders.isEmpty()) {
                log.debug("Folders found by DR_NO: {}", folders);
                return ResponseEntity.ok(folders);
            }
            log.debug("Folder not found or is empty.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    /**
     * 파일 업로드 처리
     *
     * @param uploadFiles 업로드할 파일 배열
     * @param drNo        자료실 번호
     * @param fdNo        폴더 번호
     * @param principal   인증된 사용자 정보
     * @return 업로드 결과를 포함한 Map 객체
     */
    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> uploadFile(@RequestParam("file") MultipartFile[] uploadFiles, 
                                          @RequestParam("drNo") String drNo,
                                          @RequestParam("fdNo") String fdNo,
                                          Principal principal) {
        Map<String, Object> response = new HashMap<>();

        // 업로드된 파일 확인을 위한 디버깅 로그 추가
        log.info("Received upload files: {}", Arrays.toString(uploadFiles));

        // 파일 리스트가 비어있는지 확인
        if (uploadFiles == null || uploadFiles.length == 0) {
            response.put("status", "error");
            response.put("message", "업로드된 파일이 없습니다.");
            return response;
        }

        boolean isSuccess = true;

        for (MultipartFile uploadFile : uploadFiles) {
            // 각 파일이 비어 있는지 확인
            log.info("Processing file: {}", uploadFile.getOriginalFilename());
            if (uploadFile == null || uploadFile.isEmpty()) {
                response.put("status", "error");
                response.put("message", "파일이 비어 있습니다.");
                isSuccess = false;
                break;
            }

            String uploadFolder = "C:/upload";
            File uploadDir = new File(uploadFolder);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();  // 디렉토리가 없으면 생성
            }

            String uploadFileName = uploadFile.getOriginalFilename();

            // UUID 생성 및 파일 이름 변경
            UUID uuid = UUID.randomUUID();
            uploadFileName = uuid.toString() + "_" + uploadFileName;
            File saveFile = new File(uploadFolder, uploadFileName);

            try {
                uploadFile.transferTo(saveFile);

                // DataFileVO 생성 및 저장
                DataFileVO dataFileVO = new DataFileVO();
                dataFileVO.setDfFilePath("/" + uploadFileName);
                dataFileVO.setDfOrgnlFileNm(uploadFile.getOriginalFilename());
                dataFileVO.setDfChgFileNm(uploadFileName);
                dataFileVO.setDfFileSz(uploadFile.getSize());
                dataFileVO.setEmpId(principal.getName());
                dataFileVO.setFdNo(fdNo.isEmpty() ? null : fdNo);
                dataFileVO.setDrNo(drNo);

                log.info("Saving DataFileVO: {}", dataFileVO);  // 로그 추가

                // 파일 확장자 설정
                int index = uploadFileName.lastIndexOf(".");
                if (index > 0) {
                    dataFileVO.setDfExtn(uploadFileName.substring(index + 1));
                }

                dataFolderService.saveDataFile(dataFileVO);

            } catch (IOException e) {
                log.error("Error uploading file", e);
                response.put("status", "error");
                response.put("message", "파일 업로드 중 오류가 발생했습니다: " + e.getMessage());
                isSuccess = false;
                break;
            }
        }

        if (isSuccess) {
            response.put("status", "success");
            response.put("message", "파일 업로드가 성공적으로 완료되었습니다.");
        }

        return response;
    }

    /**
     * 폴더 추가 처리
     *
     * @param folderName 폴더 이름
     * @param drNo       자료실 번호
     * @param fdUp       상위 폴더 번호
     * @param principal  인증된 사용자 정보
     * @return 폴더 추가 결과를 포함한 Map 객체
     */
    @PostMapping("/addFolder")
    @ResponseBody
    public Map<String, Object> addFolder(@RequestParam("folderName") String folderName,
                                         @RequestParam("drNo") String drNo,
                                         @RequestParam("fdUp") String fdUp,
                                         Principal principal) {

        Map<String, Object> response = new HashMap<>();

        try {
            FolderVO folder = new FolderVO();
            folder.setFdNm(folderName);
            folder.setEmpId(principal.getName());
            folder.setFdUp(fdUp.isEmpty() ? null : fdUp);
            folder.setDrNo(drNo);
            dataFolderService.addFolder(folder);
            response.put("status", "success");
        } catch (Exception e) {
            log.error("Error adding folder", e);
            response.put("status", "error");
        }
        return response;
    }

    /**
     * 파일 삭제 처리
     *
     * @param request 삭제할 파일의 ID와 휴지통의 ID를 포함한 요청 맵
     * @return 파일 삭제 결과를 포함한 Map 객체
     */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteFile(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>(); // 응답을 담을 맵 생성
        String id = request.get("id"); // 요청으로부터 삭제할 파일의 ID를 가져옴
        String trashId = request.get("trashId"); // 요청으로부터 휴지통의 ID를 가져옴

        try {
            // 파일을 휴지통으로 이동
            dataFolderService.moveFileToTrash(id, trashId);
            response.put("status", "success"); // 성공 상태를 응답에 추가
        } catch (Exception e) {
            response.put("status", "error"); // 오류 상태를 응답에 추가
            response.put("message", e.getMessage()); // 오류 메시지를 응답에 추가
        }
        return response; // 응답을 반환
    }

    /**
     * 폴더 삭제 처리 (휴지통으로 이동 또는 영구 삭제)
     *
     * @param request 삭제할 폴더의 ID와 휴지통의 ID를 포함한 요청 맵
     * @return 폴더 삭제 결과를 포함한 Map 객체
     */
    @PostMapping("/deleteFolder")
    @ResponseBody
    public Map<String, Object> deleteFolder(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String folderId = request.get("id");
        String trashId = request.get("trashId");
        boolean isTrashFolder = isTrash(trashId);
        
        try {
            FolderVO folder = dataFolderService.getFolderById(folderId);
            if (folder != null) {
                // 휴지통으로 이동
                String actualTrashId = getTrashId(folder.getDrNo());
                dataFolderService.moveFolderToTrash(folderId, actualTrashId);
                log.info("Folder with id: {} has been moved to trash with id: {}.", folderId, actualTrashId);
                response.put("status", "success");
            } else {
                response.put("status", "error");
                response.put("message", "Folder not found");
                log.error("Folder not found with id: {}", folderId);
            }
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", e.getMessage());
            log.error("Error processing folder", e);
        }
        return response;
    }

    /**
     * 폴더 이름 변경 처리
     *
     * @param payload 폴더 ID와 새로운 폴더 이름을 포함한 요청 맵
     * @return 폴더 이름 변경 결과를 포함한 Map 객체
     */
    @PostMapping("/updateFolderName")
    @ResponseBody
    public Map<String, Object> updateFolderName(@RequestBody Map<String, String> payload) {
        Map<String, Object> response = new HashMap<>();
        String folderId = payload.get("fdNo");
        String folderName = payload.get("fdNm");

        try {
            FolderVO folder = new FolderVO();
            folder.setFdNo(folderId);
            folder.setFdNm(folderName);
            dataFolderService.updateFolderName(folder);
            response.put("status", "success");
        } catch (Exception e) {
            log.error("Error updating folder name", e);
            response.put("status", "error");
        }
        return response;
    }

    /**
     * 파일 이름 변경 처리
     *
     * @param request 파일 ID와 새로운 파일 이름을 포함한 요청 맵
     * @return 파일 이름 변경 결과를 포함한 Map 객체
     */
    @PostMapping("/updateFileName")
    @ResponseBody
    public Map<String, Object> updateFileName(@RequestBody Map<String, String> request) {
        String fileId = request.get("dfNo");
        String newFileName = request.get("dfOrgnlFileNm");

        log.debug("Received file ID: {}", fileId); // 추가된 디버깅 로그
        log.debug("Received new file name: {}", newFileName); // 추가된 디버깅 로그

        Map<String, Object> response = new HashMap<>();
        if (newFileName == null || newFileName.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "Changed file name cannot be null or empty");
            return response;
        }

        try {
            DataFileVO dataFile = new DataFileVO();
            dataFile.setDfNo(fileId);
            dataFile.setDfOrgnlFileNm(newFileName);
            dataFolderService.updateFileName(dataFile);
            response.put("status", "success");
        } catch (Exception e) {
            log.error("Error updating file name", e);
            response.put("status", "error");
            response.put("message", e.getMessage());
        }
        return response;
    }

    /**
     * 선택된 파일 및 폴더 삭제 처리
     *
     * @param payload 선택된 파일 및 폴더의 정보를 포함한 요청 맵
     * @return 삭제 결과를 포함한 Map 객체
     */
    @PostMapping("/deleteSelected")
    @ResponseBody
    public Map<String, Object> deleteSelected(@RequestBody Map<String, Object> payload) {
        List<Map<String, String>> selectedItems = (List<Map<String, String>>) payload.get("items");
        
        Map<String, Object> response = new HashMap<>();
        try {
            for (Map<String, String> item : selectedItems) {
                String id = item.get("id");
                String type = item.get("type");
                String drNo = item.get("drNo");
                
                String trashId = getTrashId(drNo);  // drNo에 따라 적절한 휴지통 ID 결정
                
                if ("folder".equals(type)) {
                    dataFolderService.moveFolderToTrash(id, trashId);
                } else if ("file".equals(type)) {
                    dataFolderService.moveFileToTrash(id, trashId);
                }
            }
            response.put("status", "success");
        } catch (Exception e) {
            log.error("선택된 항목 삭제 중 오류 발생", e);
            response.put("status", "error");
            response.put("message", e.getMessage());
        }
        return response;
    }

    /**
     * 단일 파일 다운로드 처리
     *
     * @param fileId   다운로드할 파일의 ID
     * @param response HTTP 응답 객체
     * @throws IOException 파일 읽기 오류 발생 시
     */
    @GetMapping("/download/file/{id}")
    public void downloadFile(@PathVariable("id") String fileId, HttpServletResponse response) throws IOException {
        DataFileVO dataFile = dataFolderService.getDataFileById(fileId);

        if (dataFile != null) {
            String filePath = "C:/upload/" + dataFile.getDfChgFileNm();
            File file = new File(filePath);

            if (file.exists()) {
                long fileLength = file.length();

                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(dataFile.getDfOrgnlFileNm(), "UTF-8").replace("+", "%20") + "\";");
                response.setHeader("Content-Transfer-Encoding", "binary"); 
                response.setHeader("Content-Length", "" + fileLength);
                response.setHeader("Pragma", "no-cache;");
                response.setHeader("Expires", "-1;");

                try (FileInputStream fis = new FileInputStream(file);
                     OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[1024];
                    int readCount;
                    while ((readCount = fis.read(buffer)) != -1) {
                        out.write(buffer, 0, readCount);
                    }
                } catch (Exception ex) {
                    log.error("Error loading file", ex);
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading file");
                }

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found in database");
        }
    }

    /**
     * 다중 파일 다운로드 처리 (압축)
     *
     * @param selectedIds 다운로드할 파일의 ID 리스트
     * @param response    HTTP 응답 객체
     * @throws IOException 파일 읽기 오류 발생 시
     */
    @PostMapping("/downloadSelected")
    public void downloadSelected(@RequestBody List<String> selectedIds, HttpServletResponse response) throws IOException {
        if (selectedIds.size() == 1) {
            String id = selectedIds.get(0);
            downloadSingleFile(id, response);
        } else {
            response.setContentType("application/zip");
            response.setHeader("Content-Disposition", "attachment;filename=selected_files.zip");

            try (ZipOutputStream zos = new ZipOutputStream(response.getOutputStream())) {
                for (String id : selectedIds) {
                    DataFileVO dataFile = dataFolderService.getDataFileById(id);
                    String filePath = "C:/upload/" + dataFile.getDfChgFileNm();
                    File file = new File(filePath);

                    if (file.exists()) {
                        try (FileInputStream fis = new FileInputStream(file)) {
                            zos.putNextEntry(new ZipEntry(dataFile.getDfOrgnlFileNm()));
                            byte[] buffer = new byte[1024];
                            int len;
                            while ((len = fis.read(buffer)) > 0) {
                                zos.write(buffer, 0, len);
                            }
                            zos.closeEntry();
                        }
                    }
                }
            } catch (Exception e) {
                log.error("Error creating ZIP file", e);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating ZIP file");
            }
        }
    }

    /**
     * 단일 파일 다운로드 처리
     *
     * @param fileId   다운로드할 파일의 ID
     * @param response HTTP 응답 객체
     * @throws IOException 파일 읽기 오류 발생 시
     */
    private void downloadSingleFile(String fileId, HttpServletResponse response) throws IOException {
        DataFileVO dataFile = dataFolderService.getDataFileById(fileId);
        if (dataFile != null) {
            String filePath = "C:/upload/" + dataFile.getDfChgFileNm();
            File file = new File(filePath);
            if (file.exists()) {
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(dataFile.getDfOrgnlFileNm(), "UTF-8").replace("+", "%20") + "\";");
                response.setHeader("Content-Transfer-Encoding", "binary");
                response.setHeader("Content-Length", String.valueOf(file.length()));
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Expires", "-1");

                try (FileInputStream fis = new FileInputStream(file);
                     OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[1024];
                    int readCount;
                    while ((readCount = fis.read(buffer)) != -1) {
                        out.write(buffer, 0, readCount);
                    }
                } catch (Exception ex) {
                    log.error("Error loading file", ex);
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading file");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found in database");
        }
    }

    /**
     * 파일 영구 삭제 처리
     *
     * @param request 삭제할 파일의 ID를 포함한 요청 맵
     * @return 삭제 결과를 포함한 ResponseEntity 객체
     */
    @PostMapping("/permanentDelete")
    @ResponseBody
    public ResponseEntity<?> permanentDelete(@RequestBody Map<String, String> request) {
        String id = request.get("id");
        String type = request.get("type");
        
        if (id == null || id.isEmpty() || type == null || type.isEmpty()) {
            return ResponseEntity.badRequest().body("Invalid request parameters");
        }

        try {
            if ("file".equals(type)) {
                dataFolderService.deleteFileById(id);
            } else if ("folder".equals(type)) {
                dataFolderService.deleteFolderById(id);
            } else {
                return ResponseEntity.badRequest().body("Invalid type");
            }
            return ResponseEntity.ok(Collections.singletonMap("status", "success"));
        } catch (Exception e) {
            log.error("Error permanently deleting item", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                .body("Error permanently deleting item: " + e.getMessage());
        }
    }

    /**
     * 폴더 영구 삭제 처리
     *
     * @param request 삭제할 폴더의 ID를 포함한 요청 맵
     * @return 삭제 결과를 포함한 ResponseEntity 객체
     */
    @PostMapping("/permanentDeleteFolder")
    @ResponseBody
    public ResponseEntity<?> permanentDeleteFolder(@RequestBody Map<String, String> request) {
        String folderId = request.get("id");
        if (folderId == null || folderId.isEmpty()) {
            return ResponseEntity.badRequest().body("Invalid folderId");
        }

        try {
            dataFolderService.deleteFolderById(folderId);
            return ResponseEntity.ok(Collections.singletonMap("status", "success"));
        } catch (Exception e) {
            log.error("Error permanently deleting folder", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error permanently deleting folder: " + e.getMessage());
        }
    }

    /**
     * 선택된 파일 및 폴더 영구 삭제 처리
     *
     * @param payload 선택된 파일 및 폴더의 정보를 포함한 요청 맵
     * @return 삭제 결과를 포함한 Map 객체
     */
    @PostMapping("/permanentDeleteSelected")
    @ResponseBody
    public Map<String, Object> permanentDeleteSelected(@RequestBody Map<String, Object> payload) {
        List<Map<String, String>> selectedItems = (List<Map<String, String>>) payload.get("items");
        
        Map<String, Object> response = new HashMap<>();
        try {
            for (Map<String, String> item : selectedItems) {
                String id = item.get("id");
                String type = item.get("type");
                
                if ("folder".equals(type)) {
                    dataFolderService.deleteFolderById(id);
                } else if ("file".equals(type)) {
                    dataFolderService.deleteFileById(id);
                }
            }
            response.put("status", "success");
        } catch (Exception e) {
            log.error("선택된 항목 영구 삭제 중 오류 발생", e);
            response.put("status", "error");
            response.put("message", e.getMessage());
        }
        return response;
    }

    /**
     * 휴지통 비우기 엔드포인트 수정
     *
     * @param request 휴지통 폴더 ID를 포함한 요청 맵
     * @return 비우기 결과를 포함한 ResponseEntity 객체
     */
    @PostMapping("/deleteAllInTrash")
    @ResponseBody
    public ResponseEntity<?> deleteAllInTrash(@RequestBody Map<String, String> request) {
        String folderId = request.get("folderId");
        if (folderId == null || !isTrash(folderId)) {
            return ResponseEntity.badRequest().body("Invalid folderId");
        }

        try {
            dataFolderService.emptyTrash(folderId);
            return ResponseEntity.ok(Collections.singletonMap("status", "success"));
        } catch (Exception e) {
            log.error("Error emptying trash", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error emptying trash: " + e.getMessage());
        }
    }
    
    /**
     * 휴지통 여부를 확인하는 함수
     *
     * @param folderId 폴더 ID
     * @return 휴지통 여부
     */
    private boolean isTrash(String folderId) {
        return "TRASH01".equals(folderId) || "TRASH02".equals(folderId);
    }

    /**
     * 휴지통 ID를 가져오는 함수
     *
     * @param drNo 자료실 번호
     * @return 휴지통 ID
     */
    private String getTrashId(String drNo) {
        if ("DR004".equals(drNo) || "DR005".equals(drNo)) {
            return "TRASH01";
        } else if ("DR001".equals(drNo) || "DR002".equals(drNo) || "DR003".equals(drNo)) {
            return "TRASH02";
        } else {
            log.warn("Unknown DR_NO: {}. Using default trash.", drNo);
            return "TRASH02";  // 기본값
        }
    }
    
    /**
     * 파일 크기의 합계 및 사용량 정보 반환
     *
     * @return 스토리지 정보를 포함한 Map 객체
     */
    @GetMapping("/storageInfo")
    @ResponseBody
    public Map<String, Object> getStorageInfo() {
        Map<String, Object> response = new HashMap<>();
        long totalSizeInBytes = dataFolderService.getTotalFileSize();
        double totalSizeInKB = totalSizeInBytes / 1024.0;
        double totalStorageInKB = 1024.0;  // 총 용량을 1024 KB로 설정

        response.put("usedSize", String.format("%.2f", totalSizeInKB));
        response.put("totalSize", totalStorageInKB);
        response.put("percentageUsed", String.format("%.2f", (totalSizeInKB * 100) / totalStorageInKB));

        return response;
    }


}
