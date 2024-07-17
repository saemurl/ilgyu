<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<style>
.vac-header {
	display: flex; 
	justify-content: space-between;
}
.vac-header .count-vac {
	text-align:center;
 	width: 15%;
	height: 150px;
	padding: 0px;
}
.totalVacDiv .useVacDiv .remainVacDiv {
	font-size: 80px;
}
.vacTextArea {
	text-align:	center;
	font-size: 30px;
}
.vacArea {
	width: 130px;
}
</style>


<div class="card" style="height: 300px">
	<div class="bg-primary" style="border-top-left-radius: 8px; border-top-right-radius: 8px; color: white; padding: 10px; text-align: center;">
		<p style="margin: 0px">
	        <strong>내 연차 현황</strong>
	    </p>
	</div>
	
	<div class="d-flex justify-content-center">
		<button type="button" id="prevBtn" class="input-group-text border-none"><i class="ti ti-chevron-left"></i></button>
		<h3 class="card-header text-primary" id="month"></h3>
		<button type="button" id="nextBtn" class="input-group-text border-none"><i class="ti ti-chevron-right"></i></button>
	</div>
	
	<div class="mt-2" style="display: flex; justify-content: space-around; text-align: center;">
		<div class="vacArea">
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">발생 연차</h5>
		      <p class="card-text vacTextArea">
		        0
		      </p>
		    </div>
		  </div>
		</div>
		
		<div class="vacArea">
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">발생 월차</h5>
		      <p class="card-text vacTextArea">
		        0
		      </p>
		    </div>
		  </div>
		</div>
		
		<div class="vacArea">
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">이월 월차</h5>
		      <p class="card-text vacTextArea">
		        0
		      </p>
		    </div>
		  </div>
		</div>
		
		<div class="vacArea">
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">조정 연차</h5>
		      <p class="card-text vacTextArea">
		        0
		      </p>
		    </div>
		  </div>
		</div>
		
		<div class="vacArea">
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">총 연차</h5>
		      <p class="card-text vacTextArea" id="CreateVacCount">
		      	<input type="hidden" id="CreateVacInput" value="10">
		       4
		      </p>
		    </div>
		  </div>
		</div>
		<div>
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">사용 연차</h5>
		      <p class="card-text vacTextArea" id="useVacCount">
		      <input type="hidden" id="useVacInput" value="">
		      3
		      </p>
		    </div>
		  </div>
		</div>
		<div class="vacArea">
		  <div class="card shadow-none bg-transparent border border-primary">
		    <div class="card-body text-primary">
		      <h5 class="card-title text-primary">잔여 연차</h5>
		      <p class="card-text vacTextArea">
		        1
		      </p>
		    </div>
		  </div>
		</div>
		
	</div>

</div>


<br>
<div class="card">
<!--     <div class="bg-primary" style="border-top-left-radius: 8px; border-top-right-radius: 8px; color: white; padding: 10px; text-align: center;"> 
        <p style="margin: 0px">
            <strong>연차 사용 내역</strong>
        </p>
    </div> -->
    
	<br>
	
	<div style="display: flex; justify-content: space-between; margin-top: 20px; margin-left: 30px; margin-right: 30px">
		<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
	        <input type="radio" class="btn-check" name="btnradio" id="btnradio1" value="사용" checked />
	        <label class="btn btn-outline-primary" for="btnradio1">사용 연차내역</label>
	
	        <input type="radio" class="btn-check" name="btnradio" id="btnradio2" value="생성" />
	        <label class="btn btn-outline-primary" for="btnradio2">생성 연차내역</label>
	    </div>
	    <div>
			<button class="btn btn-primary" id="createBtn" style="width: 150px; float:right;">휴가신청</button>
	    </div>
	</div>
	
	 
	
    <div class="card-datatable table-responsive" id="tableArea" style="padding: 20px">
        <!-- 테이블 생성 위치 -->
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	
	
	
	$("input[name='btnradio']").on("change", function() {
    let btnradioVal = $("input[name='btnradio']:checked").val();
//     console.log("btnradioVal =>" , btnradioVal );
    
    if (btnradioVal == "생성") {
		useVacTableList ();
	}else if (btnradioVal == "사용") {
    	myTableReload();
	}
	    
	});

	
	
function useVacTableList (){
	let str = ``; 
	str += `<table id="myTable" class="table table-hover">
			<thead>
			<tr>
			<th>NO</th>
			<th>휴가 종류</th>
			<th>일수</th>
			<th>내용</th>
			<th>상태</th>
			</tr>
			</thead>`;

			str +=`<tr>`;
			str +=`<td>1</td>`;
			str +=`<td>유급 휴가</td>`;
			str +=`<td> 1 </td>`;
			str +=`<td>1개월 개근</td>`;
			str +=`<td>사용</td>`;
			str +=`</tr>`;
			
			str +=`<tr>`;
			str +=`<td>2</td>`;
			str +=`<td>유급 휴가</td>`;
			str +=`<td> 1 </td>`;
			str +=`<td>1개월 개근</td>`;
			str +=`<td>사용</td>`;
			str +=`</tr>`;
			
			str +=`<tr>`;
			str +=`<td>3</td>`;
			str +=`<td>유급 휴가</td>`;
			str +=`<td> 1 </td>`;
			str +=`<td>1개월 개근</td>`;
			str +=`<td>사용</td>`;
			str +=`</tr>`;
			
			str +=`<tr>`;
			str +=`<td>4</td>`;
			str +=`<td>유급 휴가</td>`;
			str +=`<td> 1 </td>`;
			str +=`<td>1개월 개근</td>`;
			str +=`<td>미사용</td>`;
			str +=`</tr>`;

			str += `</tbody>
					</table>`;

		$('#tableArea').html(str);

//			const myTableElement = document.querySelector("#myTable");
//			const dataTable = new simpleDatatables.DataTable(myTableElement, {
//			labels: {
//				placeholder: "검색어를 입력해 주세요.",
//				noRows: "게시판에 작성된 글이 없습니다.",
//				info: "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
//				noResults: "검색 결과가 없습니다."
//				},
//				perPageSelect: false,
//				perPage: 10
//			});
	
}
	

// myTableReload(); // 초기 테이블 로드




let valMonth;
$(function(){
	let dMonth = document.querySelector('#month');
	let today = new Date();
	let todayMonth = today.getMonth() + 1 ;
	let fmtMonth = ("00" + todayMonth.toString()).slice(-2);
	dMonth.innerHTML = fmtMonth;
	valMonth = fmtMonth;
	myTableReload();
	
	$('#prevBtn').on('click', function(){
		let month = $('#month').text();
		let prevMonth = month -1;
		if(prevMonth > 0){
			let fmtPrevMonth = ("00" + prevMonth.toString()).slice(-2);
			dMonth.innerHTML = fmtPrevMonth;
			valMonth = fmtPrevMonth;
			console.log(fmtPrevMonth);
			console.log("valMonth",valMonth);
			myTableReload();
		}
	})
	
	$('#nextBtn').on('click', function(){
		let month = $('#month').text();
		let nextMonth = Number(month) +1;
		if(nextMonth < 13){
			let fmtNextMonth = ("00" + nextMonth.toString()).slice(-2);
			dMonth.innerHTML = fmtNextMonth;
			valMonth = fmtNextMonth;
			console.log(fmtNextMonth);
			console.log("valMonth",valMonth);
			myTableReload();
		}
	})
})
function myTableReload() {
		let data = {
				"month":valMonth
		}
		console.log("myTableReload=>data",data)
		
        $.ajax({
        	url:"/attendance/vacationPostList",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
							xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
            success: function(vacationPostList) {
                console.log("아작스 연차 현황 값 받아온 데이터 체크 : ", vacationPostList);
                let str = `	<table id="myTable" class="table table-hover" style="text-ali">
		                	<thead class="table-dark">
		    				<tr>
		   					<th>NO</th>
		   					<th>휴가 종류</th>
		   					<th>사용 기간</th>
		   					<th>내용</th>
		   					<th>사용(예정) 연차일수</th>
		   					<th>상태</th>
		    				</tr>
		    				</thead>`;

                $.each(vacationPostList, function(index, vacList) {
	               	str +=	`<tr>
							 <td>\${index+1}</td>`;
					 str +=	`<td>\${vacList.LE_MNG_NM}</td>`;
					 str +=	`<td>\${vacList.LE_BGNG_YMD} ~ \${vacList.LE_END_YMD}</td>
							 <td>\${vacList.LE_CN}</td>`;
					if (vacList.APRVR_DOC_NO == 03) {
						
						str +=`<td>\${vacList.COUNT_DAYS} 일</td>
						<td><span class="badge bg-label-success">승인완료</span></td>`;
					}else if (vacList.APRVR_DOC_NO == 02) {
						str +=`<td>-</td>
						<td><span class="badge bg-label-warning">진행</span></td>`;
					}else {
						str +=`<td>-</td>
						<td><span class="badge bg-label-danger">반려</span></td>`;
					}
						
					str +=`</tr>`;
                });

                str += `</tbody>
                    </table>`;
				
                $('#tableArea').html(str);

                const myTableElement = document.querySelector("#myTable");
                const dataTable = new simpleDatatables.DataTable(myTableElement, {
                    labels: {
                        placeholder: "검색어를 입력해 주세요.",
                        noRows: "사용 연차 내역이 없습니다.",
                        info: "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
                        noResults: "검색 결과가 없습니다."
                    },
                    perPageSelect: false,
                    perPage: 10
                });
            }
        });
    }
	countVacDays();
	function countVacDays(){
		$.ajax({
			url:"/attendance/countVacDays",
			contentType:"application/json;charset=utf-8",
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
							xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				$("#useVacCount").text(result.TOTAL_DAYS);
				
				useVacCountInt = result.TOTAL_DAYS;
			}
		});
	}
	
	
	
	
	$('#createBtn').on('click', function(){

		location.href="/attendance/leaveInsert";
	})
	
	
	
	

});
</script>
