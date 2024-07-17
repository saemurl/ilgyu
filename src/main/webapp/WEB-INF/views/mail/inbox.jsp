<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!-- <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" /> -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>


<%-- <p>받은 메일함 : ${mailList}</p> --%>
<%-- <p>보낸 메일함 : ${mailSList}</p> --%>
<%-- <p>${wbList}</p> --%>
<%-- <p>${TsaveList}</p> --%>

<style>
.email-marked-read {
    background-color: #f5f5f5; /* 회색 배경색 */
}
/* #file-names { */
/*         border: 1px solid rgba(128, 128, 128, 0.5); /* 선 색깔을 회색으로, 투명도 50% */ */
/*         margin-left: 10px; /* margin-left를 조금 추가 */ */
/*         padding: 10px; /* 내용을 조금 더 보기 좋게 하기 위해 padding 추가 */ */
/*         border-radius: 5px; /* 모서리를 약간 둥글게 */ */
/* } */
.p-style {
    margin: 0;
    padding: 0;
    display: inline-block;
    vertical-align: middle;
}
.ck-editor__editable {
	   height: 500px;
}
	
.dropdown-menu-right-custom {
        right: -600px; /* 원하는 값으로 조정 */
}

  .scrollable {
    overflow-y: auto; /* 수직 스크롤 가능 */
    max-height: 600px; /* 최대 높이 설정 */
  }


</style>

<script>

	
	//체크박스 삭제 시 구분 
	//1) 수신 데이터 :  2
	//2) 발신 데이터 :  1
	let gubun = "2";
	console.log("수신 데이터 : ", gubun);
    let mlStts = "M01";
	console.log("메일 상태(mlStts) : ", mlStts);
	let fBContent = "";
	let mlSn = "";
    let empList = [];
    let num = "all";
    let atchfileSn = "";
	
	
	$(function() {
		const loginId = ${loginVO.empId}
		console.log(loginId);
		
		
		mailRList();
		mailRcnt();
		
// 	    loadBookmarks();
        let empId = "";
        let mlSnList = [];
        let gubunList = [];
        
        let id = "";
        let str = "";
        let dataFile = "";
        let attachFileList = [];

        const dropZone = document.querySelector('#dropZone');
        const dropZone_re = document.querySelector('#dropZone-re');
        
        const atchFile = document.querySelector('#attach-file');
        const atchFile_re = document.querySelector('#attach-file-re');
        
        const areaImg = document.querySelector('#areaImg');
        const areaImg_re = document.querySelector('#areaImg-re');
        
        const areaFile = document.querySelector('#areaFile');
        const areaFile_re = document.querySelector('#areaFile-re');

        $('#dropZone').on('dragover', function(){
        	  event.preventDefault();
        	  event.stopPropagation();
        	});
        
        $('#dropZone-re').on('dragover', function(){
        	  event.preventDefault();
        	  event.stopPropagation();
        	});

        	$('#dropZone').on('drop', function(){
        	  event.preventDefault();
        	  event.stopPropagation();

        	  let userSelFiles = event.dataTransfer.files;
//         	  console.log("끌어온 외부파일 이름 : ", userSelFiles);
        	  for(let i=0; i<userSelFiles.length; i++){
        	    console.log(userSelFiles[i].name);
        	    f_readOneFile(i, userSelFiles[i]);
        	  }

        	});
        	
        	$('#dropZone-re').on('drop', function(){
        	  event.preventDefault();
        	  event.stopPropagation();

        	  let userSelFiles = event.dataTransfer.files;
        	  // console.log("끌어온 외부파일 이름 : ", userSelFiles);
        	  for(let i=0; i<userSelFiles.length; i++){
        	    console.log(userSelFiles[i].name);
        	    f_readOneFile(i, userSelFiles[i]);
        	  }

        	});

        	atchFile.addEventListener('change', function() {
        	  dataFile = $(this).data("file");
        	  let userSelFiles = event.target.files;
        	  for(let i = 0; i < userSelFiles.length; i++) {
        	    f_readOneFile(i, userSelFiles[i]);
        	  }
        	});
        	
        	atchFile_re.addEventListener('change', function() {
        	  dataFile = $(this).data("file");
        	  let userSelFiles = event.target.files;
        	  for(let i = 0; i < userSelFiles.length; i++) {
        	    f_readOneFile(i, userSelFiles[i]);
        	  }
        	});

        	function addImageFile(fileReader, pFile) {
        	    let str = `
        	        <span class="item_image ms-3">
        	            <span class="imgPreview">
        	                <img src="\${fileReader.result}" alt="\${pFile.name}">
        	            </span>
        	            <span class="name">\${pFile.name}</span>
        	            <span class="delete-icon"><i class="ti ti-x"></i></span>
        	        </span>`;
        	        
        	        if(dataFile == "send"){
        	    		areaImg.innerHTML += str;
        	        }
        	        if(dataFile == "reply"){
        	        	areaImg_re.innerHTML += str;
        	        }
        	        
        	    	attachRemoveEvent();
        	}


        	function addGeneralFile(pFile) {
        	    let str = `
        	        <span class="item_file ms-3">
        	            <span class="name">\${pFile.name}</span>
        	            <span class="delete-icon"><i class="ti ti-x"></i></span>
        	        </span>`;
        	        
	        	    if(dataFile == "send"){
	        	    	areaFile.innerHTML += str;
	    	        }
	    	        if(dataFile == "reply"){
	    	        	areaFile_re.innerHTML += str;
	    	        }
        	    	attachRemoveEvent();
        	}

        	function f_readOneFile(pIdx, pFile){
        	  console.log("pFile >> ", pFile);
        	  attachFileList.push(pFile);
        	  console.log("attachFileList >> ", attachFileList);
        	  
        	  let fileType = pFile.type.split("/")[0];
        	  let fileReader = new FileReader();
        	  fileReader.readAsDataURL(pFile);
        	  fileReader.onload = function(){
        	    if(fileType == 'image'){
        	    	addImageFile(fileReader, pFile);
        	    }else{
        	    	addGeneralFile(pFile);
        	    }
        	  }
        	}

        	function f_ckFileList() {
        	    // 보낼 파일 리스트
        	    let sendFileList = document.querySelectorAll(".name");
//        	     console.log("sendFileList" ,sendFileList[0].innerText);

        	    //파일 고르깅
        	    let selFiles = attachFileList.filter(aFile => {
        	        for (let i = 0; i < sendFileList.length; i++) {
        	            if (aFile.name == sendFileList[i].innerText) {
        	                return true;
        	            }
        	        }
        	        return false;
        	    })
        	    return selFiles;
        	}

			function attachRemoveEvent() {
		        $('.delete-icon').off('click').on('click', function(){
		            let fileName = $(this).siblings('.name').text();
		            attachFileList = attachFileList.filter(file => file.name !== fileName);
		            $(this).parent().remove();
		
		            // input[type="file"]의 파일 목록 갱신
		            let dataTransfer = new DataTransfer();
		            attachFileList.forEach(file => {
		                dataTransfer.items.add(file);
		            });
		            atchFile.files = dataTransfer.files;
		        });
		    }
        
        
        window.addEventListener("dragover", function(){
            event.preventDefault();
        });
        window.addEventListener("drop", function(){
            event.preventDefault();
        });
        
        // 즐겨찾기 활성화 유지
        function loadBookmarks() {
		    $.ajax({
		        url: "/mail/getBookmarks",
		        contentType: "application/json;charset=utf-8",
		        type: "post",
		        dataType: "json",
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		        },
		        success: function(result) {
		            console.log("getBookmarks_result: ", result);
		
		            result.forEach(function(mailVO) {
		                if (mailVO.mlSn) {
		                        let bookmarkElement = $(`.bookmark[data-mlsn='\${mailVO.mlSn}']`);
		                        if (bookmarkElement.length > 0) {
		                            console.log(`mlSn: \${mailVO.mlSn}`);
		                            bookmarkElement.css("color", "#ff9f43");
		                            bookmarkElement.addClass("active");
		                        } else {
		                            console.log(`Element not found for mlSn: ${mailVO.mlSn}`);
		                        }
		                }
		            });
		        },
		        error: function(xhr, status, error) {
		            console.log("AJAX error:", status, error);
		        }
		    });
		}

        
        
        $('#emailComposeSidebar').on('hidden.bs.modal', function () {
            $("#attach-file").val(''); // 파일 입력 필드 초기화
            $("#file-names").html(''); // 파일 이름 표시 영역 초기화
        });
        
        
        
        $(document).on("click", ".bookmark", function(){
		    var isActive = $(this).hasClass("active");
		
		    // 토글 동작 수행
		    $(this).toggleClass("active");
		
		    let mlSn = $(this).data("mlsn");
		    console.log("mlsn : " + mlSn);
		    console.log("gubun : " + gubun);
		    
		    let data = {
		        "mlSn" : mlSn,
		        "gubun" : gubun
		    }
		    
		
		    if (!isActive) {
		        // 활성화 상태가 아닐 경우 (북마크 추가)
		        $(this).css("color", "#ff9f43");
		        $(this).attr("data-starred", "true");
		        
		        $.ajax({
		            url : "/mail/bookmark",
		            contentType : "application/json;charset=utf-8",
		            data : JSON.stringify(data),
		            type : "post",
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success : function(result){
		                console.log("result : ", result);
		            }
		        });
		    } else {
		        // 활성화 상태일 경우 (북마크 제거)
		        $(this).css("color", ""); 
		        $(this).attr("data-starred", "false");
		        
		
		        $.ajax({
		            url : "/mail/removeBookmark",
		            contentType : "application/json;charset=utf-8",
		            data : JSON.stringify(data),
		            type : "post",
		            dataType : "text",
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success : function(result){
		                console.log("removeBookmark_result : ", result);
		            }
		        });
		    }
		});

        
        // 휴지통
        $(document).on("click",".wastebasket", function() {
        	console.log("gubun : " + gubun);
        	let mlSn = $(this).data("mlsn");
        	console.log("개별 휴지통 : " + mlSn);
        	
        	
        	console.log("mlSnList_length : ", mlSnList.length);
        	if(mlSnList.length < 1){
        		mlSnList.push(mlSn);
        	}
        	
        	console.log("wastebasket_mlSnList : ", mlSnList);
        	console.log("wastebasket_gubunList : ", gubunList);
        	
        	
        	if(gubun == "3"){
        		Swal.fire({
            	    title: '메일을 삭제하시겠습니까?',
            	    text: "지워진 메일들은 복구할 수 없습니다.",
            	    icon: 'warning',
            	    showCancelButton: true,
            	    confirmButtonColor: '#3085d6',
            	    cancelButtonColor: '#d33',
            	    confirmButtonText: '네',
            	    customClass: {
            	      confirmButton: 'btn btn-primary me-1',
            	      cancelButton: 'btn btn-label-secondary'
            	    },
            	    buttonsStyling: false
            	  }).then(function(result) {
           		    if (result.value) {
           		    	
           		    	let wbDel = {
           	        			"mlSnList" : mlSnList
           	        		}
           	        		
           	        		$.ajax({
           	        			url : "/mail/wbDelete",
           	            		contentType : "application/json;charset=utf-8",
           	            		data : JSON.stringify(wbDel),
           	            		type : "post",
           	            		beforeSend: function(xhr) {
           	                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
           	                    },
           	            		success : function(result){
           	            			console.log("receiverW_result : ", result);
           	            			
           	            			mlSnList.forEach(function(mlsn) {
           	                            $(".wbSelectList[data-mlsn='" + mlsn + "']").remove();
           	                        });
           	            			/////////////////////////////////////////////////////////
           	            			mlSnList = [];
           	            			gubunList = [];
           	            		}
           	        		});
           		        Swal.fire({
           		          icon: 'success',
           		          title: '완료',
           		          text: '삭제되었습니다.',
           		          customClass: {
           		            confirmButton: 'btn btn-success'
           		          }
           		        });
           		      }
           		    });
        		
        		
        		
        	} // if gubun = 3 end
        	
        	else{
        	
        	let data = {
        		"gubun" : gubun,
        		"mlSnList" : mlSnList
        	}
        	
        	$.ajax({
        		url : "/mail/receiverW",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("result : ", result);
        			
        			mlSnList.forEach(function(mlsn) {
                        $(".mailR[data-mlsn='" + mlsn + "']").remove();
                    });
        			mlSnList.forEach(function(mlsn) {
                        $(".mailS[data-mlsn='" + mlsn + "']").remove();
                    });
        			mlSnList.forEach(function(mlsn) {
                        $(".tsMailList[data-mlsn='" + mlsn + "']").remove();
                    });
        			
        			
        			if(gubun == "4"){
                 		tsMailcnt();
                 	}else if(gubun == "3"){
                 		wbMailcnt();
                 	}else if(gubun == "2"){
                 		mailRcnt();
                 	}else if(gubun == "1"){
                 		mailScnt();
                 	}else{
                 		nrMailcnt();
                 	}
        			
        			mlSnList = [];
        			gubunList = [];
        			
        			
        		}
        	});
        	}
        	
        });
        
        
        // 임시저장 메일 다시 쓰기
        $(document).on("click", ".tsMail", function(){
        	$("#mailSendDiv").css("display", "none");
        	$("#tsSendDiv").css("display", "block");
		    mlSn = $(this).data("mlsn");
		    $(".item_file").remove();
		    console.log("tsMail_mlSn >> ", mlSn);
		    console.log("tsMail_mlStts >> ", mlStts);
		    
		    console.log("임시저장 보내기 empList >> ", empList);
		    
		    
		    let data = {
		    	"mlSn" : mlSn
		    }
		    
		    $.ajax({
		        url: "/mail/tsMailSend",
		        contentType: "application/json;charset=utf-8",
		        data: JSON.stringify(data),
		        type: "post",
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		        },
		        success: function(result) {
		            console.log("tsMailSend_result:", result);

		            if (result.mlIptYn === "Y") {
		                $("#sendImportant").prop("checked", true);
		            } else {
		                $("#sendImportant").prop("checked", false);
		            }

		            // 수신자 목록 설정
		            var selectedOptions = [];
		            result.mailReceiverList.forEach(function(receiver) {
		                selectedOptions.push(receiver.mlRcvr);
		            });
		            
		            $("#emailContacts").val(selectedOptions).trigger('change');

		            $("#email-title").val(result.mlTtl);
		            fBContent = result.mlCn;
		            editor2.setData(fBContent);
		            
		            atchfileSn = result.atchfileSn;
		            console.log("atchfileSn >> " + atchfileSn);
		            
		            $('#emailContacts').on('select2:unselect', function (e) {
		                
		                let empId = e.params.data.id;

		                let data = {
		                	"empId" : empId,
		                	"mlSn" : mlSn
		                }
		                
		                console.log("RDel_data >> ", data);
		                
		                if(gubun == "4"){
			                $.ajax({
			                	url: "/mail/receiverDel",
			    		        contentType: "application/json;charset=utf-8",
			    		        data: JSON.stringify(data),
			    		        type: "post",
			    		        beforeSend: function(xhr) {
			    		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			    		        },
			    		        success: function(result) {
			    		        	console.log("receiverDel_result:", result);
			    		        }
			                });
		                }
		            });
		            
		        }
		    });
		    
		    $.ajax({
		    	url: "/mail/tsMailFiles",
		        contentType: "application/json;charset=utf-8",
		        data: JSON.stringify(data),
		        type: "post",
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		        },
		        success: function(result) {
		        	console.log("tsMailFiles_result:", result);
		        	
		        		
// 	        		result.forEach(function(atchfileDetailVO, stat){
// 	        			let str =   `
// 	                        <span class="item_file">
// 	                            <span class="name">\${atchfileDetailVO.atchfileDetailLgclfl}</span>
// 	                            <span class="delete-icon"><i class="ti ti-x"></i></span>
// 	                        </span>`;
	                        
// 	                    areaFile.innerHTML += str;
// 	        		});
		        }
		    });
		    
		});
        
        $("#tsSendS").on("click", function(){
	    	
	    	let title = $("#email-title").val();
		    let message = $("#message").val();
		    
		    if ($("#sendImportant").is(":checked")) {
		        $("#sendImportant").val("Y");
		    } else {
		        $("#sendImportant").val("N");
		    }
		    let important = $("#sendImportant").val();
		    
			let formData = new FormData();
		    
		    // 파일 추가
		    let fileList = f_ckFileList();
		    console.log("fileList", fileList);
		    fileList.forEach(file => {
		        formData.append("file", file);
		    });
		    
		    let mailVO = {
		    	"atchfileSn" : atchfileSn,
		    	"mlSn" : mlSn,
		        "mlTtl": title,
		        "mlCn": message,
		        "mlIptYn": important,
		        "empList": empList,
		        "mlStts" : mlStts
		    };
		    console.log("mailVO >>> ", mailVO);
		    
		    console.log("empList : ", empList);
		    console.log("title : ", title);
		    console.log("message : ", message);
		    console.log("important : ", important);
		    
		    formData.append("mailVO", new Blob([JSON.stringify(mailVO)], {type: "application/json"}));
		    
		    fetch("/mail/tsMailSendReply", {
		        method: "POST",
		        headers: {
		            "X-CSRF-TOKEN": "${_csrf.token}"
		        },
		        body: formData
		    }).then((resp) => {
		        resp.text().then((data) => {
		            console.log("tsMailSendReply_mailVO >> ", data);
		            if(mlStts == "M01"){
		            	$(".tsMailList[data-mlsn='" + mlSn + "']").remove();
		            	  Swal.fire({
		            	    title: '완료!',
		            	    text: '메일이 전송되었습니다',
		            	    icon : 'success',
		            	    customClass: {
		            	      confirmButton: 'btn btn-primary'
		            	    },
		            	    buttonsStyling: false
		            	  });
	            	}
		            mlStts = "M01"
	            	$('#emailComposeSidebar').modal('hide');
		            tsMailcnt();
		        });
		    }).catch((error) => {
		        console.log('tsMailSendReply_Error:', error);
		    });
		    
	    });
        
        // 임시저장 메일함 리스트
        function tsmailList(){
        	$(".tsMailList").remove();
        	
        	let data = {
        		"num" : num
        	}
        	
        	
        	$.ajax({
        		url : "/mail/tsSelectList",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		dataType : "json",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("tsSelectList_result: ", result);

                    let str = "";
                    
                    result.forEach(function(mailVO, statIndex) {
                        str += `
                        <li id="tsMail" class="email-list-item email-marked-read tsMailList" data-mliptyn="\${mailVO.mlIptYn}" data-mlsn="\${mailVO.mlSn}" data-draft="true">
                            <div class="d-flex align-items-center">
                                <div class="form-check mb-0">
                                    <input class="email-list-item-input form-check-input TsCheckbox" type="checkbox" id="email-\${statIndex}" data-mlsn="\${mailVO.mlSn}">
                                    <label class="form-check-label" for="email-\${statIndex}"></label>
                                </div>
                                <i class="email-list-item-bookmark ti ti-star ti-sm d-sm-inline-block d-none cursor-pointer ms-2 me-3 bookmark" data-mlsn="\${mailVO.mlSn}"></i>`;

                        mailVO.mailReceiverList.forEach(function(receiver, index) {
                            if (index <= 0) {
                                str += `<img src="/view/\${receiver.mlRcvr}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32">`;
                            }
                        });

                        str += `<div class="email-list-item-content ms-2 ms-sm-0 me-2 tsMail" data-mlsn="\${mailVO.mlSn}" data-bs-target="#emailComposeSidebar" data-bs-toggle="modal">`;

                        if (mailVO.mailReceiverList && mailVO.mailReceiverList.length > 0) {
                            str += `<span class="h6 email-list-item-username me-2">`;
                            mailVO.mailReceiverList.forEach(function(receiver, receiverIndex) {
                                if (receiverIndex == 0) {
                                    str += `\${receiver.empNm}`;
                                }
                            });

                            if (mailVO.mailReceiverList.length > 1) {
                                str += ` 외 \${mailVO.mailReceiverList.length - 1}명`;
                            }

                            str += `</span>`;
                        } else {
                            str += `<span class="h6 email-list-item-username me-2">No Receiver</span>`;
                        }

                        str += `<span class="email-list-item-subject d-xl-inline-block d-block">\${mailVO.mlTtl}</span>
                                </div>
                                <div class="email-list-item-meta ms-auto d-flex align-items-center">`;

                        if (mailVO.mlIptYn === 'Y') {
                            str += `<span class="email-list-item-label badge badge-dot bg-primary d-none d-md-inline-block me-2" data-label="important"></span>`;
                        }

                        str += `<small class="email-list-item-time text-muted">\${mailVO.strMlSndngYmd}</small>
                                    <ul class="list-inline email-list-item-actions text-nowrap">
                                        <li class="list-inline-item email-delete wastebasket" data-mlsn="\${mailVO.mlSn}">
                                        	<i class="ti ti-trash ti-sm"></i></li>
                                    </ul>
                                </div>
                            </div>
                        </li>`;
                    });
                    loadBookmarks();
                    $("#mailList").append(str);
                }
        	});
    		
    	}
        
        
        
        
        
        
        // 임시저장 메일함 클릭
        $(document).on("click", "#tsBtn", function(){
        	tsMailcnt();
        	$(".tsMailList").css("display", "block");
        	$(".tsMailList").remove();
        	$(".BM").css("display", "none");
        	$("#restore-icon").css("display", "none");
        	$(".wbSelectList").css("display", "none");
        	$(".mailR").css("display", "none");
        	$(".mailS").css("display", "none");
        	$(".NR").css("display", "none");
        	
        	gubun = $(this).attr("data-mail");
        	console.log("임시저장 메일함_gubun : ", gubun);
        	
        	tsmailList();
        });
        
        
        
        
        
        function wbMailList(){
        	$(".wbSelectList").remove();
        	
        	let data = {
        		"num" : num
        	}
        	
    		$.ajax({
        		url : "/mail/wbSelectList",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		dataType : "json",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("wbSelectList_result: ", result);

                    let str = "";
                    
                    result.forEach(function(mailVO, statIndex) {
                        str += `
                        <li id="wb" class="email-list-item wbSelectList" data-mliptyn="\${mailVO.mlIptYn}" data-trash="true" data-bs-toggle="sidebar" data-mlsn="\${mailVO.mlSn}" data-target="#app-email-view">
                            <div class="d-flex align-items-center">
                                <div class="form-check mb-0">`
                                mailVO.wastebasketVOList.forEach(function(wastebasket) {
                                	str += `<input class="email-list-item-input form-check-input wbCheckbox" type="checkbox" id="email-\${statIndex}" data-mlsn="\${mailVO.mlSn}" data-gubun="\${wastebasket.mlRSType}">`
                                });
                                str += `<label class="form-check-label" for="email-\${statIndex}"></label>
                                </div>
                                <i class="email-list-item-bookmark ti ti-star ti-sm d-sm-inline-block d-none cursor-pointer ms-2 me-3 bookmark" data-mlsn="\${mailVO.mlSn}"></i>`;
                        
                        mailVO.wastebasketVOList.forEach(function(wastebasket) {
                            if (wastebasket.mlRSType === '2') {
                                mailVO.mailSenderVOList.forEach(function(sender, index) {
                                	if (index <= 0) {
                                    	str += `<img src="/view/\${sender.mlSndpty}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32">`;
                                	}
                                });
                            } else if (wastebasket.mlRSType === '1' || wastebasket.mlRSType === '4') {
                                mailVO.mailReceiverList.forEach(function(receiver, index) {
                                	 if (index <= 0) {
                                    	str += `<img src="/view/\${receiver.mlRcvr}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32">`;
                                	}
                                });
                            }
                        });
                        str += `<div class="email-list-item-content ms-2 ms-sm-0 me-2 wbDetail" data-mlsn="\${mailVO.mlSn}">`;

                        mailVO.wastebasketVOList.forEach(function(WastebasketVO) {
                            if (WastebasketVO.mlRSType === '1') {
                                str += `<span class="badge px-2 bg-label-primary" text-capitalized="" style="margin-right : 7px;">보낸 메일</span>`;
                            }
                        });
                        if (mailVO.mailSenderVOList.length > 0) {
            	            str += `<span class="h6 email-list-item-username me-2">`;
            	            mailVO.mailSenderVOList.forEach(function(sender, senderIndex) {
            	                if (senderIndex == 0) {
            	                    str += `\${sender.empNm}`;
            	                }
            	            });

            	            if (mailVO.mailSenderVOList.length > 1) {
            	            	
            	                str += ` 외 \${mailVO.mailSenderVOList.length - 1}명`;
            	            }

            	            str += `</span>`;
            	        }
//                         mailVO.mailSenderVOList.forEach(function(sender) {
//                             str += `<span class="h6 email-list-item-username me-2">\${sender.empNm}</span>`;
//                         });

                        str += `<span class="email-list-item-subject d-xl-inline-block d-block">\${mailVO.mlTtl}</span>
                                </div>
                                <div class="email-list-item-meta ms-auto d-flex align-items-center">`;

                        if (mailVO.mlIptYn === 'Y') {
                            str += `<span class="email-list-item-label badge badge-dot bg-primary d-none d-md-inline-block me-2" data-label="important"></span>`;
                        }

                        str += `<small class="email-list-item-time text-muted">\${mailVO.strMlSndngYmd}</small>
                                </div>
                            </div>
                        </li>`;
                    });
                    loadBookmarks();
                    $("#mailList").append(str);
                }
        	});
    	}
        
        
        
        
        
        
        
        // 휴지통 클릭
        $(document).on("click", "#wbBtn", function(){
        	wbMailcnt();
			$(".wbSelectList").css("display", "block");
			$("#restore-icon").css("display", "block");
			$(".BM").css("display", "none");
			$(".tsMailList").css("display", "none");
			$(".wbSelectList").remove();
			$(".mailR").css("display", "none");
			$(".mailS").css("display", "none");
			$(".NR").css("display", "none");
			
			
			gubun = $(this).attr("data-mail");
			console.log("휴지통_gubun : ", gubun);
        	$("#email-select-all").prop("checked", false);
        	
        	wbMailList();
        	
        });
        
        
        function mailSList(){
   		 $(".mailS").remove();
   		 
   		 let data = {
   			"num" : num
   		 }
   		 
   		 $.ajax({
       		 url : "/mail/mailSList",
         		contentType : "application/json;charset=utf-8",
         		data : JSON.stringify(data),
         		type : "post",
         		dataType : "json",
         		beforeSend: function(xhr) {
                     xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                 },
                 success: function(result) {
               	    console.log("mailSList_result : ", result);
               	    
               	    let str = "";
               	    
               	    result.forEach(function(mailVO, statIndex) {
               	        str += `
               	        <li  id="mailS" class="email-list-item email-marked-read mailS" data-mlsn="\${mailVO.mlSn}" data-mliptyn="\${mailVO.mlIptYn}" data-sent="true" data-target="#app-email-view" data-bs-toggle="sidebar">
               	            <div class="d-flex align-items-center">
               	                <div class="form-check mb-0">
               	                    <input class="email-list-item-input form-check-input Scheckbox" type="checkbox" id="email-\${statIndex}" data-mlsn="\${mailVO.mlSn}">
               	                    <label class="form-check-label" for="email-\${statIndex}"></label>
               	                </div>
               	                <i class="email-list-item-bookmark ti ti-star ti-sm d-sm-inline-block d-none cursor-pointer ms-2 me-3 bookmark" data-mlsn="\${mailVO.mlSn}"></i>`;

               	        mailVO.mailReceiverList.forEach(function(receiver, index) {
               	            if (index <= 0) {
               	                str += `<img src="/view/\${receiver.mlRcvr}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32">`
               	            }
               	        });

               	        str += `<div class="email-list-item-content ms-2 ms-sm-0 me-2 mailSDetiles" data-mlsn="\${mailVO.mlSn}">`;

               	        if (mailVO.mailSenderVOList.length > 0) {
               	            str += `<span class="h6 email-list-item-username me-2">`;
               	            mailVO.mailSenderVOList.forEach(function(sender, senderIndex) {
               	                if (senderIndex == 0) {
               	                    str += `\${sender.empNm}`;
               	                }
               	            });

               	            if (mailVO.mailSenderVOList.length > 1) {
               	            	
               	                str += ` 외 \${mailVO.mailSenderVOList.length - 1}명`;
               	            }

               	            str += `</span>`;
               	        }

               	        str += `<span class="email-list-item-subject d-xl-inline-block d-block">\${mailVO.mlTtl}</span>
               	                </div>
               	                <div class="email-list-item-meta ms-auto d-flex align-items-center">`;

               	        if (mailVO.mlIptYn === 'Y') {
               	            str += `<span class="email-list-item-label badge badge-dot bg-primary d-none d-md-inline-block me-2" data-label="important"></span>`;
               	        }

               	        str += `<small class="email-list-item-time text-muted">\${mailVO.strMlSndngYmd}</small>
               	                    <ul class="list-inline email-list-item-actions text-nowrap">
               	                    
               	                        <li class="list-inline-item email-delete wastebasket" data-mlsn="\${mailVO.mlSn}">
               	                        	<i class="ti ti-trash ti-sm"></i></li>
               	                    </ul>
               	                </div>
               	            </div>
               	        </li>`;
               	    });
               	    loadBookmarks();
               	    $("#mailList").append(str);
               	}
       	 });
   	 }
        
        
        // 보낸 메일함 클릭
        $(document).on("click", "#senderBtn", function(){
        	mailScnt();
        	$(".mailS").remove();
        	$("#restore-icon").css("display", "none");
        	$(".mailS").css("display", "block");
        	$(".mailR").css("display", "none");
        	$(".wbSelectList").css("display", "none");
        	$(".tsMailList").css("display", "none");
        	$(".BM").css("display", "none");
        	$(".NR").css("display", "none");
        	
        	
        	gubun = $(this).attr("data-mail");
        	console.log("발신 메일함_gubun : ", gubun);
        	 console.log("발신 데이터 : ", gubun);
        	 $("#email-select-all").prop("checked", false);
        	 
        	 mailSList();
        	 
        });
        function mailRList(){
        	$(".mailR").remove();
        	
        	let data = {
        		"num" : num
        	}
        	
        	
	        $.ajax({
	    		url : "/mail/mailRList",
	     		contentType : "application/json;charset=utf-8",
	     		data : JSON.stringify(data),
	     		type : "post",
	     		dataType : "json",
	     		beforeSend: function(xhr) {
	                 xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	             },
	             success: function(result) {
	            	    console.log("mailRList_result : ", result);
	
	            	    let str = "";
	
	            	    result.forEach(function(mailVO, statIndex) {
	            	        mailVO.mailReceiverList.forEach(function(receiver) {
	            	            if (receiver.mlStts == 'M01') {
	            	                str += `<li data-inbox="true" id="mailR" class="email-list-item mailR" data-mlsn="\${mailVO.mlSn}" data-bs-toggle="sidebar" data-target="#app-email-view" data-mliptyn="\${mailVO.mlIptYn}">`;
	            	            } else if (receiver.mlStts == 'M02') {
	            	                str += `<li data-inbox="true" id="mailR" class="email-list-item email-marked-read mailR" data-mlsn="\${mailVO.mlSn}" data-bs-toggle="sidebar" data-target="#app-email-view" data-mliptyn="\${mailVO.mlIptYn}">`;
	            	            }
	            	        });
	
	            	        str += `<div class="d-flex align-items-center">
	            	                    <div class="form-check mb-0">
	            	                        <input class="email-list-item-input form-check-input Wcheckbox" type="checkbox" id="email-\${statIndex}" data-mlsn="\${mailVO.mlSn}">
	            	                        <label class="form-check-label" for="email-\${statIndex}"></label>
	            	                    </div>
	            	                    <i class="email-list-item-bookmark ti ti-star ti-sm d-sm-inline-block d-none cursor-pointer ms-2 me-3 bookmark" data-mlsn="\${mailVO.mlSn}"></i>`;
	
	            	        mailVO.mailSenderVOList.forEach(function(sender) {
	            	            str += `<img src="/view/\${sender.mlSndpty}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32">`;
	            	        });
	
	            	        str += `<div class="email-list-item-content ms-2 ms-sm-0 me-2 mail mailDetiles" data-mlsn="\${mailVO.mlSn}">`;
	
	            	        mailVO.mailSenderVOList.forEach(function(sender) {
	            	            str += `<span id="mailRempNm" class="h6 email-list-item-username me-2 me2">\${sender.empNm}</span>`;
	            	        });
	
	            	        str += `<span id="mailTtl" class="email-list-item-subject d-xl-inline-block d-block">\${mailVO.mlTtl}</span>
	            	                </div>
	            	                <div class="email-list-item-meta ms-auto d-flex align-items-center">`;
	
	            	        if (mailVO.mlIptYn == 'Y') {
	            	            str += `<span class="email-list-item-label badge badge-dot bg-primary d-none d-md-inline-block me-2" data-label="important"></span>`;
	            	        }
	
	            	        str += `<small class="email-list-item-time text-muted">\${mailVO.strMlSndngYmd}</small>
	            	                <ul class="list-inline email-list-item-actions text-nowrap">
	            	                    <li class="list-inline-item email-read ">
	            	                    	<i class="ti ti-mail ti-sm Read" data-mlsn="\${mailVO.mlSn}"></i></li>
	            	                    <li class="list-inline-item email-delete wastebasket" data-mlsn="\${mailVO.mlSn}"><i class="ti ti-trash ti-sm"></i></li>
	            	                </ul>
	            	            </div>
	            	        </div>
	            	        </li>`;
	            	    });
	
	            	    loadBookmarks();
	            	    $("#mailList").append(str);
	            	}
	    	 });
        }
        
        //받은 메일함 클릭
        $(document).on("click", "#receiverBtn", function(){
        	mailRcnt();
        	$(".mailR").remove();
        	$("#restore-icon").css("display", "none");
        	$(".mailS").css("display", "none");	
        	$(".wbSelectList").css("display", "none");		
        	$(".mailR").css("display", "block");	
        	$(".tsMailList").css("display", "none");
        	$(".BM").css("display", "none");
        	$(".NR").css("display", "none");	
        	
        	
        	console.log("mlSnList_Btn >> " , mlSnList);
        	gubun = $(this).attr("data-mail");
        	 console.log("수신 데이터_gubun : ", gubun);
        	 $("#email-select-all").prop("checked", false);
        	 
        	mailRList();
        	 
        });
        
        $(document).on("change", ".Wcheckbox", function() {
            console.log("mlsn : " + $(this).data("mlsn"));//기본키 데이터

            const mlsn = $(this).data("mlsn");//기본키 데이터

            if ($(this).is(":checked")) {
                // 체크된 경우 배열에 추가
                if (!mlSnList.includes(mlsn)) {
                    mlSnList.push(mlsn);
                }
            } else {
                // 체크 해제된 경우 배열에서 제거
                mlSnList = mlSnList.filter(item => item !== mlsn);
            }

            console.log("Wcheckbox mlsn >> ", mlSnList);
        });
        
        $(document).on("change", ".Scheckbox", function() {
            console.log("mlsn : " + $(this).data("mlsn"));//기본키 데이터

            const mlsn = $(this).data("mlsn");//기본키 데이터

            if ($(this).is(":checked")) {
                // 체크된 경우 배열에 추가
                if (!mlSnList.includes(mlsn)) {
                    mlSnList.push(mlsn);
                }
            } else {
                // 체크 해제된 경우 배열에서 제거
                mlSnList = mlSnList.filter(item => item !== mlsn);
            }

            console.log("Scheckbox mlsn >> ", mlSnList);
        });
        
        $(document).on("change", ".wbCheckbox", function() {
            console.log("mlsn : " + $(this).data("mlsn"));//기본키 데이터
            console.log("휴지통 >> gubun : " + $(this).data("gubun"));

            const mlsn = $(this).data("mlsn");
            const wbgubun = $(this).data("gubun")

            if ($(this).is(":checked")) {
                // 체크된 경우 배열에 추가
                if (!mlSnList.includes(mlsn)) {
                    mlSnList.push(mlsn);
                }
                gubunList.push(wbgubun);             
            } else {
                // 체크 해제된 경우 배열에서 제거
                mlSnList = mlSnList.filter(item => item !== mlsn);
                gubunList = gubunList.filter(item => item !== wbgubun);
            }
			console.log("wbCheckbox_gubunList >> ", gubunList);
            console.log("wbCheckbox_mlsnList >> ", mlSnList);
            console.log("gubun >> ", gubun);
            
        });
        
        $(document).on("change", ".TsCheckbox", function() {
            console.log("mlsn : " + $(this).data("mlsn"));//기본키 데이터

            const mlsn = $(this).data("mlsn");//기본키 데이터

            if ($(this).is(":checked")) {
                // 체크된 경우 배열에 추가
                if (!mlSnList.includes(mlsn)) {
                    mlSnList.push(mlsn);
                }
            } else {
                // 체크 해제된 경우 배열에서 제거
                mlSnList = mlSnList.filter(item => item !== mlsn);
            }

            console.log("Scheckbox mlsn >> ", mlSnList);
        });

        //전체선택
        $("#email-select-all").on("change", function() {
        	mlSnList = [];
        	
            var isChecked = $(this).is(":checked");
            
            //전체선택 대상을 구분
            console.log("gubun : " + gubun);
            
            if(gubun=="2"){//수신 데이터(받은 메일함에서 전체 선택)
	            $(".Wcheckbox").each(function() {
	                $(this).prop("checked", isChecked).trigger("change");
	            });
	            $(".Scheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
	            $(".wbCheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
	            $(".TsCheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            }else if(gubun=="1"){//발신 데이터(보낸 메일함에서 전체 선택)
            	 $(".Scheckbox").each(function() {
 	                $(this).prop("checked", isChecked).trigger("change");
 	            });
            	 $(".Wcheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            	 $(".wbCheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            	$(".TsCheckbox").each(function() {
  	                $(this).prop("checked", false).trigger("change");
  	            });
            }else if(gubun=="3"){
            	$(".wbCheckbox").each(function() {
 	                $(this).prop("checked", isChecked).trigger("change");
 	            });
            	$(".Wcheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            	$(".Scheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            	$(".TsCheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            }else if(gubun=="4"){
            	$(".TsCheckbox").each(function() {
 	                $(this).prop("checked", isChecked).trigger("change");
 	            });
            	$(".wbCheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            	$(".Wcheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            	$(".Scheckbox").each(function() {
 	                $(this).prop("checked", false).trigger("change");
 	            });
            }
        });


		// 메일 답장
       $("#Reply").on("click", function(event) {
		    event.preventDefault(); // 기본 동작 방지
		    console.log("Reply mlSn >> ", $(".mailR").data("mlsn"));
		    console.log("Reply_empId >> ", empId);
		    
		    let title = $("#Remail-title").val();
		    let message = $("#Rmessage").val();
		    
		    if (!title) { // 제목이 비어있거나 공백만 있는지 확인
	            Swal.fire({
	                title: '제목 미등록!',
	                text: '제목을 작성해주세요',
	                icon: 'warning',
	                customClass: {
	                    confirmButton: 'btn btn-primary'
	                },
	                buttonsStyling: false
	            });
	            return false; // 추가적인 페이지 이동 방지
	        }
		    
		    if ($("#RsendImportant").is(":checked")) {
		        $("#RsendImportant").val("Y");
		    } else {
		        $("#RsendImportant").val("N");
		    }
		    let important = $("#RsendImportant").val();
		    
		    console.log("Remail-title >> ", title);
		    console.log("Rmessage >> ", message);
		    console.log("RsendImportant >> ", important);
		    
		    let formData = new FormData();
		    
		    // 파일 추가
		    let fileList = f_ckFileList();
		    console.log("fileList", fileList);
		  	fileList.forEach(file => {
		      	formData.append("file", file);
		    });
		    
		    let mailVO = {
		        "mlTtl": title,
		        "mlCn": message,
		        "mlIptYn": important,
		        "empId": empId,
		        "mlStts": mlStts
		    };
		    
		    console.log("mailVO >> ", mailVO);
		    
		    formData.append("mailVO", new Blob([JSON.stringify(mailVO)], {type: "application/json"}));
		    
		    fetch("/mail/replyMailSend", {
		        method: "POST",
		        headers: {
		            "X-CSRF-TOKEN": "${_csrf.token}"
		        },
		        body: formData
		    }).then((resp) => {
		        resp.text().then((data) => {
		            console.log("mailVO >> ", data);
		            $(".item_file").remove();
		            $("#Remail-title").val("");
		            $('#emailComposeSidebar').find('form')[0].reset();
		            
		            $("#emailContacts").val(null).trigger('change');
		            
		            if (window.editor) {
		                window.editor.setData('');
		            }
		            
		            Swal.fire({
	            	    title: '완료!',
	            	    text: '메일이 전송되었습니다',
	            	    icon : 'success',
	            	    customClass: {
	            	      confirmButton: 'btn btn-primary'
	            	    },
	            	    buttonsStyling: false
	            	  });
		
		            // 파일 리스트 초기화
		            attachFileList = [];
		        });
		    }).catch((error) => {
		        console.log('Error:', error);
		    });
		    
		    return false; // 추가적인 페이지 이동 방지
		});
        

        $("#emailContacts").on("change", function() {
            empList = $(this).val();
            console.log("직원 : ", empList);
        });
        
        
			let TSaveText = "(임시저장)";
		    var $tsElement = $(".TS");	
		    
       	 $("#emailComposeSidebar").on("show.bs.modal", function(){
	        $tsElement.text($tsElement.text().replace(TSaveText, ""));
	    });
		    
		    
	        $("#Tsave").on("click", function(){
				if ($tsElement.text().includes(TSaveText)) {
			        // "(임시저장)"이 이미 존재하면 제거
			        $tsElement.text($tsElement.text().replace(TSaveText, ""));
			        mlStts = "M01";
			    } else {
			        // "(임시저장)"이 없으면 추가
			        $tsElement.append(TSaveText);
			        mlStts = "M00";
			    }
				console.log("Tsave_mlStts >> ", mlStts);
				
	        });
			
	        $("#Tsavets").on("click", function(){
				if ($tsElement.text().includes(TSaveText)) {
			        // "(임시저장)"이 이미 존재하면 제거
			        $tsElement.text($tsElement.text().replace(TSaveText, ""));
			        mlStts = "M01";
			    } else {
			        // "(임시저장)"이 없으면 추가
			        $tsElement.append(TSaveText);
			        mlStts = "M00";
			    }
				
				console.log("Tsavets_mlStts >> ", mlStts);
				
	        }); // 임시저장 end
        
        
 
        
        // 메일 보내기
        $("#SendS").on("click", function(event) {
		    let title = $("#email-title").val().trim();
		    let message = $("#message").val();
		    
		    event.preventDefault(); // 기본 동작 방지
	        if (!title) { // 제목이 비어있거나 공백만 있는지 확인
	            Swal.fire({
	                title: '제목 미등록!',
	                text: '제목을 작성해주세요',
	                icon: 'warning',
	                customClass: {
	                    confirmButton: 'btn btn-primary'
	                },
	                buttonsStyling: false
	            });
	            return false; // 추가적인 페이지 이동 방지
	        }
		    
		    if ($("#sendImportant").is(":checked")) {
		        $("#sendImportant").val("Y");
		    } else {
		        $("#sendImportant").val("N");
		    }
		    let important = $("#sendImportant").val();
		    
		    let formData = new FormData();
		    
		    // 파일 추가
		    let fileList = f_ckFileList();
		    console.log("fileList", fileList);
		    fileList.forEach(file => {
		        formData.append("file", file);
		    });
		    
		    let mailVO = {
		        "mlTtl": title,
		        "mlCn": message,
		        "mlIptYn": important,
		        "empList": empList,
		        "mlStts": mlStts
		    };
		    console.log("mailVO >>> ", mailVO);
		    
		    console.log("empList : ", empList);
		    console.log("title : ", title);
		    console.log("message : ", message);
		    console.log("important : ", important);
		    
		    formData.append("mailVO", new Blob([JSON.stringify(mailVO)], {type: "application/json"}));
		    
		    fetch("/mail/mailSend", {
		        method: "POST",
		        headers: {
		            "X-CSRF-TOKEN": "${_csrf.token}"
		        },
		        body: formData
		    }).then((resp) => {
		        resp.text().then((data) => {
		            console.log("mailVO >> ", data);
		            
		            $('#emailComposeSidebar').modal('hide');
		            
		            let mail = "mail";
		            
		            for(let i = 0 ; i < empList.length ; i ++){
		            	
			           	let socketMsg	=	{
			           			"title":mail,
			           			"senderId":loginId,
			           			"receiverId":empList[i],
			           			"mlTtl":title
			           	}
			           	
			           	socket.send(JSON.stringify(socketMsg));
		            }
		            	if(mlStts == "M01"){
			            	  Swal.fire({
			            	    title: '완료!',
			            	    text: '메일이 전송되었습니다',
			            	    icon: 'success',
			            	    customClass: {
			            	      confirmButton: 'btn btn-primary'
			            	    },
			            	    buttonsStyling: false
			            	  });
		            	}else{
		            		
		            		Swal.fire({
			            	    title: '완료!',
			            	    text: '임시저장 되었습니다',
			            	    icon: 'success',
			            	    customClass: {
			            	      confirmButton: 'btn btn-primary'
			            	    },
			            	    buttonsStyling: false
			            	  });
		            	}
		            	mlStts = "M01";	  
		           	 attachFileList = [];
		        });
		    }).catch((error) => {
		        console.log('Error:', error);
		    });
		});

		
        // 보낸 메일함 상세정보
        $(document).on("click", ".mailSDetiles", function() {
        	$("#app-email-view").removeClass("col app-email-view flex-grow-0 bg-body").addClass("col app-email-view flex-grow-0 bg-body show");
        	$("#gubunReply").css("display", "none");
        	$("#mlCn").empty();
        	$("#empNmRest").empty();
            let mlSn = $(this).data("mlsn");
            console.log("mlSn : " + mlSn);

            let data = {
                "mlSn": mlSn
            }

            $.ajax({
                url: "/mail/mailSDetail",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result >> ", result);
                    console.log("result_empNm >> ", result.mailSenderVOList[0].empNm);
                    $("#empNmRest").empty();
                    
                    let empNms = result.mailSenderVOList.map(sender => sender.empNm);
                    let empMails = result.mailReceiverList.map(receiver => receiver.empMail);
                    console.log("empNms >> ", empNms);
                    
                    let empNmRest = "";

                    // Check the number of senders
                    if (empNms.length > 1) {
                        $("#empNm").text(empNms[0] + " 외 " + (empNms.length - 1) + "명");

                        for (let i = 1; i < empNms.length; i++) {
                        	empNmRest += `<a class="dropdown-item" href="javascript:void(0)">\${empNms[i]}  |  \${empMails[i]}</a>`;
                        }
                         $("#empNmRest").append(empNmRest);
                    } else {
                        $("#empNm").text(empNms[0]);
                    }
                    
                    $("#empMail").text(result.mailReceiverList[0].empMail);
                    $("#mlCn").append(result.mlCn);
                    $("#mlTtl").text(result.mlTtl);
                    $("#strMlSndngYmd").text(result.strMlSndngYmd);
                    $("#empAtchfileSn").attr("src", "/view/"+result.mailReceiverList[0].mlRcvr);
                    $("#wastebasket").attr("data-mlsn", result.mlSn);

                }
            });
            
        	// 다운로드 할 파일
            $.ajax({
            	url : "/mail/download",
        		contentType: "application/json;charset=utf-8",
                data: mlSn,
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result >> ", result);
                    
                    $("#downloadfile").html("");
                    
                    let str = "";
                    result.forEach(function(file) {
                    	str += `<a  href="/download/\${file.atchfileSn}/\${file.atchfileDetailSn}">\${file.atchfileDetailLgclfl}</a><br>`
                        
                    });
                    $("#downloadfile").html(str);
                	
                }
            });
        });
        
        
        // 휴지통 메일 상세정보
        $(document).on("click", ".wbDetail", function(){
        	$("#app-email-view").removeClass("col app-email-view flex-grow-0 bg-body").addClass("col app-email-view flex-grow-0 bg-body show");
        	let mlSn = $(this).data("mlsn");
        	console.log("wbDetail_mlSn >> ", mlSn);
        	$("#mlCn").empty();
        	
        	let data = {
        		"mlSn" : mlSn
        	}
        	
        	$.ajax({
        		url : "/mail/wbDetail",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		dataType : "json",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("wbDetail_result >> ", result);
        			
// 					$("#empNmRest").empty();
                    
//                     let empNms = result.mailSenderVOList.map(sender => sender.empNm);
//                     console.log("empNms >> ", empNms);
                    
//                     let empNmRest = "";

//                     // Check the number of senders
//                     if (empNms.length > 1) {
//                         $("#empNm").text(empNms[0] + " 외 " + (empNms.length - 1) + "명");

//                         for (let i = 1; i < empNms.length; i++) {
//                         	empNmRest += `<a class="dropdown-item" href="javascript:void(0)">\${empNms[i]}</a>`;
//                         }
//                          $("#empNmRest").append(empNmRest);
//                     } else {
//                         $("#empNm").text(empNms[0]);
//                     }
        			
        			$("#empNm").text(result.mailSenderVOList[0].empNm);
                    $("#empMail").text(result.mailReceiverList[0].empMail);
                    $("#mlCn").append(result.mlCn);
                    $("#mlTtl").text(result.mlTtl);
                    $("#strMlSndngYmd").text(result.strMlSndngYmd);
                    $("#empAtchfileSn").attr("src", "/view/"+result.empId);
        		}
        	});
        	
        	// 다운로드 할 파일
            $.ajax({
            	url : "/mail/download",
        		contentType: "application/json;charset=utf-8",
                data: mlSn,
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result >> ", result);
                    
                    $("#downloadfile").html("");
                    
                    let str = "";
                    result.forEach(function(file) {
                    	str += `<a  href="/download/\${file.atchfileSn}/\${file.atchfileDetailSn}">\${file.atchfileDetailLgclfl}</a><br>`
                        
                    });
                    $("#downloadfile").html(str);
                	
                }
            });
        });
        
        
        let mlSn = "";
		// 받은 메일 상세정보
        $(document).on("click", ".mailDetiles", function() {
        	$("#app-email-view").removeClass("col app-email-view flex-grow-0 bg-body").addClass("col app-email-view flex-grow-0 bg-body show");
        	$("#gubunReply").css("display", "block");
        	$("#mlCn").empty();
            mlSn = $(this).data("mlsn");
            console.log("mlSn : " + mlSn);

            let data = {
                "mlSn": mlSn
            }
            let parentLi = $(this).closest('li.mailR');
            
         	// 읽음 상태로 변경
            if (!$(parentLi).hasClass('email-marked-read')) {
                $(parentLi).addClass('email-marked-read');
                updateUnreadMailCount(-1);
            }

            $.ajax({
                url: "/mail/mailDetail",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result >> ", result);
                    console.log("result_empNm >> ", result.mailSenderVOList[0].empNm);
                    console.log("result_mlSndpty >> ", result.mailSenderVOList[0].mlSndpty);
                    empId = result.mailSenderVOList[0].mlSndpty;


                    $("#empNm").text(result.mailSenderVOList[0].empNm);
                    $("#empMail").text(result.mailReceiverList[0].empMail);
                    $("#mlCn").append(result.mlCn);
                    $("#mlTtl").text(result.mlTtl);
                    $("#strMlSndngYmd").text(result.strMlSndngYmd);
                    $("#empAtchfileSn").attr("src", "/view/"+result.mailSenderVOList[0].mlSndpty);
                    $("#detailBM").attr("data-mlsn", result.mlSn);
                    
                    
                }
            });
            
            // 다운로드 할 파일
            $.ajax({
            	url : "/mail/download",
        		contentType: "application/json;charset=utf-8",
                data: mlSn,
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result >> ", result);
                    
                    $("#downloadfile").html("");
                    
                    let str = "";
                    result.forEach(function(file) {
                    	str += `<a  href="/download/\${file.atchfileSn}/\${file.atchfileDetailSn}">\${file.atchfileDetailLgclfl}</a><br>`
                        
                    });
                    $("#downloadfile").html(str);
                	
                }
            });
            
            $.ajax({
            	url: "/mail/mlSttsUpdate",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                	console.log("result >> ", result);
                }
            });
            
        });
		
		
		
		
		// 읽지않은 메일 상세정보
		$(document).on("click", ".nrMailDetail", function(){
			$("#app-email-view").removeClass("col app-email-view flex-grow-0 bg-body").addClass("col app-email-view flex-grow-0 bg-body show");
			$("#gubunReply").css("display", "block");
			$("#mlCn").empty();
            let mlSn = $(this).data("mlsn");
            $(".NR[data-mlsn='" + mlSn + "']").remove();
            console.log("mlSn : " + mlSn);

            let data = {
                "mlSn": mlSn
            }
			let parentLi = $(this).closest('li.NR');
            
         	// 읽음 상태로 변경
            if (!$(parentLi).hasClass('email-marked-read')) {
                $(parentLi).addClass('email-marked-read');
                updateUnreadMailCount(-1);
            }
            
			
			$.ajax({
				url: "/mail/mailDetail",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                	console.log("nrMailDetail_result >> ", result);
                	
                	$("#empNm").text(result.mailSenderVOList[0].empNm);
                    $("#empMail").text(result.mailReceiverList[0].empMail);
                    $("#mlCn").append(result.mlCn);
                    $("#mlTtl").text(result.mlTtl);
                    $("#strMlSndngYmd").text(result.strMlSndngYmd);
                    $("#empAtchfileSn").attr("src", "/view/"+result.mailSenderVOList[0].mlSndpty);
                	
                }
                
			});
            
            
            // 다운로드 할 파일
            $.ajax({
            	url : "/mail/download",
        		contentType: "application/json;charset=utf-8",
                data: mlSn,
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result >> ", result);
                    
                    $("#downloadfile").html("");
                    
                    let str = "";
                    result.forEach(function(file) {
                    	str += `<a  href="/download/\${file.atchfileSn}/\${file.atchfileDetailSn}">\${file.atchfileDetailLgclfl}</a><br>`
                        
                    });
                    $("#downloadfile").html(str);
                	
                }
            });
            
            $.ajax({
            	url: "/mail/mlSttsUpdate",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                	console.log("mlSttsUpdate_result >> ", result);
                	nrMailcnt();
                	
                }
            });
			
			
			
		});
		
		
        
        $(document).on("click", "#restore-icon", function() {
        	console.log("gubun : " + gubun);
        	console.log("mlSnList : ", mlSnList);
        	
        	let data = {
        		"mlSnList" : mlSnList
        	}
        	
        	$.ajax({
        		url : "/mail/restore",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },        
        		success : function(result){
        			console.log("result : ", result);
        			
        			mlSnList.forEach(function(mlsn) {
                        $(".wbSelectList[data-mlsn='" + mlsn + "']").remove();
                        mlSnList = [];
                        wbMailcnt();
                    });
        		}
        		
        	}); // restore ajax end
        	
        });
        
        // 읽지않은 메일 수
        $.ajax({
        	url : "/mail/receiverCnt",
    		contentType : "application/json;charset=utf-8",
    		type : "post",
    		dataType : "text",
    		beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
    		success : function(result){
    			console.log("안읽은 메일 수 : ", result);
    			
    			$("#receiverCnt").html(result);
    		}
        });
        
        
        let showOnlyImportant = false;
		$("#importantLabel").on("click", function(){
		    showOnlyImportant = !showOnlyImportant; // 토글 상태 변경
		
		    $(".email-list-item").hide(); // 모든 이메일 항목 숨기기
		
		    if (showOnlyImportant) {
		        if (gubun === "2") {
		            $(".mailR").each(function() {
		                let mliptyn = $(this).data("mliptyn");
		                if (mliptyn === 'Y') {
		                    $(this).show();
		                }
		            });
		        } else if (gubun === "1") {
		            $(".mailS").each(function() {
		                let mliptyn = $(this).data("mliptyn");
		                if (mliptyn === 'Y') {
		                    $(this).show();
		                }
		            });
		        } else if (gubun === "4") {
		            $(".tsMailList").each(function() {
		                let mliptyn = $(this).data("mliptyn");
		                if (mliptyn === 'Y') {
		                    $(this).show();
		                }
		            });
		        } else if (gubun === "3") {
		            $(".wbSelectList").each(function() {
		                let mliptyn = $(this).data("mliptyn");
		                if (mliptyn === 'Y') {
		                    $(this).show();
		                }
		            });
		        } else if (gubun === "5") {
		            $(".NR").each(function() {
		                let mliptyn = $(this).data("mliptyn");
		                if (mliptyn === 'Y') {
		                    $(this).show();
		                }
		            });
		        }
		    } else {
		        if (gubun === "2") {
		            $(".mailR").show();
		        } else if (gubun === "1") {
		            $(".mailS").show();
		        } else if (gubun === "4") {
		            $(".tsMailList").show();
		        } else if (gubun === "3") {
		            $(".wbSelectList").show();
		        } else if (gubun === "5") {
		            $(".NR").show();
		        }
		    }
		});
        
        
        $(document).on("click", ".toggle-senders", function() {
        	 let $icon = $(this).find('i');
        	    $icon.toggleClass("ti-chevron-down ti-chevron-up");

        	    // Toggle dropdown menu visibility
        	    let $dropdownMenu = $(this).siblings(".dropdown-menu");
        	    if ($dropdownMenu.is(":visible")) {
        	        $dropdownMenu.dropdown('hide');
        	    } else {
        	        $dropdownMenu.dropdown('show');
        	    }
        });
        
        // 메일 쓰기 버튼 클릭
		$(document).on("click", "#emailComposeSidebarLabel", function(){
			$("#mailSendDiv").css("display", "block");
        	$("#tsSendDiv").css("display", "none");
			$(".item_file").remove();
			$('#emailComposeSidebar').find('form')[0].reset();
	        
			$("#emailContacts").val(null).trigger('change');
	        
			if (window.editor2) {
       			 window.editor2.setData('');
    		}

	        // 파일 리스트 초기화
			$("#attach-file").val("");
	        $("#areaImg").html("");
		});
        
        
		function nrMailList(){
    		$(".NR").remove();
    		
    		let data = {
    			"num" : num
    		}
    		
    		$.ajax({
        		url : "/mail/nrMailList",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		dataType : "json",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
            	    console.log("mailRList_result : ", result);

            	    let str = "";

            	    result.forEach(function(mailVO, statIndex) {
            	        mailVO.mailReceiverList.forEach(function(receiver) {
            	            if (receiver.mlStts == 'M01') {
            	                str += `<li data-nrmail="true" id="NR" class="email-list-item NR" data-mlsn="\${mailVO.mlSn}" data-bs-toggle="sidebar" data-target="#app-email-view" data-mliptyn="\${mailVO.mlIptYn}">`;
            	            } else if (receiver.mlStts == 'M02') {
            	                str += `<li data-nrmail="true" id="NR" class="email-list-item email-marked-read NR" data-mlsn="\${mailVO.mlSn}" data-bs-toggle="sidebar" data-target="#app-email-view"  data-mliptyn="\${mailVO.mlIptYn}">`;
            	            }
            	        });

            	        str += `<div class="d-flex align-items-center">
            	                    <div class="form-check mb-0">
            	                        <input class="email-list-item-input form-check-input nrCheckbox" type="checkbox" id="email-\${statIndex}" data-mlsn="\${mailVO.mlSn}">
            	                        <label class="form-check-label" for="email-\${statIndex}"></label>
            	                    </div>
            	                    <i class="email-list-item-bookmark ti ti-star ti-sm d-sm-inline-block d-none cursor-pointer ms-2 me-3 bookmark" data-mlsn="\${mailVO.mlSn}"></i>`;

            	        mailVO.mailSenderVOList.forEach(function(sender) {
            	            str += `<img src="/view/\${sender.mlSndpty}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32">`;
            	        });

            	        str += `<div class="email-list-item-content ms-2 ms-sm-0 me-2 mail nrMailDetail" data-mlsn="\${mailVO.mlSn}">`;

            	        mailVO.mailSenderVOList.forEach(function(sender) {
            	            str += `<span id="mailRempNm" class="h6 email-list-item-username me-2 me2">\${sender.empNm}</span>`;
            	        });

            	        str += `<span id="mailTtl" class="email-list-item-subject d-xl-inline-block d-block">\${mailVO.mlTtl}</span>
            	                </div>
            	                <div class="email-list-item-meta ms-auto d-flex align-items-center">`;

            	        if (mailVO.mlIptYn == 'Y') {
            	            str += `<span class="email-list-item-label badge badge-dot bg-primary d-none d-md-inline-block me-2" data-label="important"></span>`;
            	        }

            	        str += `<small class="email-list-item-time text-muted">\${mailVO.strMlSndngYmd}</small>
            	                <ul class="list-inline email-list-item-actions text-nowrap">
            	                    <li class="list-inline-item email-delete wastebasket" data-mlsn="\${mailVO.mlSn}">
            	                    	<i class="ti ti-trash ti-sm"></i></li>
            	                </ul>
            	            </div>
            	        </div>
            	        </li>`;
            	    });

            	    loadBookmarks();
            	    $("#mailList").append(str);
            	}
        	});
    	}
        
        
        // 읽지않은 메일함 클릭
        $(document).on("click", "#nrBtn", function(){
        	nrMailcnt();
        	$(".NR").remove();
        	$(".NR").css("display", "block");	
        	$("#restore-icon").css("display", "none");
        	$(".mailS").css("display", "none");	
        	$(".wbSelectList").css("display", "none");		
        	$(".mailR").css("display", "none");	
        	$(".tsMailList").css("display", "none");
        	$(".BM").css("display", "none");
        	
        	gubun = $(this).attr("data-mail");
        	console.log("읽지않은 메일함_gubun : ", gubun);
        	
        	nrMailList();
        });
        
        
        let showBookmarks = false;
        $(document).on("click", "#bmList", function() {
        	showBookmarks = !showBookmarks; 
        	
        	$(".email-list-item").hide(); // 모든 이메일 항목 숨기기
		
			if(showBookmarks){
	            if (gubun === "2") {
	                $(".mailR .bookmark.active").closest(".email-list-item").show();
	            } else if (gubun === "1") {
	                $(".mailS .bookmark.active").closest(".email-list-item").show();
	            } else if (gubun === "4") {
	                $(".tsMailList .bookmark.active").closest(".email-list-item").show();
	            } else if (gubun === "3") {
	                $(".wbSelectList .bookmark.active").closest(".email-list-item").show();
	            } else if (gubun === "5") {
	                $(".NR .bookmark.active").closest(".email-list-item").show();
	            }
			}else{
				if (gubun === "2") {
	                $(".mailR .bookmark").closest(".email-list-item").show();
	            } else if (gubun === "1") {
	                $(".mailS .bookmark").closest(".email-list-item").show();
	            } else if (gubun === "4") {
	                $(".tsMailList .bookmark").closest(".email-list-item").show();
	            } else if (gubun === "3") {
	                $(".wbSelectList .bookmark").closest(".email-list-item").show();
	            } else if (gubun === "5") {
	                $(".NR .bookmark").closest(".email-list-item").show();
	            }
			}

        })
        
        
        $(document).on("click", ".Read", function(){
        	$(this).toggleClass("ti ti-mail-opened ti-sm ti ti-mail ti-sm");
        	
        	console.log("mlSn >> ", $(this).data("mlsn"));
        	
        	
        });
        
        // 읽지않음으로 변경
        $("#unread").on("click", function(){
        	
        	let data = {
        		"mlSn" : mlSn
        	}
        	
        	$.ajax({
        		url : "/mail/unreadMail",
        		contentType : "application/json;charset=utf-8",
        		data : JSON.stringify(data),
        		type : "post",
        		dataType : "text",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("unreadMail_result : ", result);
        			updateUnreadMailCount(+1);
        			
        			let parentLi = $(this).closest('li.mailR');

        			let mailR = $(".mailR[data-mlsn='" + mlSn + "']");
                 	// 읽음 상태로 변경
                    if ($(mailR).hasClass('email-marked-read')) {
                        $(mailR).removeClass('email-marked-read');
                    }
        			
        		}
        		
        	});
        	
        });
        
        $("#addStar").on("click", function(){
        	alert("즐겨찾기 추가할 mlsn >> "+ mlSn);
        	
        	
        });
        
        $("#refreshify").on("click", function(){
//         	alert("새로고침 구분 >> ", gubun);
        	console.log("gubun >>>>>", gubun);
        	
        	if(gubun == "4"){
        		tsmailList();
        		tsMailcnt();
        	}else if(gubun == "3"){
        		wbMailList();
        		wbMailcnt();;
        	}else if(gubun == "2"){
        		mailRList();
        		mailRcnt();
        	}else if(gubun == "1"){
        		mailSList();
        		mailScnt();
        	}else{
        		nrMailList();
        		nrMailcnt();;
        	}
        	
        });
        
        
        $("#newest").on("click", function(){
        	num = $(this).data("num");
        	console.log("num >> ", num);
        	if(gubun == "4"){
        		tsmailList();
        	}else if(gubun == "3"){
        		wbMailList();
        	}else if(gubun == "2"){
        		mailRList();
        	}else if(gubun == "1"){
        		mailSList();
        	}else{
        		nrMailList();
        	}
        	
        });
        
        $("#old").on("click", function(){
        	num = $(this).data("num");
        	console.log("num >> ", num);
        	if(gubun == "4"){
        		tsmailList();
        	}else if(gubun == "3"){
        		wbMailList();
        	}else if(gubun == "2"){
        		mailRList();
        	}else if(gubun == "1"){
        		mailSList();
        	}else{
        		nrMailList();
        	}
        });
        
        // 받은 메일 수
        function mailRcnt(){
        	$.ajax({
        		url : "/mail/mailRcnt",
        		contentType : "application/json;charset=utf-8",
        		type : "post",
        		dataType : "text",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("mailRcnt_result >> ", result);
        			$("#count").html("총  " + result+"건");
        		}
        	});
        }
        
        // 보낸 메일 수
        function mailScnt(){
        	$.ajax({
        		url : "/mail/mailScnt",
        		contentType : "application/json;charset=utf-8",
        		type : "post",
        		dataType : "text",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("mailScnt_result >> ", result);
        			$("#count").html("총  " + result+"건");
        		}
        	});
        }
        
        // 임시저장 메일 수
        function tsMailcnt(){
        	$.ajax({
        		url : "/mail/tsMailcnt",
        		contentType : "application/json;charset=utf-8",
        		type : "post",
        		dataType : "text",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("tsMailcnt_result >> ", result);
        			$("#count").html("총  " + result+"건");
        		}
        	});
        }
        
        // 읽지않은 메일 수
        function nrMailcnt(){
        	$.ajax({
        		url : "/mail/nrMailcnt",
        		contentType : "application/json;charset=utf-8",
        		type : "post",
        		dataType : "text",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("nrMailcnt_result >> ", result);
        			$("#count").html("총  " + result+"건");
        		}
        	});
        }
        
        // 휴지통 메일 수
        function wbMailcnt(){
        	$.ajax({
        		url : "/mail/wbMailcnt",
        		contentType : "application/json;charset=utf-8",
        		type : "post",
        		dataType : "text",
        		beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
        		success : function(result){
        			console.log("wbMailcnt_result >> ", result);
        			$("#count").html("총  " + result+"건");
        		}
        	});
        }
        
        
        
       
    }); // onload fnc end 
    
    function updateUnreadMailCount(change) {
        let currentCount = parseInt($("#receiverCnt").text());
        let newCount = currentCount + change;
        
        if(newCount <= 0){
        	$("#receiverCnt").text(0);
        }else{
        	$("#receiverCnt").text(newCount);
        }
    }
</script>



<div class="app-email card">
    <div class="row g-0">
        <!-- Email Sidebar -->
        <div class="col app-email-sidebar border-end flex-grow-0" id="app-email-sidebar">
            <div class="btn-compost-wrapper d-grid">
                <button class="btn btn-primary btn-compose waves-effect waves-light" data-bs-toggle="modal" data-bs-target="#emailComposeSidebar" id="emailComposeSidebarLabel">메일 쓰기</button>
            </div>
            <!-- Email Filters -->
            <div class="email-filters py-2 ps">
                <!-- Email Filters: Folder -->
                <ul class="email-filter-folders list-unstyled mb-4">
                    <li id="receiverBtn" data-mail="2" class="active d-flex justify-content-between" data-target="inbox">
                        <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
                            <i class="ti ti-mail ti-sm"></i>
                            <span class="align-middle ms-2">받은 메일함</span>
                        </a>
                        <div id="receiverCnt" class="badge bg-label-primary rounded-pill badge-center"></div>
                    </li>
                    <li id="senderBtn" data-mail="1" class="d-flex" data-target="sent">
                        <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
                            <i class="ti ti-send ti-sm"></i>
                            <span class="align-middle ms-2">보낸 메일함</span></a></li>

                    <li id="tsBtn" data-mail="4" class="d-flex" data-target="draft"><a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
                    	<i class="ti ti-file ti-sm"></i>
                    		<span class="align-middle ms-2">임시저장 메일함</span>
                        </a></li>
<!--                     <li class="d-flex justify-content-between" data-target="starred"> -->
<!--                         <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center"> -->
<!--                         	<i class="ti ti-star ti-sm"></i> -->
<!--                         		<span id="bmBtn" class="align-middle ms-2">즐겨찾기</span> -->
<!--                         </a> -->
<!--                         <div class="badge bg-label-warning rounded-pill badge-center"></div> 10  -->
<!--                     </li> -->
                    <li id="nrBtn" data-mail="5" class="d-flex align-items-center" data-target="nrmail"><a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
                    	<i class="ti ti-mail ti-sm"></i>
                    		<span class="align-middle ms-2">읽지않은 메일함</span>
                        </a></li>
                    <li id="wbBtn" data-mail="3" class="d-flex align-items-center" data-target="trash"><a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
                    	<i class="ti ti-trash ti-sm"></i>
                    		<span class="align-middle ms-2">휴지통</span>
                        </a></li>
                </ul>
                <!-- Email Filters: Labels -->
                <div class="email-filter-labels">
                    <small class="fw-normal text-uppercase text-muted m-4">Label</small>
                    <ul class="list-unstyled mb-0 mt-2">
<!--                         <li data-target="work"><a href="javascript:void(0);"> <span class="badge badge-dot bg-success"></span> <span class="align-middle ms-2">Work</span> -->
<!--                             </a></li> -->
                        <li data-target="Important"><a href="javascript:void(0);">
                                <span class="badge badge-dot bg-primary"></span> <span class="align-middle ms-2">중요 메일</span>
                            </a></li>
<!--                         <li data-target="important"><a href="javascript:void(0);"> -->
<!--                                 <span class="badge badge-dot bg-info"></span> <span class="align-middle ms-2">Important</span> -->
<!--                             </a></li> -->
<!--                         <li data-target="private"><a href="javascript:void(0);"> -->
<!--                                 <span class="badge badge-dot bg-danger"></span> <span class="align-middle ms-2">Private</span> -->
<!--                             </a></li> -->
                    </ul>
                </div>
                <!--/ Email Filters -->
                <div class="ps__rail-x" style="left: 0px; bottom: 0px;">
                    <div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div>
                </div>
                <div class="ps__rail-y" style="top: 0px; right: 0px;">
                    <div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 0px;"></div>
                </div>
            </div>
        </div>
        <!--/ Email Sidebar -->

        <!-- Emails List -->
        <div class="col app-emails-list">
    <div class="shadow-none border-0">
        <div class="emails-list-header p-3 py-lg-3 py-2">
            <!-- Email List: Search -->
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center w-100">
                    <i class="ti ti-menu-2 ti-sm cursor-pointer d-block d-lg-none me-3" data-bs-toggle="sidebar" data-target="#app-email-sidebar" data-overlay=""></i>
                    <div class="mb-0 mb-lg-2 w-100">
                        <div class="input-group input-group-merge shadow-none">
                            <span class="input-group-text border-0 ps-0" id="email-search">
                                <i class="ti ti-search"></i>
                            </span>
                            <input type="text" class="form-control email-search-input border-0" placeholder="Search mail" aria-label="Search mail" aria-describedby="email-search">
                        </div>
                    </div>
                </div>
                <div class="d-flex align-items-center mb-0 mb-md-2">
                    <i id="refreshify" class="ti ti-rotate-clockwise ti-sm rotate-180 scaleX-n1-rtl cursor-pointer email-refresh me-2"></i>
                </div>
            </div>
            <hr class="mx-n3 emails-list-header-hr">
            <!-- Email List: Actions -->
            <div class="d-flex justify-content-between align-items-center">
                <div id="icon" class="d-flex align-items-center">
				    <div class="form-check mb-0 me-2">
				        <input class="form-check-input" type="checkbox" id="email-select-all">
				        <label class="form-check-label" for="email-select-all"></label>
				    </div>
				    <i id="wastebasket" class="ti ti-trash ti-sm email-list-delete cursor-pointer me-2 wastebasket"></i>
				   
				    <div class="dropdown me-2">
				        <button class="btn p-0" type="button" id="dropdownLabelOne" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				            <i class="ti ti-tag ti-sm"></i>
				        </button>
				        <div class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownLabelOne">
				            <a id="importantLabel" class="dropdown-item" href="javascript:void(0)" style="text-align: left;">
				                <i class="badge badge-dot bg-primary me-1"></i>
				                <span class="align-middle">중요 메일</span><br>
				            </a>
				            <a id="bmList" class="dropdown-item" href="javascript:void(0)" style="text-align: left;">
				                <i style="color : #ff9f43;" class="email-list-item-bookmark ti ti-star me-1"></i>
				                <span class="align-middle">즐겨찾기</span>
				            </a>
				        </div>
				    </div>
				    
				    <span style="display: none;" id="restore-icon" class="me-2"><i class="fas fa-undo-alt"></i></span>
				</div>
				
				
                <div class="email-pagination d-sm-flex d-none align-items-center flex-wrap justify-content-between justify-sm-content-end" style="margin-left: 850px;">
                    <span id="count" class="d-sm-block d-none mx-3 text-muted"></span>
<!--                     <i class="email-prev ti ti-chevron-left ti-sm scaleX-n1-rtl cursor-pointer text-muted me-2"></i> -->
<!--                     <i class="email-next ti ti-chevron-right ti-sm scaleX-n1-rtl cursor-pointer"></i> -->
                </div>
				
					
				 <div class="dropdown ms-3">
                           <button class="btn p-0" type="button" id="dropdownMoreOptions" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                               <i class="ti ti-dots-vertical ti-sm"></i>
                           </button>
                           <div class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMoreOptions">
                               
                               <a id="newest" data-num="newest" class="dropdown-item" href="javascript:void(0)">
                              		<span class="align-middle">최신 순</span> 
                              	</a>
                              	
                               <a id="old" data-num="old" class="dropdown-item" href="javascript:void(0)">
                               	<span class="align-middle">오래된 순</span>
                               </a>
                               
                               <a class="dropdown-item d-sm-none d-block" href="javascript:void(0)"> <i class="ti ti-printer ti-xs me-1"></i> <span class="align-middle">Print</span>
                               </a>
                           </div>
                    </div>
            </div>
        </div>
        <hr class="container-m-nx m-0">
        <!-- Email List: Items -->
        <div class="email-list pt-0 ps ps--active-y">
            <ul id="mailList" class="list-unstyled m-0">
                <!-- 받은 메일함 목록_mailDetiles -->
<%--                 <c:forEach var="mailVO" items="${mailList}" varStatus="stat"> --%>
<%--                     <c:forEach var="receiver" items="${mailVO.mailReceiverList}"> --%>
<%--                         <c:if test="${receiver.mlStts == 'M01'}"> --%>
<%--                             <li data-inbox="true" id="mailDetiles" class="email-list-item mailR" data-mlsn="${mailVO.mlSn}" data-bs-toggle="sidebar" data-target="#app-email-view" data-mliptyn="${mailVO.mlIptYn}"> --%>
<%--                         </c:if> --%>
<%--                         <c:if test="${receiver.mlStts == 'M02'}"> --%>
<%--                             <li data-inbox="true" id="mailDetiles" class="email-list-item email-marked-read mailR" data-mlsn="${mailVO.mlSn}" data-bs-toggle="sidebar" data-target="#app-email-view" data-mliptyn="${mailVO.mlIptYn}"> --%>
<%--                         </c:if> --%>
<%--                     </c:forEach> --%>
<!--                     <div class="d-flex align-items-center"> -->
<!--                         <div class="form-check mb-0"> -->
<%--                             <input class="email-list-item-input form-check-input Wcheckbox" type="checkbox" id="email-${stat.index}" data-mlsn="${mailVO.mlSn}"> --%>
<%--                             <label class="form-check-label" for="email-${stat.index}"></label> --%>
<!--                         </div> -->
<%--                         <i class="email-list-item-bookmark ti ti-star ti-sm d-sm-inline-block d-none cursor-pointer ms-2 me-3 bookmark" data-mlsn="${mailVO.mlSn}"></i> --%>
<%--                         <c:forEach var="sender" items="${mailVO.mailSenderVOList}"> --%>
<%--                             <img src="/view/${sender.mlSndpty}" alt="user-avatar" class="d-block flex-shrink-0 rounded-circle me-sm-3 me-2" height="32" width="32"> --%>
<%--                         </c:forEach> --%>
<!--                         <div class="email-list-item-content ms-2 ms-sm-0 me-2"> -->
<%--                             <c:forEach var="sender" items="${mailVO.mailSenderVOList}"> --%>
<%--                                 <span id="mailRempNm" class="h6 email-list-item-username me-2 me2">${sender.empNm}</span> --%>
<%--                             </c:forEach> --%>
<%--                             <span id="mailTtl" class="email-list-item-subject d-xl-inline-block d-block">${mailVO.mlTtl}</span> --%>
<!--                         </div> -->
<!--                         <div class="email-list-item-meta ms-auto d-flex align-items-center"> -->
<%--                             <c:if test="${mailVO.mlIptYn == 'Y'}"> --%>
<!--                                 <span class="email-list-item-label badge badge-dot bg-primary d-none d-md-inline-block me-2" data-label="important"></span> -->
<%--                             </c:if> --%>
<%--                             <small class="email-list-item-time text-muted">${mailVO.strMlSndngYmd}</small> --%>
<!--                             <ul class="list-inline email-list-item-actions text-nowrap"> -->
<!--                                 <li class="list-inline-item email-read"><i class="ti ti-mail-opened ti-sm"></i></li> -->
<%--                                 <li class="list-inline-item email-delete wastebasket" data-mlsn="${mailVO.mlSn}"><i class="ti ti-trash ti-sm"></i></li> --%>
<!--                             </ul> -->
<!--                         </div> -->
<!--                     </div> -->
<!--                     </li> -->
<%--                 </c:forEach> --%>
                
                
                
                <li class="email-list-empty text-center d-none">No items found.</li>
            </ul>
            <div class="ps__rail-x" style="left: 0px; bottom: 0px;">
                <div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div>
            </div>
            <div class="ps__rail-y" style="top: 0px; height: 644px; right: 0px;">
                <div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 567px;"></div>
            </div>
            <div class="ps__rail-x" style="left: 0px; bottom: 0px;">
                <div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div>
            </div>
            <div class="ps__rail-y" style="top: 0px; height: 644px; right: 0px;">
                <div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 567px;"></div>
            </div>
        </div>
    </div>
</div>

            <div class="app-overlay"></div>
        </div>
        <!-- /Emails List -->

        <!-- Email View -->
        <div class="col app-email-view flex-grow-0 bg-body" id="app-email-view">
            <div class="card shadow-none border-0 rounded-0 app-email-view-header p-3 py-md-3 py-2">
                <!-- Email View : Title  bar-->
                <div class="d-flex justify-content-between align-items-center py-2">
                    <div class="d-flex align-items-center overflow-hidden">
                        <i class="ti ti-chevron-left ti-sm cursor-pointer me-2" data-bs-toggle="sidebar" data-target="#app-email-view"></i>
                        <h6 style="display : none;" class="text-truncate mb-0 me-2">Focused impactful open
                            issues</h6>
                        <span style="display : none;" class="badge bg-label-danger rounded-pill">Private</span>
                    </div>
                    <!-- Email View : Action  bar-->
                    <div class="d-flex align-items-center">
<!--                         <i class="ti ti-printer ti-sm mt-1 cursor-pointer d-sm-block d-none"></i> -->
                        <div class="dropdown ms-3">
                            <button class="btn p-0" type="button" id="dropdownMoreOptions" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="ti ti-dots-vertical ti-sm"></i>
                            </button>
                            <div class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMoreOptions">
                                
                                <a id="unread" data-mlsn="" class="dropdown-item" href="javascript:void(0)">
                                	<i class="ti ti-mail ti-xs me-1"></i>
                               		<span class="align-middle">읽지 않은 상태로 표시</span> 
                               	</a>
                               	
<!--                                 <a id="addStar" class="dropdown-item" href="javascript:void(0)"> -->
<!--                                 	<i class="ti ti-star ti-sm me-1"></i> -->
<!--                                 	<span class="align-middle">즐겨찾기</span> -->
<!--                                 </a> -->
                                
                                <a class="dropdown-item d-sm-none d-block" href="javascript:void(0)"> <i class="ti ti-printer ti-xs me-1"></i> <span class="align-middle">Print</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <hr class="app-email-view-hr mx-n3 mb-2">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <i class="ti ti-trash ti-sm cursor-pointer me-3" data-bs-toggle="sidebar" data-target="#app-email-view"></i> 
                        	<i class="ti ti-mail-opened ti-sm cursor-pointer me-3"></i>
                    </div>
                </div>
            </div>
            <hr class="m-0">
                <!-- Email View : Last mail-->
				<div class="scrollable">
                <div class="card email-card-last mx-sm-4 mx-3 mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                        <div class="d-flex align-items-center mb-sm-0 mb-3">
                            <img id="empAtchfileSn" src="" alt="user-avatar" class="flex-shrink-0 rounded-circle me-3" height="40" width="40">
                            <div class="flex-grow-1 ms-1">
							    
							    <div class="d-flex align-items-center">
								    <h6 id="empNm" class="m-0"></h6>
								    <div class="dropdown d-flex align-self-center ms-2">
								        <button class="btn p-0" type="button" id="emailsActions" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								            <i class="ti ti-chevron-down ti-sm"></i>
								        </button>
								        <div id="empNmRest" class="dropdown-menu dropdown-menu-end dropdown-menu-right-custom" aria-labelledby="emailsActions">
								        </div>
								    </div>
								</div>
				                
							    <small id="empMail" class="text-muted"></small>
							</div>
                        </div>
                        <div class="d-flex align-items-center">
                            <p id="strMlSndngYmd" id="strMlSndngYmd" class="mb-0 me-3 text-muted"></p>
<!--                             <i class="ti ti-paperclip cursor-pointer me-2"></i>  -->
                            <i id="detailBM" class="email-list-item-bookmark ti ti-star ti-sm cursor-pointer me-2"></i>


<!--                             <div class="dropdown me-3 d-flex align-self-center"> -->
<!--                                 <button class="btn p-0" type="button" id="dropdownEmailTwo" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> -->
<!--                                     <i class="ti ti-dots-vertical"></i> -->
<!--                                 </button> -->
<!--                                 <div class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownEmailTwo"> -->
<!--                                     <a class="dropdown-item scroll-to-reply" href="javascript:void(0)"> <i class="ti ti-corner-up-left me-1"></i> <span class="align-middle">답장하기</span> -->
<!--                                     </a> <a class="dropdown-item" href="javascript:void(0)"> <i class="ti ti-corner-up-right me-1"></i> <span class="align-middle">Forward</span> -->
<!--                                     </a> <a class="dropdown-item" href="javascript:void(0)"> <i class="ti ti-alert-octagon me-1"></i> <span class="align-middle">Report</span> -->
<!--                                     </a> -->
<!--                                 </div> -->
<!--                             </div> -->
                        
                        
                        </div>
                    </div>
                    <div class="card-body">
                        <p id="mlTtl" class="fw-medium"></p>
                        <p id="mlCn"></p>
<!--                         <p class="mb-0">Sincerely yours,</p> -->
<!--                         <p class="fw-medium mb-0">Envato Design Team</p> -->
                        <hr>
                        <p class="email-attachment-title mb-2">첨부파일</p>
                        <div class="cursor-pointer" style="display : flex;">
                            <i class="ti ti-file"></i> 
                            	<span id="downloadfile" class="align-middle ms-1">
                            		<a id="downloadfile" href=""></a>
                            	</span>
                        </div>
                    </div>
                </div>
                
                <!-- Email View : Reply mail-->
                <form action="" enctype="multipart/form-data">
	                <div id="gubunReply"  style="display : none;" class="email-reply card mt-4 mx-sm-4 mx-3">
	                    <h6 class="card-header border-0">답장하기</h6>
	                    <hr class="container-mx-sm-4 mx-3">
	                    <div class="email-compose-subject d-flex align-items-center mb-2">
	                        <label for="Remail-title" class="form-label me-0" style="margin-left : 20px; width : 35px;">제목 :</label>
	                        <input type="text" class="form-control border-0 shadow-none flex-grow-1 " id="Remail-title" placeholder="제목을 입력해주세요">
	                    </div>
	                    <label class="switch switch-primary switch-me" style="margin-left : 20px;">중요
							<input type="checkbox" class="switch-input" value="" id="RsendImportant" style="margin-left : 20px;">
							<span class="switch-toggle-slider" style="margin-left : 7px;">
								<span class="switch-on"></span>
							</span>
						</label>
						
						
						<div class="fileBox">
							<span class="dd_text" style="margin-left : 20px;">파일첨부</span>
							<div id="dropZone-re" class="dd_attach dd_zone" style="margin-left : -20px; width: 85%;">
								<div class="area_txt">
									<span class="ic_attach ic_upload"></span> 
									<span class="msg">이곳에 파일을 드래그 하세요. 또는 
										<span class="btn_file">
											<span class="txt">파일선택</span>
											<input type="file" title="파일선택" data-file="reply" multiple id="attach-file-re">
										</span>
									</span>
								</div>
								<div class="area_img" id="areaImg-re">
			            
								</div>
								<div class="area_file" id="areaFile-re">
			
								</div>
							</div>
						</div><br>
						
	
	<!--                     CKEditor ////////////////////// -->
	                    <div id="Rckeditor"  class="card-body pt-0 px-3">
	                        <div class="email-compose-message container-m-nx" id="RckMessage">
	                    </div>
	                        <textarea style="display : none;" id="Rmessage" name="Rmessage" class="form-control" rows="4" cols="30"></textarea>
	<!--                         CKEditor ////////////////////// -->
	                    </div>
	                    
	                    <div class="d-flex justify-content-end align-items-center">
	                        <button id="Reply" class="btn btn-primary waves-effect waves-light">
	                            <i class="ti ti-send ti-xs me-1"></i>
	                            <span class="align-middle">Send</span>
	                        </button>
	                    </div>
	                </div>
                </form>
            </div>
            <div class="ps__rail-x" style="left: 0px; bottom: 0px;">

                <div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div>
            </div>
            <div class="ps__rail-y" style="top: 0px; height: 642px; right: 0px;">
                <div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 572px;"></div>
            </div>
        </div>
    </div>
    <!-- Email View -->



<!-- Compose Email -->
<div class="app-email-compose modal fade" id="emailComposeSidebar" tabindex="-1" aria-labelledby="emailComposeSidebarLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
        <div class="modal-content p-0">
            <div class="modal-header py-3 bg-body">
                <h5 class="modal-title fs-5 TS" id="emailComposeSidebarLabel">메일 작성</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body flex-grow-1 pb-sm-0 p-4 py-2">
                <form id="frm" class="email-compose-form" action="" enctype="multipart/form-data">
                    <div id="addEmpNm" class="email-compose-to d-flex justify-content-between align-items-center">
                        <label class="form-label mb-0" for="emailContacts" style="font-size : medium;">To:</label>
                        <div class="select2-primary border-0 shadow-none flex-grow-1 mx-2">
                            <div class="position-relative">
                                <select class="select2 select-email-contacts form-select select2-hidden-accessible" id="emailContacts" name="emailContacts" multiple="" data-select2-id="emailContacts" tabindex="-1" aria-hidden="true">
                                    <c:forEach var="employeeVO" items="${employeeList}" varStatus="stat">
                                        <option data-avatar="/view/${employeeVO.empId}" value="${employeeVO.empId}">${employeeVO.empNm}</option>
                                    </c:forEach>
                                </select>
                                <span class="select2 select2-container select2-container--default" dir="ltr" data-select2-id="1" style="width: auto;">
                                    <span class="selection"></span>
                                    <span class="text-truncate" _msthidden="1">
                                    <span class="dropdown-wrapper" aria-hidden="true"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <label class="switch switch-primary switch-me">중요
                        <input type="checkbox" class="switch-input" value="" id="sendImportant">
                        <span class="switch-toggle-slider" style="margin-left : 7px;">
                            <span class="switch-on"></span>
                        </span>
                    </label>
                    <div class="email-compose-subject d-flex align-items-center mb-2 " style="margin-top : 6px;">
                        <label for="email-title" class="form-label mb-0" style="width : 50px; font-size : medium;">제목 : </label>
                        <input type="text" class="form-control border-0 shadow-none flex-grow-1 mx-2" id="email-title" placeholder="제목을 입력해주세요">
                    </div>
                    <div class="fileBox">
                        <span class="dd_text">파일첨부</span>
                        <div id="dropZone" class="dd_attach dd_zone">
                            <div class="area_txt">
                                <span class="ic_attach ic_upload"></span> 
                                <span class="msg">이곳에 파일을 드래그 하세요. 또는 
                                    <span class="btn_file">
                                        <span class="txt">파일선택</span>
                                        <input type="file" title="파일선택" data-file="send" multiple id="attach-file">
                                    </span>
                                </span>
                            </div>
                            <div class="area_img" id="areaImg"></div>
                            <div class="area_file" id="areaFile"></div>
                        </div>
                    </div><br>
                    <div class="email-compose-message container-m-nx" id="ckMessage"></div>
                    <textarea style="display : none;" id="message" name="message" class="form-control" rows="4" cols="30"></textarea>
                    <hr class="container-m-nx mt-0 mb-2">
                    <div class="email-compose-actions d-flex justify-content-between align-items-center mt-3 mb-3">
                        <div class="d-flex align-items-center">
                            <div id="mailSendDiv" class="btn-group mailSendDiv">
                                <button id="SendS" type="button" class="btn btn-primary waves-effect waves-light">
                                    <i class="ti ti-send ti-xs me-1"></i>Send
                                </button>
                                <button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split waves-effect waves-light" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span class="visually-hidden">Send Options</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a id="Tsave" class="dropdown-item" href="javascript:void(0);">임시저장</a></li>
                                </ul>
                            </div>
                            <div id="tsSendDiv" style="display : none;" class="btn-group tsSendDiv">
                                <button id="tsSendS" type="button" class="btn btn-primary waves-effect waves-light">
                                    <i class="ti ti-send ti-xs me-1"></i>Send
                                </button>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <button type="button" class="btn" data-bs-dismiss="modal" aria-label="Close">
                                <i class="ti ti-trash"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>




<!-- /Compose Email -->
<script type="text/javascript">
    /*
		ClassicEditor : ckeditor5.js 에서 제공해주는 객체
		uploadUrl : 이미지 업로드를 수행할 URL
		window.editor=editor : editor객체를 window.editor 라고 부름
 */
//  	console.log("fBContent >> ", fBContent);
    ClassicEditor.create(document.querySelector('#ckMessage'), {
            ckfinder: {
                uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
            }
        })
        .then(editor => {
            window.editor2 = editor;
        })
        .catch(err => {
            console.error(err.stack);
        });

    $(function() {
        //ckeditor 내용 => textarea로 복사
        $(".ck-blurred").keydown(function() {
            console.log("str : " + window.editor2.getData());
            $("#message").val(window.editor.getData());
        });

        $(".ck-blurred").on("focusout", function() {
            $("#message").val(window.editor2.getData());
        });
    });

// ===============================================================
	
	
	ClassicEditor.create(document.querySelector('#RckMessage'), {
            ckfinder: {
                uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
            }
        })
        .then(editor => {
            window.editor = editor;
        })
        .catch(err => {
            console.error(err.stack);
        });

    $(function() {
        //ckeditor 내용 => textarea로 복사
        $(".ck-blurred").keydown(function() {
        	
            console.log("str : " + window.editor.getData());
            $("#Rmessage").val(window.editor.getData());
        });

        $(".ck-blurred").on("focusout", function() {
            $("#Rmessage").val(window.editor.getData());
        });
    });
	

    function handleImg(e) {
        let files = e.target.files;
        let fileArr = Array.prototype.slice.call(files);

        fileArr.forEach(function(f) {
            if (!f.type.match("image.*")) {
                alert("이미지 확장자만 가능합니다.");
                return;
            }
            let reader = new FileReader();

            $("#pImg").html("");

            reader.onload = function(e) {
                let img_html = "<img src=\"" + e.target.result + "\" style='width:50%;' />";
                $("#pImg").append(img_html);
            }
            reader.readAsDataURL(f);
        });
    }
</script>
<!-- <script src="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script> -->