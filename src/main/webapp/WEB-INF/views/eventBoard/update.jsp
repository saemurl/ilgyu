<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />

<style>
img{
	width: 560px;
    height: 660px;
    border-radius: 15px;
}

#adressArea{
	display: flex;
	margin-bottom: 20px;
}

#mrgAddDe, #obtAddDe {
	width: 10vw;
    margin-left: 5px;
}

#leftBottomMrgPanel {
    padding: 20px;
	width: 72.5vw;
	height:80px;
	margin-top: 10px;
	display: flex;
    justify-content: center;
    align-items: center;
    background-color: #FFFFE0; /* 밝은 노랑 */
}

#leftBottomRipPanel {
	padding: 20px;
    width: 72.5vw;
	height:80px;
	margin-top: 10px;
	display: flex;
    justify-content: center;
    align-items: center;
    background-color: #585858; /* 어두운 회색 */
}

#leftBottomRipPanel, 

#mrgMent {
    color: #333333; /* 진한 회색 */
    font-family: 'Arial', 'Helvetica', sans-serif;
    font-size: 1.2em;
}

#ripMent {
    color: #FFFFFF; /* 흰색 */
    font-family: 'Arial', 'Helvetica', sans-serif;
    font-size: 1.2em;
}

#rightPicture {
	height: 700px;
    width: 500px;
}   

.detail-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

.detail-header .info {
    display: flex;
    gap: 20px;
}

.eventBtn {
    display: flex;
    justify-content: end;
}
</style>


<script>

$(document).ready(function() {
	

//날짜 입력란 클릭 시 picker 꺼내서 날짜를 선택받도록 하는 영역 [시작] -----------
	flatpickr(".dob-picker", {
	    dateFormat: "Y-m-d"
	});
	
	flatpickr("#mrgDt", {
	    dateFormat: "Y-m-d"
	});
	
	flatpickr("#obtDmDt", {
	    dateFormat: "Y-m-d"
	});
	
	flatpickr("#obtFpDt", {
	    dateFormat: "Y-m-d"
	});
//날짜 입력란 클릭 시 picker 꺼내서 날짜를 선택받도록 하는 영역 [종료] -----------

	$('#mrgAddDe').on('click', function() {
		new daum.Postcode({
	      oncomplete: function(data) {
	         let addr = '';
	         if (data.userSelectedType === 'R') {
	            addr = data.roadAddress;
	         } else {
	            addr = data.jibunAddress;
	         }
	         $('#mrgDaddr').val(addr);
	      }
	   }).open();
	})

	$('#obtAddDe').on('click', function() {
		new daum.Postcode({
	      oncomplete: function(data) {
	         let addr = '';
	         if (data.userSelectedType === 'R') {
	            addr = data.roadAddress;
	         } else {
	            addr = data.jibunAddress;
	         }
	         $('#obtDaddr').val(addr);
	      }
	   }).open();
	})
	
	

	
	$('#cancelBtn').on('click', function () {
		
		Swal.fire({
		    html: "게시글 수정을 취소하시겠습니까?",
		    icon: 'question',
		    showCancelButton: true,
		    confirmButtonColor: '#3085d6',
		    cancelButtonColor: '#d33',
		    cancelButtonText: "닫기",
		    confirmButtonText: "취소",
		    customClass: {
		        confirmButton: 'btn btn-primary me-1',
		        cancelButton: 'btn btn-label-secondary'
		    },
		    buttonsStyling: false
		}).then(function(result) {
		    if (result.isConfirmed) {
				window.history.back();
		    }
		});    
	});

// 파일 업로드 이미지만 허용하도록  [시작] ───────────────────────────────────────────────────────
	document.getElementById('atchfileSn').addEventListener('change', function() {
	    const file = this.files[0];
	    if (file) {
	        const fileType = file.type;
	        const validImageTypes = ['image/jpeg', 'image/png'];
	        if (!validImageTypes.includes(fileType)) {
	            
	        	Swal.fire({
	        		icon: "error" ,
	        	    text: '업로드 파일은 jpg 또는 png 형식만 가능합니다.',
	        	    showClass: {
	        	      popup: 'animate__animated animate__shakeX'
	        	    },
	        	    customClass: {
	        	      confirmButton: 'btn btn-primary'
	        	    },
	        	    buttonsStyling: false
	        	})
	        	
	            this.value = '';
	        }
	    }
	});
// 파일 업로드 이미지만 허용하도록 [종료] ────────────────────────────────────────────────────────


// 결혼 게시글 수정  [시작] ─────────────────────────────────────────────────────────────────
	$('#mrgEdit').on('click', function () {
		let evtbNo = "${marriageVO.evtbNo}";
		let title = $('#title').val();
        let mrgDt = $('#mrgDt').val();
        let mrgAddress = $('#mrgAddress').val();
        let mrgDaddr = $('#mrgDaddr').val();
        let mrgCon = $('#mrgCon').val();
        let atchfileSn = $("#atchfileSn");	// 파일업로드		
 		let files = atchfileSn[0].files;
        
 		console.log("수정 할 결혼양식 받아온 값 체크 : " + "evtbNo : " + evtbNo + ", " + title + ", " + mrgDt + ", " + mrgAddress + ", " + mrgDaddr + ", " + atchfileSn + ", " + mrgCon);
        
        let formData = new FormData();
		
		formData.append("evtbNo",evtbNo);
		formData.append("title",title);
		formData.append("mrgDt",mrgDt);
		formData.append("mrgAddress",mrgAddress);
		formData.append("mrgDaddr",mrgDaddr);
		formData.append("mrgCon",mrgCon);
		
		for(let i =0; i<files.length; i++){
			formData.append("UploadFile", files[i]);
		}
        
		Swal.fire({
            title: '',
            text: "게시글을 수정하시겠습니까?",
            icon: 'info',
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
            	$.ajax({
					url:"/board/mrgUpdate",
					processData:false,
					contentType:false,
					data:formData,
					type:"post",
					dataType:"text",
					beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
					success:function(result){
						location.href = `/board/detail?evtbNo=${eventBoardVO.evtbNo}&evtbSe=${eventBoardVO.evtbSe}`;
					}
            	});
            }
        });
	});	
// 결혼 게시글 수정  [종료] ─────────────────────────────────────────────────────────────────



// 부고 게시글 수정  [시작] ─────────────────────────────────────────────────────────────────
	$('#obtEdit').on('click', function () {
		let evtbNo = "${obituaryVO.evtbNo}";
		let title = $('#title').val();
        let obtDmDt = $('#obtDmDt').val();
        let obtFpDt = $('#obtFpDt').val();
        let obtAddress = $('#obtAddress').val();
        let obtDaddr = $('#obtDaddr').val();
        let obtCon = $('#obtCon').val();
        let atchfileSn = $("#atchfileSn");	// 파일업로드		
		let files = atchfileSn[0].files;

        console.log("부고양식 받아온 값 체크 : " + title + ", " + obtDmDt + ", " + obtFpDt + ", " + obtAddress + ", " + obtDaddr + ", " + atchfileSn + ", " + obtCon);
        
		let formData = new FormData();
		
		formData.append("evtbNo",evtbNo);
		formData.append("title",title);
		formData.append("obtDmDt",obtDmDt);
		formData.append("obtFpDt",obtFpDt);
		formData.append("obtAddress",obtAddress);
		formData.append("obtDaddr",obtDaddr);
		formData.append("obtCon",obtCon);
		
		for(let i =0; i<files.length; i++){
			formData.append("UploadFile", files[i]);
		}
		
		Swal.fire({
            title: '',
            text: "게시글을 수정하시겠습니까?",
            icon: 'info',
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
            	$.ajax({
					url:"/board/obtUpdate",
					processData:false,
					contentType:false,
					data:formData,
					type:"post",
					dataType:"text",
					beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
					success:function(result){
						location.href = `/board/detail?evtbNo=${eventBoardVO.evtbNo}&evtbSe=${eventBoardVO.evtbSe}`;
					}
            	});
            }
        });
	});


// 부고 게시글 수정  [종료] ─────────────────────────────────────────────────────────────────

// 파일 등록 시 이미지 파일일 경우 우측 영역에 미리보기 표시 [시작] -----
    $('#atchfileSn').on('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#mrgPicture').attr('src', e.target.result);
            }
            reader.readAsDataURL(file);
        }
    });

	$('#atchfileSn').on('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#ripPicture').attr('src', e.target.result);
            }
            reader.readAsDataURL(file);
        }
    });
// 파일 등록 시 이미지 파일일 경우 우측 영역에 미리보기 표시 [종료] -----


});
</script>
<!-- 결혼 게시판 수정 페이지  ──────────────────────────────────────────────────────────────────────────────────────────────────────────── -->
<c:if test="${eventBoardVO.evtbSe=='E01'}">
	<div style="display: flex; gap: 20px;">
	    <div class="card" id="leftPanel" style="padding: 20px; width: 40vw;">
	    	<a href="<%=request.getContextPath() %>/board/eventList">경조사게시판 ></a><br/>

	    	<input class="form-control" type="text" id="title" value="${marriageVO.mrgTtl}"><br/>

			<input type="text"  class="form-control dob-picker flatpickr-input" id="mrgDt" value="${marriageVO.mrgDt}"><br/>

			<div id="adressArea">
				<input type="text" class="form-control" id="mrgAddress" value="${marriageVO.mrgAddr}"/>
				<button type="button" class="btn btn-primary waves-effect waves-light" id="mrgAddDe">상세주소</button>
			</div>

			<input type="text" class="form-control" id="mrgDaddr" value="${marriageVO.mrgDaddr}" readonly/><br/>

			<textarea rows="7" class="form-control" id="mrgCon">${marriageVO.mrgCon}</textarea><br/>

			<input type="file" class="form-control" id="atchfileSn" accept=".jpg, .jpeg, .png" /><br/>
			
	        <div class="eventBtn">
            	<button type="button" id="mrgEdit" class="btn btn-label-primary waves-effect" style="margin-right: 10px;">수정</button>
       			<button type="button" class="btn btn-label-secondary waves-effect" id="cancelBtn">취소</button>
	        </div>
	    
	    </div>
	    
	    <div class="card" id="rightMrgPanel" style="flex: 1; height: 700px; align-items: center; justify-content: space-around;">
	    	<img id="mrgPicture" alt="이미지" src="/upload${imgPath}">
	    </div>
	    
	</div>	    

    <div class="card" id="leftBottomMrgPanel">
        <div>
           	<h3 id="mrgMent" style="margin: 0px;">
           		두 분의 인생이 더욱 아름답고 빛나는 순간들로 가득하길 기원합니다.
           	</h3>
        </div>
	</div>
</c:if>
<!-- 결혼 게시판 수정 페이지  ──────────────────────────────────────────────────────────────────────────────────────────────────────────── -->


<!-- 부고 게시판 수정 페이지  ──────────────────────────────────────────────────────────────────────────────────────────────────────────── -->
<c:if test="${eventBoardVO.evtbSe=='E02'}">
	<div style="display: flex; gap: 20px;">
	    <div class="card" id="leftPanel" style="padding: 20px; width: 40vw; height: 700px;">
	        <a href="<%=request.getContextPath() %>/board/eventList">경조사게시판 ></a><br>
	        
	        <input class="form-control" type="text" id="title" value="${obituaryVO.obtTtl}" style="margin-bottom: 10px;">
	        
	        <label for="obtDmDt">별 세</label>
	        <input type="text" class="form-control dob-picker flatpickr-input" id="obtDmDt" value="${obituaryVO.obtDmDt}" style="margin-bottom: 10px;">
	        
	        <label for="obtDmDt">발인일</label>
			<input type="text" class="form-control dob-picker flatpickr-input" id="obtFpDt" value="${obituaryVO.obtFpDt}"><br/>
	        
	        <div id="adressArea">	
		        <input type="text" class="form-control" id="obtAddress" value="${obituaryVO.obtAddr}"/>
				<button type="button" class="btn btn-primary waves-effect waves-light" id="obtAddDe">상세주소</button><br/>
	        </div>
	        
	        <input type="text" class="form-control" id="obtDaddr" value="${obituaryVO.obtDaddr}" readonly/><br/>
	        
	        <textarea rows="5" class="form-control" id="obtCon">${obituaryVO.obtCon}</textarea><br/>

			<input type="file" class="form-control" id="atchfileSn" accept=".jpg, .jpeg, .png" /><br/>

			<div class="eventBtn">
            	<button type="button" id="obtEdit" class="btn btn-label-primary waves-effect" style="margin-right: 10px;">수정</button>
       			<button type="button" class="btn btn-label-secondary waves-effect" id="cancelBtn">취소</button>
	        </div>

        </div>

	    <div class="card" id="rightRipPanel" style="flex: 1; height: 700px; align-items: center; justify-content: space-around;">
	    	<img id="ripPicture" alt="이미지" src="/upload${imgPath}">
	    </div>
	    
	</div>

	<div class="card" id="leftBottomRipPanel" style="margin-top: 10px;">
	    <div>
	        <h3 id="ripMent" style="margin: 0px;">
	            	삼가 고인의 冥福을 빌며, 평안한 安息을 기원합니다.
	        </h3>
	    </div>
	</div>
</c:if>
<!-- 부고 게시판 수정 페이지  ──────────────────────────────────────────────────────────────────────────────────────────────────────────── -->


