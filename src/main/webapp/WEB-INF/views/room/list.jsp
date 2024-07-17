<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script src="\resources\vuexy\assets\vendor\libs\jquery\jquery.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>

<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<style>

.swiper-container {
	width: 100%;
}
.swiper-slide {
    display: flex;
    justify-content: center;
}

.table-container {
	display: flex;
	justify-content: center;
	margin-top: 50px;
}

th, td {
	border: 1px solid #ddd;
 	padding: 3px;
	text-align: center;
}

/* 주말 색상 변경 CSS */
.flatpickr-day.sat {
	color: #5A9BD5; /* 토요일 색상 */
}

.flatpickr-day.sun {
	color: #FF6961; /* 일요일 색상 */
}

#calendarSelect {
	width: 268px; /* 입력 필드 너비 조정 */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
}
#selectTimeArea { 
	margin: 10px;
    padding: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column; /* 내용물이 수직으로 정렬되도록 설정 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
}

----------------------------------------------------
-- 예약 버튼쪽 CSS

.rentClickArea {
	cursor: pointer;
	transition: background-color 0.3s ease;
}

.rentClickArea:hover {
	background-color: #f0f0f0; /* 배경색을 변경 */
}

.rentClickArea:active {
    background-color: #d0d0d0; /* 클릭할 때 배경색을 변경 */
    transform: scale(0.98); /* 살짝 눌린 효과를 줌 */
}

.swiper-container {
    overflow: hidden;
    position: relative;
}

----------------------------------------------------
-- 슬라이더쪽 CSS

.swiper-wrapper {
    display: flex;
    align-items: center;
}

.swiper-slide {
    display: flex;
    justify-content: center;
    align-items: center;
    height: auto;
}

.swiper-roomEach {
    background-color: white;
    width: 80%; /* 필요한 경우 조정 */
    margin: 10px;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

#meetingroomCard{
	text-align: center;
}

----------------------------------------------------

</style>

<script src="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.js"></script>
<script>
// picker 캘린더  시작 --------------------------------------------------------------------------------------------------\\
$(function() {
	
	var flatpickrInline = document.querySelector("#calendarSelect");

	flatpickrInline.flatpickr({
		inline : true,
		minDate: "today",
		defaultDate: "today",
		allowInput : false,
		monthSelectorType : "static",
		onDayCreate : function(dObj, dStr, fp, dayElem) { // 주말 색상 변경 용으로 값을 잡음
			var date = dayElem.dateObj;
			if (date.getDay() === 6) {
				dayElem.classList.add('sat');
			}
			if (date.getDay() === 0) {
				dayElem.classList.add('sun');
			}
		},
		onChange: function(selectedDates, dateStr, instance) {				 			// [날짜가 변경되었을 때 이벤트]
            var selectedRoom = document.getElementById("roomSelect").value;
            console.log("선택된 날짜: " + dateStr + ", 선택된 회의실: " + selectedRoom);
            
            if (selectedDates.length > 0) {
                var formattedDate = instance.formatDate(selectedDates[0], "Ymd");
                
                updateTable(formattedDate, selectedRoom); 		// 날짜가 변경될 때 테이블 업데이트 함수 호출
            }
	    }
	});
	
	document.getElementById("roomSelect").addEventListener("change", function() { 	// [선택된 회의실 값이 변경되었을 때 이벤트]
        var selectedDate = document.querySelector("#calendarSelect")._flatpickr.selectedDates[0];
        var formattedDate = selectedDate ? flatpickr.formatDate(selectedDate, "Ymd") : '';
        var selectedRoom = this.value;
        console.log("선택된 날짜: " + formattedDate + ", 선택된 회의실: " + selectedRoom);
        
        $('#roomNm').text(selectedRoom);			// 회의실 선택이 변경될 때 테이블 앞 회의실명 변경
        updateTable(formattedDate, selectedRoom); 	// 날짜가 변경될 때 테이블 업데이트 함수 호출
    });
// picker 캘린더  끝 --------------------------------------------------------------------------------------------------//


// 예약 버튼 눌렀을 떄 처리될 영역 ---------------------------------------------------------------------------------------------------------\\
	$('#rentConfirmBtn').on('click', function() {
		Swal.fire({
	        title: '',
	        text: "회의실을 예약하시겠습니까?",
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
	        	
	        	var empId = ${employeeVOList.empId};		// 회원 아이디 값
	    		var mtgrNm = $('#mtgrNm').val();		// 선택 회의실 이름 
	    		var rentBgng = $('#rentBgng').val();	// 선택 예약 시작시간
	    		var rentEnd = $('#rentEnd').val();		// 선택 예약 종료시간
	    		var rentRsn = $('#rentRsn').val();		// 사용목적
	    		
	    		console.log("버튼 클릭 값 체크 : " + empId + ", " + mtgrNm + ", " + rentBgng + ", " + rentEnd + ", " + rentRsn);
	        	
	            let data = {
            		empId : empId,	
            		mtgrNm : mtgrNm,
            		rentBgng : rentBgng,
            		rentEnd : rentEnd,
            		rentRsn : rentRsn
	            };

	            $.ajax({
	                url: "/room/rent",
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
	                        text: '예약 처리되었습니다.',
	                        customClass: {
	                            confirmButton: 'btn btn-success'
	                        }
	                    });
	                    $('#rentRoomModal').modal('hide');	// 모달창 닫기
	                    
	                    // 선택 중이던 날짜, 회의실 값 가져와서 updateTable()함수 재호출해서 화면 비동기 전환하기
	                    var selectedDate = document.getElementById("calendarSelect").value;
	                    var selectedRoom = document.getElementById("roomSelect").value;
	                    
	                    console.log("예약 후 selectedDate 체크 : " + selectedDate);
	                    console.log("예약 후 selectedRoom 체크 : " + selectedRoom);
	                    
	                    //비동기 재호출
	                    updateTable(selectedDate, selectedRoom); 		// 날짜가 변경될 때 테이블 업데이트 함수 호출
	                }
	            });
	        }
	    });
	})
// 예약 버튼 눌렀을 떄 처리될 영역 ---------------------------------------------------------------------------------------------------------//
});

// 상세정보 클릭 했을 때 말풍선(Popover) 가 뜨게 하는 영역 시작 ---------------------------------------------\\
$(document).ready(function(){
    // Popover 초기화
    $('[data-bs-toggle="popover"]').popover({ html: true });

    $(document).on('click', '.roomDetail', function() {
        var roomId = $(this).val(); // 버튼의 value 속성 값 가져오기
        console.log("버튼 클릭된 회의실 ID:", roomId);
    });

    // 다른 곳 클릭 시 Popover 닫기
    $(document).on('click', function (e) {
        $('[data-bs-toggle="popover"]').each(function () {
            if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                $(this).popover('hide');
            }
        });
    });

    $(document).on('click', '[data-bs-toggle="popover"]', function (e) {
        $('[data-bs-toggle="popover"]').not(this).popover('hide');
        $(this).popover('toggle');
        e.stopPropagation(); // 이벤트 전파 중지
    });
});
// 상세정보 클릭 했을 때 말풍선(Popover) 가 뜨게 하는 영역 종료 ---------------------------------------------//

// 회의실 종류 선택 옵션을 DB에서 실시간으로 가져와서 출력 시작 ------------------------------------------------------------------------\\
$(document).ready(function() {
    function loadRooms() {
        
        $.ajax({
            url: '/room/roomSearch',
            method: 'GET',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(chooseRoomList) {
                var roomSelect = $('#roomSelect');
                roomSelect.empty();
				
                console.log("회의실 사용가능한 애들 조회하는 체크 : ", chooseRoomList);
                 
                // 기본 선택 옵션 추가
                var defaultOption = $('<option></option>')
				    .attr('disabled', 'disabled')
				    .attr('selected', 'selected')
				    .text('———— 선택해주세요  ————');
                roomSelect.append(defaultOption.clone());
                
                chooseRoomList.forEach(function(room) {
                    var option = $('<option></option>')
                        .attr('value', room.mtgrNm)
                        .text(room.mtgrNm);
                    
                     if (room.mtgrChck === 'N') {
                        option.attr('disabled', 'disabled')
                              .text(room.mtgrNm + ' (사용불가)')
                              .css('color', '#FF6961');
                    }
                    
                    roomSelect.append(option.clone());
                });
            },
        });
    }
    loadRooms();
});
//회의실 종류 선택 옵션을 DB에서 실시간으로 가져와서 출력 끝 --------------------------------------------------------------------------//


// 선택된 회의실 예약 현황 체크 후 출력 시작 -------------------------------------------------------------------------------------\\
function updateTable(selectedDate, selectedRoom) {
    if (!selectedDate || !selectedRoom) {
        return; // 날짜 또는 회의실이 선택되지 않은 경우 함수 종료
    }
    
    $.ajax({
        url: '/room/roomRentCheck',
        contentType: "application/json;charset=utf-8",
        method: 'POST',
        data: JSON.stringify({
            "date": selectedDate,
            "room": selectedRoom
        }),
        dataType: "json",
        beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        },
        success: function(data) {
			
        	if (selectedDate != null && selectedRoom != '———— 선택해주세요 ————' && selectedRoom != null) {
	        	for (let hour = 9; hour <= 18; hour++) {
	        	    $('#time-' + hour + '_00').removeClass('available unavailable').css('color', '#5A9BD5').text('가능').addClass('available');
	        	}
        	}
        	
        	if (data.length === 0) {
                return;
            }

            data.forEach(function(slot) {

            	var time = slot.rentBgng.split(' ')[1].replace(':', '_');		// 꺼내온 시간 값 12:00 을 12_00 으로 변경.. id 값은 : 을 인식 못 함
            	var cell = $('#time-' + time);

                if (slot.rentStts === 'Y') {
                	cell.removeClass('available').addClass('unavailable').css('color', '#FF6961').text('불가능');
                } else {
                    cell.removeClass('unavailable').addClass('available').text('가능');
                }
            });
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error("Error occurred: " + textStatus, errorThrown);
        }
    });
}
//선택된 회의실 예약 현황 체크 후 출력 끝 ---------------------------------------------------------------------------------------//


// 회의실, 시간 선택했을 때 예약 모달창 출력 시작 -------------------------------------------------------------------------------------\\
function selectRoom(param) {
	
	var calendarSelect = $('#calendarSelect').val();
	
	var timeSelect = param.id;
	var starttime = timeSelect.slice(5).replace("_", ":");	// ex) time-9_00 => 9:00
	
	 // 시간 계산
    var timeParts = starttime.split(':');
    var hours = parseInt(timeParts[0], 10);
    var minutes = parseInt(timeParts[1], 10);
    
    var endHours = hours + 1;
    if (endHours >= 24) {
        endHours = endHours - 24;
    }
    
    var endHoursString = endHours.toString().padStart(2, '0');
    var endMinutesString = minutes.toString().padStart(2, '0');
    var endTime = endHoursString + ':' + endMinutesString;
    
    console.log("종료시간 체크 : " + endTime);  // 확인용
	
	var rentCheck = param.innerText || param.textContent;
	console.log("예약 상태 체크" + rentCheck);
	
	var roomSelect = $('#roomSelect').val();		// ex) 103호실
	
	// 예약 조회 안 된 거, 예약 불가능한 거 누르면 함수 종료시켜서 아무 반응 없도록 시작 ------------------------------------\\
	if(rentCheck == "-"){
		return;
	}

	if(rentCheck == "불가능"){
		Swal.fire({
		    position: 'top-end',
		    icon: 'warning',
		    title: '',
		    text: '해당 회의실은 이미 예약중입니다.',
		    showConfirmButton: false,
		    timer: 1500,
		    customClass: {
		      confirmButton: 'btn btn-primary'
		    },
		    buttonsStyling: false
		})
		return;
	}
	// 예약 조회 안 된 거, 예약 불가능한 거 누르면 함수 종료시켜서 아무 반응 없도록 끝 -------------------------------------//
	
	console.log("체크 date : " + calendarSelect + " roomSelect : " + roomSelect + " startTime : " + starttime + "endTime : " + endTime);	// 체크
	
	var startDate = calendarSelect + " " + starttime;
	var endDate = calendarSelect + " " + endTime;
	
	console.log("startDate : " + startDate);
	console.log("endDate : " + endDate);
	
    $('#mtgrNm').val(roomSelect);			// 선택 회의실 이름 
    $('#rentBgng').val(startDate);			// 선택 예약 시작시간
	$('#rentEnd').val(endDate);				// 선택 예약 종료시간   들 전부 모달에 전달..
    
	// 모달출력
	var rentRoomModal = new bootstrap.Modal(document.getElementById('rentRoomModal'));
    rentRoomModal.show();
} 

document.addEventListener('DOMContentLoaded', function() {				// 모달창 종료했을 때 안에 작성했던 사용목적 지우기
    var rentRoomModal = document.getElementById('rentRoomModal');
    rentRoomModal.addEventListener('hidden.bs.modal', function () {
        document.getElementById('rentRsn').value = '';
    });
//회의실, 시간 선택했을 때 예약 모달창 출력 끝 -------------------------------------------------------------------------------------//

$('#mapBtn').on('click', function () {
	
	var mapModal = new bootstrap.Modal(document.getElementById('mapModal'));
	mapModal.show();
	
});

$('#exampleBtn').on('click', function () {
	console.log("자동완성 버튼 클릭 체크 ");
	
	$('#rentRsn').val("프로젝트 주간 정기 회의");
	
})


});

</script>

<div class="swiper-container">
    <div class="swiper-wrapper">
        <c:forEach var="meetingRoom" items="${meetingRoomVOList}">
            <div class="swiper-slide">
                <div class="swiper-roomEach">
                    
                    <div class="card h-100" id="meetingroomCard">
				      <img class="card-img-top" id="roomImg" src="/upload${meetingRoom.imgPath}" alt="카드이미지" style="height: 170px;">
				      <div class="card-body">
				        <strong class="card-title">${meetingRoom.mtgrNm}</strong>
				        <p class="card-text">
				          ${meetingRoom.mtgrCpct}명 <hr/>
				          <c:forEach var="equipment" items="${meetingRoom.equipments}">
				              ${equipment.iconPath}
				          </c:forEach>
				        </p>
				        <button type="button" class="btn btn-primary" data-bs-toggle="popover" data-bs-placement="bottom" 
						    	data-bs-content="
						        [ 시설물 ] <br>
						        <c:forEach var='equipment' items='${meetingRoom.equipments}' varStatus='status'>
						            ${equipment.eqpmntNm}<c:if test='${!status.last}'>, </c:if>
						        </c:forEach> <hr>
						       	[ 상세정보 ]  <br>
						        ${meetingRoom.mtgrExpln}">
						    	상세보기
						</button>
				      </div>
				    </div>
                
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="swiper-pagination"></div>
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
</div>

<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script>
        var swiper = new Swiper('.swiper-container', {
            slidesPerView: 4,
            spaceBetween: 10,
            cssMode: true,
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            }
        });
    </script>

<div class="bottom-panel" style="display: flex">

	<!-- 달력 출력 영역 -->
	<div class="calendarSelect mb-3">
		<input type="text" class="form-control mb-1" placeholder="YYYY-MM-DD"
			id="calendarSelect" />
	</div>

	<!-- 회의실 시간 선택 영역 -->
	<div class="card" id="selectTimeArea">
		
	  	<div id="lottie"></div>
		
		<div>
            <button class="btn btn-label-primary waves-effect" id="mapBtn" style="width: 800px; margin-bottom: 20px">
            	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-geo-alt-fill" viewBox="0 0 16 16">
  				<path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/>
				</svg> &nbsp; 회의실 위치 조회
            </button>
		</div>
		<div>
			<select class="form-select text-capitalize" id="roomSelect">
				<!-- DB 에서 회의실 조회해서 출력 -->
            </select>
		</div>
		<hr/>
		<table class="table-striped" id="selectTimeTbl">
			<thead>
				<tr>
					<th style="padding: 5px;">회의실명</th>
					<% for (int hour = 9; hour <= 18; hour++) { %>
					<th><%= hour %>:00 - <%= (hour + 1) %>:00</th>
					<% } %>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td id="roomNm">-</td>
					<%
						for (int hour = 9; hour <= 18; hour++) {
					%>
						<td class="rentClickArea" id="time-<%= hour %>_00" onclick="selectRoom(this)"> - </td>
					<%
						}
					%>
				</tr>
			</tbody>
		</table>
	</div>

</div>


<!-- —————————————————————————————————————————————————————————————————————————————————————————————————————————————————— [ Modal ] [시작] -->
<!-- [ 회의실 예약 모달 ] -->
<div class="modal fade" id="rentRoomModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">회의실 예약</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col mb-3">
            <label for="mtgrNm" class="form-label">회의실명</label>
            <input type="text" id="mtgrNm" class="form-control" readonly>
          </div>
        </div>
        <div class="row g-2">
          <div class="col mb-0">
            <label for="rentBgng" class="form-label">시작시간</label>
            <input type="text" id="rentBgng" class="form-control" readonly>
          </div>
          <div class="col mb-0">
            <label for="rentEnd" class="form-label">종료시간</label>
            <input type="text" id="rentEnd" class="form-control" readonly>
          </div>
        </div>
        <div>
          <label for="rentRsn" class="form-label">사용목적</label>	
          <textarea id="rentRsn" class="form-control" rows="15" cols="10"></textarea>
        </div>
      </div>
      <div class="modal-footer">
      	<button type="button" id="exampleBtn" style="background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
        <button type="button" class="btn btn-primary" id="rentConfirmBtn">예약</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- [ 회의실 위치 조회 모달 ] -->
<div class="modal animate__animated animate__bounceInUp" id="mapModal" tabindex="-1" aria-modal="true" role="dialog">
   <div class="modal-dialog modal-dialog-centered" role="document">
     <div class="modal-content">
       <div class="modal-header">
			<h5>회의실 구조도</h5>
			<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
       </div>
       <div class="modal-body">
			<div class="nav-tabs-shadow nav-align-left">
			  <ul class="nav nav-tabs" role="tablist">
			    <li class="nav-item">
			      <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-left-align-1F">1F</button>
			    </li>
			    <li class="nav-item">
			      <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-left-align-2F">2F</button>
			    </li>
			  </ul>
			  <div class="tab-content">
			    <div class="tab-pane fade show active" id="navs-left-align-1F">
			      <p>
			        <img class="card-img-top" src="/upload/a432ec33-f583-4a1f-9271-294c33dc27ea_1층구조도.png" alt="1층 구조도" style="height: 300px;">
			      </p>
			    </div>
			    <div class="tab-pane fade" id="navs-left-align-2F">
			      <p>
			        <img class="card-img-top" src="/upload/37c6ea15-3865-4cfc-b27c-a71bfe78d4dc_2층구조도.png" alt="2층 구조도" style="height: 300px;">
			      </p>
			    </div>
			  </div>
			</div>
       </div>
     </div>
   </div>
</div>

<!-- —————————————————————————————————————————————————————————————————————————————————————————————————————————————————— [ Modal ] [종료] -->

<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>