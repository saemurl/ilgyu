<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script src="/resources/sbadmin/vendor/jquery/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/bs-stepper/bs-stepper.css"/>


<style>
.btn-prev {
	margin-right: 50px;
}

.bs-stepper-content {
	height: 500px;	
}
</style>

<script type="text/javascript">
$(document).ready(function() {
	  const wizardNumbered = document.querySelector(".wizard-numbered");

	    if (typeof wizardNumbered !== undefined && wizardNumbered !== null) {
	        const wizardNumberedBtnNextList = [].slice.call(wizardNumbered.querySelectorAll('.btn-nextPage')),
	            wizardNumberedBtnPrevList = [].slice.call(wizardNumbered.querySelectorAll('.btn-prev')),
	            wizardNumberedBtnSubmit = wizardNumbered.querySelector('.btn-submit');

	        const numberedStepper = new Stepper(wizardNumbered, {
	            linear: false
	        });
	        if (wizardNumberedBtnNextList) {
	            wizardNumberedBtnNextList.forEach(wizardNumberedBtnNext => {
	                wizardNumberedBtnNext.addEventListener('click', event => {
	                    numberedStepper.next();
	                });
	            });
	        }
	        if (wizardNumberedBtnPrevList) {
	            wizardNumberedBtnPrevList.forEach(wizardNumberedBtnPrev => {
	                wizardNumberedBtnPrev.addEventListener('click', event => {
	                    numberedStepper.previous();
	                });
	            });
	        }
	        if (wizardNumberedBtnSubmit) {
	            wizardNumberedBtnSubmit.addEventListener('click', event => {
	                event.preventDefault(); // prevent form submission for debugging
	                const csrfToken = "${_csrf.token}";
	                const csrfHeader = "${_csrf.headerName}";
	                alert('Submitted..!!');
	            });
	        }
	    }

	    $('#exampleBtn').on('click', function () {
			console.log("샘플 생성 버튼 체크");
			
			$('#empNm').val("한서윤");
			$('#empBrdt').val("1993-10-06");
			$('#empTelno').val("010-1278-9181");
			$('#empMail').val("colalovebear@gmail.com");
		})
	    
		
		
});
</script>

<!-- 헤더 영역 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
<div class="bs-stepper wizard-numbered mt-2">
	<div class="bs-stepper-header">
		<div class="step" data-target="#account-details">
			<button type="button" class="step-trigger">
				<span class="bs-stepper-circle">1</span>
				<span class="bs-stepper-label"> <span class="bs-stepper-title">사원 개인정보 등록</span> 
				<span class="bs-stepper-subtitle">성명, 생년월일, 연락처</span>
				</span>
			</button>
		</div>
		<div class="line">
			<i class="ti ti-chevron-right"></i>
		</div>
		<div class="step" data-target="#personal-info">
			<button type="button" class="step-trigger">
				<span class="bs-stepper-circle">2</span>
				<span class="bs-stepper-label"> <span class="bs-stepper-title">사원 사내정보 등록</span>
				<span class="bs-stepper-subtitle">사번, 소속, 이메일</span>
				</span>
			</button>
		</div>
		<div class="line">
			<i class="ti ti-chevron-right"></i>
		</div>
		<div class="step" data-target="#social-links">
			<button type="button" class="step-trigger">
				<span class="bs-stepper-circle">3</span>
				<span class="bs-stepper-label"> <span class="bs-stepper-title">등록 전 확인사항</span>
				<span class="bs-stepper-subtitle">사원 공지 전 확인 메뉴얼</span>
				</span>
			</button>
		</div>
		<div>
			<button type="button" class="btn rounded-pill btn-icon btn-label-primary waves-effect" id="exampleBtn" style="margin-left: 50px;">
            	<span class="ti ti-star ti-md"></span>
            </button>
		</div>
	</div>
<!-- 첫번 째 영역 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
	<div class="bs-stepper-content">
		<form id="frm" name="frm" action="/hrm/createPost" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			<div id="account-details" class="content">
				<div class="content-header mb-4">
					<span class="badge px-2 bg-label-primary">사원 개인 정보</span>
					<small>&nbsp 신규 사원의 성명, 이메일, 생년월일을 입력해주세요.</small>
				</div>
				
				<div class="row g-6">
					<div class="mb-4">
						<label class="form-label" for="empNm"><strong>성명</strong></label> <input type="text"
							class="form-control" name="empNm" id="empNm" />
					</div>
					<div class="mb-4">
						<label class="form-label" for="empBrdt"><strong>생년월일</strong></label> 
						<input type="date" class="form-control" name="empBrdt" id="empBrdt" />
					</div>
					<div class="mb-4">
						<label class="form-label" for="empTelno"><strong>연락처</strong></label>
						<input type="text" class="form-control" name="empTelno" id="empTelno" />
					</div>
					
					<div class="col-12 d-flex" style="justify-content: center; margin-top: 104px;">
						<button type="button" class="btn btn-label-secondary btn-prev" disabled>
							<i class="ti ti-arrow-left me-sm-1 me-0"></i>
							<span class="align-middle d-sm-inline-block d-none">이전</span>
						</button>
						<button type="button" class="btn btn-primary btn-nextPage">
							<span class="align-middle d-sm-inline-block d-none me-sm-1 me-0">다음</span>
							<i class="ti ti-arrow-right"></i>
						</button>
					</div>
				</div>
			</div>
<!-- 두번 째 영역 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
			<div id="personal-info" class="content">
				<div class="content-header mb-4">
					<span class="badge px-2 bg-label-primary">사원 사내 정보</span>
					<small>&nbsp 신규 사원의 사번, 소속, 개인 이메일을 입력해주세요.</small>
				</div>
				<div class="row g-6">
					
					<div class="mb-4">
						<label class="form-label" for="empId"><strong>사번</strong></label>
						<input type="text" class="form-control" name="empId" id="empId" placeholder="해당 입사일에 맞추어 자동 등록됩니다." readonly />
					</div>
					<div class="mb-4">
						<label class="form-label" for="deptUpCd"><strong>소속</strong></label>
						<div class="row">
							<div class="col-md-6 mb-4 mb-md-0">
								<select id="deptUpCd" name="deptUpCd" class="select2 form-select"
									data-allow-clear="true">
									<option value="">선택해주세요</option>
									<c:forEach var="departmentVO" items="${DeptVOList}"
										varStatus="stat">
										<option value="${departmentVO.deptCd}">${departmentVO.deptNm}</option>
									</c:forEach>
								</select>
							</div>
							<div class="col-md-6">
								<select id="deptCd" name="deptCd" class="select2 form-select"
									data-allow-clear="true">
								</select>
							</div>
						</div>
					</div>
					<div class="mb-4">
						<label class="form-label" for="empJncmpYmd"><strong>입사일</strong></label>
						<input type="date" class="form-control" name="empJncmpYmd" id="empJncmpYmd" />
					</div>
					<div class="mb-4">
						<label class="form-label" for="empMail"><strong>이메일</strong></label>
						<input type="email" name="empMail" id="empMail" class="form-control phone-mask" />
					</div>
					
					
					<div class="col-12 d-flex" style="justify-content: center; margin-top: 16px;">
						<button type="button" class="btn btn-label-secondary btn-prev">
							<i class="ti ti-arrow-left me-sm-1 me-0"></i> <span
								class="align-middle d-sm-inline-block d-none">이전</span>
						</button>
						<button type="button" class="btn btn-primary btn-nextPage">
							<span class="align-middle d-sm-inline-block d-none me-sm-1 me-0">다음</span>
							<i class="ti ti-arrow-right"></i>
						</button>
					</div>
				</div>
			</div>
<!-- 세번 째 영역 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
			<!-- Social Links -->
			<div id="social-links" class="content">
				<div class="content-header mb-4">
					<span class="badge px-2 bg-label-danger">등록 전 확인사항</span>
					<small>&nbsp 사원 등록 전 확인 메뉴얼</small>
				</div>
				<div class="row g-6">
					
					<div id="manualTitle">
						
					</div>
					
					<div id="manualCon" class="row">
					    <div class="col-md-6">
					        <a>
					            <strong style="color: #3366ff;">1. 개인정보 확인</strong><br/>
					            <ul style="margin: 0; padding-left: 20px;">
					                <li><strong>성명</strong>: 사원의 성명은 공식 서류와 일치하는지 확인하세요.</li>
					                <li><strong>생년월일</strong>: 정확한 생년월일을 입력하세요.</li>
					                <li><strong>연락처</strong>: 사원의 현재 연락처를 입력하세요.</li>
					            </ul>
					            <br/>
					            <strong style="color: #3366ff;">2. 사내 정보 확인</strong><br/>
					            <ul style="margin: 0; padding-left: 20px;">
					                <li><strong>사번</strong>: 사번은 시스템에서 자동 생성됩니다. 사번이 정확한지 확인하세요.</li>
					                <li><strong>소속 부서</strong>: 사원이 소속된 부서를 정확하게 선택하세요.</li>
					                <li><strong>입사일</strong>: 사원의 실제 입사일을 입력하세요.</li>
					                <li><strong>이메일</strong>: 사원의 회사 이메일 주소를 입력하세요.</li>
					            </ul>
					            <br/>
					            <strong style="color: #3366ff;">3. 기타 필수 정보</strong><br/>
					            <ul style="margin: 0; padding-left: 20px;">
					                <li><strong>주소</strong>: 사원의 현재 주소를 입력하세요.</li>
					                <li><strong>비상 연락처</strong>: 비상시 연락 가능한 연락처를 입력하세요.</li>
					            </ul>
					        </a>
					    </div>
					    <div class="col-md-6">
					        <a>
					            <strong style="color: #3366ff;">4. 서류 제출 확인</strong><br/>
					            <ul style="margin: 0; padding-left: 20px;">
					                <li><strong>신분증 사본</strong>: 사원의 신분증 사본을 제출 받으세요.</li>
					                <li><strong>학위증명서</strong>: 사원의 학위증명서를 제출 받으세요.</li>
					                <li><strong>경력증명서</strong>: 사원의 경력증명서를 제출 받으세요.</li>
					            </ul>
					            <br/>
					            <strong style="color: #3366ff;">5. 등록 전 최종 확인</strong><br/>
					            <ul style="margin: 0; padding-left: 20px;">
					                <li>모든 정보가 정확하게 입력되었는지 다시 한 번 확인하세요.</li>
					                <li>서류가 모두 제출되었는지 확인하세요.</li>
					                <li>사원 등록을 완료하기 전, 상위 관리자와 마지막으로 정보 확인을 하세요.</li>
					            </ul>
					            <br/>
					            <strong style="color: #ff0000;">6. 주의 사항</strong><br/>
					            <ul style="margin: 0; padding-left: 20px;">
					                <li>입력한 모든 정보는 개인정보 보호법에 따라 안전하게 관리됩니다.</li>
					                <li>잘못된 정보 입력 시, 등록이 거부되거나 사원 정보가 부정확하게 관리될 수 있습니다.</li>
					                <li>사원의 개인정보는 외부로 유출되지 않도록 주의하세요.</li>
					            </ul>
					        </a>
					    </div>
					</div>

					<div class="col-12 d-flex" style="justify-content: center; margin-top: 56px;">
						<button type="button" class="btn btn-label-secondary btn-prev">
							<i class="ti ti-arrow-left me-sm-1 me-0"></i> <span
								class="align-middle d-sm-inline-block d-none">이전</span>
						</button>
						<button type="submit" id="submitBtn" class="btn btn-primary" style="width: 93.7px;">
							등록 &nbsp
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-fill-check" viewBox="0 0 16 16">
							  <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7m1.679-4.493-1.335 2.226a.75.75 0 0 1-1.174.144l-.774-.773a.5.5 0 0 1 .708-.708l.547.548 1.17-1.951a.5.5 0 1 1 .858.514M11 5a3 3 0 1 1-6 0 3 3 0 0 1 6 0"/>
							  <path d="M2 13c0 1 1 1 1 1h5.256A4.5 4.5 0 0 1 8 12.5a4.5 4.5 0 0 1 1.544-3.393Q8.844 9.002 8 9c-5 0-6 3-6 4"/>
							</svg>
						</button>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
			
			
<script>
	let empId = "${empId}";
	console.log("empid : ", empId);

	$("#empJncmpYmd").on("change", function() {

		console.log("this.val : ", $(this).val())
		let inputDate = $(this).val();

		if (inputDate) {
			let formattedDate = inputDate.replace(/-/g, '');
			console.log("Formatted Date: ", formattedDate);

			$("#empId").val(formattedDate + empId);
		}
	});

	$("#deptUpCd").on(
			"change",
			function() {
				console.log($(this).val());
				let str = "<option value=''>팀 선택</option>";
				$("#deptCd").append(str);

				let deptUpCd = $(this).val();

				let data = {
					"deptUpCd" : deptUpCd
				};

				console.log("data >>", data);

				$.ajax({
					url : "/hrm/Team",
					contentType : "application/json;charset=utf-8",
					data : JSON.stringify(data),
					type : "post",
					dataType : "json",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("${_csrf.headerName}",
								"${_csrf.token}");
					},
					success : function(result) {
						console.log("result >> ", result)

						$.each(result, function(index, department) {
							str += "<option value='" + department.deptCd + "'>"
									+ department.deptNm + "</option>";
						});

						$("#deptCd").html(str);

					}
				});

			});
</script>

<script src="/resources/vuexy/assets/vendor/libs/bs-stepper/bs-stepper.js"></script>