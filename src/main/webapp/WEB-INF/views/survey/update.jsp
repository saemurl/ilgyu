<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.css" />
<script src="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.js"></script>
<script type="text/javascript">
const empId = ${loginVO.empId};
$(function(){
	var flatpickrDateTimeStart = document.querySelector("#srvyBgngYmd");
	var flatpickrDateTimeEnd = document.querySelector("#srvyEndYmd");
	var srvyBgng = document.querySelector("#srvyBgng").value;
	var srvyEnd = document.querySelector("#srvyEnd").value;
	var today = new Date();
	
	const header = "${_csrf.headerName}";
	const token = "${_csrf.token}";
	
	if(today > new Date(srvyBgng)) {
		flatpickrDateTimeStart.disabled = true;
		flatpickrDateTimeStart.style.backgroundColor = '#ebebed';
	}

	flatpickrDateTimeStart.flatpickr({
	  enableTime: true,
	  dateFormat: "Y-m-d H:i",
	  defaultDate: srvyBgng
	});
	
	flatpickrDateTimeEnd.flatpickr({
	  enableTime: true,
	  dateFormat: "Y-m-d H:i",
	  defaultDate: srvyEnd
	});
	
	$('#cancelBtn').on('click', function(){
		Swal.fire({
			position: "center",
			title: "취소하시겠습니까?",
			icon: "question",
			showCancelButton: true, 
			confirmButtonText: "예",
			cancelButtonText: "아니오",
			customClass: {
			       confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
			       cancelButton: 'btn btn-label-secondary waves-effect waves-light'
			     },
		}).then((result)=>{
			if(result.isConfirmed){
				console.log('취소');
				location.href='/survey/manage';
			}
		});
	});
	
	$('#updateSurveyBtn').on('click', function(){
		let srvyNo = $('#srvyNo').val();
		let title = document.querySelector('#srvyTtl').value;
		let content = document.querySelector('#srvyCn').value;
		let srvyBgngYmd = document.querySelector('#srvyBgngYmd').value;
		let srvyEndYmd = document.querySelector('#srvyEndYmd').value;
		
		let surveyVO = {
			"srvyNo" : srvyNo,
			"srvyTtl" : title,
			"srvyCn" : content,
			"srvyBgngYmd" : srvyBgngYmd,
			"srvyEndYmd" : srvyEndYmd
		}
		
		Swal.fire({
			position: "center",
			title: "수정하시겠습니까?",
			icon: "question",
			showCancelButton: true, // 수정된 부분
			confirmButtonText: "수정",
			cancelButtonText: "취소",
			customClass: {
			       confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
			       cancelButton: 'btn btn-label-secondary waves-effect waves-light'
			     },
		}).then((result)=>{
			if(result.isConfirmed){
				$.ajax({
					url:"/survey/updateAjax",
					contentType:"application/json;charset=UTF-8",
					data:JSON.stringify(surveyVO),
					type:"post",
					beforeSend:function(xhr){
						xhr.setRequestHeader(header, token);
					},
					success:function(result){
						console.log(result);
						location.href='/survey/result?srvyNo='+srvyNo;
					}
				})
			}
		});
	});
	
})
</script>
<input type="hidden" id="srvyNo" value="${surveyVO.srvyNo}">
<input type="hidden" id="srvyBgng" value="${surveyVO.srvyBgngYmd}">
<input type="hidden" id="srvyEnd" value="${surveyVO.srvyEndYmd}">
<div class="row">
	<div class="col-xl">
		<div class="card mb-4">
			<div class="card-header d-flex justify-content-between align-items-center">
 				<h5 class="mb-0">설문 수정</h5>
 				<small class="text-muted float-end"></small>
			</div>
			<div class="card-body">
				<div class="mb-3">
					<label class="form-label" for="srvyTtl">제목</label>
					<input type="text" class="form-control" id="srvyTtl" placeholder="제목을 입력하세요." value="${surveyVO.srvyTtl}" />
				</div>
				<div class="mb-3">
					<label class="form-label" for="srvyCn">내용</label>
					<input type="text" class="form-control" id="srvyCn" placeholder="내용을 입력하세요." value="${surveyVO.srvyCn}" />
				</div>
				<div class="mb-3" style="display: flex; justify-content: space-between;">
					<div class="" style="width: 49%">
						<label class="form-label" for="srvyBgngYmd">시작기한</label>
						<input type="date" id="srvyBgngYmd" class="form-control" placeholder="YYYY-MM-DD HH:MM" value="${surveyVO.srvyBgngYmd}" />
					</div >
					<div style="text-align: center; padding-top: 32px;">
						<p> ㅡ </p>
					</div>
					<div class="" style="width: 49%">
						<label class="form-label" for="srvyEndYmd">마감기한</label>
						<input type="date" id="srvyEndYmd" class="form-control" placeholder="YYYY-MM-DD HH:MM" value="${surveyVO.srvyEndYmd}"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div style="text-align: center">
	<button type="button" class="btn btn-primary" id="updateSurveyBtn">수정</button>
	<button type="button" class="btn btn-secondary" id="cancelBtn">취소</button>
</div>


