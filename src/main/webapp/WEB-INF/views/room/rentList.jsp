<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
.details-row {
    display: none;
}

#firstCard {
	width: 800px; 
	height: 150px; 
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	margin-right: 10px; 
}

#secondCard {
	width: 581px; 
	height: 150px; 
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* 애니메이션 영역 ------------- */
.progress {
    height: 10px;
    width: 200px;
    background-color: #f3f3f3;
    border-radius: 2px;
    overflow: hidden;
    margin-right: 10px;
}

.progress-bar {
    height: 100%;
    width: 0;
    border-radius: 2px;
    animation: loadProgress 0.8s ease-out forwards;
    box-shadow: 0 3px 3px -5px #000, 0 2px 5px #7367f0;
}

.bg-first {
    background-color: #7367f0;
    animation-delay: 0s; /* 첫 번째 바는 딜레이 없음 */
}

.bg-second {
    background-color: #a599f7;
    animation-delay: 0.1s; /* 두 번째 바는 0.2초 딜레이 */
}

.bg-third {
    background-color: #ccc2fb;
    animation-delay: 0.2s; /* 세 번째 바는 0.4초 딜레이 */
}

@keyframes loadProgress {
    0% {
        width: 0;
    }
    60% {
        width: calc(var(--progress-width) + 5%);
    }
    75% {
        width: calc(var(--progress-width) - 3%);
    }
    85% {
        width: calc(var(--progress-width) + 1%);
    }
    100% {
        width: var(--progress-width);
    }
}
/* 애니메이션 영역 ------------- */

#firstBtn, #secondBtn, #thirdtBtn {
	height: 20px;
}

</style>

<script>
$(document).ready(function() {

	
   let dataTable;

    function reloadTable() {
        if (dataTable) {
            dataTable.destroy(); // 기존 인스턴스를 제거합니다.
        }

        $.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/room/rentTable",
            type: "get",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
            	
            	let employeeVOList = result.employeeVOList;
                let meetingRoomRentVOList = result.meetingRoomRentVOList;
            	
                console.log("아작스 예약 정보자 데이터 체크: ", employeeVOList);
                console.log("아작스 회의실 예약 정보 데이터 체크: ", meetingRoomRentVOList);

                let str = ``;

                str += `<table id="myTable" class="dt-row-grouping table">
                <thead>
                <tr>
                <th>예약번호</th>
                <th>회의실</th>
                <th>예약일</th>
                <th>예약시간</th>
                <th>신청자</th>
                <th>대여상태</th>
                <th>작업</th>
                <th style="display:none;">사용목적</th>
                </tr>
                </thead>
                <tbody>`;

                $.each(meetingRoomRentVOList, function(index, meetingRoomRentVO) {
                	
                    str += `<tr>`;

                    str += `<td>\${meetingRoomRentVO.rentNo}</td>`;
                    str += `<td>\${meetingRoomRentVO.mtgrNm}</td>`;
                    str += `<td>\${meetingRoomRentVO.rentDate}</td>`;
                    str += `<td>\${meetingRoomRentVO.rentBgng.substring(9, 14)} - \${meetingRoomRentVO.rentEnd.substring(9, 14)}</td>`;
                    str += `<td>\${meetingRoomRentVO.empNm}</td>`;
                    str += `<td>`;
                    if (meetingRoomRentVO.rentStts === 'Y') {
                        str += `<span class="badge bg-label-success">예약</span>`;
                    } else {
                        str += `<span class="badge bg-label-danger">취소</span>`;
                    }
                    str += `</td>`;
                    
                    str += `<td>
                    <div class="dropdown d-inline-block">
                    <a href="javascript:;" class="multiBtn" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="text-primary ti ti-dots-vertical"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                    <li><a href="#" class="dropdown-item detail" style="padding:8px;">상세보기</a></li>`;
                    if (meetingRoomRentVO.rentStts === 'Y') {
                    str += `<hr/>
                    <li><a href="#" class="dropdown-item text-danger cancel" data-rentno="\${meetingRoomRentVO.rentNo}">예약취소</a></li>`;
                    }                    
                    str += `</ul>
                    </div>
                    </td>`;
                    
                    str += `<td style="display:none;">\${meetingRoomRentVO.rentRsn}</td>`;
                    
                    str += `</tr>`;
                });

                str += `</tbody>
                </table>`;
				
                $('#tableArea').html(str);

                const myTable = document.querySelector("#myTable");
                dataTable = new simpleDatatables.DataTable(myTable, {
                	labels: {
                        placeholder: "검색어를 입력해 주세요.",
                        noRows: "게시판에 작성된 글이 없습니다.",
                        info: "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
                        noResults: "검색 결과가 없습니다."
                    },
                    perPageSelect: false,
                    perPage: 10
                });
            }
        });
    }

    reloadTable(); // 초기 데이터테이블을 초기화합니다.
	
// 회의실 예약 취소 버튼 영역 시작 ----------------------------------------------------------------------------------------------------------\\ 	
	$('#tableArea').on('click', '.cancel', function() {
        var rentNo = $(this).data('rentno');
        
        $(this).closest('.dropdown-menu').removeClass('show').closest('.dropdown').removeClass('show');

        Swal.fire({
            title: '',
            text: "회의실 예약을 취소하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: "닫기",
            confirmButtonText: "예약 취소",
            customClass: {
                confirmButton: 'btn btn-primary me-1',
                cancelButton: 'btn btn-label-secondary'
            },
            buttonsStyling: false
        }).then(function(result) {
            if (result.value) {
                let data = { rentNo: rentNo };

                $.ajax({
                    url: "/room/rentalCancel",
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify(data),
                    type: "post",
                    dataType: "json",
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(meetingRoomRentVOList) {
                    	
                    	console.log("체크체크체크", meetingRoomRentVOList);
                        Swal.fire({
                            icon: 'success',
                            title: '',
                            text: '예약이 취소되었습니다.',
                            customClass: {
                                confirmButton: 'btn btn-success'
                            }
                        });
                        
                        reloadTable();
                        FchartReload();
                        toggleReload();
                    },
                });
            }
        });
    });
    
    // 상세보기에서 예약취소 버튼 누르면 ---
	$('#rentCancelBtn').on('click', function() {	
		
        Swal.fire({
            title: '',
            text: "회의실 예약을 취소하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: "닫기",
            confirmButtonText: "예약 취소",
            customClass: {
                confirmButton: 'btn btn-primary me-1',
                cancelButton: 'btn btn-label-secondary'
            },
            buttonsStyling: false
        }).then(function(result) {
            if (result.value) {
            	let rentNo = $('#detailModal').data('rentno');
                let data = { rentNo: rentNo };

                $.ajax({
                    url: "/room/rentalCancel",
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify(data),
                    type: "post",
                    dataType: "json",
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(meetingRoomRentVOList) {
                        Swal.fire({
                            icon: 'success',
                            title: '',
                            text: '예약이 취소되었습니다.',
                            customClass: {
                                confirmButton: 'btn btn-success'
                            }
                        });
                        
                        var detailModal = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
                        detailModal.hide();
                        
                        reloadTable();
                        FchartReload();
                        toggleReload();
                    },
                });
            }
        });
	})
    
// 회의실 예약 취소 버튼 영역 끝 -----------------------------------------------------------------------------------------------------------// 	    
    

// 회의실 예약 상세조회 버튼 영역 시작 ----------------------------------------------------------------------------------------------------------\\

	$('#tableArea').on('click', '.detail', function() {
		
		$(this).closest('.dropdown-menu').removeClass('show').closest('.dropdown').removeClass('show');
		
		var detailValue = $(this).closest('tr'); // 클릭된 detail 버튼이 있는 행을 가져옴
        var rentNo = detailValue.find('td').eq(0).text();
        var mtgrNm = detailValue.find('td').eq(1).text();
        var rentDate = detailValue.find('td').eq(2).text();
        var rentTime = detailValue.find('td').eq(3).text();
        var rentStts = detailValue.find('td').eq(5).text().trim();	// 삭제 여부 체크 '취소' or '예약'
        var rentRsn = detailValue.find('td').eq(7).text();
        
        $('#rentNo').val(rentNo);
        $('#mtgrNm').val(mtgrNm);
        $('#rentDate').val(rentDate);
        $('#rentTime').val(rentTime);
        $('#rentRsn').val(rentRsn);
		
        if (rentStts === '취소') {
            document.querySelector('#rentCancelBtn').style = 'display: none !important';
            document.querySelector('#updateBtn').style = 'display: none !important';
        } else {
        	document.querySelector('#rentCancelBtn').style = 'display: inline-block !important';
        	document.querySelector('#updateBtn').style = 'display: inline-block !important';
        }
        
        // 모달의 데이터 속성에 rentNo 저장
        $('#detailModal').data('rentno', rentNo);
        
		var detailModal = new bootstrap.Modal(document.getElementById('detailModal'));
		detailModal.show();
		
	});

// 회의실 예약 상세조회 버튼 영역 끝 -----------------------------------------------------------------------------------------------------------//

// updateBtn 클릭 시 시작 -----------------------------------------------------------------------------------------------------------\\
	$('#updateBtn').on('click', function() {
		
		Swal.fire({
            title: '',
            text: "회의실 예약을 수정하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: "닫기",
            confirmButtonText: "수정",
            customClass: {
                confirmButton: 'btn btn-primary me-1',
                cancelButton: 'btn btn-label-secondary'
            },
            buttonsStyling: false
        }).then(function(result) {
            if (result.value) {
            	let rentNo = $('#detailModal').data('rentno');
                let rentRsn = $('#rentRsn').val();
            	
                console.log("값 담긴거 체크 : " + rentNo + ", " + rentRsn);
                
            	let data = { 
           			rentNo: rentNo, 
           			rentRsn: rentRsn
            	};

                $.ajax({
                    url: "/room/rentalUpdate",
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify(data),
                    type: "post",
                    dataType: "json",
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(meetingRoomRentVOList) {
                        Swal.fire({
                            icon: 'success',
                            title: '',
                            text: '예약정보가 수정되었습니다.',
                            customClass: {
                                confirmButton: 'btn btn-success'
                            }
                        });
                        reloadTable();
                        FchartReload();
                    },
                });
            }
        });
	});
// updateBtn 클릭 시 종료 -----------------------------------------------------------------------------------------------------------//


// 상단 차트 조회 ------------

let FPropChart;

function FchartReload() {
    const canvas = $('#FPropChart')[0];
    const ctx = canvas.getContext('2d');

    $.ajax({
        contentType: "application/json;charset=utf-8",
        url: "/room/myRentRoomLabels",
        type: "get",
        dataType: "json",
        success: function(nameLabels) {
            const labels = nameLabels.map(label => label.mtgrNm);
            const counts = nameLabels.map(label => label.count);

            if (typeof FPropChart !== 'undefined') {
                FPropChart.destroy();
            }

            const maxValue = Math.max(...counts);
            const roundedMaxValue = Math.ceil(maxValue / 10) * 10;

            const data = {
                labels: labels,
                datasets: [{
                    label: '',
                    data: counts,
                    backgroundColor: 'rgba(153, 102, 255, 0.2)', // 연보라색 통일
                    borderColor: '#7367f0', // 보라색 테두리 통일
                    borderWidth: 1
                }]
            };

            const config = {
                type: 'bar',
                data: data,
                options: {
                    responsive: false,
                    plugins: {
                        legend: {
                            display: false // 범례 표시를 비활성화
                        },
                        tooltip: {
                            enabled: true // 툴팁 활성화
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            suggestedMax: roundedMaxValue, // y축 최대값을 제안
                            ticks: {
                                stepSize: 1 // 단위 설정
                            }
                        }
                    }
                }
            };

            FPropChart = new Chart(ctx, config);
        }
    });
}

// 초기 차트 로드
FchartReload();


// 자주 대여한 회의실 리로드 영역 -----------------------------
	function toggleReload() {
		$.ajax({
	        contentType: "application/json;charset=utf-8",
	        url: "/room/myRentTop3",
	        type: "get",
	        dataType: "json",
	        success: function(rentTopThree) {
	        	console.log("최댓값 3개 : ", rentTopThree);
	        	
	        		if (rentTopThree.length >= 3) {
	                    let topOne = rentTopThree[0].mtgrNm;
	                    let topOneCount = rentTopThree[0].count;
	                    
	                    let topTwo = rentTopThree[1].mtgrNm;
	                    let topTwoCount = rentTopThree[1].count;
	                    
	                    let topThree = rentTopThree[2].mtgrNm; 
	                    let topThreeCount = rentTopThree[2].count;
	                    
	                    let totalCount = topOneCount + topTwoCount + topThreeCount;

	                    let topOnePercentage = (topOneCount / totalCount) * 10000;
	                    let topTwoPercentage = (topTwoCount / totalCount) * 10000;
	                    let topThreePercentage = (topThreeCount / totalCount) * 10000;
	                    
	                    console.log("최댓값 1위, 2위, 3위 : " + topOne + " : " + topOneCount +" 번 , " + topTwo + " : " + topTwoCount +" 번 , " + topThree + " : " + topThreeCount + " 번");
	                    
	                    let str01 = ``;
	                    str01 += `
	                    	<div style="display: flex; align-items: center; margin-bottom: 10px;">
		        	            <div class="progress">
		        	                <div class="progress-bar bg-first" role="progressbar" style="--progress-width: \${topOnePercentage}%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
		        	            </div>
		        				<button class="btn btn-primary btn-sm waves-effect waves-light" id="firstBtn">\${topOne}</button>
		        				<i class="ti ti-ticket ti-md"></i><div class="badge bg-label-info">\${topOneCount} 회</div> 
		        	        </div>
		        	        <div style="display: flex; align-items: center; margin-bottom: 10px;">
		        	            <div class="progress">
		        	                <div class="progress-bar bg-second" role="progressbar" style="--progress-width: \${topTwoPercentage}%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
		        	            </div>
		        	            <button class="btn btn-primary btn-sm waves-effect waves-light" id="secondBtn">\${topTwo}</button>
		        	            <i class="ti ti-ticket ti-md"></i><div class="badge bg-label-info">\${topTwoCount} 회</div> 
		        	        </div>
		        	        <div style="display: flex; align-items: center;">
		        	            <div class="progress">
		        	                <div class="progress-bar bg-third" role="progressbar" style="--progress-width: \${topThreePercentage}%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
		        	            </div>
		        	            <button class="btn btn-primary btn-sm waves-effect waves-light" id="thirdtBtn">\${topThree}</button>
		        	            <i class="ti ti-ticket ti-md"></i><div class="badge bg-label-info">\${topThreeCount} 회</div> 
		        	        </div>`;
		        		$('#toggleArea').html(str01);	        
	                } 

	        		if (rentTopThree.length == 2) {
	                    let topOne = rentTopThree[0].mtgrNm; // 첫 번째 회의실 이름
	                    let topOneCount = rentTopThree[0].count;
	                    
	                    let topTwo = rentTopThree[1].mtgrNm; // 두 번째 회의실 이름
	                    let topTwoCount = rentTopThree[1].count;
	                    
	                    let totalCount = topOneCount + topTwoCount;

	                    let topOnePercentage = (topOneCount / totalCount) * 1000;
	                    let topTwoPercentage = (topTwoCount / totalCount) * 1000;
	                    
	                    console.log("최댓값 1위, 2위 : " + topOne + ", " + topTwo );
	                    
	                    let str02 = ``;
	                    str02 = `
	                    	<div style="display: flex; align-items: center; margin-bottom: 10px;">
		        	            <div class="progress">
		        	                <div class="progress-bar bg-first" role="progressbar" style="--progress-width: \${topOnePercentage}%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
		        	            </div>
		        				<button class="btn btn-primary btn-sm waves-effect waves-light" id="firstBtn">\${topOne}</button>
		        				<i class="ti ti-ticket ti-md"></i><div class="badge bg-label-info">\${topOneCount} 회</div> 
		        	        </div>
		        	        <div style="display: flex; align-items: center; margin-bottom: 10px;">
		        	            <div class="progress">
		        	                <div class="progress-bar bg-second" role="progressbar" style="--progress-width: \${topTwoPercentage}%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
		        	            </div>
		        	            <button class="btn btn-primary btn-sm waves-effect waves-light" id="secondBtn">\${topTwo}</button>
		        	            <i class="ti ti-ticket ti-md"></i><div class="badge bg-label-info">\${topTwoCount} 회</div> 
		        	        </div>`;
	                    $('#toggleArea').html(str02);	        
	                } 
	        		
	        		if (rentTopThree.length == 1) {
        			 	let topOne = rentTopThree[0].mtgrNm; // 첫 번째 회의실 이름
	                    let topOneCount = rentTopThree[0].count;
	                    
	                    let topOnePercentage = (topOneCount / topOneCount) * 100;
        			 	
        			 	console.log("최댓값 1위 : " + topOne );
	                    
	                    // nacocomusic gogo!
	                    // nacocomusic gogo!
	                    // nacocomusic gogo!
	                    
	                    
	                    let str03 = ``;
	                    str03 = `
	                    	<div style="display: flex; align-items: center; margin-bottom: 10px;">
		        	            <div class="progress">
		        	                <div class="progress-bar bg-first" role="progressbar" style="--progress-width: \${topOnePercentage}%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
		        	            </div>
		        				<button class="btn btn-primary btn-sm waves-effect waves-light" id="firstBtn">\${topOne}</button>
		        				<i class="ti ti-ticket ti-md"></i><div class="badge bg-label-info">\${topOneCount} 회</div> 
		        	        </div>`;
	                    $('#toggleArea').html(str03);	     
	                } 
	        		if (rentTopThree.length == 0) {
	        			let str04 = ``;
	        			str04 = `
	        				<div style="display: flex; align-items: center; margin-top: 35px;">
	        				"회의실 예약 정보가 없습니다."
	        				</div>`;
	        			$('#toggleArea').html(str04);
	        		}
			}
		})
	};
	toggleReload();

	
	 // 버튼 클릭 이벤트 설정
    $('#toggleArea').on('click', '.firstBtn', function () {
		alert("체크1");
    });

    $('#toggleArea').on('click', '.secondBtn', function () {
    	alert("체크2");
    });

    $('#toggleArea').on('click', '.thirdBtn', function () {
    	alert("체크3");
    });
	
	
});
</script>

<div style="display: flex; margin-bottom: 20px;">
	
	
	<div class="card" id="firstCard">
		<div class="bg-primary"
			style="border-top-left-radius: 5px; border-top-right-radius: 5px; color: white; padding: 5px; text-align: center; width:auto;">
			<p style="margin: 0px">
				<strong>전체 예약 횟수</strong>
			</p>
		</div>
		<div style="align-self: center;">
			<canvas id="FPropChart" width="700" height="100" style="margin-top: 10px;"></canvas>
		</div>
	</div>
	
	
	<div class="card" id="secondCard">
		<div class="bg-primary"
			style="border-top-left-radius: 5px; border-top-right-radius: 5px; color: white; padding: 5px; text-align: center; width:auto;">
			<p style="margin: 0px">
				<strong>자주 대여한 회의실</strong>
			</p>
		</div>
		<div id="toggleArea" style="align-self: center; margin-top: 10px;">
			<!-- 스크립트에서 가져올 영역 -->
	    </div>
	</div>
	
</div>


<div class="card" style="height: 650px; padding: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
    <div class="card-datatable table-responsive" id="tableArea">
        <!-- 테이블 출력 영역 -->
    </div>
</div>

<!-- 모달 영역 -->

<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">예약 상세조회</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col mb-3">
            <label for="rentNo" class="form-label">예약번호</label>
            <input type="text" id="rentNo" class="form-control" readonly>
          </div>
        </div>
        <div class="row">
          <div class="col mb-3">
            <label for="mtgrNm" class="form-label">회의실</label>
            <input type="text" id="mtgrNm" class="form-control" readonly>
          </div>
        </div>
        <div class="row g-2">
          <div class="col mb-0">
            <label for="rentDate" class="form-label">예약일</label>
            <input type="text" id="rentDate" class="form-control" readonly>
          </div>
          <div class="col mb-0">
            <label for="rentTime" class="form-label">예약시간</label>
            <input type="text" id="rentTime" class="form-control" readonly>
          </div>
        </div>
        <div>
          <label for="rentRsn" class="form-label">사용목적</label>	
          <textarea id="rentRsn" class="form-control" rows="15" cols="10"></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="updateBtn">수정</button>
        <button type="button" class="btn btn-primary" id="rentCancelBtn">예약취소</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>