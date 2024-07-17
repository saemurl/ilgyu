package com.groovit.groupware.controller;

import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;


import org.springframework.ui.Model;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groovit.groupware.service.TodoService;
import com.groovit.groupware.vo.TodoVO;
import com.groovit.groupware.service.ScheduleCalendarService;
import com.groovit.groupware.vo.DepartmentVO;
import com.groovit.groupware.vo.EmployeeVO;
import com.groovit.groupware.vo.MeetingRoomVO;
import com.groovit.groupware.vo.ScheduleCalendarVO;

import lombok.extern.slf4j.Slf4j;


@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
@RequestMapping("/schedule")
@Controller
@Slf4j
public class ScheduleController extends BaseController{
	
	@Autowired
	ScheduleCalendarService scheduleCalendarService;
	
	@Autowired
	TodoService todoService;
	
	// 일정 캘린더 메인 조회 --------------------------------------------------------
	@GetMapping("/list")
	public String list(Model model, Principal principal) {
		
		String empId = principal.getName();
		
		EmployeeVO employeeVO = this.scheduleCalendarService.employee(empId);
		log.info("로그인 회원 정보 조회 : " + employeeVO);
		
		model.addAttribute("employeeVO",employeeVO);
		
		return "schedule/list";
	}
	
	// 일정 캘린더 메인 Ajax --------------------------------------------------------
	@PostMapping("/listAjax")
	@ResponseBody
	public List<ScheduleCalendarVO> listAjax(@RequestBody Map<String, Object> map, Principal principal) {
		
		String empId = principal.getName();
		map.put("empId", empId);
		
		log.info("체크체크체크체크" + map);
		
		List<ScheduleCalendarVO> scheduleCalendarVOList = this.scheduleCalendarService.list(map);
		
		log.info("체크체크체크체크" + scheduleCalendarVOList);
		
		return scheduleCalendarVOList;
	}
	
	// 일정 캘린더 리스트 필터 갱신 Ajax --------------------------------------------------------
	@PostMapping("/filteredListAjax")
	@ResponseBody
	public List<ScheduleCalendarVO> filteredListAjax(@RequestBody Map<String, Object> map, Principal principal){
		
		String empId = principal.getName();
		map.put("empId", empId);
		
	    List<String> colors = (List<String>) map.get("color");
	    
	    Map<String, Object> params = new HashMap<>();
	    params.put("empId", empId);
	    params.put("colors", colors);
	    
	    List<ScheduleCalendarVO> scheduleCalendarVOList = this.scheduleCalendarService.filteredList(params);
	    
	    return scheduleCalendarVOList;    
	}
	
	// 등록하려는 부서 종류 조회 Ajax ------------------------------------------------------------
	@GetMapping("/departments")
	@ResponseBody
    public List<DepartmentVO> getDepartments(Principal principal) {
		
		String empId = principal.getName();
		
		List<DepartmentVO> departmentVOList = this.scheduleCalendarService.getDepartments(empId);  
		
		log.info("조회해오는 부서명 전체 Ajax ========== " + departmentVOList);
		
        return departmentVOList;
    }
	
	// 등록하려는 회의실 종류 조회 Ajax ------------------------------------------------------------
	@GetMapping("/locations")
	@ResponseBody
	public List<MeetingRoomVO> getlocations(Principal principal) {
		
		List<MeetingRoomVO> meetingRoomVOList = this.scheduleCalendarService.getlocations();  
		
		// log.info("조회해오는 회의실명 전체 Ajax ========== " + meetingRoomVOList);
		
		return meetingRoomVOList;
	}
	
	// 일정 등록 -----------------------------------------------------------------------------
	@PostMapping("create")
	@ResponseBody
	public Map<String, Object> create(@RequestBody Map<String, Object> map, Principal principal) {
	    log.info("등록하려는 값 Ajax ========== " + map);

	    ScheduleCalendarVO scheduleCalendarVO = new ScheduleCalendarVO();
	    scheduleCalendarVO.setEmpId(principal.getName());
	    scheduleCalendarVO.setDescription((String) map.get("description"));
	    scheduleCalendarVO.setTitle((String) map.get("title"));
	    try {
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
	        scheduleCalendarVO.setStart(sdf.parse((String) map.get("start")));
	        scheduleCalendarVO.setEnd(sdf.parse((String) map.get("end")));
	    } catch (ParseException e) {
	        log.error("날짜 SimpleDateFormat 오류", e);
	    }
	    scheduleCalendarVO.setAllday((String) map.get("allday"));
	    scheduleCalendarVO.setColor((String) map.get("color"));
	    scheduleCalendarVO.setDeptNm((String) map.get("deptNm"));
	    scheduleCalendarVO.setLocation((String) map.get("location"));

	    log.info("등록하려는 값이 담겼는지 확인 ========== " + scheduleCalendarVO);

	    return scheduleCalendarService.create(scheduleCalendarVO);
	}


	// 일정 수정 -----------------------------------------------------------------------------
	@PostMapping("update")
	@ResponseBody
	public ScheduleCalendarVO update(@RequestBody Map<String, Object> map, Principal principal) {
	    log.info("수정하려는 값 Ajax ========== " + map);

	    ScheduleCalendarVO scheduleCalendarVO = new ScheduleCalendarVO();
	    scheduleCalendarVO.setId(Integer.parseInt((String) map.get("id")));
	    scheduleCalendarVO.setEmpId(principal.getName());
	    scheduleCalendarVO.setDescription((String) map.get("description"));
	    scheduleCalendarVO.setTitle((String) map.get("title"));
	    try {
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
	        scheduleCalendarVO.setStart(sdf.parse((String) map.get("start")));
	        scheduleCalendarVO.setEnd(sdf.parse((String) map.get("end")));
	    } catch (ParseException e) {
	        log.error("날짜 SimpleDateFormat 오류", e);
	    }
	    scheduleCalendarVO.setAllday((String) map.get("allday"));
	    scheduleCalendarVO.setColor((String) map.get("color"));
	    scheduleCalendarVO.setDeptNm((String) map.get("deptNm"));
	    scheduleCalendarVO.setLocation((String) map.get("location"));

	    log.info("수정하려는 값이 담겼는지 확인 ========== " + scheduleCalendarVO);

	    scheduleCalendarService.update(scheduleCalendarVO);

	    return scheduleCalendarVO;
	}
	
	// 일정 삭제 -----------------------------------------------------------------------------
	@PostMapping("delete")
	@ResponseBody
	public ScheduleCalendarVO delete(@RequestBody Map<String, Object> map, Principal principal) {
		log.info("삭제하려는 값 Ajax ========== " + map);

	    ScheduleCalendarVO scheduleCalendarVO = new ScheduleCalendarVO();
	    scheduleCalendarVO.setEmpId(principal.getName());
	    scheduleCalendarVO.setId(Integer.parseInt((String) map.get("id")));

	    log.info("삭제하려는 값이 담겼는지 확인 ========== " + scheduleCalendarVO);

	    scheduleCalendarService.delete(scheduleCalendarVO);

	    return scheduleCalendarVO;
	}
	
	// 부서 알람 목적 부서인원 조회 -------------------------------------------------------------------
	@PostMapping("/deptEmpList")
	@ResponseBody
	public List<EmployeeVO> deptEmpList(@RequestBody String deptNmValue){
		log.info("공지 돌려야하는 부서 이름 : " + deptNmValue);
		List<EmployeeVO> deptEmpList = this.scheduleCalendarService.deptEmpList(deptNmValue); 
		log.info("가져온 부서 회원 리스트 정보 : ");
		
		return deptEmpList;
	}
	
	
	// To-Do 리스트 페이지로 이동
    @GetMapping("/todoList")
    public String todoList(Model model, Principal principal) {
        String empId = principal.getName();
        List<TodoVO> todoList = this.todoService.getAllTodos(empId);
        log.info("todoList for {}: {}", empId, todoList);
        model.addAttribute("todoList", todoList);
        return "schedule/todoList";
    }

    // To-Do 리스트 조회
    @GetMapping("/todos")
    @ResponseBody
    public List<TodoVO> getTodos(Principal principal) {
        String empId = principal.getName();
        return todoService.getAllTodos(empId);
    }

    // To-Do 항목 추가
    @PostMapping("/todos")
    @ResponseBody
    public ResponseEntity<?> addTodo(@RequestBody TodoVO todoVO, Principal principal) {
        String empId = principal.getName();
        todoVO.setEmpId(empId);
        log.debug("Adding Todo: " + todoVO.toString()); 

        // 중복 등록 방지 로직 추가
        List<TodoVO> existingTodos = todoService.getAllTodos(empId);
        boolean isDuplicate = existingTodos.stream()
            .anyMatch(existingTodo -> existingTodo.getTodoTtl().equals(todoVO.getTodoTtl()) &&
                                       existingTodo.getTodoDdln().equals(todoVO.getTodoDdln()) &&
                                       existingTodo.getTodoCtgr().equals(todoVO.getTodoCtgr()) &&
                                       existingTodo.getTodoCn().equals(todoVO.getTodoCn()));
        if (isDuplicate) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("이미 동일한 일정이 존재합니다.");
        }

        todoService.addTodo(todoVO);
        Map<String, Object> response = new HashMap<>();
        response.put("message", "일정이 성공적으로 등록되었습니다.");
        return ResponseEntity.ok(response);
    }


    // To-Do 항목 수정
    @PutMapping("/todos/{todoId}")
    @ResponseBody
    public ResponseEntity<?> updateTodo(
            @PathVariable("todoId") String todoId,
            @RequestBody TodoVO todoVO,
            Principal principal) {
        todoVO.setTodoId(todoId);
        try {
            int result = todoService.updateTodo(todoVO);
            if (result > 0) {
                Map<String, Object> response = new HashMap<>();
                response.put("message", "일정이 성공적으로 수정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일정 수정 중 오류가 발생했습니다.");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일정 수정 중 오류가 발생했습니다.");
        }
    }

    // To-Do 항목 삭제
    @DeleteMapping("/todos/{todoId}")
    @ResponseBody
    public ResponseEntity<?> deleteTodo(@PathVariable("todoId") String todoId) {
        todoService.deleteTodoById(todoId);
        return ResponseEntity.ok().build();
    }
	
}