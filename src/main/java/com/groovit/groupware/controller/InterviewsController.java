package com.groovit.groupware.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.Principal;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.ArrayList;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.mapper.InterviewsMapper;
import com.groovit.groupware.vo.ApplicantsVO;
import com.groovit.groupware.vo.InterviewsVO;

import lombok.extern.slf4j.Slf4j;

@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@Slf4j
@RequestMapping("/interviews")
@Controller
public class InterviewsController extends BaseController {

    @Autowired
    InterviewsMapper interviewsMapper;

    @GetMapping("/list")
    public String list(Principal principal, Model model) {
        List<InterviewsVO> interviewsList = interviewsMapper.getAllInterviews();
        log.info("interviewsList : {}", interviewsList);
        model.addAttribute("interviewsList", interviewsList);

        return "interviews/list";
    }
    
    @GetMapping("/statistics")
    @ResponseBody
    public Map<String, Object> getStatistics() {
        List<InterviewsVO> interviewsList = interviewsMapper.getAllInterviews();
        log.info("interviewsList : {}", interviewsList);
        
        // 면접 지원자 합격/불합격자 통계
        Map<String, Long> statusCount = interviewsList.stream()
                .collect(Collectors.groupingBy(InterviewsVO::getStatus, Collectors.counting()));
        
        // 면접 지원자 출신 대학 통계
        Map<String, Long> universityCount = interviewsList.stream()
                .flatMap(interview -> interview.getApplicantsVOList().stream())
                .filter(applicant -> applicant.getUniversity() != null)
                .collect(Collectors.groupingBy(applicant -> applicant.getUniversity(), Collectors.counting()));

        // 면접 지원자 지원 구분 통계
        Map<String, Long> applicationTypeCount = interviewsList.stream()
                .collect(Collectors.groupingBy(InterviewsVO::getApplicationType, Collectors.counting()));

        // 면접 지원자 세부 전공 통계
        Map<String, Long> majorCount = interviewsList.stream()
                .flatMap(interview -> interview.getApplicantsVOList().stream())
                .filter(applicant -> applicant.getMajor() != null)
                .collect(Collectors.groupingBy(applicant -> applicant.getMajor(), Collectors.counting()));

        // 2024 공채 지원자 수와 합격/불합격자 수 계산
        long total2024Applicants = interviewsList.stream()
                .filter(interview -> "2024 공채".equals(interview.getApplicationType()))
                .count();

        long total2024Pass = interviewsList.stream()
                .filter(interview -> "2024 공채".equals(interview.getApplicationType()) && "최종 합격".equals(interview.getStatus()))
                .count();

        long total2024Fail = interviewsList.stream()
                .filter(interview -> "2024 공채".equals(interview.getApplicationType()) && !"최종 합격".equals(interview.getStatus()))
                .count();

        // 수시 채용 지원자 수와 합격/불합격자 수 계산
        long totalSusiApplicants = interviewsList.stream()
                .filter(interview -> "수시 채용".equals(interview.getApplicationType()))
                .count();

        long totalSusiPass = interviewsList.stream()
                .filter(interview -> "수시 채용".equals(interview.getApplicationType()) && "최종 합격".equals(interview.getStatus()))
                .count();

        long totalSusiFail = interviewsList.stream()
                .filter(interview -> "수시 채용".equals(interview.getApplicationType()) && !"최종 합격".equals(interview.getStatus()))
                .count();

        // 인턴 채용 지원자 수와 합격/불합격자 수 계산
        long totalInternApplicants = interviewsList.stream()
                .filter(interview -> "인턴 채용".equals(interview.getApplicationType()))
                .count();

        long totalInternPass = interviewsList.stream()
                .filter(interview -> "인턴 채용".equals(interview.getApplicationType()) && "최종 합격".equals(interview.getStatus()))
                .count();

        long totalInternFail = interviewsList.stream()
                .filter(interview -> "인턴 채용".equals(interview.getApplicationType()) && !"최종 합격".equals(interview.getStatus()))
                .count();

        Map<String, Object> statistics = new HashMap<>();
        statistics.put("statusCount", statusCount);
        statistics.put("universityCount", universityCount);
        statistics.put("applicationTypeCount", applicationTypeCount);
        statistics.put("majorCount", majorCount);
        statistics.put("total2024Applicants", total2024Applicants);
        statistics.put("total2024Pass", total2024Pass);
        statistics.put("total2024Fail", total2024Fail);
        statistics.put("totalSusiApplicants", totalSusiApplicants);
        statistics.put("totalSusiPass", totalSusiPass);
        statistics.put("totalSusiFail", totalSusiFail);
        statistics.put("totalInternApplicants", totalInternApplicants);
        statistics.put("totalInternPass", totalInternPass);
        statistics.put("totalInternFail", totalInternFail);
        
        log.info("statusCount : {}", statusCount);
        log.info("universityCount : {}", universityCount);
        log.info("applicationTypeCount : {}", applicationTypeCount);
        log.info("majorCount : {}", majorCount);
        log.info("total2024Applicants : {}", total2024Applicants);
        log.info("total2024Pass : {}", total2024Pass);
        log.info("total2024Fail : {}", total2024Fail);
        log.info("totalSusiApplicants : {}", totalSusiApplicants);
        log.info("totalSusiPass : {}", totalSusiPass);
        log.info("totalSusiFail : {}", totalSusiFail);
        log.info("totalInternApplicants : {}", totalInternApplicants);
        log.info("totalInternPass : {}", totalInternPass);
        log.info("totalInternFail : {}", totalInternFail);

        return statistics;
    }

    // 상태 업데이트
    @PostMapping("/updateStatus")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam("intrvwId") int intrvwId,
                                            @RequestParam("status") String status) {
        Map<String, Object> response = new HashMap<>();
        try {
            interviewsMapper.updateStatus(intrvwId, status);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    // 선택된 인터뷰 항목 엑셀로 내보내기
    @PostMapping("/export")
    @ResponseBody
    public ResponseEntity<byte[]> exportSelectedInterviews(@RequestBody List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        List<InterviewsVO> selectedInterviews = interviewsMapper.getInterviewsByIds(ids);

        if (selectedInterviews == null || selectedInterviews.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Interviews");

            // Header row
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("ID");
            headerRow.createCell(1).setCellValue("상태");
            headerRow.createCell(2).setCellValue("지원 구분");
            headerRow.createCell(3).setCellValue("지원자명");
            headerRow.createCell(4).setCellValue("출신 대학");
            headerRow.createCell(5).setCellValue("세부 전공");
            headerRow.createCell(6).setCellValue("1차 면접일");
            headerRow.createCell(7).setCellValue("2차 면접일");
            headerRow.createCell(8).setCellValue("등록일");

            // Data rows
            int rowNum = 1;
            for (InterviewsVO interview : selectedInterviews) {
                if (interview.getApplicantsVOList() != null) {
                    for (ApplicantsVO applicant : interview.getApplicantsVOList()) {
                        Row row = sheet.createRow(rowNum++);
                        row.createCell(0).setCellValue(interview.getIntrvwId());
                        row.createCell(1).setCellValue(interview.getStatus());
                        row.createCell(2).setCellValue(interview.getApplicationType());
                        row.createCell(3).setCellValue(applicant.getApplicantNm());
                        row.createCell(4).setCellValue(applicant.getUniversity());
                        row.createCell(5).setCellValue(applicant.getMajor());
                        row.createCell(6).setCellValue(interview.getFirstIntrvwDate() != null ? dateFormat.format(interview.getFirstIntrvwDate()) : "");
                        row.createCell(7).setCellValue(interview.getSecondIntrvwDate() != null ? dateFormat.format(interview.getSecondIntrvwDate()) : "");
                        row.createCell(8).setCellValue(interview.getRegistrationDate() != null ? dateFormat.format(interview.getRegistrationDate()) : "");
                    }
                }
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            byte[] excelData = outputStream.toByteArray();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=interviews.xlsx");

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(excelData);

        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }
    
    // 면접 지원자 등록
    @PostMapping("/addApplicant")
    @ResponseBody
    public Map<String, Object> addApplicant(@RequestParam Map<String, String> params) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 지원자 정보 설정 및 삽입
            ApplicantsVO applicant = new ApplicantsVO();
            applicant.setApplicantNm(params.get("applicantName"));
            applicant.setUniversity(params.get("applicantUniversity"));
            applicant.setMajor(params.get("applicantMajor"));
            applicant.setContact(params.get("applicantContact"));
            applicant.setApplicantEmail(params.get("applicantEmail"));

            interviewsMapper.insertApplicant(applicant);
            

            // 삽입된 지원자의 ID 가져오기
            String applicantId = applicant.getApplicantId();

            // 면접 정보 설정 및 삽입
            InterviewsVO interviewVO = new InterviewsVO();
            interviewVO.setStatus(params.get("status"));
            interviewVO.setApplicationType(params.get("applicationType"));
            interviewVO.setApplicantId(applicantId); // 지원자 ID 설정

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            if (params.get("firstIntrvwDate") != null && !params.get("firstIntrvwDate").isEmpty()) {
                interviewVO.setFirstIntrvwDate((Date) dateFormat.parse(params.get("firstIntrvwDate")));
            }
            if (params.get("secondIntrvwDate") != null && !params.get("secondIntrvwDate").isEmpty()) {
                interviewVO.setSecondIntrvwDate((Date) dateFormat.parse(params.get("secondIntrvwDate")));
            }
            if (params.get("registrationDate") != null && !params.get("registrationDate").isEmpty()) {
                interviewVO.setRegistrationDate((Date) dateFormat.parse(params.get("registrationDate")));
            }

            interviewsMapper.insertInterview(interviewVO);

            // 지원자 목록을 인터뷰 VO에 설정
            List<ApplicantsVO> applicantsList = new ArrayList<>();
            applicantsList.add(applicant);
            interviewVO.setApplicantsVOList(applicantsList);

            response.put("success", true);
            response.put("data", interviewVO);
        } catch (ParseException e) {
            response.put("success", false);
            response.put("message", "Invalid date format");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }
}
