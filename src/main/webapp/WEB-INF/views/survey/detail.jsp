<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/sweetalert2.min.css" />
<script type="text/javascript" src="/resources/js/sweetalert2.min.js"></script>

<script type="text/javascript">
$(function() {
	const empId = "${loginVO.empId}";

	$('#btnCancel').on('click', function() {
		Swal.fire({
			position: "center",
			title: "취소하시겠습니까?",
			icon: "question",
			showCancelButton: true, // 수정된 부분
			confirmButtonText: "예",
			cancelButtonText: "아니오",
			customClass: {
			       confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
			       cancelButton: 'btn btn-label-secondary waves-effect waves-light'
			     },
		}).then((result)=>{
			if(result.isConfirmed){
				console.log('취소');
				location.href='/survey/list';
			}
		});
	});
	
	$('#btnSubmit').on('click', function(){
		let respList = [];
		let srvyNo = $('#srvyNo').val();
		$("input[type='radio']:checked").each(function() {
	        var questionId = $(this).attr("name"); 
	        var answerId = $(this).val(); 
			let surveyResponseVO = {
				srvyNo: srvyNo,
	            sqSn: questionId,
	            saSn: answerId,
	            empId: empId
			}
	        respList.push(surveyResponseVO);
	    });
		console.log(respList);
		Swal.fire({
			position: "center",
			title: "설문을 완료하시겠습니까?",
			icon: "question",
			showCancelButton: true, // 수정된 부분
			confirmButtonText: "제출",
			cancelButtonText: "취소",
			customClass: {
			       confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
			       cancelButton: 'btn btn-label-secondary waves-effect waves-light'
			     },
		}).then((result)=>{
			if(result.isConfirmed){
				$.ajax({
					url:"/survey/resp",
					contentType:"application/json;charset=UTF-8",
					data:JSON.stringify(respList),
					type:"post",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
					},
					success:function(result){
						console.log(result);
						location.href='/survey/result?srvyNo='+srvyNo;
					}
				})
			}
		});
	});
});
</script>

<style>
.surveyInfo {
	padding: 30px;
}
</style>

<div class="card rows">

	<div class="surveyInfo">

		<input type="hidden" id="srvyNo" value="${surveyVO.srvyNo}">
		<br>
		<a href="<%=request.getContextPath() %>/survey/list">설문 ></a>
		<br>
		<div style="display: flex; justify-content: space-between;">
			<div style="align-items: center;">
				<h2>${surveyVO.srvyTtl}</h2>
			</div>
			<div>
				<div>작성자 : ${surveyVO.empNm}</div>
				<div>작성일 : ${surveyVO.srvyWrtYmd}</div>
				<div>설문기간 : ${surveyVO.srvyBgngYmd} - ${surveyVO.srvyEndYmd}</div>
			</div>
		</div>
		<br>
		<hr>
		<br>
		<div class="row gy-4">
			<div class="col-md">
				<div class="card shadow-none bg-primary-subtle py-sm-1">
					<div class="card-body text-primary p-0 pre-wrap">
						<p class="card-text">${surveyVO.srvyCn}</p>
					</div>
				</div>
			</div>
		</div>
		<br>
		<div class="divider text-start">
			<div class="divider-text">설문 시작</div>
		</div>
	
		<!-- 질문 -->
		<c:forEach var="question" items="${surveyVO.questionList}" varStatus="stat">
			<c:if test="${question.sqEsntlYn eq 'Y'}">
				<div class="mb-4 mt-4">
					<span class="badge bg-danger bg-glow" style="margin-bottom: 5px">필수</span>
					<h4>${stat.count}. ${question.sqQstnCn}</h4>
				</div>
			</c:if>
			<c:if test="${question.sqEsntlYn eq 'N'}">
				<div class="mb-4 mt-4">
					<h4>${stat.count}. ${question.sqQstnCn}</h4>
				</div>
			</c:if>
	
			<c:forEach var="answer" items="${question.answerList}" varStatus="status">
				<c:choose>
					<c:when test="${question.sqEsntlYn eq 'Y' and status.count == 1}">
						<div class="form-check custom-option custom-option-basic mb-2 ">
						    <label class="form-check-label custom-option-content">
						        <input name="${question.sqSn}" class="form-check-input" type="radio" value="${answer.saSn}" checked />
						        <span class="custom-option-header">
						            <span class="fw-medium">${answer.saCn}</span>
						        </span>
						    </label>
						</div>
					</c:when>
					<c:otherwise>
						<div class="form-check custom-option custom-option-basic mb-2">
						    <label class="form-check-label custom-option-content">
						        <input name="${question.sqSn}" class="form-check-input" type="radio" value="${answer.saSn}" />
						        <span class="custom-option-header">
						            <span class="fw-medium">${answer.saCn}</span>
						        </span>
						    </label>
						</div>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<hr>
		</c:forEach>
		<div style="display:flex ; justify-content: end;">
			<button type="button" style="margin-right: 10px" class="btn btn-primary" id="btnSubmit">제출</button>
			<button type="button" class="btn btn-secondary" id="btnCancel">취소</button>
		</div>
	</div>
</div>
