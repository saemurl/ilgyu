<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
<style>
.card {
	padding: 20px;
}
</style>
<script type="text/javascript">
const urlParams = new URL(location.href).searchParams;
const srvyNo= urlParams.get('srvyNo');
const colors = [
    '#9B86BD',  // 보라색
    '#E9C46A',  // 밝은 황색
    '#F4A261',  // 살구색
    '#E76F51',  // 산호색
    '#80AF81',  // 짙은 청록색
    '#1D3557',  // 짙은 파란색
    '#A8DADC',  // 연한 청록색
    '#457B9D'   // 중간 청록색
];
const header = "${_csrf.headerName}";
const token ="${_csrf.token}";
const loginEmpId = ${loginVO.empId};

$(function() {
	let srvyEndYmd =$('#srvyEndYmd').val();
	let endTime = new Date(srvyEndYmd);
	let now = new Date();
	let writer = $('#srvyWriter').val();
	if(endTime <= now){
		$('.progressTool').hide();
	}
	
	console.log("설문 작성자인지 아닌지" + (loginEmpId != writer));
	if(loginEmpId != writer){
		$('#writerManageTool').removeClass("d-flex");
		$('#writerManageTool').hide();
	}
	
	getGraph();
	
	$('#btnList').on('click', function(){
		location.href="/survey/list";
	})
	
	$('#surveyStop').on('click', function(){
		Swal.fire({
	        title: '설문을 마감하시겠습니까 ?',
	        text: "마감시 복구가 불가능합니다.",
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: 'Yes',
	        customClass: {
				confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
				cancelButton: 'btn btn-label-secondary waves-effect waves-light'
	        },
	        buttonsStyling: false
		}).then(function (result) {
			if (result.isConfirmed) {
				$.ajax({
					url:"/survey/updateStop",
					contentType:"application/json;charset=UTF-8",
					data:srvyNo,
					type:"post",
					beforeSend:function(xhr){
						xhr.setRequestHeader(header,token);
					},
					success:function(result){
						Swal.fire({
		            	icon: 'success',
		            	title: '설문이 마감되었습니다.',
		            	showConfirmButton: false
					});
						setTimeout(function () {
							location.href = '/survey/manage';
						}, 1500);
					}
				})
			}
		});
	});
	
	$('#surveyDel').on('click', function(){
		/*
		if(endTime > now){
			Swal.fire({
		        title: '진행중인 설문은 삭제가 불가능합니다.',
		        text: "설문마감 후 삭제를 진행하시겠습니까 ?",
		        icon: 'warning',
		        showCancelButton: true,
		        confirmButtonText: 'Yes',
		        customClass: {
					confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
					cancelButton: 'btn btn-label-secondary waves-effect waves-light'
		        },
		        buttonsStyling: false
			}).then(function (result) {
				if (result.isConfirmed) {
					$.ajax({
						url:"/survey/delete",
						contentType:"application/json;charset=UTF-8",
						data:srvyNo,
						type:"post",
						beforeSend:function(xhr){
							xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
						},
						success:function(result){
							Swal.fire({
			            	icon: 'success',
			            	title: '삭제되었습니다.',
			            	showConfirmButton: false,
			            	timer: 1500
						});
							setTimeout(function () {
								location.href = '/survey/manage';
							}, 1500);
						}
					})
				}
			});
		}
		*/
		let text = '설문을 삭제하시겠습니까 ?';
		if(endTime > now){
			text = '진행중인 설문입니다. \n 그래도 삭제하시겠습니까?';
		}
		Swal.fire({
	        title: text,
	        text: "삭제시 복구가 불가능합니다.",
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: 'Yes',
	        customClass: {
				confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
				cancelButton: 'btn btn-label-secondary waves-effect waves-light'
	        },
	        buttonsStyling: false
		}).then(function (result) {
			if (result.isConfirmed) {
				$.ajax({
					url:"/survey/delete",
					contentType:"application/json;charset=UTF-8",
					data:srvyNo,
					type:"post",
					beforeSend:function(xhr){
						xhr.setRequestHeader(header,token);
					},
					success:function(result){
						Swal.fire({
		            	icon: 'success',
		            	title: '삭제되었습니다.',
		            	showConfirmButton: false
					});
						setTimeout(function () {
							location.href = '/survey/manage';
						}, 1500);
					}
				})
			}
		});
	});
	
	
	
});
function getGraph() {
	let data = {
		"srvyNo" : srvyNo
	}

	$.ajax({
		url : "/survey/getResult",
		type : "get",
		data : data,
		dataType : "json",
		success : function(result) {
			$.each(result.questionList, function(idx, question){
				console.log(question.sqSn);
				let id = "myChart"+(idx+1);
				let answerList = [];
				let responseList = [];
				let colorList = [];
				$.each(question.answerList, function(idx2, answer){
// 					console.log(answer);
					answerList.push(answer.saCn);
					responseList.push(answer.numOfResp);
					colorList.push(colors[idx2]);
				});
// 				console.log(answerList);
// 				console.log(responseList);
// 				console.log(id);
				// 그래프
                new Chart(document.getElementById(id), {
                    type: 'doughnut',
                    data: {
                      labels: answerList, // X축 
                      datasets: [{ 
                          data: responseList, // 값
                          backgroundColor: colorList,
                          fill: false
                        }
                      ]
                    },
                    options: {
                        responsive: false,
                        plugins: {
                            legend: {
                              position: 'bottom',
                              align: 'start',
                              labels: {
                                  boxWidth: 10
                              }
                            }
                    	}
                    }
                  }); //그래프
                  
			});	
		}
	}) // ajax	  
} // getGraph
</script>
<input type="hidden" id="srvyNo" value="${surveyVO.srvyNo}">
<input type="hidden" id="srvyEndYmd" value="${surveyVO.srvyEndYmd}">
<input type="hidden" id="srvyWriter" value="${surveyVO.empId}">
<div class="card rows">
	<div id="manageTool" class="toolBox">
		<a style="margin-right: auto" href="<%=request.getContextPath() %>/survey/list">설문 ></a>
		<div class="d-flex" id="writerManageTool">
			<div class="progressTool" >
				<a class="tool" href="/survey/update?srvyNo=${surveyVO.srvyNo}" id="surveyUpdate"><i class="ti ti-edit me-1"></i>수정</a>
				<a class="tool" href="javascript:void(0);" id="surveyStop"><i class="ti ti-ban me-1"></i>마감</a>
			</div>
			<a class="tool" href="javascript:void(0);" id="surveyDel"><i class="ti ti-trash me-1"></i>삭제</a>
		</div>
	</div>
	<div style="display: flex; justify-content: space-between;">
		<div style="align-items: center;">
			<h2>${surveyVO.srvyTtl}</h2>
		</div>
		<div>
			<div>작성자 : ${surveyVO.empNm}</div>
			<div>작성일 : ${surveyVO.srvyWrtYmd}</div>
			<div>설문기간 : ${surveyVO.srvyBgngYmd}-${surveyVO.srvyEndYmd}</div>
		</div>
	</div>
	<br><hr><br>
	<div class="row gy-4">
		<div class="col-md">
			<div class="card shadow-none bg-primary-subtle py-sm-1">
			    <div class="card-body text-primary p-0 pre-wrap">
			      	<p class="card-text">${surveyVO.srvyCn}</p>
				 </div>
		    </div>
		  </div>
		</div>
		<div class="divider text-start">
			<div class="divider-text">설문 결과</div>
		</div>
		<c:forEach var="question" items="${surveyVO.questionList}" varStatus="stat">
			<c:if test="${question.sqEsntlYn eq 'Y'}">
				<div class="ms-3">
					<span class="badge bg-danger bg-glow" style="margin-bottom: 5px">필수</span>
					<h4>${stat.count}. ${question.sqQstnCn}</h4>
				</div>
			</c:if>
			<c:if test="${question.sqEsntlYn eq 'N'}">
				<h4>${stat.count}.${question.sqQstnCn}</h4>
			</c:if>
			<div class="surveyChart">
				<canvas id="myChart${stat.count}" width="350" height="350" class="myChart"></canvas>
				<div class="col-xl-4 col-md-6 mb-4 myResult">
					<div class="card h-100 noshadow">
						<div class="card-body align-content-center">
							<ul class="p-0 m-0">
								<c:set var="totalNumOfResp" value="0" />
								<c:forEach var="answer" items="${question.answerList}" varStatus="status">
									<c:set var="totalNumOfResp" value="${totalNumOfResp + answer.numOfResp}" />
								</c:forEach>
								<c:forEach var="answer" items="${question.answerList}" varStatus="status">
									<c:set var="percentage" value="${(answer.numOfResp * 100) / totalNumOfResp}" />
									<fmt:formatNumber value="${percentage}" var="fmtPercentage" type="number" minFractionDigits="1" maxFractionDigits="1" />
									<li class="mb-3 pb-1 d-flex">
										<div class="d-flex w-50 align-items-center me-3" style="justify-content: space-between;">
											<h6 class="mb-0" style="text-align: left;">${answer.saCn}</h6>
										</div>
										<div class="d-flex flex-grow-1 align-items-center">
											<div class="progress w-100 me-3" style="height: 8px">
												<div
													class="progress-bar bg-primary"
													role="progressbar"
					                                style="width: ${fmtPercentage}%"
					                                aria-valuenow="${fmtPercentage}"
					                                aria-valuemin="0"
					                                aria-valuemax="100"></div>
											</div>
											<span class="text-muted">${fmtPercentage}%  (${answer.numOfResp}건)</span>
										</div>
									</li>
								</c:forEach>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</c:forEach>
		<hr>
		<div style="display:flex ; justify-content: end;">
			<button type="button" class="btn btn-outline-primary" id="btnList">목록</button>
		</div>
	</div>
</div>
