<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%> 
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script> 
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/toastr/toastr.css" />

<nav
    class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
    id="layout-navbar">
    <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
        <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
            <i class="ti ti-menu-2 ti-sm"></i>
        </a>
    </div>

    <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">

        <ul class="navbar-nav flex-row align-items-center ms-auto">
            
            <!-- 조직도 -->
            <li class="nav-item dropdown-notifications navbar-dropdown dropdown me-3 me-xl-1">
                <a class="nav-link hide-arrow" href="/orgchart/list">
                    <i class="ti ti-md ti-sitemap"></i>
                </a>
            </li>
            <!-- // 조직도 -->
            
            <!-- alarm -->
            <li class="nav-item dropdown-notifications navbar-dropdown dropdown me-3 me-xl-1">
                <!-- 요청 URI : /alarm, 현재는 템플릿 참고를 위해 변경하지 않았음 -->
                <a
                    class="nav-link dropdown-toggle hide-arrow"
                    href="javascript:void(0);"
                    data-bs-toggle="dropdown"
                    data-bs-auto-close="outside"
                    aria-expanded="false">
                    <i class="ti ti-bell ti-md"></i>
                    <span class="badge bg-danger rounded-pill badge-notifications alarmCount"></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end py-0">
                    <li class="dropdown-menu-header border-bottom">
                        <div class="dropdown-header d-flex align-items-center py-3">
                            <h5 class="text-body mb-0 me-auto">Alarm</h5>
                            <a
                                href="javascript:void(0)"
                                class="dropdown-notifications-all text-body allDelNotifi"
                                data-bs-toggle="tooltip"
                                data-bs-placement="top"
                                title="전체 삭제" style="margin-right: 10px">
                                <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1.3"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-trash"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M4 7l16 0" /><path d="M10 11l0 6" /><path d="M14 11l0 6" /><path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12" /><path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3" /></svg>
							</a>
                            <a
                                href="javascript:void(0)"
                                class="dropdown-notifications-all text-body allReadNotifi"
                                data-bs-toggle="tooltip"
                                data-bs-placement="top"
                                title="전체 읽기">
                                <i class="ti ti-mail-opened fs-4"></i>
                            </a>
                        </div>
                    </li>
                    <li class="dropdown-notifications-list scrollable-container">
                        <ul class="list-group list-group-flush alarmAllList">
                            <!-- 알람 항목들 -->
                            
                            
                        </ul>
                    </li>
<!--                     <li class="dropdown-menu-footer border-top">
                        <a
                            href="javascript:void(0);"
                            class="dropdown-item d-flex justify-content-center text-primary p-2 h-px-40 mb-1 align-items-center">
                            View all alarms
                        </a>
                    </li> -->
                </ul>
            </li>
            <!-- // alarm -->
        
            <!-- Chat -->
            <li class="nav-item dropdown-notifications navbar-dropdown dropdown me-3 me-xl-1">
                <a class="nav-link hide-arrow" href="/chat/list">
                    <i class="ti ti-md ti-messages"></i>
<!--                     <span class="badge bg-danger rounded-pill badge-notifications">5</span> -->
                </a>
            </li>
            <!-- // Chat -->

            <!-- User -->
            <li class="nav-item navbar-dropdown dropdown-user dropdown wideWidth">
                <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown">
                    <div class="d-flex align-items-center">
                        <div class="avatar avatar-md me-2 avatar-online ">
                            <img src="<c:choose>
		                                <c:when test="${loginVO.atchfileSn == null}">
		                                    /resources/images/default-profile.png
		                                </c:when>
		                                <c:otherwise>
		                                    /upload${loginVO.atchfileDetailVOList[0].atchfileDetailPhysclPath}
		                                </c:otherwise>
		                              </c:choose>" class=" rounded-circle" />
                        </div>
                        <div class="flex-grow-1">
                            <span class="fw-medium d-block">${loginVO.empNm} ${loginVO.jbgdNm}</span>
                            <small class="text-muted">${loginVO.deptNm}</small>
                            <input type="hidden" id="loginVOempId" value="${loginVO.empId }">
                        </div>
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="/mypage/profile">
                            <i class="ti ti-user-check me-2 ti-sm"></i>
                            <span class="align-middle">정보 수정</span>
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="/salary/list">
                            <i class="flex-shrink-0 ti ti-credit-card me-2 ti-sm"></i>
                            <span class="align-middle">급여 조회</span>
                        </a>
                    </li>
                    <li>
                        <div class="dropdown-divider"></div>
                    </li>
                    <li style="padding: 10px">
                    	<div style="align-items: center;">
	                    	<form action="/logout" method="post" >
	                    		<button type="submit" class="btn btn-label-primary me-2" style="width: 100%; " >
	                    			<span class="tf-icons ti-xs ti ti-logout me-2 ti-sm"></span>Log Out
	                    		</button>
	                    		<sec:csrfInput />
							</form>
                    	</div>
                    
							
						<%-- <a class="dropdown-item" href="<c:url value='/logout' />">
                            <i class="ti ti-logout me-2 ti-sm"></i>
                            <span class="align-middle">Log Out</span>
                        </a> --%>
                    </li>
                </ul>
            </li>
            <!-- // User -->
        </ul>
    </div>
    
    



    <!-- Search Small Screens -->
    <div class="navbar-search-wrapper search-input-wrapper d-none">
        <input
            type="text"
            class="form-control search-input container-xxl border-0"
            placeholder="Search..."
            aria-label="Search..." />
        <i class="ti ti-x ti-sm search-toggler cursor-pointer"></i>
    </div>
    
    
</nav>

<script src="/resources/vuexy/assets/vendor/libs/toastr/toastr.js" ></script>
<script type="text/javascript">
var socket = null;
let loginId = $("#loginVOempId").val();
$(document).ready(function(){
	if( loginId != null ){
	connectWs();
	}
})


//소켓
toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": false,
  "progressBar": true,
  "positionClass": "toast-bottom-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "3000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}


function connectWs(){
console.log("알람 웹소켓 체크")
var wsk = new SockJS("/ws-alram");
socket = wsk;

	wsk.onopen = function() {
 		console.log('open');
 
 };

 wsk.onmessage = function(event) {
		console.log("onmessage"+event.data);
		toastr.success(event.data);
		alarmList();
};


	wsk.onclose = function() {
	    console.log('close');
};
 

};

//소켓끝

alarmList();


function alarmList(){
	let data = {
			"alarmRcvr":loginId
	};
	
	$.ajax({
		url:"/alarm/alarmList",
		contentType:"application/json;charset=utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(alarmVOList){
			console.log("result : ", alarmVOList);
			$(".alarmAllList").empty();
			$.each(alarmVOList , function(index,alarmVOList){
				
				let str = "";
				let alarmStts = alarmVOList.ALARM_STTS ; 
				if (alarmStts == "0") {
					str += `<li class='list-group-item list-group-item-action dropdown-notifications-item waves-effect '>`; 
					str +=	`<div class='d-flex'>`; 
					str +=	`<div class='flex-shrink-0 me-3'>`; 
					str +=	`<div class='avatar'>`; 
					str +=	`<img src='/view/\${alarmVOList.ALARM_SNDPTY}' alt='' class='rounded-circle'>`; 
					str +=	`</div>`; 
					str +=	`</div>`; 
					str +=	`<div class='flex-grow-1 alarmRead' data-value='\${alarmVOList.ALARM_NO}'>`; 
					//채팅
					if (alarmVOList.ALARM_TYPE == "chat") {
						str +=	`<h6 class='mb-1 small'>[채팅 도착]</h6>`; 
					}
					else if (alarmVOList.ALARM_TYPE == "freeBoard") {
						str +=	`<h6 class='mb-1 small'>[새 댓글 등록]</h6>`; 
					}
					else if (alarmVOList.ALARM_TYPE == "schedule") {
						str +=	`<h6 class='mb-1 small'>[부서 일정 등록]️</h6>`; 
					}
					//참조자 등록
					else if (alarmVOList.ALARM_TYPE == "approvalCC") {
						str +=	`<h6 class='mb-1 small'>[참조자 등록]</h6>`; 
					}
					//결재자 등록
					else if (alarmVOList.ALARM_TYPE == "approvalAL") {
						str +=	`<h6 class='mb-1 small'>[결재자 등록]️</h6>`; 
					}
					//반려 알람
					else if (alarmVOList.ALARM_TYPE == "approvalRJ") {
						str +=	`<h6 class='mb-1 small'>[결재 반려]</h6>`; 
					}
					//승일 알람
					else if (alarmVOList.ALARM_TYPE == "approve") {
						str +=	`<h6 class='mb-1 small'>[결재 승인]</h6>`; 
					}
					//상신 취소 알람
					else if (alarmVOList.ALARM_TYPE == "approveCL") {
						str +=	`<h6 class='mb-1 small'>[결재 취소]</h6>`; 
					}
					else if (alarmVOList.ALARM_TYPE == "mail") {
						str +=	`<h6 class='mb-1 small'>[메일 도착]</h6>`; 
					}
					str +=	`<small class='mb-1 d-block text-body'>\${alarmVOList.ALARM_URL}</small>`; 
					str +=	`<small class='text-muted'>\${alarmVOList.ALARM_OCRN_TM}</small>`; 
					str +=	`</div>`; 
					str +=	`<div class='flex-shrink-0 dropdown-notifications-actions'>`; 
					str +=	`<a href='javascript:void(0)' class='dropdown-notifications-read'><span class='badge badge-dot'></span></a>`; 
					str +=	`<a href='javascript:void(0)' class='dropdown-notifications-archive'><span class='ti ti-x alarmBtn'   data-value='\${alarmVOList.ALARM_NO}' ></span></a>`; 
					str +=	`</div>`; 
					str +=	`</div>`; 
					str +=	`</li>`;
						
					$(".alarmAllList").append(str);
				}else {
					str += `<li class='list-group-item list-group-item-action dropdown-notifications-item marked-as-read waves-effect' >`;
					str += `<div class='d-flex' >`;
					str += `<div class='flex-shrink-0 me-3'>`;
					str += `<div class='avatar'>`;
					str += `<img src='/view/\${alarmVOList.ALARM_SNDPTY}' alt='' class='rounded-circle'>`;
					str += `</div>`;
					str += `</div>`;
					str += `<div class='flex-grow-1 alarmRead' data-value='\${alarmVOList.ALARM_NO}'>`;
					
					if (alarmVOList.ALARM_TYPE == "chat") {
						str +=	`<h6 class='mb-1 small'>[채팅도착]</h6>`; 
					}
					else if (alarmVOList.ALARM_TYPE == "freeBoard") {
						str +=	`<h6 class='mb-1 small'>[새 댓글 등록]</h6>`; 
					}
					else if (alarmVOList.ALARM_TYPE == "schedule") {
						str +=	`<h6 class='mb-1 small'>[부서 일정 등록]️</h6>`; 
					}
					//참조자 등록
					else if (alarmVOList.ALARM_TYPE == "approvalCC") {
						str +=	`<h6 class='mb-1 small'>[참조자 등록]</h6>`; 
					}
					//결재자 등록
					else if (alarmVOList.ALARM_TYPE == "approvalAL") {
						str +=	`<h6 class='mb-1 small'>[결재자 등록]️</h6>`; 
					}
					//반려 알람
					else if (alarmVOList.ALARM_TYPE == "approvalRJ") {
						str +=	`<h6 class='mb-1 small'>[결재 반려]</h6>`; 
					}
					//승일 알람
					else if (alarmVOList.ALARM_TYPE == "approve") {
						str +=	`<h6 class='mb-1 small'>[결재 승인]</h6>`; 
					}
					//상신 취소 알람
					else if (alarmVOList.ALARM_TYPE == "approveCL") {
						str +=	`<h6 class='mb-1 small'>[결재 취소]</h6>`; 
					}
					else if (alarmVOList.ALARM_TYPE == "mail") {
						str +=	`<h6 class='mb-1 small'>[메일 도착]</h6>`; 
					}
					str += `<small class='mb-1 d-block text-body'>\${alarmVOList.ALARM_URL}</small>`;
					str += `<small class='text-muted'>\${alarmVOList.ALARM_OCRN_TM}</small>`;
					str += `</div>`;
					str += `<div class='flex-shrink-0 dropdown-notifications-actions'>`;
					str += `<a href='javascript:void(0)' class='dropdown-notifications-read'><span class='badge badge-dot'></span></a>`;
					str += `<a href='javascript:void(0)' class='dropdown-notifications-archive ' ><span class='ti ti-x alarmBtn'   data-value='\${alarmVOList.ALARM_NO}'></span></a>`;
					str += `</div>`;
					str += `</div>`;
					str += `</li>`;
					$(".alarmAllList").append(str);
				}
					str = "";
			});
		}
	});
	
	
}

/* 전체 읽음 표시 */
$(".allReadNotifi").on("click",function(){
	console.log("전체 읽기 처리");
	$.ajax({
		url:"/alarm/allReadNotifi",
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(result){
			console.log("result : ", result);
			$(".alarmAllList").empty();
			alarmList();
			countAlarm();
		}
	});
	
});


/* 읽음 표시 */
$(document).on('click', '.alarmRead', function(){
	console.log("readlog : " , $(this).data('value'));
	let alarmNo = $(this).data('value');
	let data = {
			"alarmNo":alarmNo
	};
	console.log("readBtn : " , data);
	$.ajax({
		url:"/alarm/alarmRead",
		contentType:"application/json;charset=utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(result){
			console.log("result : ", result);
			$(".alarmAllList").empty();
			alarmList();
			countAlarm();
		}
	});
});


/* 삭제 하기 */
$(document).on('click', '.alarmBtn', function(){
	console.log("dellog : " , $(this).data('value'));
	let alarmNo = $(this).data('value');
	let data = {
			"alarmNo":alarmNo
	};
	console.log("deleteBtn : " , data);
	$.ajax({
		url:"/alarm/alarmDelete", 
		contentType:"application/json;charset=utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(result){
			console.log("result : ", result);
			$(".alarmAllList").empty();
			alarmList();
			countAlarm();
		}
	});
	
});
countAlarm();

/* 읽지않은 알람 숫자 카운틴 */
function countAlarm(){
	console.log("알람 카운팅 처리");
	$.ajax({
		url:"/alarm/countAlarm",
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(result){
			console.log("카운트 한 값 : ", result);
			if (result > 0 ) {
				$(".alarmCount").remove('display');
				$(".alarmCount").text(result);
			}else {
				$(".alarmCount").css('display','none');
			}
		}
	});
}

$(".allDelNotifi").on("click",function(){
	console.log("전체 알람 삭제 처리");
	$.ajax({
		url:"/alarm/allDelNotifi",
		contentType:"application/json;charset=utf-8",
		type:"post",
		dataType:"json",
		beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
		},
		success:function(result){
			console.log("result : ", result);
			$(".alarmAllList").empty();
			alarmList();
			countAlarm();
		}
	});
	
	
});






</script>


