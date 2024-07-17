<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-chat.css" />




<!-- Content -->

<div class="container-xxl flex-grow-1 container-p-y">
    <div class="app-chat card overflow-hidden">
        <div class="row g-0">
<!--        Sidebar Left
            <div class="col app-chat-sidebar-left app-sidebar overflow-hidden" id="app-chat-sidebar-left">
                <div class="chat-sidebar-left-user sidebar-header d-flex flex-column justify-content-center align-items-center flex-wrap px-4 pt-5">
                    <div class="avatar avatar-xl avatar-online">
                        <img src="/resources/vuexy/assets/img/avatars/1.png" alt="Avatar" class="rounded-circle" />
                    </div>
                    <h5 class="mt-2 mb-0">로그인한 사람 정보 출력</h5>
                    <span>Admin</span>
                    <i class="ti ti-x ti-sm cursor-pointer close-sidebar" data-bs-toggle="sidebar" data-overlay data-target="#app-chat-sidebar-left"></i>
                </div>
                <div class="sidebar-body px-4 pb-4">
                    <div class="my-4">
                        <small class="text-muted text-uppercase">About</small>
                        <textarea id="chat-sidebar-left-user-about" class="form-control chat-sidebar-left-user-about mt-3" rows="4" maxlength="120">
							할말인데 아마 없어질듯</textarea>
                    </div>
                    <div class="my-4">
                        <small class="text-muted text-uppercase">활동상태인데 구현 가능할지 모름</small>
                        <div class="d-grid gap-2 mt-3">
                            <div class="form-check form-check-success">
                                <input name="chat-user-status" class="form-check-input" type="radio" value="active" id="user-active" checked />
                                <label class="form-check-label" for="user-active">Active</label>
                            </div>
                            <div class="form-check form-check-danger">
                                <input name="chat-user-status" class="form-check-input" type="radio" value="busy" id="user-busy" />
                                <label class="form-check-label" for="user-busy">Busy</label>
                            </div>
                            <div class="form-check form-check-warning">
                                <input name="chat-user-status" class="form-check-input" type="radio" value="away" id="user-away" />
                                <label class="form-check-label" for="user-away">Away</label>
                            </div>
                            <div class="form-check form-check-secondary">
                                <input name="chat-user-status" class="form-check-input" type="radio" value="offline" id="user-offline" />
                                <label class="form-check-label" for="user-offline">Offline</label>
                            </div>
                        </div>
                    </div>
                    <div class="my-4">
                        <small class="text-muted text-uppercase">알람 끄고 키는건데 구현 못함</small>
                        <ul class="list-unstyled d-grid gap-2 me-3 mt-3">
                            <li class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="ti ti-message me-1 ti-sm"></i>
                                    <span class="align-middle">Two-step Verification</span>
                                </div>
                                <label class="switch switch-primary me-4 switch-sm">
                                    <input type="checkbox" class="switch-input" checked="" />
                                    <span class="switch-toggle-slider">
                                        <span class="switch-on"></span>
                                        <span class="switch-off"></span>
                                    </span>
                                </label>
                            </li>
                            <li class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="ti ti-bell me-1 ti-sm"></i>
                                    <span class="align-middle">Notification</span>
                                </div>
                                <label class="switch switch-primary me-4 switch-sm">
                                    <input type="checkbox" class="switch-input" />
                                    <span class="switch-toggle-slider">
                                        <span class="switch-on"></span>
                                        <span class="switch-off"></span>
                                    </span>
                                </label>
                            </li>
                            <li>
                                <i class="ti ti-user-plus me-1 ti-sm"></i>
                                <span class="align-middle">Invite Friends</span>
                            </li>
                            <li>
                                <i class="ti ti-trash me-1 ti-sm"></i>
                                <span class="align-middle">Delete Account</span>
                            </li>
                        </ul>
                    </div>
                    <div class="d-flex mt-4">
                        <button class="btn btn-primary" data-bs-toggle="sidebar" data-overlay data-target="#app-chat-sidebar-left">
                            Logout
                        </button>
                    </div>
                </div>
            </div>
             /Sidebar Left-->



            <!-- Chat & Contacts -->
            <div class="col app-chat-contacts app-sidebar flex-grow-0 overflow-hidden border-end" id="app-chat-contacts">
                <div class="sidebar-header">
                    <div class="d-flex align-items-center me-3 me-lg-0">
                        <div class="flex-shrink-0 avatar avatar-online me-3" data-bs-toggle="sidebar" data-overlay="app-overlay-ex" data-target="#app-chat-sidebar-left">
                            <img class="user-avatar rounded-circle cursor-pointer" src="/view/${loginVO.empId}" alt="Avatar" />
                        </div>
                        <div class="flex-grow-1 input-group input-group-merge rounded-pill">
                     			<h5 class="chat-contact-name text-truncate m-0">${loginVO.empNm}</h5>
			                    <p class="chat-contact-status text-muted text-truncate mb-0" style="align-content:end;">&nbsp;&nbsp; ${loginVO.deptNm} ${chatEmpList.jbgdNm}</p>
<!--                             <span class="input-group-text" id="basic-addon-search31"><i class="ti ti-search"></i></span> -->
<!--                             <input type="text" class="form-control chat-search-input" placeholder="Search..." aria-label="Search..." aria-describedby="basic-addon-search31" /> -->
                        </div>
                    </div>
                    <i class="ti ti-x cursor-pointer d-lg-none d-block position-absolute mt-2 me-1 top-0 end-0" data-overlay data-bs-toggle="sidebar" data-target="#app-chat-contacts"></i>
                </div>
                <hr class="container-m-nx m-0" />



                <div class="sidebar-body">



<!--
                    <div class="chat-contact-list-item-title">
                        <h5 class="text-primary mb-0 px-4 pt-3 pb-2">Chats</h5>
                    </div>
                    채팅 목록
                    <ul class="list-unstyled chat-contact-list" id="chat-list">
                        <li class="chat-contact-list-item chat-list-item-0 d-none">
                            <h6 class="text-muted mb-0">No Chats Found</h6>
                        </li>


                        <li class="chat-contact-list-item">
                            <a class="d-flex align-items-center">
                                <div class="flex-shrink-0 avatar avatar-online">
                                    <img src="/resources/vuexy/assets/img/avatars/13.png" alt="Avatar" class="rounded-circle" />
                                </div>
                                <div class="chat-contact-info flex-grow-1 ms-2">
                                    <h6 class="chat-contact-name text-truncate m-0">Waldemar Mannering</h6>
                                    <p class="chat-contact-status text-muted text-truncate mb-0">
                                        Refer friends. Get rewards.
                                    </p>
                                </div>
                                <small class="text-muted mb-auto">5 Minutes</small>
                            </a>
                        </li>
                    </ul>
-->




                    <!-- 연락처 -->
                    <ul class="list-unstyled chat-contact-list mb-0" id="contact-list">



                        <li class="chat-contact-list-item chat-contact-list-item-title">
                            <h5 class="text-primary mb-0">Contacts</h5>
                        </li>



                        <c:forEach var="chatEmpList" items="${employeeVOList}" varStatus="count">
						    <c:if test="${loginEmpId != chatEmpList.empId }">
						        <li class="chat-contact-list-item">
						            <a class="d-flex align-items-center" href="javascript:void(0);" onclick="chatInfoList(this)" data-emp-id="${chatEmpList.empId}">
						                <div class="flex-shrink-0 avatar avatar-offline">
						                    <img src="/view/${chatEmpList.empId}" alt="Avatar" class="rounded-circle" />
						                </div>
						                <div class="chat-contact-info flex-grow-1 ms-2">
						                    <h6 class="chat-contact-name text-truncate m-0">${chatEmpList.empNm}</h6>
						                    <p class="chat-contact-status text-muted text-truncate mb-0">${chatEmpList.deptNm} ${chatEmpList.jbgdNm}</p>
						                    <div style="display: none;">
						                        <input type="text" class="listEmpId" value="${chatEmpList.empId}">
						                        <input type="text" class="listEmpNm" value="${chatEmpList.empNm}">
						                        <input type="text" class="listFilePath" value="${chatEmpList.atchfileDetailVOList[0].atchfileDetailPhysclPath}">
						                        <input type="text" class="listDeptNm" value="${chatEmpList.deptNm}">
						                        <input type="text" class="listJbgdNm" value="${chatEmpList.jbgdNm}">
						                    </div>
						                </div>
						            </a>
						        </li>
						    </c:if>
						</c:forEach>






                    </ul>
                </div>
            </div>
            <!-- /Chat contacts -->

            <!-- Chat History -->
            <div class="col app-chat-history bg-body">
                <div class="chat-history-wrapper">
                    <div class="chat-history-header border-bottom">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex overflow-hidden align-items-center">
                                <i class="ti ti-menu-2 ti-sm cursor-pointer d-lg-none d-block me-2" data-bs-toggle="sidebar" data-overlay data-target="#app-chat-contacts"></i>
                                <div class="flex-shrink-0 avatar">
                                    <img src=" " id="selectImg" alt="Avatar" class="rounded-circle" data-bs-toggle="sidebar" data-overlay data-target="#app-chat-sidebar-right" style="display: none;"/>
                                </div>
                                <div class="chat-contact-info flex-grow-1 ms-2">
                                    <h6 class="m-0" id="selectNm"></h6>
                                    <small class="user-status text-muted" id="selectDept"></small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="chat-history-body bg-body">
                        <ul class="list-unstyled chat-history">
                        
                        









                            

                        </ul>
                    </div>
                    <!-- Chat message form -->
                    <div class="chat-history-footer shadow-sm">
                        <div class="form-send-message d-flex justify-content-between align-items-center">
                            <input class="form-control message-input border-0 me-3 shadow-none" id="id_message" placeholder="메세지를 입력해 주세요" />
                            <div class="message-actions d-flex align-items-center">
                                <!--                                 <i class="speech-to-text ti ti-microphone ti-sm cursor-pointer"></i> -->
                                <!--                                 <label for="attach-doc" class="form-label mb-0"> -->
                                <!--                                     <i class="ti ti-photo ti-sm cursor-pointer mx-3"></i> -->
                                <!--                                     <input type="file" id="attach-doc" hidden /> -->
                                <!--                                 </label> -->
                                <button class="btn btn-primary d-flex " id="id_send">
                                    <i class="ti ti-send me-md-1 me-0"></i>
<!--                                     <span class="align-middle d-md-inline-block d-none">전송</span> -->
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Chat History -->

<!--             Sidebar Right 
            <div class="col app-chat-sidebar-right app-sidebar overflow-hidden" id="app-chat-sidebar-right">
                <div class="sidebar-header d-flex flex-column justify-content-center align-items-center flex-wrap px-4 pt-5">
                    <div class="avatar avatar-xl avatar-online">
                        <img src="/resources/vuexy/assets/img/avatars/2.png" alt="Avatar" class="rounded-circle" />
                    </div>
                    <h6 class="mt-2 mb-0">선택한사람의 이름</h6>
                    <span> 선택한사람의 부서</span>
                    <i class="ti ti-x ti-sm cursor-pointer close-sidebar d-block" data-bs-toggle="sidebar" data-overlay data-target="#app-chat-sidebar-right"></i>
                </div>
                <div class="sidebar-body px-4 pb-4">
                    <div class="my-4">
                        <small class="text-muted text-uppercase">About</small>
                        <p class="mb-0 mt-3">
                            A Next. js developer is a software developer who uses the Next. js framework alongside ReactJS
                            to build web applications.
                        </p>
                    </div>
                    <div class="my-4">
                        <small class="text-muted text-uppercase">Personal Information</small>
                        <ul class="list-unstyled d-grid gap-2 mt-3">
                            <li class="d-flex align-items-center">
                                <i class="ti ti-mail ti-sm"></i>
                                <span class="align-middle ms-2">josephGreen@email.com</span>
                            </li>
                            <li class="d-flex align-items-center">
                                <i class="ti ti-phone-call ti-sm"></i>
                                <span class="align-middle ms-2">+1(123) 456 - 7890</span>
                            </li>
                            <li class="d-flex align-items-center">
                                <i class="ti ti-clock ti-sm"></i>
                                <span class="align-middle ms-2">Mon - Fri 10AM - 8PM</span>
                            </li>
                        </ul>
                    </div>
                    <div class="mt-4">
                        <small class="text-muted text-uppercase">Options</small>
                        <ul class="list-unstyled d-grid gap-2 mt-3">
                            <li class="cursor-pointer d-flex align-items-center">
                                <i class="ti ti-badge ti-sm"></i>
                                <span class="align-middle ms-2">Add Tag</span>
                            </li>
                            <li class="cursor-pointer d-flex align-items-center">
                                <i class="ti ti-star ti-sm"></i>
                                <span class="align-middle ms-2">Important Contact</span>
                            </li>
                            <li class="cursor-pointer d-flex align-items-center">
                                <i class="ti ti-photo ti-sm"></i>
                                <span class="align-middle ms-2">Shared Media</span>
                            </li>
                            <li class="cursor-pointer d-flex align-items-center">
                                <i class="ti ti-trash ti-sm"></i>
                                <span class="align-middle ms-2">Delete Contact</span>
                            </li>
                            <li class="cursor-pointer d-flex align-items-center">
                                <i class="ti ti-ban ti-sm"></i>
                                <span class="align-middle ms-2">Block Contact</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            /Sidebar Right-->

            <div class="app-overlay"></div>
        </div>
    </div>
</div>
<!-- / Content -->
<script>
$(document).ready(function() {
    // URL에서 empId 파라미터 가져오기
    const urlParams = new URLSearchParams(window.location.search);
    const empId = urlParams.get('empId');
    console.log("URL에서 empId 파라미터", empId);

    // 특정 empId에 해당하는 요소를 찾아 클릭 이벤트 트리거
    if (empId) {
        setTimeout(function() {
            var targetEmployee = $('#contact-list').find(`a[data-emp-id='\${empId}']`);
            if (targetEmployee.length) {
            	$('#contact-list').scrollTop(targetEmployee.offset().top - $('#contact-list').offset().top + $('#contact-list').scrollTop());
                targetEmployee[0].click(); // a 요소를 클릭
            }
        }, 300); // DOM이 완전히 로드될 때까지 약간의 지연 시간을 줍니다.
    }
});












    let webSocket; // 페이지 바뀌면 변수가 사라진다는 사실에 주목할 필요가 있음
    let loginEmpId = ${loginEmpId};
    let chatListEmpId	 = "";
    let chatListEmpNm	 = "";
    let chatListFilePath = "";
    let chatListDeptNm	 = "";
    let chatListJbgdNm	 = "";
    let chatListChatNo	 = "";
    let chatRoomname 	 = "";
    
    function chatInfoList(element){
    	chatListEmpId		 = $(element).find(".listEmpId").val();
    	chatListEmpNm		 = $(element).find(".listEmpNm").val();
    	chatListFilePath	 = $(element).find(".listFilePath").val();
    	chatListDeptNm		 = $(element).find(".listDeptNm").val();
    	chatListJbgdNm		 = $(element).find(".listJbgdNm").val();
    	chatRoomname		 = loginEmpId +","+chatListEmpId
    	let consoleData = {
    			"로그인한ID":loginEmpId,
    			"클릭한 ID":chatListEmpId,
    			"클릭한 이름":chatListEmpNm,
    			"클릭한 파일이름":chatListFilePath,
    			"클릭한 부서":chatListDeptNm,
    			"클릭한 직책":chatListJbgdNm,
    			"클릭한 방 이름":chatRoomname
    	}
    	console.log("데이터 체크 : ",consoleData);
    	
        $("#selectNm").text(chatListEmpNm);
        $("#selectDept").text(chatListDeptNm + " " + chatListJbgdNm);
        $("#selectImg").show();
        
        $("#selectImg").attr("src", '/view/'+chatListEmpId);
        
        
        chatRoomName = findChatRoom ();
        if (chatRoomName == "") {
        	data = { 
            		"chatRoomname":chatRoomname
            }
            
            $.ajax({
        		url:"/chat/createRoomNo",
        		contentType:"application/json;charset=utf-8",
        		data:JSON.stringify(data),
        		type:"post",
        		dataType:"text",
        		beforeSend:function(xhr){
        			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        		},
        		success:function(result){
        			console.log(result);
        		}
        	});
        	chatRoomName = findChatRoom ();
		}
        
        chatRoomName = findChatRoom ();
        console.log("찾은 공통 채팅방 : ", chatRoomName);
        
        chatLogList ();
        
        
    }
    
    function chatLogList (){
    	let chatHistory = {
        		"chatNo":chatRoomName
        }
        $.ajax({
    		url:"/chat/chatHistoryList",
    		contentType:"application/json;charset=utf-8",
    		data:JSON.stringify(chatHistory),
    		type:"post",
    		dataType:"json",
    		beforeSend:function(xhr){
    			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    		},
    		success:function(chatHistoryList){
    			console.log("result : " , chatHistoryList)
    			
    			if (!chatHistoryList || chatHistoryList.length === 0) {
	    			console.log("대화기록이 없습니다");
	    			$(".chat-history").empty();
	    			let notMsg  = ``;
	    			notMsg+=		`<div class="divider divider-primary">`;
	    			notMsg+=		`<div class="divider-text">대화기록이 없습니다</div>`;
	    			notMsg+=		`</div>`;
    				$(".chat-history").append(notMsg);	
	    			
				}else {
	    			$(".chat-history").empty();
	    			
	    			$.each(chatHistoryList, function(index,item){
	    				console.log("loginEmpId",loginEmpId);
	    				console.log("item.CHAT_S_EMP_ID",item.CHAT_S_EMP_ID);
	    				console.log("item.CHAR_SNDNG_HR",item.CHAR_SNDNG_HR);
	    				
	    				let chatSEmpId = parseInt(item.CHAT_S_EMP_ID) 
	    				console.log("변환 chatSEmpId",chatSEmpId);

	    				let formattedTime = formatTimestamp(item.CHAR_SNDNG_HR);
	    				console.log("formattedTime",formattedTime);
	    				
	    				
	    				
	    				
	    				
	    				
	    				
			    			let comment = ``;
	    				if (loginEmpId != chatSEmpId ) {
	    					comment +=`<li class="chat-message">`;
	    					comment +=`<div class="d-flex overflow-hidden">`;
	    					comment +=`<div class="user-avatar flex-shrink-0 me-3">`;
	    					comment +=`<div class="avatar avatar-sm">`;
	    					comment +=`<img src="/upload\${chatListFilePath}" alt="Avatar" class="rounded-circle" />`;
	    					comment +=`</div>`;
	    					comment +=`</div>`;
	    					comment +=`<div class="chat-message-wrapper flex-grow-1">`;
	    					comment +=`<div class="chat-message-text">`;
	    					comment +=`<p class="mb-0">\${item.CHAR_SNDNG_CN}</p>`;
	    					comment +=`</div>`;
	    					comment +=`<div class="text-muted mt-1">`;
	    					comment +=`<small> \${formattedTime} </small>`;
	    					comment +=`</div>`;
	    					comment +=`</div>`;
	    					comment +=`</div>`;
	    					comment +=`</li>`;
		    				$(".chat-history").append(comment);
		    				
						}else{
							comment +=`<li class="chat-message chat-message-right">`;
							comment +=`<div class="d-flex overflow-hidden">`;
							comment +=`<div class="chat-message-wrapper flex-grow-1">`;
							comment +=`<div class="chat-message-text">`;
							comment +=`<p class="mb-0">\${item.CHAR_SNDNG_CN}</p>`;
							comment +=`</div>`;
							comment +=`<div class="text-end text-muted mt-1">`;
							comment +=`<i class="ti ti-checks ti-xs me-1 text-success"></i>`;
							comment +=`<small> \${formattedTime} </small>`;
							comment +=`</div>`;
							comment +=`</div>`;
							comment +=`<div class="user-avatar flex-shrink-0 ms-3">`;
							comment +=`</div>`;
							comment +=`</div>`;
							comment +=`</li>`;
		    				$(".chat-history").append(comment);
						}
		    				scrollToBottom();
	    			});
				}
    		}
    	});
    }
    
    
    function formatTimestamp(timestamp) {
        var date = new Date(timestamp);
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        var period = hours < 12 ? '오전' : '오후';
        
        // 12시간 형식으로 변경
        hours = hours % 12 || 12;
        
        // 두 자리 숫자 형태로 변환
        hours = hours.toString().padStart(2, '0');
        minutes = minutes.toString().padStart(2, '0');
        seconds = seconds.toString().padStart(2, '0');
        
        return `\${period} \${hours}:\${minutes}:\${seconds}`;
    }
    
    function scrollToBottom() {
        $(".chat-history-body").scrollTop($(".chat-history-body")[0].scrollHeight);
    }
    
     
    function findChatRoom (){
    	let data = {
    			"loginEmpId":loginEmpId,
    			"listEmpId":chatListEmpId
    	}
    	console.log("data",data);
    	
    	$.ajax({
    		url:"/chat/findChatRoom",
    		contentType:"application/json;charset=utf-8",
    		data:JSON.stringify(data),
    		type:"post",
    		dataType:"text",
    		async:false,
    		beforeSend:function(xhr){
    			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    		},
    		success:function(result){
    			
    			chatListChatNo = result;
    		}
    	});
    	return chatListChatNo;
	}

    
    
    
    
    const c_chatWin = document.querySelector("#id_chatwin");
    const c_message = document.querySelector("#id_message");
    const c_send = document.querySelector("#id_send");
    
//     $("#id_send").on("click",function(){
//     	send();
//     });

// Click event listener for the send button
c_send.addEventListener("click", () => {
    if ($("#selectNm").text() != "") {
        send();
    } else {
        alert("대화할 상대를 선택해주세요");
        return;
    }
});

// Keydown event listener for the Enter key on the input field
c_message.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
        if ($("#selectNm").text() != "") {
            send();
        } else {
            alert("대화할 상대를 선택해주세요");
            return;
        }
    }
});

    //연결
    connect();
    
    
    
	function connect() {
		//ip를 쓰면, ip가 , localhost 를 쓰면 localhost가 들어오도록 하고 픔
		let myServer = location.href.split("/")[2]; // http://localhost/
		webSocket = new WebSocket(`ws://\${myServer}/ws-chat`); // End Point
		//이벤트에 이벤트핸들러 뜽록 
		webSocket.onopen = fOpen; // 소켓 접속되면 짜똥 실행할 함수(fOpen)
		webSocket.onmessage = fMessage; // 써버에서 메쎄징 오면  짜똥 실행할 함수(fMessage) 
	}

    //연결 시
    function fOpen() {
    	
    	
    }

    function todayLog (){
    	let today = new Date();   

    	console.log(today.toLocaleDateString() + '<br>');
    	console.log(today.toLocaleTimeString() + '<br>');
    	console.log(today.toLocaleString() + '<br><br>');
    	console.log(today.toLocaleDateString('en-US'));
    	
    	let timeResult = today.toLocaleTimeString()
    	return timeResult;
    }
    
    function send() { // 써버로 메쎄찡 떤쏭하는 함수
    	let timeResult = todayLog ();
    	
    	let chatSndngCn = $("#id_message").val();
		let chatMessage = {
				   timeResult:timeResult,
		           chatSEmpId: loginEmpId,
		           chatREmpId: chatListEmpId,
		           chatNo: chatListChatNo,
		           chatSndngCn: chatSndngCn
		       };
    	console.log("웹소켓으로 보내는 내용",chatMessage);
    	
    	
    	webSocket.send(JSON.stringify(chatMessage));
        c_message.value = "";
        let chat = "chat";
        
       	let socketMsg	=	{
       			"title":chat,
       			"senderId":loginEmpId,
       			"receiverId":chatListEmpId
       	}
       	
       	socket.send(JSON.stringify(socketMsg));
        	
    }

    function fMessage() {
        let data = JSON.parse(event.data);
        console.log("서버에서 전달받은 메시지 : " , data);
        let webSndngCn 		=  	data.chatSndngCn
        let webSEmpId		=	data.chatREmpId
        let webREmpId		=	data.chatSEmpId
        let webChatNo		=	data.chatNo
        let webTimeLog		=	data.timeResult
        console.log("서버에서 전달받은 쳇넘버 : ",webChatNo);
        if (chatListChatNo == webChatNo) {
        	
	        if (loginEmpId == webSEmpId) {
	        	let comment = ``;
	        	comment +=`<li class="chat-message">`;
				comment +=`<div class="d-flex overflow-hidden">`;
				comment +=`<div class="user-avatar flex-shrink-0 me-3">`;
				comment +=`<div class="avatar avatar-sm">`;
				comment +=`<img src="/upload\${chatListFilePath}" alt="Avatar" class="rounded-circle" />`;
				comment +=`</div>`;
				comment +=`</div>`;
				comment +=`<div class="chat-message-wrapper flex-grow-1">`;
				comment +=`<div class="chat-message-text">`;
				comment +=`<p class="mb-0">\${data.chatSndngCn}</p>`;
				comment +=`</div>`;
				comment +=`<div class="text-muted mt-1">`;
				comment +=`<small>\${data.timeResult}</small>`;
				comment +=`</div>`;
				comment +=`</div>`;
				comment +=`</div>`;
				comment +=`</li>`;
				$(".chat-history").append(comment);
				
				comment = ``;
			}else {
				let comment = ``;
				comment +=`<li class="chat-message chat-message-right">`;
				comment +=`<div class="d-flex overflow-hidden">`;
				comment +=`<div class="chat-message-wrapper flex-grow-1">`;
				comment +=`<div class="chat-message-text">`;
				comment +=`<p class="mb-0">\${data.chatSndngCn}</p>`;
				comment +=`</div>`;
				comment +=`<div class="text-end text-muted mt-1">`;
				comment +=`<small>\${data.timeResult}</small>`;
				comment +=`</div>`;
				comment +=`</div>`;
				comment +=`<div class="user-avatar flex-shrink-0 ms-3">`;
				comment +=`</div>`;
				comment +=`</div>`;
				comment +=`</li>`;
				$(".chat-history").append(comment);
				comment = ``;
			}
				scrollToBottom();
		}
    }
 
    function disconnect() { //써버와 인연 끊는 함쑹
        webSocket.send(loginEmpId + "님이 뛰쳐나갔쪙");
        webSocket.close();
    }
</script>
<script src="/resources/vuexy/assets/js/app-chat.js"></script>