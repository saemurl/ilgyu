<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.css" />
<script src="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.js"></script>
<script type="text/javascript">
const empId = ${loginVO.empId};
$(function(){
	var flatpickrDateTimeStart = document.querySelector("#srvyBgngYmd");
	var flatpickrDateTimeEnd = document.querySelector("#srvyEndYmd");

	flatpickrDateTimeStart.flatpickr({
	  enableTime: true,
	  dateFormat: "Y-m-d H:i"
	});
	
	flatpickrDateTimeEnd.flatpickr({
	  enableTime: true,
	  dateFormat: "Y-m-d H:i"
	});
	
	$(document).on('click', '.answerPlusBtn', function(){
		let str = `
			<div class="mb-3 input-group input-group-merge" style="display: flex">
				<input type="text" class="form-control answer" id="answer" placeholder="보기 입력" />
				<span class="input-group-text answerDelBtn"><i class="ti ti-x" style="text-align: center;" ></i></span>
			</div>
		`
		$(this).parent().parent().append(str);
	});
	
	$(document).on('click', '.answerDelBtn', function(){
		$(this).parent().remove();
	})
	
	$('#addSurveyBtn').on('click', function(){
		let str = `
			<div class="row">
				<div class="col-xl">
					<div class="card mb-4">
						<div class="card-header d-flex justify-content-between align-items-center">
			 				<h5 class="mb-0">설문지 작성</h5>
			 				<small class="text-muted float-end"></small>
						</div>
						<div class="card-body mun">
							<div class="mb-3">
								<label class="form-label" for="question">질문</label>
								<input type="text" class="form-control question" id="question" placeholder="" />
								<div class="form-check">
									<input class="form-check-input" type="checkbox" value="" id="essential">
									<label class="form-check-label" for="essential"> 필수 답변 </label>
				                </div>
							</div>
							<div class="mb-3">
								<label class="form-label" for="answer">보기</label>
								<div class="mb-3 input-group input-group-merge" style="display: flex">
									<input type="text" class="form-control answer" id="answer" placeholder="보기 입력" />
									<span class="input-group-text answerPlusBtn"><i class="ti ti-plus" style="text-align: center;" ></i></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		`;
		$(this).before(str);
	})
	
	$('#insertSurveyBtn').on('click', function(){
		let title = document.querySelector('#srvyTtl').value;
		let content = document.querySelector('#srvyCn').value;
		let srvyBgngYmd = document.querySelector('#srvyBgngYmd').value;
		let srvyEndYmd = document.querySelector('#srvyEndYmd').value;
		
		let questions = document.querySelectorAll('.mun');
		
		// 문항리스트를 담을 배열
		let questionList = [];
		
		for(let i=0; i<questions.length; i++){
			// 문항i번의 질문
			let question = questions[i].querySelector('.question');
			// 문항i번의 보기들
			let answers = questions[i].querySelectorAll('.answer');
			let essentialYn = questions[i].querySelector("#essential").checked == true ? 'Y' : 'N';
			// 문항i번의 보기들을 담을 배열
			let answerList = [];
			for(let j=0; j<answers.length; j++){
				answerList.push({saCn: answers[j].value});
			}
			// 질문, 보기들을 하나로 묶어서
			let mun = {
				sqQstnCn: question.value,
				sqEsntlYn:essentialYn,
				answerList: answerList
			}
			// 문항리스트에 담음
			questionList.push(mun);
		}
		console.log(questionList);
		let surveyVO = {
			empId:empId,
			srvyTtl:title,
			srvyCn:content,
			srvyBgngYmd:srvyBgngYmd,
			srvyEndYmd:srvyEndYmd,
			questionList:questionList
		}
		fetch("/survey/insertAjax", {
			method:"post",
			headers:{
				"Content-Type":"application/json;charset=UTF-8",
				"${_csrf.headerName}": "${_csrf.token}"
			},
			body: JSON.stringify(surveyVO)
		}).then((resp)=>{
			resp.text().then((data)=>{
				console.log(data);
				location.href = '/survey/list';
			})
		})
	console.log(surveyVO);
	})
	
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
				location.href='/survey/manage';
			}
		});
	})
	
	$('#surveyExampleBtn').on('click', function(){
		$('#srvyTtl').val("사내 복지제도 관련 만족도 조사");
		$('#srvyCn').val("사내 복지제도 관련 만족도 조사를 진행합니다. \n적극적으로 의견을 반영하여 개선할 예정이니 성실한 참여 부탁드립니다.");
	})
})
</script>
<div class="row">
	<div class="col-xl">
		<div class="card mb-4">
			<div class="card-header d-flex justify-content-between align-items-center">
 				<h5 class="mb-0">설문 등록</h5>
 				<small class="text-muted float-end"></small>
			</div>
			<div class="card-body">
				<div class="mb-3">
					<label class="form-label" for="srvyTtl">제목</label>
					<input type="text" class="form-control" id="srvyTtl" placeholder="제목을 입력하세요." />
				</div>
				<div class="mb-3">
					<label class="form-label" for="srvyCn">내용</label>
					<textarea type="text" class="form-control" id="srvyCn" placeholder="내용을 입력하세요." ></textarea>
				</div>
				<div class="mb-3" style="display: flex; justify-content: space-between;">
					<div class="" style="width: 49%">
						<label class="form-label" for="srvyBgngYmd">시작기한</label>
						<input type="date" id="srvyBgngYmd" class="form-control" placeholder="YYYY-MM-DD HH:MM"/>
					</div >
					<div style="text-align: center; padding-top: 32px;">
						<p> ㅡ </p>
					</div>
					<div class="" style="width: 49%">
						<label class="form-label" for="srvyEndYmd">마감기한</label>
						<input type="date" id="srvyEndYmd" class="form-control" placeholder="YYYY-MM-DD HH:MM"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-xl">
		<div class="card mb-4">
			<div class="card-header d-flex justify-content-between align-items-center">
 				<h5 class="mb-0">설문지 작성</h5>
 				<small class="text-muted float-end"></small>
			</div>
			<div class="card-body mun">
				<div class="mb-3">
					<label class="form-label" for="question">질문</label>
					<input type="text" class="form-control question" id="question" placeholder="" />
					<div class="form-check">
						<input class="form-check-input" type="checkbox" value="" id="essential">
						<label class="form-check-label" for="essential"> 필수 답변 </label>
	                </div>
				</div>
				<div class="mb-3">
					<label class="form-label" for="answer">보기</label>
					<div class="mb-3 input-group input-group-merge" style="display: flex">
						<input type="text" class="form-control answer" id="answer" placeholder="보기 입력" />
						<span class="input-group-text answerPlusBtn"><i class="ti ti-plus" style="text-align: center;" ></i></span>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<button type="button" class="btn btn-outline-secondary" id="addSurveyBtn">문항추가</button>

<div style="text-align: center">
	<button type="button" class="btn rounded-pill btn-icon btn-label-primary waves-effect" id="surveyExampleBtn" style="margin-right: 15px;">
      <span class="ti ti-star ti-md"></span>
    </button>
	<button type="button" class="btn btn-primary" id="insertSurveyBtn">설문 등록</button>
	<button type="button" class="btn btn-secondary" id="cancelBtn">취소</button>
</div>


