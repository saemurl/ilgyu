<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<script src="\resources\vuexy\assets\vendor\libs\jquery\jquery.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-calendar.css" />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@6.1.8/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>

<style>
#calendar {
    width: 60vw;
    height: 60vh;
}
    
.AllArea {
    display: flex;
}

.left-panel {
    width: 20%;
    padding: 10px;
    box-sizing: border-box;
	background-color:white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
}

.right-panel {
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
	background-color:white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
}

/* 캘린더 이벤트에 마우스 올렸을 때 스타일들 추가 영역 시작 ---- */
.fc-event {
    cursor: pointer;
    transition: all 0.1s ease;
}

.fc-event:active {
    transform: scale(0.95);
}
/* 캘린더 이벤트에 마우스 올렸을 때 스타일들 추가 영역 끝 ---- */
</style>

<script type="text/javascript">
    
document.addEventListener("DOMContentLoaded", function() {
    // 일정 추가 오프캔버스
    const colorSelectAdd = document.getElementById('color-select-add');
    const deptCdYnAdd = document.getElementById('deptCdYn-add');
    
    if (colorSelectAdd && deptCdYnAdd) {
        function toggleDeptCdYnAdd() {
            if (colorSelectAdd.value === '#ff9f43') {
                deptCdYnAdd.style.display = 'block';
            } else {
                deptCdYnAdd.style.display = 'none';
            }
        }

        toggleDeptCdYnAdd();
        colorSelectAdd.addEventListener('change', toggleDeptCdYnAdd);
    }

    // 일정 상세 오프캔버스
    const colorSelectDetail = document.getElementById('color-select-detail');
    const deptCdYnDetail = document.getElementById('deptCdYn-detail');
    
    if (colorSelectDetail && deptCdYnDetail) {
        function toggleDeptCdYnDetail() {
            if (colorSelectDetail.value === '#ff9f43') {
                deptCdYnDetail.style.display = 'block';
            } else {
                deptCdYnDetail.style.display = 'none';
            }
        }

        toggleDeptCdYnDetail();
        colorSelectDetail.addEventListener('change', toggleDeptCdYnDetail);
    }
});

$(document).ready(function() {
    $("#create").on("click", function() {
        $("#schTitle-add").val('');
        $("#schStart-add").val('');
        $("#schEnd-add").val('');
        $("#allDay-add").prop('checked', false); 
        
        $('#addEventSidebar').offcanvas('show');
    });
});

// [ 개인/부서/회사 ] 체크 박스는 최소 1개는 유지하도록 만드는 스크립트문 [없어서 체크박스 0개되면 에러 발생] -------------------------------------\\
$(document).ready(function() {
    function ensureOneCheckboxChecked() {
        if ($('.input-color:checked').length === 0) {
            Swal.fire({
                title: '',
                text: '최소 한 개는 선택해주세요.',
                icon: 'warning',
                customClass: {
                    confirmButton: 'btn btn-primary'
                },
                buttonsStyling: false
            });
            return false;
        }
        return true;
    }

    $('.input-color').on('change', function() {
        if ($('.input-color:checked').length === 0) {
            $(this).prop('checked', true);
            Swal.fire({
                title: '',
                text: '최소 한 가지는 선택되어야합니다.',
                icon: 'warning',
                customClass: {
                    confirmButton: 'btn btn-primary'
                },
                buttonsStyling: false
            });
        }
    });
});
// [ 개인/부서/회사 ] 체크 박스는 최소 1개는 유지하도록 만드는 스크립트문 [없어서 체크박스 0개되면 에러 발생] -------------------------------------//


 
// 부서 종류 선택 옵션을 DB에서 실시간으로 가져와서 출력 시작 ------------------------------------------------------------------------\\
$(document).ready(function() {
    function loadDepartments() {
        
    	$.ajax({
            url: '/schedule/departments',
            method: 'GET',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(data) {
                var deptAddSelect = $('#deptCd-add');
                var deptDetailSelect = $('#deptNm-detail');
                deptAddSelect.empty();
                deptDetailSelect.empty();

             	// 기본 선택 옵션 추가
                var defaultOption = $('<option></option>')
				    .attr('value', '')
				    .attr('disabled', 'disabled')
				    .attr('selected', 'selected')
				    .text('———— 선택해주세요  ————');
                deptAddSelect.append(defaultOption.clone());
                deptDetailSelect.append(defaultOption.clone());
                
                data.forEach(function(department) {
                    var option = $('<option></option>')
                        .attr('value', department.deptNm)
                        .text(department.deptNm);
                    
                    deptAddSelect.append(option.clone());
                    deptDetailSelect.append(option.clone());
                });
            },
        });
    }
    loadDepartments();
// 부서 종류 선택 옵션을 DB에서 실시간으로 가져와서 출력 끝 ------------------------------------------------------------------------//

// 관리자 일정 샘플 자동완성 버튼 ---------------------------- \\
	$('#exampleBtn').on('click', function () {
		console.log("자동완성 버튼 클릭 체크 ");
		
		$('#schTitle-add').val("부서 일정 공지");
		$('#description-add').val(`부서원 개별 프로젝트 진행도 보고서 제출해주세요`);
		
	})
// 관리자 일정 샘플 자동완성 버튼 ---------------------------- //  
	
});


// 회의실 종류 선택 옵션을 DB에서 실시간으로 가져와서 출력 시작 ------------------------------------------------------------------------\\

$(document).ready(function() {
    function loadLocations() {
        $.ajax({
            url: '/schedule/locations',
            method: 'GET',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(data) {
            	var locationAddSelect = $('#location-select-add');
                var locationDetailSelect = $('#location-select-detail');
                locationAddSelect.empty();
                locationDetailSelect.empty();

             	// 기본 선택 옵션 추가
                var defaultOption = $('<option></option>')
				    .attr('value', '')
				    .attr('disabled', 'disabled')
				    .attr('selected', 'selected')
				    .text('———— 선택해주세요  ————');
				locationAddSelect.append(defaultOption.clone());
				locationDetailSelect.append(defaultOption.clone());

                data.forEach(function(location) {
                    var option = $('<option></option>')
                        .attr('value', location.mtgrNm)
                        .text(location.mtgrNm);
                    
                    locationAddSelect.append(option.clone());
                    locationDetailSelect.append(option.clone());
                });
            },
        });
    }
    loadLocations();
});
// 회의실 종류 선택 옵션을 DB에서 실시간으로 가져와서 출력 끝 ------------------------------------------------------------------------//

$(document).ready(function() {
	
	// allDay 버튼은 당일치기 날짜가 아닐 경우에는 킬 수 없도록 한다. [ Date가 하루 이상일 때 allDay 활성화하면 온갖 버그가 생겨서 막았습니다. ]
	$('#allDay-add, #allDay-detail').change(function() {
	    let startDate, endDate;

	    if (this.id === 'allDay-add') {
	        startDate = new Date($('#schStart-add').val());
	        endDate = new Date($('#schEnd-add').val());
	    } else if (this.id === 'allDay-detail') {
	        startDate = new Date($('#schStart-detail').val());
	        endDate = new Date($('#schEnd-detail').val());
	    }

	    // 날짜가 동일하지 않은 경우 경고 메시지 표시 및 체크박스 해제
	    if (startDate.getTime() !== endDate.getTime()) {
	        $(this).prop('checked', false); // ALLDAY 체크박스 해제
	        Swal.fire({
	            title: '',
	            html: '일정 강조는 일정 시작일과 종료일이 동일할 때만<br>선택할 수 있습니다.',
	            icon: 'warning',
	            customClass: {
	                confirmButton: 'btn btn-primary'
	            },
	            buttonsStyling: false
	        });
	    }
	});

// 모달창에서 날짜가 변경되었을 때 확인하는 로직 영역 시작 --------------------------------------------------------------------------\\
	function checkAndUncheckAllDay() {
		startDate = new Date($('#schStart-add').val());
        endDate = new Date($('#schEnd-add').val());
        
        if ($('#schStart-add').length && $('#schEnd-add').length && $('#allDay-add').is(':checked')) {
            if (startDate.getTime() !== endDate.getTime()) {
                $('#allDay-add').prop('checked', false);
                buttonsStyling: false
            }
        }
        
        if ($('#schStart-detail').length && $('#schEnd-detail').length && $('#allDay-detail').is(':checked')) {
            if (startDate.getTime() !== endDate.getTime()) {
                $('#allDay-detail').prop('checked', false);
                buttonsStyling: false
            }
        }
        
        if (startDate.getTime() > endDate.getTime()) {
        	Swal.fire({
                title: '',
                html: '종료일은 시작일보다 이를수 없습니다.',
                icon: 'error',
                customClass: {
                    confirmButton: 'btn btn-primary'
                },
                buttonsStyling: false
            }).then((result) => {
                if (result.isConfirmed) {

                	endDate = startDate;
                    
                    $('#schEnd-add').val(startDate.toISOString().split('T')[0]);
                    $('#schEnd-detail').val(startDate.toISOString().split('T')[0]);
                }
            });
	    }
    }
   	// 변경되었을 때 checkAndUncheckAllDay() 함수 호출 용도
    $('#schStart-add, #schEnd-add, #schStart-detail, #schEnd-detail').change(checkAndUncheckAllDay);
// 모달창에서 날짜가 변경되었을 때 확인하는 로직 영역 끝 ----------------------------------------------------------------------------//
	
	
});


</script>

<!-- FullCalendar -->
<script type="text/javascript">

let calendar; // 전역 변수로 선언

$(document).ready(function() {
    const calendarEl = document.querySelector('#calendar');
    const mySchStart = document.querySelector("#schStart-add");
    const mySchEnd = document.querySelector("#schEnd-add");
    const mySchTitle = document.querySelector("#schTitle-add");
    const mySchAllday = document.querySelector("#allDay-add");

    if (!calendarEl || !mySchStart || !mySchEnd || !mySchTitle || !mySchAllday) {
        console.error("캘린더 생성 쪽 오류 체크 ...");
        return;
    }

    let empId;
    let data = {
        "empId": empId
    };

    const headerToolbar = {
        left: 'prev,next,today',
        center: 'title',
        right: ''
    };

    const calendarOption = {
        height: '750px',
        expandRows: true,
        headerToolbar: headerToolbar,
        initialView: 'dayGridMonth',
        locale: 'kr',
        selectable: true,
        selectMirror: true,
        navLinks: false,
        displayEventTime : false,
        weekNumbers: false,
        editable: false,
        dayMaxEventRows: true,
        nowIndicator: true,
        dayHeaderContent: function(args) {
            var date = args.date;
            var dayNumber = date.getDay();
            if (dayNumber === 0) {
                return { html: '<span style="color:#FF6961;">' + args.text + '</span>' };
            } else if (dayNumber === 6) {
                return { html: '<span style="color:#5A9BD5;">' + args.text + '</span>' };
            }
            return args.text;
        },
        dayCellDidMount: function(args) {
            var date = args.date;
            var dayNumber = date.getDay();
            if (dayNumber === 0) {
                args.el.style.color = '#FF6961';
            } else if (dayNumber === 6) {
                args.el.style.color = '#5A9BD5';
            }
        },
        timeZone: 'local',
        events: function(info, successCallback, failureCallback) {
            $.ajax({
                contentType: "application/json;charset=utf-8",
                url: "/schedule/listAjax",
                data: JSON.stringify(data),
                dataType: "json",
                type: "post",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(data) {
                    var events = data.map(function(event) {
                        let startDate = new Date(event.start);
                        let endDate = new Date(event.end);

                        if (event.allday === 'Y') {
                            // UTC 시간으로 변환하여 날짜만 설정
                            startDate = new Date(startDate.toISOString().substring(0, 10));
                            endDate = new Date(endDate.toISOString().substring(0, 10));
                        }

                        return {
                            id: event.id,
                            title: event.title,
                            start: new Date(event.start).toISOString(),
                            end: new Date(event.end).toISOString(),
                            description: event.description,
                            allDay: event.allday === 'Y',
                            backgroundColor: event.color,
                            deptNm: event.deptNm,
                            location: event.location
                        };
                    });
                    successCallback(events);
                },
                error: function() {
                    failureCallback();
                }
            });

        },
        eventClick: function(info) {
            $('#addEventDetailSidebar').offcanvas('show');
			
            const event = info.event;
            const empMng = '${employeeVO.empMng}';
            
         	// 일정 종류가 부서로 설정되어 있으면 부서 선택 영역을 표시
            if (event.backgroundColor === '#ff9f43') {
                $('#deptCdYn-detail').show();
            } else {
                $('#deptCdYn-detail').hide();
            }

            if ((event.backgroundColor === '#ff9f43' || event.backgroundColor === '#28c76f') && empMng === 'N') {
                document.querySelector('#ScheduleUpdate').style = 'display: none !important';
                document.querySelector('#ScheduleDelete').style = 'display: none !important';
            } else {
                $('#ScheduleUpdate').show();
                $('#ScheduleDelete').show();
            }

         	// 이벤트 객체 출력
            console.log('Event:', event);

            $('#id-detail').val(event.id);
            $('#schTitle-detail').val(event.title);
            $('#color-select-detail').val(event.backgroundColor);

            let startDate = new Date(event.start);
            let endDate = event.end ? new Date(event.end) : new Date(event.start);

            // 시작일과 종료일이 제대로 설정되었는지 확인
            console.log('Original Start Date:', event.start);
            console.log('Original End Date:', event.end);

            const startDateOnly = startDate.toISOString().substring(0, 10);
            const endDateOnly = endDate.toISOString().substring(0, 10);

            console.log(`Processed Start Date: ${startDateOnly}, Processed End Date: ${endDateOnly}`);

            $('#schStart-detail').val(startDateOnly);
            $('#schEnd-detail').val(endDateOnly);
			
            // Null 이 아니면
           	if (event.deptNm != null || event.deptNm != ""){
            $('#deptCdYn-detail').val(event.deptNm)
           	}
            
            $('#allDay-detail').prop('checked', event.allDay);
            // 부서명과 회의 장소 값 설정
            $('#deptNm-detail').val(event.extendedProps.deptNm);
            $('#location-select-detail').val(event.extendedProps.location);
            $('#description-detail').val(event.extendedProps.description);
        },
        datesSet: function() { // 달력이 리렌더링 될 때마다 필터링된 이벤트를 불러옴
            updateEventSource();
        }
    };

    calendar = new FullCalendar.Calendar(calendarEl, calendarOption);
    calendar.render();

    function updateEventSource() {
        var color = $('.input-color:checked').map(function() {
            return $(this).data('value');
        }).get();

        $.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/schedule/filteredListAjax",
            data: JSON.stringify({ empId: empId, color: color }),
            dataType: "json",
            type: "post",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(data) {
                var formattedData = data.map(function(event) {
                    return {
                        id: event.id,
                        start: new Date(event.start).toISOString(),
                        end: new Date(event.end).toISOString(),
                        title: event.title,
                        description: event.description,
                        allDay: event.allday === 'Y',
                        backgroundColor: event.color,
                        deptNm: event.deptNm,
                        location: event.location,
                    };
                    // 시작일과 종료일이 동일한 경우 종료일을 설정하지 않음
                    if (startDate.getTime() !== endDate.getTime()) {
                        formattedEvent.end = endDate.toISOString().substring(0, 10);
                    }
                    return formattedEvent;
                });

                calendar.removeAllEvents();
                calendar.addEventSource(formattedData);
            },
            error: function() {
                console.error("회사, 부서, 개인 이벤트 조회 오류..");
            }
        });
    }

    $('.input-color').change(function() {
        updateEventSource();
    });

    calendar.on("select", info => {
        const startDate = new Date(info.startStr);
        const endDate = new Date(info.endStr);
        endDate.setDate(endDate.getDate() - 1); // 하루를 빼서 선택 범위를 조정

        const startDateOnly = startDate.toISOString().substring(0, 10);
        const endDateOnly = endDate.toISOString().substring(0, 10);

        console.log("날짜 체크 시작: " + startDateOnly);
        console.log("날짜 체크 끝: " + endDateOnly);

        $('#schStart-add').val(startDateOnly);
        $('#schEnd-add').val(endDateOnly);

        $('#addEventSidebar').offcanvas('show');
    });


    function fCalAdd() {
        const event = {
            title: mySchTitle.value,
            start: mySchStart.value,
            end: mySchEnd.value,
            allDay: mySchAllday.checked
        };

        calendar.addEvent(event);
        $('#addEventSidebar').offcanvas('hide');
    }

// 일정  ( 등록  수정  삭제 ) 시작 -------------------------------------------------------------------------------------------\\
// [ 등록 ]
$("#ScheduleCreate").on("click", function() {
    // 필수 입력 값 확인
    if (!$("#schTitle-add").val() || !$("#schStart-add").val() || !$("#schEnd-add").val() || !$("#location-select-add").val()) {
        Swal.fire({
            icon: 'error',
            title: '',
            text: '모든 항목을 작성해주세요.',
            customClass: {
                confirmButton: 'btn btn-danger'
            }
        });
        return;
    }

    Swal.fire({
        title: '',
        text: "일정을 등록하시겠습니까?",
        icon: 'info',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        cancelButtonText: "취소",
        confirmButtonText: "등록",
        customClass: {
            confirmButton: 'btn btn-primary me-1',
            cancelButton: 'btn btn-label-secondary'
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
        	
            let colorValue = $("#color-select-add").val();
            let deptNmValue = colorValue === "#ff9f43" ? $("#deptCd-add").val() : null; // 일정 종류가 부서일 때만 부서명이 담기도록 한다.

            let data = {
                description: $("#description-add").val(),
                title: $("#schTitle-add").val(),
                start: $("#schStart-add").val(),
                end: $("#schEnd-add").val(),
                allday: $("#allDay-add").is(":checked") ? "Y" : "N",
                color: colorValue,
                deptNm: deptNmValue,
                location: $("#location-select-add").val()
            };

            $.ajax({
                url: "/schedule/create",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    // console.log("result : ", result);
                    Swal.fire({
                        icon: 'success',
                        title: '',
                        text: '등록되었습니다.',
                        customClass: {
                            confirmButton: 'btn btn-success'
                        }
                    });

                    let startDate = new Date(data.start);
                    let endDate = new Date(data.end);

                    console.log("Created event ID:", result.id);
                    
                    if (deptNmValue != null) {
						
                    	console.log("부서 알람용 체크 : "+ deptNmValue)	
                    	
                    	$.ajax({
			                url: "/schedule/deptEmpList",
			                contentType: "application/json;charset=utf-8",
			                data: deptNmValue,
			                type: "post",
			                dataType: "json",
			                beforeSend: function(xhr) {
			                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			                },
			                success: function(deptEmpList) {
			                	console.log("아작스를 통해 가져온 알람용 해당 부서 사람들 ID : ", deptEmpList);
			                	
			                	let schedule = "schedule";
			                	let loginEmpId = ${employeeVO.empId};
			                	console.log("체크 : " +loginEmpId);
			                	
			                	for(let i=0; i<deptEmpList.length; i++){
				                   	let socketMsg	=	{
				                   			"title":schedule,
				                   			"senderId":loginEmpId,
				                   			"receiverId":deptEmpList[i].empId,
				                   			"scheduleNm":$("#schTitle-add").val(),
				                   			"deptNm":deptNmValue
				                   	}
				                   	socket.send(JSON.stringify(socketMsg));
			                		
			                	}
			                	
			                   	
			                	
			                }
                    	})
                    	
					}
                    // 이벤트 추가
                    calendar.addEvent({
                        id: result.id,
                        title: data.title,
                        start: startDate,
                        end: endDate,
                        allDay: data.allday === "Y",
                        backgroundColor: data.color,
                        extendedProps: {
                            description: data.description,
                            deptNm: data.deptNm,
                            location: data.location
                        }
                    });
                    calendar.render();
                    $('#addEventSidebar').offcanvas('hide');
                }
            });
        }
    });
});

// [ 수정 ]
$("#ScheduleUpdate").on("click", function() {
	// 공백 비허용 스위트얼러트 체크
	if (!$("#schTitle-detail").val() || !$("#schStart-detail").val() || !$("#schEnd-detail").val() || !$("#location-select-detail").val()) {
        Swal.fire({
            icon: 'error',
            title: '',
            text: '모든 항목을 작성해주세요.',
            customClass: {
                confirmButton: 'btn btn-danger'
            }
        });
        return;
    }
	
	Swal.fire({
        title: '',
        text: "일정을 수정하시겠습니까?",
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
    }).then((result) => {
        if (result.isConfirmed) {
	

    let colorValue = $("#color-select-detail").val();
    let deptNmValue = colorValue === "#ff9f43" ? $("#deptNm-detail").val() : null; // 일정 종류가 부서일 때만 부서명이 담기도록 한다.

	// 디버깅용 콘솔 출력
    console.log("Color Value:", colorValue);
    console.log("deptNmValue Detail Value:", deptNmValue);
    
    let data = {
        id: $("#id-detail").val(),
        description: $("#description-detail").val(),
        title: $("#schTitle-detail").val(),
        start: $("#schStart-detail").val(),
        end: $("#schEnd-detail").val(),
        allday: $("#allDay-detail").is(":checked") ? "Y" : "N",
        color: colorValue,
        deptNm: deptNmValue,
        location: $("#location-select-detail").val()
    };

		    $.ajax({
		        url: "/schedule/update",
		        contentType: "application/json;charset=utf-8",
		        data: JSON.stringify(data),
		        type: "post",
		        dataType: "json",
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		        },
		        success: function(result) {
 		            //console.log("result : ", result);
		            Swal.fire({
                        icon: 'success',
                        title: '',
                        text: '수정되었습니다.',
                        customClass: {
                            confirmButton: 'btn btn-success'
                        }
                    });
		            
		            const event = calendar.getEventById(data.id);
		            if (event) {
		                event.remove();
		            }
					
		            let startDate = new Date(data.start);
		            let endDate = new Date(data.end);
		
		            calendar.addEvent({
		                id: data.id,
		                title: data.title,
		                start: startDate,
		                end: endDate,
		                allDay: data.allday === "Y",
		                backgroundColor: data.color,
		                extendedProps: {
		                    description: data.description,
		                    deptNm: data.deptNm,
		                    location: data.location
		                }
		            });
		            $('#addEventDetailSidebar').offcanvas('hide');
		        }
		    });
        }
    });
});

// [ 삭제 ]
$("#ScheduleDelete").on("click", function() {
	
	let data = {
            id: $("#id-detail").val(),
    };
	
	Swal.fire({
        title: '',
        text: "일정을 삭제하시겠습니까?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        cancelButtonText: "취소",
        confirmButtonText: "삭제",
        customClass: {
            confirmButton: 'btn btn-primary me-1',
            cancelButton: 'btn btn-label-secondary'
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
			$.ajax({
		        url: "/schedule/delete",
		        contentType: "application/json;charset=utf-8",
		        data: JSON.stringify(data),
		        type: "post",
		        dataType: "json",
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		        },
		        success: function(result) {
		            console.log("result : ", result);
		            Swal.fire({
                        icon: 'success',
                        title: '',
                        text: '삭제되었습니다.',
                        customClass: {
                            confirmButton: 'btn btn-success'
                        }
                    });
		            
		            var event = calendar.getEventById(data.id);
		            if (event) {
		                event.remove();
		            }
		            
		            $('#addEventDetailSidebar').offcanvas('hide');
		        }
		    });
        }
    });
});
// 일정  ( 등록  수정  삭제 ) 끝 ---------------------------------------------------------------------------------------------//


document.addEventListener("DOMContentLoaded", function() {
    const empMng = '${employeeVO.empMng}'; // 서버에서 제공되는 값
    const colorSelectDetail = document.getElementById('color-select-detail');
    const scheduleButtonsContainer = document.getElementById('scheduleButtonsContainer');
	
    // empMng 값이 'N'일 경우 select 요소를 비활성화
    if (empMng === 'N') {
        colorSelectDetail.disabled = true;
    }

    // 버튼 활성화/비활성화 함수
    function updateButtonState() {
        const selectedValue = colorSelectDetail.value;
        if (selectedValue === '#7367f0') { // 개인
            scheduleButtonsContainer.style.display = 'block';
        } else { // 부서 또는 회사
            scheduleButtonsContainer.style.display = 'none';
        }
    }

    // 초기 상태 업데이트
    updateButtonState();

    // 색상 선택이 변경될 때 버튼 상태 업데이트
    colorSelectDetail.addEventListener('change', updateButtonState);
});

});

</script>

<!-- 모달 영역 시작 ================================================================================= -->            

<!-- 일정 등록 -->
<div class="offcanvas offcanvas-end event-sidebar" tabindex="-1" id="addEventSidebar" aria-labelledby="addEventSidebarLabel" aria-modal="true" role="dialog">
    <div class="offcanvas-header my-1">
        <h5 class="offcanvas-title" id="addEventSidebarLabel">일정 추가</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body pt-0">
        <div class="form-group">
            <label for="schTitle-add">일정 제목</label>
            <input type="text" class="form-control" id="schTitle-add">
        </div>
        <div>
            <label for="color-select-add">일정 종류</label>
            <select class="form-select" id="color-select-add" name="color" <c:if test="${employeeVO.empMng == 'N'}">disabled</c:if> >
                <option value="#7367f0">개인</option>
               	<option value="#ff9f43">부서</option>
               	<option value="#28c76f">회사</option>
            </select>
        </div>
        <div class="form-group" id="deptCdYn-add">
            <label for="deptCd-add">부서</label>
            <select class="form-select" id="deptCd-add">
				<!-- 내부 value 는 Ajax 에서 데려온다. -->
            </select>
        </div>
        <div class="form-group" id="location-add">
            <label for="location-select-add">회의 장소</label>
            <select class="form-select" id="location-select-add">
            	<!-- 내부 value 는 Ajax 에서 데려온다. -->
            </select>
        </div>
        <div class="form-group">
            <label for="schStart-add">시작일</label>
            <input type="date" class="form-control" id="schStart-add">
        </div>
        <div class="form-group">
            <label for="schEnd-add">종료일</label>
            <input type="date" class="form-control" id="schEnd-add">
        </div>
        <hr/>
        <div class="form-group">
            <label class="switch">
                <input type="checkbox" class="switch-input allDay-switch" id="allDay-add">
                <span class="switch-toggle-slider">
                    <span class="switch-on"></span>
                    <span class="switch-off"></span>
                </span>
                <span class="switch-label">일일 강조</span>
            </label>
        </div>
        <hr/>
        <div class="form-group">
            <label for="description-add">상세 정보</label>
            <textarea class="form-control" id="description-add" style="height: 200px;"></textarea>
        </div>
        <br/>
        <button type="button" class="btn btn-primary" id="ScheduleCreate">등록</button>
        <button type="button" id="exampleBtn" style="margin-left: 15px; background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
    </div>
</div>


<!-- 일정 상세 -->
<div class="offcanvas offcanvas-end event-sidebar" tabindex="-1" id="addEventDetailSidebar" aria-labelledby="addEventSidebarLabel" aria-modal="true" role="dialog">
    <div class="offcanvas-header my-1">
        <h5 class="offcanvas-title" id="addEventSidebarLabel">일정 상세</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    
    <input type="hidden" id="id-detail">	<!-- 수정, 삭제할 때 PK값 담아가려고 생성 -->
    
    <div class="offcanvas-body pt-0">
        <div class="form-group">
            <label for="schTitle-detail">일정 제목</label>
            <input type="text" class="form-control" id="schTitle-detail">
        </div>
        <div>
            <label for="color-select-detail">일정 종류</label>
            <select class="form-select" id="color-select-detail" name="color" <c:if test="${employeeVO.empMng == 'N'}">disabled</c:if>>
               		<option value="#7367f0">개인</option>
               		<option value="#ff9f43">부서</option>
               		<option value="#28c76f">회사</option>
            </select>
        </div>    
        <div class="form-group" id="deptCdYn-detail">
            <label for="deptNm-detail">부서</label>
            <select class="form-select" id="deptNm-detail">
				<!-- 내부 value 는 Ajax 에서 데려온다. -->
            </select>
        </div>
        <div class="form-group" id="location-detail">
            <label for="location-select-detail">회의 장소</label>
            <select class="form-select" id="location-select-detail">
            	<!-- 내부 value 는 Ajax 에서 데려온다. -->
            </select>
        </div>
        <div class="form-group">
            <label for="schStart-detail">시작일</label>
            <input type="date" class="form-control" id="schStart-detail">
        </div>
        <div class="form-group">
            <label for="schEnd-detail">종료일</label>
            <input type="date" class="form-control" id="schEnd-detail">
        </div>
        <hr/>
        <div class="form-group">
            <label class="switch">
                <input type="checkbox" class="switch-input allDay-switch" id="allDay-detail">
                <span class="switch-toggle-slider">
                    <span class="switch-on"></span>
                    <span class="switch-off"></span>
                </span>
                <span class="switch-label">중요 표시</span>
            </label>
        </div>
        <hr/>
        <div class="form-group">
            <label for="description-detail">상세 정보</label>
            <textarea class="form-control" id="description-detail" style="height: 200px;"></textarea>
        </div>
        <br/>
       	<div class="form-group">
	       	<button type="button" class="btn btn-primary" id="ScheduleUpdate">수정</button>
    	   	<button type="button" class="btn btn-primary" id="ScheduleDelete">삭제</button>
        </div>
    </div>
</div>

<!-- 모달 영역 끝 ================================================================================= -->            

<div class="AllArea">
    <div class="left-panel" style="margin-right: 10px;">
        <button type="button" class="btn btn-primary" id="create">일정 추가</button>
        <hr/>
        <div class="chooseType">
            <div class="form-check mb-2">
                <input class="form-check-input input-color" type="checkbox"
                    id="select-personal" data-value="#7367f0" checked> 
                <label class="form-check-label" for="select-personal">개인</label>
            </div>
            <div class="form-check form-check-warning mb-2">
                <input class="form-check-input input-color" type="checkbox"
                    id="select-department" data-value="#ff9f43" checked> 
                <label class="form-check-label" for="select-department">부서</label>
            </div>
            <div class="form-check form-check-success mb-2">
                <input class="form-check-input input-color" type="checkbox"
                    id="select-company" data-value="#28c76f" checked> 
                <label class="form-check-label" for="select-company">회사</label>
            </div>
        </div>
    </div>
    <div class="right-panel">
        <div id="Wrapper">
            <div id='calendar'></div>
        </div>
    </div>
</div>

<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>