<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<script src="/resources/vuexy/assets/vendor/libs/chartjs/chartjs.js"></script>

<style>
#insertRoom{
    width: 200px;
}
.hidden {
    display: none;
}

-- 회의실 관리 테이블 회의실명 클릭 디자인 ------------------------------
.roomMtgrNm {
    cursor: pointer;
    color: #007bff;
    transition: color 0.3s ease, background-color 0.3s ease;
}

.roomMtgrNm:hover {
    color: #0056b3;
    background-color: #f1f1f1;
}

.roomMtgrNm.active {
    color: #ffffff; /* 클릭 시 텍스트 색상 */
    background-color: #7367f0; /* 클릭 시 배경 색상 */
}
-- 회의실 관리 테이블 회의실명 클릭 디자인 ------------------------------

#todayTableDiv {
	
}
</style>




<script>

$(document).ready(function() {
    
	
	// 초기 설정
    $('#topTable').removeClass('hidden');
	
    // 화면 선택 버튼 ──────────────────────────────────────────────────────\\    
    $('input[name="topBtn"]').on('change', function() {
        if ($('#roomAllBtn').is(':checked')) {
            roomAllFunction();
        } else if ($('#rentAllBtn').is(':checked')) {
            rentAllFunction();
        }
    });

    if ($('#roomAllBtn').is(':checked')) {
        roomAllFunction();
    } else if ($('#rentAllBtn').is(':checked')) {
        rentAllFunction();
    }
    // 화면 선택 버튼 ──────────────────────────────────────────────────────//    
    
    let topTable;        // 위 테이블
    let bottomTable;    // 아래 테이블
    
    function initializeTopDataTable() {
        if (topTable) {
            topTable.destroy(); // 기존 인스턴스를 제거합니다.
        }

        const myTopTable = document.querySelector("#myTopTable");
        topTable = new simpleDatatables.DataTable(myTopTable, {
            labels: {
                info: "",
                noRows: "등록된 회의실이 없습니다."
            },
            perPageSelect: false, 
            searchable: false, 
            perPage: 5,
            columns: [
                { select: [5], sortable: false } 
            ]
        });
    }

    function initializeBottomDataTable() {
        if (bottomTable) {
            bottomTable.destroy(); // 기존 인스턴스를 제거합니다.
        }

        const myBottomTable = document.querySelector("#myBottomTable");
        bottomTable = new simpleDatatables.DataTable(myBottomTable, {
            labels: {
                info: "",
                placeholder: "회의실 예약 검색어를 입력하세요.",
                noRows: "회의실 예약 데이터가 없습니다."
            },
            perPageSelect: false, 
            searchable: false, 
            perPage: 5,
            columns: [
                { select: [6], sortable: false } 
            ]
        });
    }

    initializeTopDataTable(); // 초기 데이터테이블을 초기화합니다.
    initializeBottomDataTable(); // 초기 데이터테이블을 초기화합니다.


// 회의실 등록 버튼 클릭 시 [시작] ---------------    
    $('#insertBtn').on('click', function () {
    	
    	// Select2 플러그인을 적용
        $("#eqpmntNm").select2({
            dropdownParent: $('#insertRoomModal')
        });
    	
    	$('#insertRoomModal').modal('show');
    
    });
    
    // 모달 닫힐 때 value 초기화
    $('#insertRoomModal').on('hidden.bs.modal', function () {
        $('#insertRoomModal').find('input, textarea').val('');
        $("#eqpmntNm").val(null).trigger('change');
    });
// 회의실 등록 버튼 클릭 시 [종료] ---------------    

$(document).on('click', '.rent-detail-icon', function () {
    var row = $(this).closest('tr');

    var rentNo = row.find('.rentNo').text();
    var mtgrNm = row.find('.mtgrNm').text();
    var empNm = row.find('.empNm').text();
    var rentStts = row.find('.rentStts span').text();
    var rentDate = row.find('.rentDate').text();
    var rentTime = row.find('.rentTime').text();
    var rentRsn = row.find('.rentRsn').text(); // Get the hidden element value

    // 콘솔 로그로 값 확인
    console.log("모달 값 가는지 체크 : " + rentNo);
    console.log("회의실명 : " + mtgrNm);
    console.log("신청자 : " + empNm);
    console.log("대여상태 : " + rentStts);
    console.log("예약일 : " + rentDate);
    console.log("예약시간 : " + rentTime);
    console.log("사용 목적 : " + rentRsn);

    // 모달의 입력 필드에 데이터 설정
    $('#rentNoDr').val(rentNo);
    $('#mtgrNmDr').val(mtgrNm);
    $('#empNmDr').val(empNm);

    if (rentStts.trim() === '예약') {
        $('#rentSttsSuccess').show();
        $('#rentSttsCancel').hide();
        document.querySelector('#rentCancelBtn').style = 'display: block !important';
    } else if (rentStts.trim() === '취소') {
        $('#rentSttsSuccess').hide();
        $('#rentSttsCancel').show();
        document.querySelector('#rentCancelBtn').style = 'display: none !important';
    }
    
    $('#rentDateDr').val(rentDate);
    $('#rentTimeDr').val(rentTime);
    $('#rentRsnDr').val(rentRsn);

    // 모달 열기
    $('#rentRoomModal').modal('show');
});

// 예약 상세조회 수정버튼 클릭 영역 -------------------------------------------\\
$(document).on('click', '#rentCancelBtn', function () {
	
	Swal.fire({
        title: '주의',
        html: "관리자 권한 하에 해당 예약을 취소시킬 경우 <br> 해당 사원에게 별도 공지하는 것을 권장합니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        cancelButtonText: "닫기",
        confirmButtonText: "예약 취소",
        customClass: {
            confirmButton: 'btn btn-warning me-1',
            cancelButton: 'btn btn-label-secondary'
        },
        buttonsStyling: false
    }).then(function(result) {
        if (result.value) {
            let data = { rentNo: $('#rentNoDr').val() };

            $.ajax({
                url: "/room/adminRentalCancel",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    Swal.fire({
                        icon: 'success',
                        title: '',
                        text: '예약이 취소되었습니다.',
                        customClass: {
                            confirmButton: 'btn btn-success'
                        }
                    })
                    
                    // 비동기 테이블 변경 [ 회의실 관리 ] ----------------------------------------------------------
						$.ajax({
			                contentType: "application/json;charset=utf-8",
			                url: "/room/reloadTopTable",
			                type: "get",
			                success: function(meetingRoomVOList) {
			                	
								let strCancel01 = ``;
								strCancel01 += `<table id="myTopTable" class="table table-striped table-bordered dataTable">
								            <thead>
								                <tr>
								                    <th>No</th>
								                    <th>회의실명</th>
								                    <th>수용인원</th>
								                    <th>시설물</th>
								                    <th>상태</th>
								                    <th>작업</th>
								                </tr>
								            </thead>
								            <tbody>`;

								$.each(meetingRoomVOList, function(index, meetingRoomVO) {
									strCancel01 += `<tr>
								                <td>\${index + 1}</td>             
								                <td class="roomMtgrNm">\${meetingRoomVO.mtgrNm}</td>        
								                <td>\${meetingRoomVO.mtgrCpct}</td>
								                <td class="roomEquipments">`;
								    
								    $.each(meetingRoomVO.equipments, function(equipIndex, equipment) {
								    	strCancel01 += `\${equipment.eqpmntNm}`;
								        if (equipIndex < meetingRoomVO.equipments.length - 1) {
								        	strCancel01 += `, `;
								        }
								    });

								    strCancel01 += `</td>
								                <td class="roomMtgrChck">`;
								    
								    if (meetingRoomVO.mtgrChck == 'Y') {
								    	strCancel01 += `<span class="badge bg-label-success">이용가능</span>`;
								    } else {
								    	strCancel01 += `<span class="badge bg-label-danger">이용불가</span>`;
								    }

								    strCancel01 += `</td>
								                <td>
								                    <i class="text-primary ti ti-dots-vertical room-detail-icon" style="cursor: pointer;"></i>
								                </td>
								            </tr>`;
								});

								strCancel01 += `</tbody>
								        </table>`;
								
								$('#topTable').html(strCancel01);
								initializeTopDataTable();
			                	
			                }
						});    
						
						
						
						// 비동기 테이블 변경 [ 전체 예약 조회 ] ----------------------------------------------------------
						$.ajax({
			                contentType: "application/json;charset=utf-8",
			                url: "/room/reloadBottomTable",
			                type: "get",
			                success: function(meetingRoomRentVOList) {
			                	
			                	let strCancel02 = ``;
			                	strCancel02 += `<table id="myBottomTable" class="table table-striped table-bordered dataTable">
								            <thead>
								                <tr>
								                    <th>예약번호</th>
								                    <th>회의실</th>
								                    <th>예약일</th>
								                    <th>예약시간</th>
								                    <th>신청자</th>
								                    <th>대여상태</th>
								                    <th style="display:none;">사용목적</th>
								                    <th>작업</th>
								                </tr>
								            </thead>
								            <tbody>`;
								
								$.each(meetingRoomRentVOList, function(index, meetingRoomRentVO) {
									strCancel02 += `<tr>
								                <td class="rentNo">\${meetingRoomRentVO.rentNo}</td>
								                <td class="mtgrNm">\${meetingRoomRentVO.mtgrNm}</td>
								                <td class="rentDate">\${meetingRoomRentVO.rentDate}</td>
								                <td class="rentTime">\${meetingRoomRentVO.rentBgng.substring(9, 14)} - \${meetingRoomRentVO.rentEnd.substring(9, 14)}</td>
								                <td class="empNm">\${meetingRoomRentVO.empNm}</td>
								                <td class="rentStts">`;
								    
								    if (meetingRoomRentVO.rentStts == 'Y') {
								    	strCancel02 += `<span class="badge bg-label-success">예약</span>`;
								    } else {
								    	strCancel02 += `<span class="badge bg-label-danger">취소</span>`;
								    }
								
								    strCancel02 += `</td>
								                <td class="rentRsn" style="display:none;">\${meetingRoomRentVO.rentRsn}</td>
								                <td>
								                    <i class="text-primary ti ti-dots-vertical rent-detail-icon" style="cursor: pointer;"></i>
								                </td>
								            </tr>`;
								});
								
								strCancel02 += `</tbody>
								        </table>`;  
								
						        $('#bottomTable').html(strCancel02);
								initializeBottomDataTable();
			                }
						});
					
					// 모달창 내 회의실 상태변경 -----------------------------------------------------------------
					$('#rentSttsSuccess').hide();
			        $('#rentSttsCancel').show();
			        document.querySelector('#rentCancelBtn').style = 'display: none !important';	
						
					// 차트 비동기 변경 [ 전체 예약 조회 ] ----------------------------------------------------------
                    chartReload(); 
                }
            })
        }
    });
	
});

// 예약 상세조회 수정버튼 클릭 영역 -------------------------------------------//



// 차트 영역 [시작] ---------------------------------------------------------------------------------------------------------	
	let rentPropChart;

	function chartReload() {
	    const canvas = $('#rentPropChart')[0];
	    const ctx = canvas.getContext('2d');
		
	    $.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/room/reloadRentRoom",
            type: "get",
            dataType: "json",
            success: function(roomNameList) {
            	
            	console.log("roomNameList :", roomNameList);
            	
                var labels = roomNameList.map(function(roomName) {
                    return roomName.mtgrNm;
                });
            
			    $.ajax({
		            url: "/room/rentCount",
		            contentType: "application/json;charset=utf-8",
		            type: "get",
		            dataType: "text", // 데이터 타입을 'json'으로 변경합니다.
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success: function(allCount) {
		            	
		            	console.log("체크" + allCount);
		            	
		            	var datas = allCount.split(',').map(Number);

		                if (rentPropChart) {
		                    rentPropChart.destroy();
		                }

		                const data = {
		                    labels: labels,
		                    datasets: [{
		                        data: datas
		                    }]
		                };

		                const config = {
		                    type: 'doughnut',
		                    data: data,
		                    options: {
		                        responsive: false, // 이걸 꺼야 크기 임의 조절이 된다.
		                        maintainAspectRatio: false,
		                        plugins: {
		                            title: {
		                                display: true,
		                                text: '금일 회의실 예약 통계 ',
		                                font: {
		                                    size: 18
		                                },
		                                padding: {
		                                    bottom: 10
		                                }
		                            }
		                        }
		                    }
		                };
		                const ctx = $('#rentPropChart')[0].getContext('2d');
		                rentPropChart = new Chart(ctx, config);
		            },
		            error: function(error) {
		                console.error('Error fetching data', error);
		            }
		        });
            }
	    });
    }
	chartReload();
// 차트 영역 [종료] ---------------------------------------------------------------------------------------------------------	


// 선택한 회의실 금일 예약 조회 영역 출력 [시작] ---------------------------------------------------------------------------------
	
    function defaultTodayTableDiv() {
        var todayRentTableBody = $('#todayRentTableBody tbody');
        todayRentTableBody.empty();
        var defaultRow = $('<tr></tr>');
        defaultRow.append('<td colspan="5" style="text-align: center; padding: 20px 0;">회의실을 선택하여 금일 예약 일정을 조회해주세요.</td>');
        todayRentTableBody.append(defaultRow);
    }

    defaultTodayTableDiv();

    $(document).on('click', '.roomMtgrNm', function(event) {
        event.stopPropagation();  // 이벤트 버블링 방지

        var mtgrNm = $(this).text();
        console.log("값 체크 : " + mtgrNm);

        var data = { mtgrNm: mtgrNm };
        
        // 클릭 했을 때 색상 변경해둬서 눌러둔 회의실 표시 [시작] -----
        $('.roomMtgrNm').removeClass('active');
        $(this).addClass('active');
        // 클릭 했을 때 색상 변경해둬서 눌러둔 회의실 표시 [종료] -----
        
        $.ajax({
            url: '/room/selectRentList',
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: 'POST',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(rentList) {
                console.log("가져온 금일 예약 회의실 조회 jsp 영역 체크 : ", rentList);
                
                var todayRentTableBody = $('#todayRentTableBody tbody');
                todayRentTableBody.empty();
                
                if (rentList.length === 0) {
                    // 데이터가 없는 경우 안내 메시지 추가
                    var row = $('<tr></tr>');
                    row.append('<td colspan="5" style="text-align: center; padding: 20px 0;">해당 회의실은 금일 예약 정보가 없습니다.</td>');
                    todayRentTableBody.append(row);
                } else {
                    // 데이터 추가
                    rentList.forEach(function(item) {
                        var row = $('<tr></tr>');
                        row.append('<td>' + item.mtgrNm + '</td>');
                        row.append('<td>' + item.rentDate + '</td>');
                        row.append('<td>' + item.rentBgng.substring(9, 14) + ' - ' + item.rentEnd.substring(9, 14) + '</td>');
                        row.append('<td>' + item.empNm + '</td>');
                        if(item.rentStts === 'Y'){ row.append('<td>' + '<span class="badge bg-label-success">'+ "예약" +'</span>' + '</td>'); }
                        if(item.rentStts === 'N'){ row.append('<td>' + '<span class="badge bg-label-danger">'+ "취소" +'</span>' + '</td>'); }
                        todayRentTableBody.append(row);
                    });
                }
            },
            error: function(error) {
                console.error('Error fetching data:', error);
            }
        });
    });

    $(document).on('click', '.top-panel', function(event) {	// 딴 곳 누르면 금일 조회 초기화
        if (!$(event.target).closest('.roomMtgrNm').length) {
            
        	defaultTodayTableDiv();
            
            $('.roomMtgrNm').removeClass('active');
        }
    });
	
// 선택한 회의실 금일 예약 조회 영역 출력 [종료] ---------------------------------------------------------------------------------	




// 회의실 상세 조회 [시작] ---------------------------------------------------------------------------------	
	
	$(document).on('click', '.room-detail-icon', function () {
	    // Select2 플러그인을 초기화하고 적용
	    $('#eqpmntNmDt').select2({
	        dropdownParent: $('#updateRoomModal')
	    });
	
	    var row = $(this).closest('tr');
	    var roomMtgrNm = row.find('.roomMtgrNm').text();
	    var roomEquipmentsText = row.find('.roomEquipments').text();
	    var roomMtgrChck = row.find('.roomMtgrChck').text().trim();
	    
	    var equipmentMap = {
	        "컴퓨터": "E001",
	        "프린터기": "E002",
	        "빔프로젝트": "E003",
	        "화이트보드": "E004",
	        "마이크": "E005",
	        "스피커": "E006"
	    };
	    
	    var roomEquipments = roomEquipmentsText.split(',').map(function(item) {
	        return equipmentMap[item.trim()];
	    });
	    
	    console.log("회의실 이름 가져오기 : " + roomMtgrNm);
	    console.log("회의실 장비 가져오기 : " + roomEquipments);
	    console.log("회의실 상태 가져오기 : " + roomMtgrChck);
	
	    let data = { "mtgrNm": roomMtgrNm };
	
	    $.ajax({
	        url: "/room/selectRoomDetail",
	        contentType: "application/json;charset=utf-8",
	        data: JSON.stringify(data),
	        type: "post",
	        dataType: "json",
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	        },
	        success: function(SelectRoomVO) {
	            console.log("아작스 값 받아온거 다시 체크 : ", SelectRoomVO);
	            $('#mtgrExplnDt').val(SelectRoomVO.mtgrExpln);
	            $('#mtgrCpctDt').val(SelectRoomVO.mtgrCpct);
	        }
	     });
	
	    $('#eqpmntNmDt').val(roomEquipments).trigger('change');
        console.log("Select2 값 설정 후 : ", $('#eqpmntNmDt').val());
        
	    $('#mtgrNmDt').val(roomMtgrNm);
	    $('#updateRoomModal').modal('show');
	    
	    if (roomMtgrChck === '이용가능') {
	        $('#mtgrChckOk').show();
	        $('#mtgrChckNo').hide();
	    } else if (roomMtgrChck === '이용불가') {
	        $('#mtgrChckOk').hide();
	        $('#mtgrChckNo').show();
	    }
	    
	});

	$(document).on('click', '#mtgrChckChange', function () {	// 회의실 상세 모달 내부 상태변경 버튼
		// 현재 상태 확인
	    var isMtgrChckOkVisible = $('#mtgrChckOk').is(':visible');
	    var isMtgrChckNoVisible = $('#mtgrChckNo').is(':visible');
	    
	    // 상태를 반전시키기
	    if (isMtgrChckOkVisible) {
	        $('#mtgrChckOk').hide();
	        $('#mtgrChckNo').show();
	    } else if (isMtgrChckNoVisible) {
	        $('#mtgrChckOk').show();
	        $('#mtgrChckNo').hide();
	    }
	});

// 회의실 상세 조회 [종료] ---------------------------------------------------------------------------------	




// 회의실 등록( +파일업로드 ) [시작] ---------------------------------------------------------------------------------	
	$(document).on('click', '#insertRoomBtn', function () {

		console.log("회의실 등록버튼 살아있는지 체크");
		
		let mtgrNm = $("#mtgrNm").val();		
		let mtgrCpct = $("#mtgrCpct").val();		
		let mtgrExpln = $("#mtgrExpln").val();		
		let eqpmntNm = $("#eqpmntNm").val();		
		
		let formData = new FormData();
		
		formData.append("mtgrNm",mtgrNm);
		formData.append("mtgrCpct",mtgrCpct);
		formData.append("mtgrExpln",mtgrExpln);
		formData.append("eqpmntNm",eqpmntNm);

		let atchfileSn = $("#atchfileSn");	// 파일업로드		
		let files = atchfileSn[0].files;
		
		for(let i =0; i<files.length; i++){
			formData.append("UploadFile", files[i]);
		}
		
		Swal.fire({
            title: '',
            text: "회의실을 등록하시겠습니까?",
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: "닫기",
            confirmButtonText: "등록",
            customClass: {
                confirmButton: 'btn btn-primary me-1',
                cancelButton: 'btn btn-label-secondary'
            },
            buttonsStyling: false
        }).then(function(result) {
            if (result.value) {
		
				$.ajax({
					url:"/room/createRoom",
					processData:false,
					contentType:false,
					data:formData,
					type:"post",
					dataType:"text",
					beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
					success:function(result){

						Swal.fire({
                            icon: 'success',
                            title: '',
                            text: '회의실이 등록되었습니다.',
                            customClass: {
                                confirmButton: 'btn btn-success'
                            }
                        });
						
	                	// 비동기 테이블 변경 [ 회의실 관리 ] ----------------------------------------------------------
						$.ajax({
			                contentType: "application/json;charset=utf-8",
			                url: "/room/reloadTopTable",
			                type: "get",
			                success: function(meetingRoomVOList) {
			                	
								let str2 = ``;
								str2 += `<table id="myTopTable" class="table table-striped table-bordered dataTable">
								            <thead>
								                <tr>
								                    <th>No</th>
								                    <th>회의실명</th>
								                    <th>수용인원</th>
								                    <th>시설물</th>
								                    <th>상태</th>
								                    <th>작업</th>
								                </tr>
								            </thead>
								            <tbody>`;

								$.each(meetingRoomVOList, function(index, meetingRoomVO) {
								    str2 += `<tr>
								                <td>\${index + 1}</td>             
								                <td class="roomMtgrNm">\${meetingRoomVO.mtgrNm}</td>        
								                <td>\${meetingRoomVO.mtgrCpct}</td>
								                <td class="roomEquipments">`;
								    
								    $.each(meetingRoomVO.equipments, function(equipIndex, equipment) {
								        str2 += `\${equipment.eqpmntNm}`;
								        if (equipIndex < meetingRoomVO.equipments.length - 1) {
								            str2 += `, `;
								        }
								    });

								    str2 += `</td>
								                <td class="roomMtgrChck">`;
								    
								    if (meetingRoomVO.mtgrChck == 'Y') {
								        str2 += `<span class="badge bg-label-success">이용가능</span>`;
								    } else {
								        str2 += `<span class="badge bg-label-danger">이용불가</span>`;
								    }

								    str2 += `</td>
								                <td>
								                    <i class="text-primary ti ti-dots-vertical room-detail-icon" style="cursor: pointer;"></i>
								                </td>
								            </tr>`;
								});

								str2 += `</tbody>
								        </table>`;
								
								$('#topTable').html(str2);
								initializeTopDataTable();
			                	
			                }
						});    
						
						
						
						// 비동기 테이블 변경 [ 전체 예약 조회 ] ----------------------------------------------------------
						$.ajax({
			                contentType: "application/json;charset=utf-8",
			                url: "/room/reloadBottomTable",
			                type: "get",
			                success: function(meetingRoomRentVOList) {
			                	
			                	let str3 = ``;
								str3 += `<table id="myBottomTable" class="table table-striped table-bordered dataTable">
								            <thead>
								                <tr>
								                    <th>예약번호</th>
								                    <th>회의실</th>
								                    <th>예약일</th>
								                    <th>예약시간</th>
								                    <th>신청자</th>
								                    <th>대여상태</th>
								                    <th style="display:none;">사용목적</th>
								                    <th>작업</th>
								                </tr>
								            </thead>
								            <tbody>`;
								
								$.each(meetingRoomRentVOList, function(index, meetingRoomRentVO) {
								    str3 += `<tr>
								                <td class="rentNo">\${meetingRoomRentVO.rentNo}</td>
								                <td class="mtgrNm">\${meetingRoomRentVO.mtgrNm}</td>
								                <td class="rentDate">\${meetingRoomRentVO.rentDate}</td>
								                <td class="rentTime">\${meetingRoomRentVO.rentBgng.substring(9, 14)} - \${meetingRoomRentVO.rentEnd.substring(9, 14)}</td>
								                <td class="empNm">\${meetingRoomRentVO.empNm}</td>
								                <td class="rentStts">`;
								    
								    if (meetingRoomRentVO.rentStts == 'Y') {
								        str3 += `<span class="badge bg-label-success">예약</span>`;
								    } else {
								        str3 += `<span class="badge bg-label-danger">취소</span>`;
								    }
								
								    str3 += `</td>
								                <td class="rentRsn" style="display:none;">\${meetingRoomRentVO.rentRsn}</td>
								                <td>
								                    <i class="text-primary ti ti-dots-vertical rent-detail-icon" style="cursor: pointer;"></i>
								                </td>
								            </tr>`;
								});
								
								str3 += `</tbody>
								        </table>`;  
								
						        $('#bottomTable').html(str3);
								initializeBottomDataTable();
			                	
			                }
						});
						
						// 차트도 비동기 재갱신 ---------------------------------------------------------------------------
						chartReload();
					}
				});
            }
         });
	});
// 회의실 등록( +파일업로드 ) [시작] ---------------------------------------------------------------------------------	
    

// 회의실 상세정보 수정 [시작] ---------------------------------------------------------------------------------------------------------------

$('#updateRoomBtn').on('click', function(){
	
	Swal.fire({
        title: '',
        text: "회의실 정보를 수정하시겠습니까?",
        icon: 'info',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        cancelButtonText: "취소",
        confirmButtonText: "수정",
        customClass: {
            confirmButton: 'btn btn-primary me-1',
            cancelButton: 'btn btn-label-secondary'
        },
        buttonsStyling: false
    }).then(function(result) {
        if (result.value) {
        	
        	var mtgrNmDt = $('#mtgrNmDt').val();
        	var mtgrCpctDt = $('#mtgrCpctDt').val();
        	var mtgrChckOk = $('#mtgrChckOk').css('display');
        	var mtgrChckNo = $('#mtgrChckNo').css('display');
        	if(mtgrChckOk === 'inline-block'){
        		var mtgrChck = "Y";
        	}
        	if(mtgrChckNo === 'inline-block'){
        		var mtgrChck = "N";
        	}
        	var mtgrExplnDt = $('#mtgrExplnDt').val();
        	
        	console.log("받아오는 mtgrNmDt 값 체크 " + mtgrNmDt);
        	console.log("받아오는 mtgrCpctDt 값 체크 " + mtgrCpctDt);
        	console.log("받아오는 mtgrChck 값 체크 " + mtgrChck);
        	console.log("받아오는 mtgrExplnDt 값 체크 " + mtgrExplnDt);
        	
        	let data = {
        		mtgrNm : mtgrNmDt,
        		mtgrCpct : mtgrCpctDt,
        		mtgrChck : mtgrChck,
        		mtgrExpln : mtgrExplnDt
        	}
        	
        	 $.ajax({
                 url: "/room/updateRoom",
                 contentType: "application/json;charset=utf-8",
                 data: JSON.stringify(data),
                 type: "post",
                 dataType: "json",
                 beforeSend: function(xhr) {
                     xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                 },
                 success: function(result) {
                	 Swal.fire({
                         icon: 'success',
                         title: '',
                         text: '수정되었습니다.',
                         customClass: {
                             confirmButton: 'btn btn-success'
                         }
                     });
                	 
                	// 비동기 테이블 변경 [ 회의실 관리 ] ----------------------------------------------------------
						$.ajax({
			                contentType: "application/json;charset=utf-8",
			                url: "/room/reloadTopTable",
			                type: "get",
			                success: function(meetingRoomVOList) {
			                	
								let strUr01 = ``;
								strUr01 += `<table id="myTopTable" class="table table-striped table-bordered dataTable">
								            <thead>
								                <tr>
								                    <th>No</th>
								                    <th>회의실명</th>
								                    <th>수용인원</th>
								                    <th>시설물</th>
								                    <th>상태</th>
								                    <th>작업</th>
								                </tr>
								            </thead>
								            <tbody>`;

								$.each(meetingRoomVOList, function(index, meetingRoomVO) {
									strUr01 += `<tr>
								                <td>\${index + 1}</td>             
								                <td class="roomMtgrNm">\${meetingRoomVO.mtgrNm}</td>        
								                <td>\${meetingRoomVO.mtgrCpct}</td>
								                <td class="roomEquipments">`;
								    
								    $.each(meetingRoomVO.equipments, function(equipIndex, equipment) {
								    	strUr01 += `\${equipment.eqpmntNm}`;
								        if (equipIndex < meetingRoomVO.equipments.length - 1) {
								        	strUr01 += `, `;
								        }
								    });

								    strUr01 += `</td>
								                <td class="roomMtgrChck">`;
								    
								    if (meetingRoomVO.mtgrChck == 'Y') {
								    	strUr01 += `<span class="badge bg-label-success">이용가능</span>`;
								    } else {
								    	strUr01 += `<span class="badge bg-label-danger">이용불가</span>`;
								    }

								    strUr01 += `</td>
								                <td>
								                    <i class="text-primary ti ti-dots-vertical room-detail-icon" style="cursor: pointer;"></i>
								                </td>
								            </tr>`;
								});

								strUr01 += `</tbody>
								        </table>`;
								
								$('#topTable').html(strUr01);
								initializeTopDataTable();
			                	
			                }
						});    
						
						
						
						// 비동기 테이블 변경 [ 전체 예약 조회 ] ----------------------------------------------------------
						$.ajax({
			                contentType: "application/json;charset=utf-8",
			                url: "/room/reloadBottomTable",
			                type: "get",
			                success: function(meetingRoomRentVOList) {
			                	
			                	let strUr02 = ``;
			                	strUr02 += `<table id="myBottomTable" class="table table-striped table-bordered dataTable">
								            <thead>
								                <tr>
								                    <th>예약번호</th>
								                    <th>회의실</th>
								                    <th>예약일</th>
								                    <th>예약시간</th>
								                    <th>신청자</th>
								                    <th>대여상태</th>
								                    <th style="display:none;">사용목적</th>
								                    <th>작업</th>
								                </tr>
								            </thead>
								            <tbody>`;
								
								$.each(meetingRoomRentVOList, function(index, meetingRoomRentVO) {
									strUr02 += `<tr>
								                <td class="rentNo">\${meetingRoomRentVO.rentNo}</td>
								                <td class="mtgrNm">\${meetingRoomRentVO.mtgrNm}</td>
								                <td class="rentDate">\${meetingRoomRentVO.rentDate}</td>
								                <td class="rentTime">\${meetingRoomRentVO.rentBgng.substring(9, 14)} - \${meetingRoomRentVO.rentEnd.substring(9, 14)}</td>
								                <td class="empNm">\${meetingRoomRentVO.empNm}</td>
								                <td class="rentStts">`;
								    
								    if (meetingRoomRentVO.rentStts == 'Y') {
								    	strUr02 += `<span class="badge bg-label-success">예약</span>`;
								    } else {
								    	strUr02 += `<span class="badge bg-label-danger">취소</span>`;
								    }
								
								    strUr02 += `</td>
								                <td class="rentRsn" style="display:none;">\${meetingRoomRentVO.rentRsn}</td>
								                <td>
								                    <i class="text-primary ti ti-dots-vertical rent-detail-icon" style="cursor: pointer;"></i>
								                </td>
								            </tr>`;
								});
								
								strUr02 += `</tbody>
								        </table>`;  
								
						        $('#bottomTable').html(strUr02);
								initializeBottomDataTable();
			                }
						});

						// 차트도 비동기 재갱신 ---------------------------------------------------------------------------
						chartReload();
						
// 						$('#updateRoomModal').modal('hide');
                 }
        	 });
        }
    });
	
	
	
});

// 회의실 상세정보 수정 [종료] ---------------------------------------------------------------------------------------------------------------

	$(document).on('click', '#enjoyBtn', function () {
		chartReload();
	});
    
    
});

function roomAllFunction() {
    $('#topTable').removeClass('hidden');
    $('#bottomTable').addClass('hidden');
    document.querySelector('#insertBtn').style = 'display: block !important';
}

function rentAllFunction() {
    $('#bottomTable').removeClass('hidden');
    $('#topTable').addClass('hidden');
    document.querySelector('#insertBtn').style = 'display: none !important';
}





</script>


<div class="top-panel card" style="padding: 20px; height:450px;">
    
    <div class="container" style="display: flex; justify-content:space-between; align-items: center;">
	    <div>
		    <div class="btn-group" role="group" aria-label="Basic radio toggle button group" style="margin-right: 20px;">
		        <input type="radio" class="btn-check" name="topBtn" id="roomAllBtn" checked>
		        <label class="btn btn-outline-primary waves-effect" for="roomAllBtn">회의실 관리</label>
		    
		        <input type="radio" class="btn-check" name="topBtn" id="rentAllBtn">
		        <label class="btn btn-outline-primary waves-effect" for="rentAllBtn">전체 예약 조회</label>
		    </div>
	    </div>
	    <div style="display: flex;">
	    	<button type="button" class="btn btn-icon rounded-pill btn-google-plus waves-effect waves-light" id="enjoyBtn" style="margin-right: 10px;">
	    		<i class="tf-icons ti ti-brand-pinterest"></i>
	    	</button>
	    	<button type="button" class="btn btn-primary waves-effect waves-light" id="insertBtn">회의실 등록</button>
	    </div>
	</div>
    
    <div class="card-datatable table-responsive" id="topTable">
        <table id="myTopTable" class="table table-striped table-bordered dataTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>회의실명</th>
                    <th>수용인원</th>
                    <th>시설물</th>
                    <th>상태</th>
                    <th>작업</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="meetingRoomVO" items="${meetingRoomVOList}" varStatus="stat">
                    <tr>
                        <td>${stat.count}</td>
                        <td class="roomMtgrNm">${meetingRoomVO.mtgrNm}</td>
                        <td>${meetingRoomVO.mtgrCpct}</td>
                        <td class="roomEquipments">
                            <c:forEach var='equipment' items='${meetingRoomVO.equipments}' varStatus='status'>
                                ${equipment.eqpmntNm}<c:if test='${!status.last}'>, </c:if>
                            </c:forEach>
                        </td>
                        <td class="roomMtgrChck">
                            <c:choose>
                                <c:when test="${meetingRoomVO.mtgrChck == 'Y'}">
                                    <span class="badge bg-label-success">이용가능</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-label-danger">이용불가</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <i class="text-primary ti ti-dots-vertical room-detail-icon" style="cursor: pointer;"></i>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    <div class="card-datatable table-responsive hidden" id="bottomTable">
        <table id="myBottomTable" class="table table-striped table-bordered dataTable">
            <thead>
                <tr>
                    <th>예약번호</th>
                    <th>회의실</th>
                    <th>예약일</th>
                    <th>예약시간</th>
                    <th>신청자</th>
                    <th>대여상태</th>
                    <th style="display:none;">사용목적</th>
                    <th>작업</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="meetingRoomRentVO" items="${meetingRoomRentVOList}">
                  <tr>
	                  <td class="rentNo">${meetingRoomRentVO.rentNo}</td>
	                  <td class="mtgrNm">${meetingRoomRentVO.mtgrNm}</td>
	                  <td class="rentDate">${meetingRoomRentVO.rentDate}</td>
	                  <td class="rentTime">${fn:substring(meetingRoomRentVO.rentBgng, 9, 14)} - ${fn:substring(meetingRoomRentVO.rentEnd, 9, 14)}</td>
	                  <td class="empNm">${meetingRoomRentVO.empNm}</td>
	                  <td class="rentStts">
	                      <c:choose>
	                          <c:when test="${meetingRoomRentVO.rentStts == 'Y'}">
	                              <span class="badge bg-label-success">예약</span>
	                          </c:when>
	                          <c:otherwise>
	                              <span class="badge bg-label-danger">취소</span>
	                          </c:otherwise>
	                      </c:choose>
	                  </td>
	                  <td class="rentRsn" style="display:none;">${meetingRoomRentVO.rentRsn}</td>
	                  <td>
	                      <i class="text-primary ti ti-dots-vertical rent-detail-icon" style="cursor: pointer;"></i>
	                  </td>
                  </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<br/>


<!-- 하단부 차트, 상세보기 [시작]─────────────────────────────────────────────────────────────────── -->
<div class="bottom" style="display: flex;">

<!-- 차트 [시작] ──────────────────────── -->
	<div class="card" id="chartArea" style="padding: 20px; width: 450px; display: flex; justify-content: center; align-items: center; margin-right: 20px;">
	    <canvas id="rentPropChart" width="300" height="300"></canvas>
	</div>
<!-- 차트 [종료] ──────────────────────── -->

<!-- 금일 선택 회의실 예약 조회 [시작] ──────────────────────── -->
	<div class="card" id="todayTableDiv" style="width: 1100px; height: 340px;">
	    <div class="bg-primary" style="border-top-left-radius: 8px; border-top-right-radius: 8px; color: white; padding: 10px; text-align: center;">
        	<p style="margin: 0px">금일 회의실 예약 조회</p>
    	</div>
	    <div style="height: calc(100% - 40px); overflow-y: auto; padding-left: 20px; padding-right: 20px;">
	        <table id="todayRentTableBody" class="datatables-basic table dataTable no-footer dtr-column" style="width: 100%;">
	            <tbody>
	                <tr>
	                    <td colspan="5" style="text-align: center; padding: 20px 0;">회의실을 선택하여 금일 예약 일정을 조회해주세요.</td>
	                </tr>
	            </tbody>
	        </table>
	    </div>
	</div>
<!-- 금일 선택 회의실 예약 조회 [종료] ──────────────────────── -->


</div>
<!-- 하단부 차트, 상세보기 [종료]─────────────────────────────────────────────────────────────────── -->


<!-- 모달 영역 ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── -->
<!-- 회의실 정보 수정 모달 -->
<div class="modal fade" id="updateRoomModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel3">회의실 상세</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row g-2">
          <div class="col mb-0">
            <label for="mtgrNmDt" class="form-label">회의실명</label>
            <input type="text" id="mtgrNmDt" class="form-control" placeholder="ex ) 101실">
          </div>
          <div class="col mb-0">
            <label for="mtgrChck" class="form-label">회의실 상태</label>
            <span id="mtgrChckOk" class="badge bg-label-success badge-lg" style="display: none;">이용가능</span>
   			<span id="mtgrChckNo" class="badge bg-label-danger badge-lg" style="display: none;">이용불가</span>
   			<br/>
   			<button type="button" class="btn btn-label-primary waves-effect" id="mtgrChckChange" style="width: 400px;">상태변경</button>
          </div>
        </div>
          <div class="col mb-3">
            <label for="mtgrCpctDt" class="form-label">수용인원</label>
            <input type="number" id="mtgrCpctDt" class="form-control">
          </div>
          <div class="col mb-3">
            <label for="mtgrExplnDt" class="form-label">회의실 설명</label>
            <textarea id="mtgrExplnDt" class="form-control"></textarea>
          </div>
          <div class="col mb-3">
			<label for="eqpmntNmDt" class="form-label">시설물</label>
			  <select id="eqpmntNmDt" class="eqpmntNm form-select" multiple disabled>
			    <optgroup label="회의실 내 물품 목록">
			      <option value="E001">컴퓨터</option>
			      <option value="E002">프린터기</option>
			      <option value="E003">빔프로젝트</option>
			      <option value="E004">화이트보드</option>
			      <option value="E005">마이크</option>
			      <option value="E006">스피커</option>
			    </optgroup>
			  </select>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="updateRoomBtn">수정</button>
        <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 회의실 추가 모달 -->
<div class="modal fade" id="insertRoomModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel3">회의실 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col mb-3">
            <label for="mtgrNm" class="form-label">회의실명</label>
            <input type="text" id="mtgrNm" class="form-control" placeholder="ex ) 101실">
          </div>
        </div>
          <div class="col mb-3">
            <label for="mtgrCpct" class="form-label">수용인원</label>
            <input type="number" id="mtgrCpct" class="form-control">
          </div>
          <div class="col mb-3">
            <label for="mtgrExpln" class="form-label">회의실 설명</label>
            <textarea id="mtgrExpln" class="form-control"></textarea>
          </div>
          <div class="col mb-3">
			<label for="eqpmntNm" class="form-label">시설물</label>
			  <select id="eqpmntNm" class="eqpmntNm form-select" multiple>
			    <optgroup label="회의실 내 물품 목록">
			      <option value="E001">컴퓨터</option>
			      <option value="E002">프린터기</option>
			      <option value="E003">빔프로젝트</option>
			      <option value="E004">화이트보드</option>
			      <option value="E005">마이크</option>
			      <option value="E006">스피커</option>
			    </optgroup>
			  </select>
          </div>
		  <div class="col mb-3">
		  	<label for="atchfileSn" class="form-label">회의실 사진</label>
		  	<input type="file" id="atchfileSn" class="form-control">
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="insertRoomBtn">등록</button>
        <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>


<!-- 회의실 예약 상세 모달 -->
<div class="modal fade" id="rentRoomModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel3">
        	예약 상세
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row g-4">
          <div class="col mb-0">
            <label for="rentNoDr" class="form-label">예약번호</label>
            <input type="text" id="rentNoDr" class="form-control" readonly>
          </div>
          <div class="col mb-0">
            <label for="mtgrNmDr" class="form-label">회의실명</label>
            <input type="text" id="mtgrNmDr" class="form-control" readonly>
          </div>
          <div class="col mb-0">
            <label for="empNmDr" class="form-label">신청자</label>
            <input type="text" id="empNmDr" class="form-control" readonly>
          </div>
          <div class="col mb-0">
            <label class="form-label">대여상태</label>
    		<span id="rentSttsSuccess" class="badge bg-label-success badge-lg" style="display: none;">예약</span>
   			<span id="rentSttsCancel" class="badge bg-label-danger badge-lg" style="display: none;">취소</span>
   			<button type="button" class="btn btn-label-secondary waves-effect" id="rentCancelBtn">예약 취소</button>
          </div>
        </div>
        <div class="row g-2">
          <div class="col mb-0">
            <label for="rentDateDr" class="form-label">예약일</label>
            <input type="text" id="rentDateDr" class="form-control" readonly>
          </div>
          <div class="col mb-0">
            <label for="rentTimeDr" class="form-label">예약시간</label>
            <input type="text" id="rentTimeDr" class="form-control" readonly>
          </div>
        </div>
        <div class="col mb-3">
            <label for="rentRsnDr" class="form-label">사용 목적</label>
            <textarea id="rentRsnDr" class="form-control" readonly></textarea>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 모달 영역 ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── -->

<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>