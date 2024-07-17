<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="\resources\vuexy\assets\vendor\libs\jquery\jquery.js"></script>
<script src="/resources/js/html2canvas.js"></script>
<script src="/resources/js/jspdf.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.min.js"></script>

<style>
#pdfDownload, #pagePrint{
	display: block;
	border: 1px solid #868686;
    border-radius: 3px;
	width: 30px;
    height: 30px;
    text-align: center;
    align-content: center;
    margin: 5px;
}

@media print {
    body * {
        visibility: hidden;
    }
    #myPayStubArea * {
        visibility: visible;
    }
    #myPayStubArea {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
    }
    #pdfDownload, #pagePrint {
        display: none;
    }
}

#tableTitle {
	background-color: #F2F2F2;
	width: 100px;
    height: 30px;
    text-align: center;
}

td {
    text-align: center;
}

#textArea {
	display: flex;
    justify-content: space-around;
}
    
    
</style>

<script>
$(document).ready(function() {

	$('#selectMonth').on('change', function () {
		
		let nowYear = $('#nowYear').val();
		let selectMonth = this.value;
		console.log("선택한 selectMonth : " + selectMonth);
		
		let getMoneyDate = nowYear + "-" + selectMonth + "-25";
		let ajaxDate = nowYear + "-" + selectMonth;
		
		console.log("날짜 체크 : " + getMoneyDate);
		$('#getMoneyDate').text(getMoneyDate);
		
		let data = {'salMonth' : ajaxDate};
		
		$.ajax({
            url: "/salary/getSalaryData",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(selectSalaryVO) {
                
            	console.log("아작스 salary : selectSalaryVO : ", selectSalaryVO );
            	
            	let salBsc = selectSalaryVO.salBsc;				// 기본급여
            	let salAllowance = selectSalaryVO.salAllowance;	// 상여금
            	let salMeals = selectSalaryVO.salMeals;			// 식대
            	let salEtcs	= selectSalaryVO.salEtcs;			// 기타수당

            	let salPs = selectSalaryVO.salPs;				// 국민연금
            	let salHt = selectSalaryVO.salHt;				// 건강보험
            	let salEmp = selectSalaryVO.salEmp;				// 고용보험
            	let salTex = selectSalaryVO.salTex;				// 소득세
            	
            	let allMoney = salBsc + salAllowance + salMeals + salEtcs; 	// 지급합계
            	let allBill = salPs + salHt + salEmp + salTex;				// 공제합계
            	let realGetMoney = allMoney - allBill;						// 실지급액
            	
            	console.log("아작스 salary 값 개별 체크 : " + salBsc);
            	
           	 	let formatter = new Intl.NumberFormat('ko-KR', {	// [ 금액 #,### 처리 용도 ]
           	        minimumFractionDigits: 0
           	    });

           	    $('#salBsc').text(formatter.format(salBsc));
           	    $('#salAllowance').text(formatter.format(salAllowance));
           	    $('#salMeals').text(formatter.format(salMeals));
           	    $('#salEtcs').text(formatter.format(salEtcs));

           	    $('#salPs').text(formatter.format(salPs));
           	    $('#salHt').text(formatter.format(salHt));
           	    $('#salEmp').text(formatter.format(salEmp));
           	    $('#salTex').text(formatter.format(salTex));

           	    $('#allMoney').text(formatter.format(allMoney));
           	    $('#allBill').text(formatter.format(allBill));
           	    $('#realGetMoney').text(formatter.format(realGetMoney));
            	
            }
        });
		
		
	})
	
	
});
// 페이지 인쇄, PDF 출력 처리 버튼 영역 -------------------------------------------------------
	var initBodyHtml;
	
	function printPage() {
	    const element = document.getElementById('myPayStubArea');
	    const printContent = element.innerHTML;

        window.print();
	}
	
	function downloadPDF() {
		
	    const element = document.getElementById('myPayStubArea');
	    
	    let downloadName = $('.empName').text();
	    console.log("다운로드 이름 체크 : " + downloadName);
	    
	    html2canvas(element).then((canvas) => {
	        const imgData = canvas.toDataURL('image/png');
	        const pdf = new jspdf.jsPDF();
	        const imgProps = pdf.getImageProperties(imgData);
	        const pdfWidth = pdf.internal.pageSize.getWidth();
	        const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

	        pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
	        pdf.save(downloadName + "_급여명세서.pdf");
	    });
	}
//페이지 인쇄, PDF 출력 처리 버튼 영역 -------------------------------------------------------

document.addEventListener('DOMContentLoaded', function() {
    const selectMonth = document.getElementById('selectMonth');
    const currentMonth = new Date().getMonth() + 1; // getMonth()는 0부터 시작하므로 +1 필요

    for (let i = 1; i < currentMonth; i++) {
        const option = document.createElement('option');
        option.value = i.toString().padStart(2, '0');
        option.text = i + '월';
        selectMonth.appendChild(option);
    }
});

</script>


<div style="display: flex;">
    
    <div class="card" id="myPayStubArea" style="height: 800px; width: 810px; padding: 20px; margin-right: 30px;">
    
        <br/>
        <h5 style="align-self: center;">급여 명세서</h5>
		<div class="" style="display: flex; justify-content: space-around;">
			<table style="border-top: 1px solid gray; border-bottom: 1px solid gray; width: 45%;">
			    <tr>
			        <td rowspan="2" id="tableTitle">지급연월</td>
			        <td rowspan="2" id="getMoneyDate">-</td>
			    </tr>
			</table>

			<table style="border-top: 1px solid gray; border-bottom: 1px solid gray; width: 45%;">
			    <tr>
			        <td id="tableTitle">사 원 명</td>
			        <td id="tableCon" class="empName">${employeeVO.empNm}</td>
			    </tr>
			    <tr>
			        <td id="tableTitle">소속/직급</td>
			        <td id="tableCon"> ${employeeVO.deptNm} / ${employeeVO.jbgdNm} </td>
			    </tr>
			</table>
		</div>
		
		<br/>
		
		<div style="display: flex; justify-content: space-around;">
			<div style="border-bottom: 1px solid #5d596c; width: 45%; text-align: center; color: #4A90E2;">
				<strong> 지급 내역 </strong>
			</div>		
			<div style="border-bottom: 1px solid #5d596c; width: 45%; text-align: center; color: #E57373;">
				<strong> 공제 내역 </strong>
			</div>		
		</div>
		
		<br/>
		
		<div style="display: flex; justify-content: space-around;">
			<div style="border-bottom: 1px solid #5d596c; width: 45%; text-align: center; height: 300px;">
				<div id="textArea">
		            <span>기본급여</span>
		            <span class="amount" id="salBsc"></span>
				</div>				
		            <br/>
		        <div id="textArea">
		            <span>상여금</span>
		            <span class="amount" id="salAllowance"></span>
				</div>
					<br/>
		        <div id="textArea">
		            <span>식대</span>
		            <span class="amount" id="salMeals"></span>
				</div>
					<br/>
		        <div id="textArea">
		            <span>기타수당</span>
		            <span class="amount" id="salEtcs"></span>
				</div>
			</div>
				
			<div style="border-bottom: 1px solid #5d596c; width: 45%; text-align: center; height: 300px;">
				<div id="textArea">
					<span>국민연금</span>
	                <span class="amount" id="salPs"></span>
	           	</div>
	                <br/>
	            <div id="textArea">    
					<span>건강보험</span>
	                <span class="amount" id="salHt"></span>
	            </div>
					<br/>
				<div id="textArea">
					<span>고용보험</span>
	                <span class="amount" id="salEmp"></span>
	            </div>
	                <br/>
	            <div id="textArea">
					<span>소득세</span>
	                <span class="amount" id="salTex"></span>
				</div>
			</div>
		</div>
		
		<br>
		
		<div style="display: flex; justify-content: space-around;">
			<div style="width: 45%; text-align: center;">
				<br>
				<a>귀하의 노고에 진심으로 감사합니다.</a>		
			</div>

			<div style="border-bottom: 1px solid #5d596c; width: 45%; text-align: center;">
				<table style="width: 100%;">
				    <tr>
				        <td id="tableTitle">지급합계</td>
				        <td id="allMoney"></td>
				    </tr>
				    <tr>
				        <td id="tableTitle" id="allBill">공제합계</td>
				        <td id="allBill"></td>
				    </tr>
				    <tr>
				        <td id="tableTitle" id="realGetMoney">실지급액</td>
				        <td id="realGetMoney"></td>
				    </tr>
				</table>
			</div>
		</div>
		<br><br><br>
		<div style="text-align: -webkit-center;">
			<div style="width: 45%; text-align: center;">
				<a><strong>Groovit Company</strong></a><br>
				<a>대표이사 : O O O</a>
				<img alt="도장" src="\resources\images\stampSample.png" style="width: 70px;">	
			</div>
		</div>
	
	</div>	




	<div>
		<!-- 인쇄, PDF다운로드 버튼 -------------------------------------------------------------------- -->
		<div style="display: flex;">
			<a id="pdfDownload" href="" role="button" onclick="downloadPDF(); return false;">
				<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="#868686" class="bi bi-filetype-pdf" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M14 4.5V14a2 2 0 0 1-2 2h-1v-1h1a1 1 0 0 0 1-1V4.5h-2A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v9H2V2a2 2 0 0 1 2-2h5.5zM1.6 11.85H0v3.999h.791v-1.342h.803q.43 0 .732-.173.305-.175.463-.474a1.4 1.4 0 0 0 .161-.677q0-.375-.158-.677a1.2 1.2 0 0 0-.46-.477q-.3-.18-.732-.179m.545 1.333a.8.8 0 0 1-.085.38.57.57 0 0 1-.238.241.8.8 0 0 1-.375.082H.788V12.48h.66q.327 0 .512.181.185.183.185.522m1.217-1.333v3.999h1.46q.602 0 .998-.237a1.45 1.45 0 0 0 .595-.689q.196-.45.196-1.084 0-.63-.196-1.075a1.43 1.43 0 0 0-.589-.68q-.396-.234-1.005-.234zm.791.645h.563q.371 0 .609.152a.9.9 0 0 1 .354.454q.118.302.118.753a2.3 2.3 0 0 1-.068.592 1.1 1.1 0 0 1-.196.422.8.8 0 0 1-.334.252 1.3 1.3 0 0 1-.483.082h-.563zm3.743 1.763v1.591h-.79V11.85h2.548v.653H7.896v1.117h1.606v.638z"/>
				</svg>
			</a>
	
			<a id="pagePrint" href="" role="button" onclick="printPage(); return false;">
				<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="#868686" class="bi bi-printer-fill" viewBox="0 0 16 16">
				  <path d="M5 1a2 2 0 0 0-2 2v1h10V3a2 2 0 0 0-2-2zm6 8H5a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1"/>
				  <path d="M0 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2h-1v-2a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2H2a2 2 0 0 1-2-2zm2.5 1a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1"/>
				</svg>
			</a>
		</div>
		<!-- 인쇄, PDF다운로드 버튼 -------------------------------------------------------------------- -->
	    <div class="card" id="rightPanel" style="height: 100px; width: 800px; margin-bottom: 10px;">
			<div class="bg-primary"
				style="border-top-left-radius: 3px; border-top-right-radius: 3px; color: white; padding: 3px; text-align: center;">
				<p style="margin: 0px">
					<strong>날짜 선택</strong>
				</p>
			</div>
			
			<div style="padding: 20px; padding-top: 5px;">
				<!-- 날짜 선택 버튼 -------------------------------------------------------------------- -->
				<div class="salary-date" style="display: flex; align-items: center;">
					<input type="text" class="form-control" id="nowYear" value="2024" readonly style="width: 100px; margin-right: 20px; text-align: center;">
		            <select class="form-select" id="selectMonth" style="width: 200px;">
		            	<option value="선택" selected disabled>선택해주세요</option>
		            	<!-- 스크립트 영역에서 처리해서 가져오는 영역 -->
		            </select>
		        </div>
		        <div>
		        	<small style="color: #E57373">※ 급여 조회는 올해 기준으로만 가능합니다. 이전 년도 정보 조회가 필요할 경우 회계팀에 별도 문의주세요.</small>
		        </div>
				<!-- 날짜 선택 버튼 -------------------------------------------------------------------- -->
			</div>
		</div>
		
		<div class="card" style="height: 650px; width: 800px; padding: 20px;">
			
			<div class="accordion accordion-custom-button mt-3" id="accordionCustom">
			  <div class="accordion-item active">
			    <h2 class="accordion-header" id="headingCustomOne">
			      <button type="button" class="accordion-button" data-bs-toggle="collapse" data-bs-target="#accordionCustomOne" aria-expanded="false" aria-controls="accordionCustomOne">
			        	건강보험·국민연금 납부금액 조정을 신청
			      </button>
			    </h2>
			
			    <div id="accordionCustomOne" class="accordion-collapse collapse show" aria-labelledby="headingCustomOne" data-bs-parent="#accordionCustom">
			      <div class="accordion-body">
			                  건강보험·국민연금은 작년 소득을 기준으로 산정돼요.	<br/>
					그럼 기한후 종합소득세 신고나 종합소득세 경정청구를 통해 소득금액이 조정된 경우에는 어떻게 될까요?	<br/>
					
					소득금액이 조정됐을 때는 별도로 각 공단에 납부금액 조정을 신청해야 해요.	<br/>
					조정된 금액은 신청일이 속하는 달의 다음 달부터 그해 12월까지 반영돼요.	<br/><br/>
					<strong>1. 발급받은 증명원을 각 공단에 제출해요.</strong>	<br/>
						<div style="background-color: rgb(207, 226, 243); padding: 10px;">
							◾ 직접 방문		<br/>
							◾ 팩스		<br/>
							◾ 우편		<br/>
						</div>
					<strong>2. 각 공단에 유선으로 문의해요.</strong>	<br/>
						<div style="background-color: rgb(207, 226, 243); padding: 10px;">
							건강보험 고객센터 : 1577-1000	<br/>
							국민연금  고객센터 : 1355 (국번없이)	<br/>
						</div><br/>
						직접 방문하신 경우에는 해당 지사에서 소득금액 조정을 신청하셔도 돼요.
			      </div>
			    </div>
			  </div>
			  <div class="accordion-item">
			    <h2 class="accordion-header" id="headingCustomTwo">
			      <button type="button" class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#accordionCustomTwo" aria-expanded="false" aria-controls="accordionCustomTwo">
			        	직원 4대보험료 줄이는 방법
			      </button>
			    </h2>
			    <div id="accordionCustomTwo" class="accordion-collapse collapse" aria-labelledby="headingCustomTwo" data-bs-parent="#accordionCustom">
			      <div class="accordion-body">
			        <div style="background-color: rgb(207, 226, 243); padding: 10px;">
					            ◾ 비과세 급여 반영하기	<br/>
						◾ 4대보험 취득 신고 및 상실 신고 기한 준수하기	<br/>
						◾ 직원은 매월 2일 이후에 채용하기	<br/>
						◾ 사회보험료 지원금 받기 (두루누리 지원금)	<br/>
						◾ 일자리 안정 자금 받기 (2022년 6월 30일자로 지원 종료)	<br/>
					</div><br/>
			        <strong>비과세 급여 반영하기</strong><br/>
			        	보험료는 과세 급여를 기준으로 계산돼요. 따라서 급여 신고 시 비과세 항목을 반영하면 보험료를 낮출 수 있어요.<br/><br/>
			        <strong>대표적인 비과세 항목</strong><br/>
			        <div style="background-color: rgb(207, 226, 243); padding: 10px;">
			        	◾ 식대 (월 20만 원까지)<br/>
			        	◾ 자가운전보조금 (월 20만 원까지)<br/>
			        	◾ 출산, 자녀보육수당 (월 10만 원까지)<br/>
			        	◾ 연구보조비 (월 20만 원까지)<br/>
			        	◾ 연장근로수당 (연간 240만 원)<br/>
			        	◾ 학자금
			        </div>
			      </div>
			    </div>
			  </div>
			  <div class="accordion-item">
			    <h2 class="accordion-header" id="headingCustomThree">
			      <button type="button" class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#accordionCustomThree" aria-expanded="false" aria-controls="accordionCustomThree">
			        	4대보험 취득 취소 방법
			      </button>
			    </h2>
			    <div id="accordionCustomThree" class="accordion-collapse collapse" aria-labelledby="headingCustomThree" data-bs-parent="#accordionCustom">
			      <div class="accordion-body">
			        <strong>4대보험 취득 신고는 언제까지 해야 하나요?</strong><br/>
					국민연금, 고용보험, 산재보험은 취득일(입사일) 다음달 15일까지<br/>
					건강보험은 입사일 이후 14일 이내에 취득 신고를 해주셔야 해요.<br/>
					고용보험은 실업급여 수급 자격과도 연관되어 있기 때문에 취득 신고를 기한 내에 하지 않거나<br/>
					거짓으로 신고한 경우 과태료가 부과돼요.<br/><br/>
					
					<strong>근로자 취득 신고를 잘못했어요. 어떻게 취소하나요?</strong>
					<table class="table table-bordered" style="width: 100%; text-align: center;">
						<tr>
							<th style="background-color: rgb(207, 226, 243);">국민연금공단</th>
							<td>사업장가입자 내용변경 신고서</td>
						</tr>
						<tr>
							<th style="background-color: rgb(207, 226, 243);">건강보험공단</th>
							<td>직장가입자 자격 취득취소 신고서</td>
						</tr>
						<tr>
							<th style="background-color: rgb(207, 226, 243);">근로복지공단<br>(고용보험/산재보험)</th>
							<td>피보험자·고용정보 내역 취소 신청서</td>
						</tr>
						<tr>
							<th style="background-color: rgb(207, 226, 243);">공통</th>
							<td>취득 취소 사유를 기재한 경위서(또는 사실확인서)</td>
						</tr>
					</table>
			      </div>
			    </div>
			  </div>
			</div>
			
		</div>
		
    </div>
    
    
    
    
</div>
