<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">

const urlParams = new URL(location.href).searchParams;
const currentPage = urlParams.get('currentPage') == null ? 1 : urlParams.get('currentPage');
const deptCd = '${loginVO.deptCd}';
const header = "${_csrf.headerName}";
const token ="${_csrf.token}";

$(function(){
	let dMonth = document.querySelector('#month');
	let today = new Date();
	let todayMonth = today.getMonth() + 1 ;
	let fmtMonth = ("00" + todayMonth.toString()).slice(-2);
	dMonth.innerHTML = fmtMonth;
	
	getList("", currentPage);
	getEmpList();
	
	$('#btnSearch').on('click', function(){
		let keyword = $('#search').val();
		getList(keyword, currentPage);
	});
	
	$('#search').on('keyup', function(event){
        if (event.keyCode === 13) { // 엔터 키의 keyCode는 13
            keyword = $(this).val();
            getList(keyword, currentPage);
        }
    });
	
	$('#prevBtn').on('click', function(){
		let month = $('#month').text();
		let prevMonth = month -1;
		if(prevMonth > 0){
			let fmtPrevMonth = ("00" + prevMonth.toString()).slice(-2);
			dMonth.innerHTML = fmtPrevMonth;
		}
		getList("", currentPage);
	})
	
	$('#nextBtn').on('click', function(){
		let month = $('#month').text();
		let nextMonth = Number(month) +1;
		console.log(nextMonth);
		if(nextMonth < 13){
			let fmtNextMonth = ("00" + nextMonth.toString()).slice(-2);
			dMonth.innerHTML = fmtNextMonth;
		}
		getList("", currentPage);
	})
})

function getList(keyword, currentPage){
	let month = $('#month').text();
	console.log(month);
	let data = {
  		"currentPage": currentPage,
  		"keyword":keyword,		
  		"month":month,
  		"deptCd":deptCd
	}
	$.ajax({
		url:"/attendance/getListBydepart",
		type:"get",
		data:data,
		success:function(result){
			console.log(result.content);
			let str = "";
			for(const attendanceVO of result.content){
				let stts = attendanceVO.attnStts;
				let badge = "primary";
				if(stts == 'AS02') badge = 'success';
				else if(stts == 'AS01') badge = 'warning';
				
				str += `
					<tr>
						<td>
							<div class="d-flex justify-content-start align-items-center user-name">
								<div class="avatar-wrapper">
									<div class="avatar avatar-sm me-4">
										<img src="/view/\${attendanceVO.empId}" alt="Avatar" class="rounded-circle">
									</div>
								</div>
								<div class="d-flex flex-column">
									<span class="fw-medium">\${attendanceVO.empNm}</span>
								</div>
							</div>
						</td>
						<td>\${attendanceVO.attnBgng}</td>
						<td>\${attendanceVO.attnBgngTime}</td>
						<td>\${attendanceVO.attnEndTime}</td>
						<td><span class="badge bg-label-\${badge} me-1">\${attendanceVO.stts}</span></td>
					</tr>
				`
			}
		$('#listBox').html(str);
		$('#pagingBox').html(result.pagingArea2);
		$('#total').text(`총 \${result.total}건`);
		}
	})
	
}

function getEmpList(){
	console.log(deptCd);
	let data = {
		"deptCd":deptCd
	}
	$.ajax({
		url:"/attendance/getEmployeeByDepart",
		type:"get",
		data:data,
		success: function(result){
			console.log(result);
			let str = "";
			for(const emp of result){
				str += `
					<tr>
						<td>
							<div class="d-flex justify-content-start align-items-center">
								<div class="avatar me-3 avatar-sm">
									<img src="/view/\${emp.empId}" alt="Avatar" class="rounded-circle" />
								</div>
								<div class="d-flex justify-content-between">
									<h6 class="mb-0">\${emp.jbgdNm} \${emp.empNm}</h6>
								</div>
							</div>
						</td>
					</tr>
				`;
			}
			$('#departOrg').html(str);
		}
	})
}
</script>
<div class="d-flex justify-content-between">
	<div class="col-12 col-md-6 col-lg-4 mb-4 order-1 order-xl-0" style="width: 30%">
		<div class="card" style="height: 100%">
			<div class="card-header d-flex align-items-center mb-4" style="padding: 15px;">
				<div class="card-title mb-0">
					<h5 class="m-0 me-2">오늘의 근무현황</h5>
				</div>
			</div>
			<div class="card-body">
				<div id="todayAttendanceChart"></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-xl-8 mb-4 order-1 order-lg-0">
		<div class="card">
			<div class="card-header d-flex justify-content-between ms-auto">
				<ul class="nav nav-tabs widget-nav-tabs pb-3 gap-4 mx-1 d-flex flex-nowrap" role="tablist">
					<li class="nav-item">
						<a
                            href="javascript:void(0);"
                            class="nav-link btn active d-flex flex-column align-items-center justify-content-center h-30"
                            role="tab"
                            data-bs-toggle="tab"
                            data-bs-target="#navs-orders-id"
                            aria-controls="navs-orders-id"
                            aria-selected="true">
                            <h6 class="tab-widget-title mb-0">연차사용현황</h6>
						</a>
					</li>
					<li class="nav-item">
						<a
                            href="javascript:void(0);"
                            class="nav-link btn d-flex flex-column align-items-center justify-content-center h-30"
                            role="tab"
                            data-bs-toggle="tab"
                            data-bs-target="#navs-sales-id"
                            aria-controls="navs-sales-id"
                            aria-selected="false">
                            <h6 class="tab-widget-title mb-0">월별근무평균</h6>
						</a>
					</li>
					<li class="nav-item">
						<a
                            href="javascript:void(0);"
                            class="nav-link btn d-flex flex-column align-items-center justify-content-center h-30"
                            role="tab"
                            data-bs-toggle="tab"
                            data-bs-target="#navs-profit-id"
                            aria-controls="navs-profit-id"
                            aria-selected="false">
                            <h6 class="tab-widget-title mb-0">연장근무현황</h6>
						</a>
					</li>
				</ul>
			</div>
			<div class="card-body">
				<div class="tab-content p-0 ms-0 ms-sm-2">
					<div class="tab-pane fade show active" id="navs-orders-id" role="tabpanel">
						<div id="earningReportsTabsOrders"></div>
					</div>
					<div class="tab-pane fade" id="navs-sales-id" role="tabpanel">
						<div id="earningReportsTabsSales"></div>
					</div>
					<div class="tab-pane fade" id="navs-profit-id" role="tabpanel">
						<div id="earningReportsTabsProfit"></div>
					</div>
					<div class="tab-pane fade" id="navs-income-id" role="tabpanel">
						<div id="earningReportsTabsIncome"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="d-flex justify-content-between" style="width: 100%;">
	<div class="card" style="width: 78%;">
		<div>
			<div class="d-flex justify-content-center">
				<button type="button" id="prevBtn" class="input-group-text border-none"><i class="ti ti-chevron-left"></i></button>
				<h3 class="card-header text-primary" id="month"></h3>
				<button type="button" id="nextBtn" class="input-group-text border-none"><i class="ti ti-chevron-right"></i></button>
			</div>
			<div class="d-flex justify-content-between align-items-center">
				<h6 id="total" class="text-muted ms-4 mb-0"></h6>
				<div class="input-group input-group-merge nameSearch">
			    	<input type="search" id="search" placeholder="이름검색" class="form-control" value="">
			    	<button type="button" id="btnSearch" class="input-group-text"><i class="ti ti-search"></i></button>
			    </div>
		    </div>
			<div class="table-responsive text-nowrap">
				<table class="table">
					<thead>
						<tr>
							<th>이름</th>
							<th>날짜</th>
		                    <th>출근시간</th>
		                    <th>퇴근시간</th>
		                    <th>상태</th>
						</tr>
					</thead>
					<tbody class="table-border-bottom-0" id="listBox">
						
					</tbody>
				</table>
			</div>
			<div id="pagingBox" class="pt-3"></div>
		</div>
	</div>
	<div class="col-xl-6 col-lg-6 col-md-6" style="width: 20%">
		<div class="card">
			<div class="card-header d-flex align-items-center justify-content-between">
				<div class="card-title mb-0">
					<h5 class="m-0 me-2">부서원</h5>
				</div>
			</div>
			<div class="card-body pb-0 ps" id="vertical-orgchart">
				<div class="table-responsive">
					<table class="table table-borderless orgChart">
						<tbody id="departOrg">
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="/resources/vuexy/assets/js/cards-analytics.js" defer="defer"></script>
                