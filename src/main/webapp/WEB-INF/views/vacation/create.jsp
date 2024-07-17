<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
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
    #previewArea, #previewArea * {
        visibility: visible;
    }
    #previewArea {
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

<div style="display: flex;">
	<div>
		<div class="card" style="width: 800px; height: 600px; margin-bottom: 20px;">	    
			
			<div class="bg-primary"
				style="border-top-left-radius: 3px; border-top-right-radius: 3px; color: white; padding: 3px; text-align: center;">
				<p style="margin: 0px">
					<strong>휴가 신청</strong>
				</p>
			</div>
			
			<div style="padding: 20px;">
			
				<small style="color: #E57373">
					※ 휴가 신청 시, 최소 2주 전에 신청서를 제출해야 하며, 승인 후 일정 변경 시 즉시 상사에게 보고해야 합니다.<br/><br/> 
				</small>
			
				<div style="display: flex;">
					<span class="badge bg-label-primary" style="height: 30px; align-content: center; place-self: center; margin-right: 10px;">휴가 종류</span>
			        <select class="form-select" id="leMngCd" aria-label="기본 선택 예" style="width: 200px;">
			            <option value="LE001">연차휴가</option>
			            <option value="LE002">출산휴가</option>
			            <option value="LE003">병가</option>
			            <option value="LE004">생리휴가</option>
			            <option value="LE005">경조사휴가</option>
			        </select>
				</div>
		        <br>
			    <div>
			        <textarea class="form-control" id="leCn" rows="5" placeholder="휴가 사유를 기술해주세요."></textarea>
			    </div>
			    
			    <br/>
			    <div style="display: flex;">
			        <span class="badge bg-label-primary" style="height: 30px; align-content: center; place-self: center; margin-right: 10px;">휴가 시작</span>
			        <input type="date" class="form-control" id="leBgngYmd" style="width: 200px;">
			        <a style="align-self: center; margin-left: 10px; margin-right: 10px;">-</a>
			        <span class="badge bg-label-danger" style="height: 30px; align-content: center; place-self: center; margin-right: 10px;">휴가 종료</span>
			        <input type="date" class="form-control" id="leEndYmd" style="width: 200px;">
			    </div>
			    
				<br>
			    <div class="mb-2" style="display: flex;">
			        <input type="text" class="form-control" id="leAgent" style="width: 200px;" readonly>
			        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#aproveInfoModal" style="margin-left: 10px;">
			        	대무자 선택 &nbsp;
			        	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-fill" viewBox="0 0 16 16">
						  <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
						</svg>
			        </button>
			    </div>
			    <hr/>
			    <button class="btn btn-primary" id="previewBtn" style="width:100px; margin-right: 10px;">미리보기</button>
				<button class="btn btn-primary" id="btnInsert" style="width:100px;">휴가신청</button>
				<button type="button" id="exampleBtn" style="margin-left: 15px; background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
				<div style="background-color: rgb(207, 226, 243); padding: 10px; margin-top: 10px;">
		        	- 휴가 신청 양식은 모든 필수 항목을 정확하게 작성해야 하며 <a style="color: #E57373">누락된 정보가 있을 경우 신청이 반려될 수 있습니다.</a><br/>
		        	- 휴가 신청 시 연차, 병가, 경조사 휴가 등 휴가의 유형을 명확히 기재해야 합니다.<br/>
		        	- 휴가 중 예상치 못한 긴급 상황에 대비하여 긴급 연락처는 본인 이외의 번호를 기재하는 것을 권장합니다.<br/>
		        </div>
			</div>
		</div>
		
		<div class="card" style="height: 180px; padding: 20px; padding-top: 10px;">
			
			<div style="display: flex; justify-content: right;">
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
			<strong style="color: #E57373;">※ 서류 제출 유의사항</strong>
			<div style="background-color: rgb(207, 226, 243); padding: 10px; margin-top: 5px;">
					- 개인 정보 보호를 위해 다운로드한 PDF 파일을 안전한 위치에 보관하고, 필요 시 암호화를 권장합니다.<br/>
		        	- 다운로드 전 모든 입력 정보를 정확히 기재하고 미리보기를 통해 내용을 확인합니다.<br/>
					- PDF 파일이 저장될 위치와 파일명을 확인하고 저장 후 열어 내용이 올바른지 다시 확인합니다.<br/>
	        </div>
			
		</div>
		
	</div>	

<!-- 미리보기 PDF 영역 -------------------------------------------------------------------------------------------------------------- -->
	<div class="card" id="previewArea" style="height: 800px; width: 810px; padding: 20px; margin-left: 20px;">
		<h5 style="align-self: center;">휴가 신청서</h5>
		<div class="" style="display: flex; justify-content: space-around;">
			<table style="border-top: 1px solid gray; border-bottom: 1px solid gray; width: 45%;">
			   <tr>
			        <td rowspan="2" colspan="2" id="tableTitle">기간</td>
			        <td id="leBgngYmdPre" style="width: 150px;"></td>
			    </tr>
			    <tr>
			        <td id="leEndYmdPre"></td>
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
			<table style="border-top: 1px solid gray; border-bottom: 1px solid gray; width: 95%; align-self: center;">
				<tr>
			        <td id="tableTitle">휴가 구분</td>
			        <td id="leMngCdPre" class="" style="height: 50px; width: 470px;"></td>
			    </tr>
			</table>
		<br/>
			<table style="border-top: 1px solid gray; border-bottom: 1px solid gray; width: 95%; align-self: center;">
				<tr>
			        <td id="tableTitle">사 유</td>
			        <td id="leCnPre" class="" style="height: 300px; width: 470px;"></td>
			    </tr>
			</table>
		<br/>
			<table style="border-top: 1px solid gray; border-bottom: 1px solid gray; width: 95%; align-self: center;">
				<tr>
			        <td id="tableTitle">업무 대행자</td>
			        <td id="leAgentPre" class="" style="height: 50px; width: 470px;"></td>
			    </tr>
			</table>
		<br/>	
			<div>
				<small style="float: right; margin-right: 20px;">위와 같이 휴가를 신청합니다.</small><br>
				<small style="float: right; margin-right: 20px;" id="previewDate"></small><br>
				<small style="float: right; margin-right: 20px;" id="previewName">신청자 :  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (인)</small>
				
			</div>
		<div style="text-align: -webkit-center;">
			<div style="width: 45%; text-align: center;">
				<a><strong>Groovit Company</strong></a><br>
				<a>대표이사 : O O O</a>
				<img alt="도장" src="\resources\images\stampSample.png" style="width: 70px;">	
			</div>
		</div>
	</div>
<!-- 미리보기 PDF 영역 [종료] -------------------------------------------------------------------------------------------------------------- -->
	
</div>

<!-- 대무자 선택 모달 영역 [ 시작 ] ----------------------------------------------------------------------------------------------------------- -->
    <div class="modal fade" id="aproveInfoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content" style="padding: 10px;">
	            <button id="toggleBtn" class="btn btn-label-primary waves-effect" onclick="jsTree()" style="width: 150px;">전체열기</button>
                <div class="modal-body" id="jstreeBody" style="align-self: center; width: 400px;">
                    <input type="text" class="form-control" id="schName" placeholder="[ 부서, 팀, 이름 ] 검색" style="margin-right: 10px;">
                    <div id="jstreeApprTemp" style=""></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btnSave">저장</button>
                    <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>
<!-- 대무자 선택 모달 영역 [ 종료 ] ----------------------------------------------------------------------------------------------------------- -->


<script>
    let selectedApproverName = ""; // 선택된 대무자의 이름을 저장하는 변수 추가

    $(document).ready(function() {
        $("#btnSave").on('click', function() {
            $("#leAgent").val(selectedApproverName); // 대무자 이름 설정
            $("#aproveInfoModal").modal('hide'); // 모달 닫기
        });

        $("#jstreeApprTemp").jstree({
        	"plugins": ["search"],
            'core': {
                'data': {
                    "url": function(node) {
                        return "/orgchart/select"; // ajax로 요청할 URL
                    }
                },
                "check_callback": true // 요거이 없으면, create_node 안먹음
            }
        });

        $('#jstreeApprTemp').on("select_node.jstree", function(e, data) {
            selectedApproverName = data.node.text; // 선택된 노드의 이름 저장
        });

        $("#schName").on("input", function() {
            $('#jstreeApprTemp').jstree(true).search($("#schName").val());
        });
        
        
        new PerfectScrollbar(document.getElementById('jstreeBody'), {
      	  wheelPropagation: false
      	});
        
        
        $('#previewBtn').on('click', function () {
			console.log("미리보기 버튼 클릭 체크 ");
			
			let leMngCd = '';
			let leMngCdVal = $("#leMngCd").val();
			if(leMngCdVal == 'LE001') leMngCd = '연차휴가';
			if(leMngCdVal == 'LE002') leMngCd = '출산휴가';
			if(leMngCdVal == 'LE003') leMngCd = '병가';
			if(leMngCdVal == 'LE004') leMngCd = '생리휴가';
			if(leMngCdVal == 'LE005') leMngCd = '경조사휴가';
			console.log("값 체크 : "+ leMngCd);
			
	        let leCn      = $("#leCn").val();
	        let leBgngYmd = $("#leBgngYmd").val();
	        let leEndYmd  = $("#leEndYmd").val();
	        let leAgent   = $("#leAgent").val();
			
	        $('#leMngCdPre').text(leMngCd);
	        $('#leCnPre').text(leCn);
	        $('#leBgngYmdPre').text(leBgngYmd);
	        $('#leEndYmdPre').text(leEndYmd);
	        $('#leAgentPre').text(leAgent);
	        
	     	// 현재 날짜를 yyyy-mm-dd 형식으로 포맷하여 출력
	        let today = new Date();
	        let year = today.getFullYear();
	        let month = ('0' + (today.getMonth() + 1)).slice(-2);
	        let day = ('0' + today.getDate()).slice(-2);
	        let formattedDate = year + '-' + month + '-' + day;

	        $('#previewDate').text(formattedDate);
	       
		});
        
    });

    let isTreeOpen = false;
    
    function jsTree() {
        if (isTreeOpen) {
            $('#jstreeApprTemp').jstree(true).close_all();
            $("#toggleBtn").text("전체열기");
        } else {
            $('#jstreeApprTemp').jstree(true).open_all();
            $("#toggleBtn").text("전체닫기");
        }
        isTreeOpen = !isTreeOpen;
    }
    

    $('#btnInsert').on('click', function(){
        let leMngCd   = $("#leMngCd").val();
        let leCn      = $("#leCn").val();
        let leBgngYmd = $("#leBgngYmd").val();
        let leEndYmd  = $("#leEndYmd").val();
        let leAgent   = $("#leAgent").val();

        let data = {
                "leMngCd" : leMngCd,
                "leCn"     : leCn,
                "leBgngYmd" : leBgngYmd,
                "leEndYmd" : leEndYmd,
                "leAgent" : leAgent
        }

        $.ajax({
            url: "/attendance/leaveInsertPost",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            beforeSend:function(xhr){
                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
            success: function(result) {
                console.log("result >> ", result);
                location.href="/attendance/vacationList";
            }
        });
    })
    
// 페이지 인쇄, PDF 출력 처리 버튼 영역 -------------------------------------------------------
	var initBodyHtml;
	
	function printPage() {
	    const element = document.getElementById('previewArea');
	    const printContent = element.innerHTML;

        window.print();
	}
	
	function downloadPDF() {
		
	    const element = document.getElementById('previewArea');
	    
	    html2canvas(element).then((canvas) => {
	        const imgData = canvas.toDataURL('image/png');
	        const pdf = new jspdf.jsPDF();
	        const imgProps = pdf.getImageProperties(imgData);
	        const pdfWidth = pdf.internal.pageSize.getWidth();
	        const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

	        pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
	        pdf.save("휴가신청서.pdf");
	    });
	}
//페이지 인쇄, PDF 출력 처리 버튼 영역 -------------------------------------------------------

	$('#exampleBtn').on('click', function () {
		console.log("자동완성 버튼 클릭 체크 ");
		
		$('#leCn').val("개인 사유로 인한 휴가 신청");
		$('#leBgngYmd').val("2024-07-18");
		$('#leEndYmd').val("2024-07-22");
	})

</script>
<script src="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>