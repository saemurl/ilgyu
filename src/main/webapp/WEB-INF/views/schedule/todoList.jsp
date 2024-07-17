<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Page CSS -->
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/jkanban/jkanban.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-kanban.css">

<script>
let exampleClick = 0;

$(document).ready(function () {
	
	$('#exampleBtn').on('click', function () {
		exampleClick ++;
		console.log("자동완성 버튼 클릭 체크 " + exampleClick);
		
		if(exampleClick == 1){
            $('#new-title').val("주간 회의 보고서 작성");
            $('.add-new-item').eq(0).val("주간 회의에서 논의된 주요 사항을 요약 후 정리했던 항목을 참고하여 진행 상황을 업데이트하기");
        }

        if(exampleClick == 2){
            $('#new-title').val("프로젝트 계획서 작성");
            $('.add-new-item').eq(0).val("인수인계받은 안드로이드 어플 제작 프로젝트 계획서 작성 후 이민석 부장님에게 상신하기");
        }

        if(exampleClick == 3){
            $('#new-title').val("지난 달 급여명세서이 파일 출력");
            $('.add-new-item').eq(0).val("6월 급여명세서 조회 후 PDF 다운로드해서 따로 보관하기");
            
            exampleClick = 0; // 초기화
        }
	})
	
})
</script>


<h4 class="py-3 mb-4"><span class="text-muted fw-light">일정관리/</span> TO DO</h4>

<div class="app-kanban">
    <div class="kanban-wrapper"></div>
    <div class="offcanvas offcanvas-end kanban-update-item-sidebar">
        <div class="offcanvas-header border-bottom">
            <h5 class="offcanvas-title">To Do</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
            <div class="tab-content px-0 pb-0 pt-0">
                <!-- 할일 -->
                <div class="tab-pane fade show active" id="tab-update" role="tabpanel">
                    <form id="kanban-update-item-form">
                        <div class="mb-3">
                            <label class="form-label" for="title">제목</label>
                            <span class="badge badge-dot bg-danger me-1" style="margin-top: -10px; width: 0.3rem; height: 0.3rem;"></span>
                            <input type="text" id="title" class="form-control" placeholder="Enter Title" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="due-date">기한</label>
                            <input type="text" id="due-date" class="form-control" placeholder="할일을 입력하세요" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="label-update">카테고리</label>
                            <select class="select2 select2-label form-select" id="label-update">
                                <option data-color="bg-label-success" value="Work">Work</option>
                                <option data-color="bg-label-warning" value="Personal">Personal</option>
                                <option data-color="bg-label-info" value="Family">Family</option>
                                <option data-color="bg-label-danger" value="Study">Study</option>
                                <option data-color="bg-label-primary" value="Hobby">Hobby</option>
                                <option data-color="bg-label-secondary" value="Others">Others</option>
                            </select>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">내용</label>
                            <textarea class="form-control" id="new-content" rows="3"></textarea>
                        </div>
                        <div class="d-flex flex-wrap">
                            <button type="submit" class="btn btn-primary me-3">수정</button>
                            <button type="button" class="btn btn-label-danger" data-bs-dismiss="offcanvas">삭제</button>
                        </div>
                    </form>
                </div>
                <!-- 새 할일 -->
                <div class="tab-pane fade" id="tab-new" role="tabpanel">
                    <form id="kanban-add-item-form">
                        <div class="mb-3">
                            <label class="form-label" for="new-title">제목</label>
                            <span class="badge badge-dot bg-danger me-1" style="margin-top: -10px; width: 0.3rem; height: 0.3rem;"></span>
                            <input type="text" id="new-title" class="form-control" placeholder="할일을 입력하세요" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="new-due-date">기한</label>
                            <input type="text" id="new-due-date" class="form-control" placeholder="Enter Due Date" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="label-new">카테고리</label>
                            <select class="select2 select2-label form-select" id="label-new">
                                <option data-color="bg-label-success" value="Work">Work</option>
                                <option data-color="bg-label-warning" value="Personal">Personal</option>
                                <option data-color="bg-label-info" value="Family">Family</option>
                                <option data-color="bg-label-danger" value="Study">Study</option>
                                <option data-color="bg-label-primary" value="Hobby">Hobby</option>
                                <option data-color="bg-label-secondary" value="Others">Others</option>
                            </select>
                        </div>
                        <div class="mb-4">
                            <label class="form-label" for="new-content">내용</label>
                            <textarea class="form-control add-new-item" id="new-content" rows="3" placeholder="세부내용을 입력하세요"></textarea>
                        </div>
                        <div class="d-flex flex-wrap">
                            <button type="submit" class="btn btn-primary me-3">저장</button>
                            <button type="button" class="btn btn-label-secondary me-3" data-bs-dismiss="offcanvas">취소</button>
                            <button type="button" id="exampleBtn" style="margin-left: 15px; background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

