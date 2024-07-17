<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500&family=Quicksand:wght@500&display=swap" rel="stylesheet">

<style>

#adressArea{
	display: flex;
}

#leftPanel{
	padding: 20px;
    height: 700px;
    width: 40vw;
	margin-right: 10px;
}

#leftBottomDefPanel {
	padding: 20px;
	width: 40vw;
	height:80px;
	margin-top: 10px;
	display: flex;
    justify-content: center;
    align-items: center;
}

#leftBottomMrgPanel{
	padding: 20px;
	width: 40vw;
	height:80px;
	margin-top: 10px;
	display: flex;
    justify-content: center;
    align-items: center;
    background-color: #FFFFE0; /* 밝은 노랑 */
}

#leftBottomMrgPanel h3 {
    color: #333333; /* 진한 회색 */
    font-family: 'Quicksand', 'Poppins', sans-serif;
    font-weight: 500;
    font-size: 1.2em;
}

#leftBottomObtPanel{
	padding: 20px;
	width: 40vw;
	height:80px;
	margin-top: 10px;
	display: flex;
    justify-content: center;
    align-items: center;
    background-color: #585858; /* 어두운 회색 */
}

#leftBottomObtPanel h3 {
    color: #FFFFFF; /* 흰색 */
    font-family: 'Arial', 'Helvetica', sans-serif;
    font-size: 1.2em;
}

#rightPanel{
	padding: 20px;
	width: 35vw;
	display: flex;
	align-items: center;
	justify-content: center;
}

#mrgAddDe, #obtAddDe{
	width: 10vw;
    margin-left: 5px;
}

#submitBtn, #cancelBtn {
	width: 100px;
}

#submitBtn{
	margin-right: 10px;
}

#rightPicture {
	height: 700px;
    width: 500px;
}   

#selectOneArea {
	margin-top: 100px;
    margin-bottom: 100px;
    text-align: center;
}

</style>


<script>

$(document).ready(function() {
	
	$('#mrg').click(function() {
		$('#obt').prop('checked', false);
		$('.allFormArea').show();
		$('#basicForm').hide();
		$('#leftBottomDefPanel').hide();
		$('#leftBottomMrgPanel').show();
		$('#leftBottomObtPanel').hide();
		$('#basicFormHide').show();
		$('#marriageForm').show();
	    $('#obituaryForm').hide();
	});
	
	$('#obt').click(function() {
		$('#mrg').prop('checked', false);
		$('.allFormArea').show();
		$('#basicForm').hide();
	    $('#leftBottomDefPanel').hide();
	    $('#leftBottomObtPanel').show();
	    $('#leftBottomMrgPanel').hide();
	    $('#basicFormHide').show();
	    $('#marriageForm').hide();
	    $('#obituaryForm').show();
	});	
	
// 날짜 입력란 클릭 시 picker 꺼내서 날짜를 선택받도록 하는 영역 [시작] -----------
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
// 날짜 입력란 클릭 시 picker 꺼내서 날짜를 선택받도록 하는 영역 [종료] -----------
	
// 상세주소 클릭 시 [시작] ------------------------------------------------
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
// 상세주소 클릭 시 [종료] ------------------------------------------------

// 파일 등록 시 이미지 파일일 경우 우측 영역에 미리보기 표시 [시작] -----
    $('#atchfileSn').on('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#rightPicture').attr('src', e.target.result);
                $('#textOverlay').hide();
            }
            reader.readAsDataURL(file);
        }
    });
// 파일 등록 시 이미지 파일일 경우 우측 영역에 미리보기 표시 [종료] -----

// 취소 버튼 클릭 시 게시판으로 복귀
	$('#cancelBtn').on('click', function () {
		Swal.fire({
		    html: "게시글 작성을 취소하시겠습니까?",
		    icon: 'warning',
		    showCancelButton: true,
		    confirmButtonColor: '#3085d6',
		    cancelButtonColor: '#d33',
		    cancelButtonText: "닫기",
		    confirmButtonText: "취소",
		    customClass: {
		        confirmButton: 'btn btn-warning me-1',
		        cancelButton: 'btn btn-label-secondary'
		    },
		    buttonsStyling: false
		}).then(function(result) {
		    if (result.isConfirmed) {
		        location.href = "/board/eventList";
		    }
		});
	});

// [ 등록 ] 버튼 클릭 시 [시작] ────────────────────────────────────────────────────────────────────────────────────────────────────────── 
	$('#submitBtn').on('click', function () {
		
		if(!$('#mrg').is(':checked') && !$('#obt').is(':checked')) {
            alert("작성 양식을 선택해주세요");
        }
		
		if ($('#mrg').is(':checked')) {
            console.log("결혼 양식 글 등록 버튼 클릭 시 ---------------------------");
            
            let title = $('#title').val();
            let mrgDt = $('#mrgDt').val();
            let mrgAddress = $('#mrgAddress').val();
            let mrgDaddr = $('#mrgDaddr').val();
            let mrgCon = $('#mrgCon').val();
            let atchfileSn = $("#atchfileSn");	// 파일업로드		
    		let files = atchfileSn[0].files;
            
            console.log("결혼양식 받아온 값 체크 : " + title + ", " + mrgDt + ", " + mrgAddress + ", " + mrgDaddr + ", " + atchfileSn + ", " + mrgCon);
            
            let formData = new FormData();
    		
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
                text: "게시글을 등록하시겠습니까?",
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
    					url:"/board/mrgCreate",
    					processData:false,
    					contentType:false,
    					data:formData,
    					type:"post",
    					dataType:"text",
    					beforeSend: function(xhr) {
    		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
    		            },
    					success:function(result){
    						location.href = "/board/eventList";
    					}
                	});
                }
            });
		}
		
		if ($('#obt').is(':checked')) {
            console.log("부고 양식 글 등록 버튼 클릭 시 ---------------------------");
            
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
                text: "게시글을 등록하시겠습니까?",
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
    					url:"/board/obtCreate",
    					processData:false,
    					contentType:false,
    					data:formData,
    					type:"post",
    					dataType:"text",
    					beforeSend: function(xhr) {
    		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
    		            },
    					success:function(result){
    						location.href = "/board/eventList";
    					}
                	});
                }
            });
        }
	});
// [ 등록 ] 버튼 클릭 시 [종료] ──────────────────────────────────────────────────────────────────────────────────────────────────────────

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

$('#exampleBtn').on('click', function () {
	console.log("자동완성 버튼 클릭 체크 ");
	
	$('#title').val("이준서 사무팀장 결혼 알림");
	$('#mrgDt').val("2024-10-21");
	$('#mrgAddress').val("Dear Hotel 그랜드홀");
	$('#mrgCon').val(
		"예식일 : 2024-08-23\n\n장 소 : Dear Hotel 2층 그랜드홀\n\n상세주소 : 서울 강서구 공항대로36길 57\n\n초록빛 싱그러움이 가득한 5월의 봄 날 사랑하는 두 사람이 같은 곳을 바라보며 평생 함께 걷고자 합니다.\n저희 동행의 첫 걸음에 함께 하시어 진실한 모습으로 행복한 가정 가꾸어 나갈 수 있도록 축복해 주십시오."
	);
})

});
</script>

<div style="display: flex;">
	
	<div>
		<div class="card" id="leftPanel">
		
			<div class="btn-group" role="group" aria-label="Basic checkbox toggle button group" style="width: 20vw;">
			    <input type="checkbox" class="btn-check" id="mrg">
			    <label class="btn btn-outline-primary waves-effect" for="mrg">
			      <span class="d-block d-sm-none">
			        <i class="ti ti-home ti-sm"></i>
			      </span>
			      <span class="d-none d-sm-block">결혼</span>
			    </label>
			
			    <input type="checkbox" class="btn-check" id="obt">
			    <label class="btn btn-outline-primary waves-effect" for="obt">
			      <span class="d-block d-sm-none">
			        <i class="ti ti-plane-tilt ti-sm"></i>
			      </span>
			      <span class="d-none d-sm-block">부고</span>
			    </label>
		    </div>
			<br/>
			
			
			<div id="basicForm">
				<div id="selectOneArea">
					<hr>
		        	<div class="selectOne">[ 작성 양식을 선택해주세요 ]</div>
		        	<hr>
		        </div>
			</div>
		
			<div class="allFormArea" style="display: none;">
				<input class="form-control" type="text" id="title" placeholder="글 제목을 입력해주세요.">
				
				<!-- 결혼 / 부고 선택 시 변경 영역 구분 [ 시작 ] ----------- -->
				<!-- [결혼] -->
				<br/>
				<div id="marriageForm" style="display: none;">
					
					<input type="text"  class="form-control dob-picker flatpickr-input" id="mrgDt" placeholder="결혼일 : YYYY-MM-DD"><br/>
					<div id="adressArea">
						<input type="text" class="form-control" id="mrgAddress" placeholder="예식장 주소를 입력해주세요."/>
						<button type="button" class="btn btn-primary waves-effect waves-light" id="mrgAddDe">상세주소</button>
					</div>
						<br/><input type="text" class="form-control" id="mrgDaddr" placeholder="상세주소" readonly/><br/>
						<textarea rows="7" class="form-control" id="mrgCon" placeholder="상세 내용을 입력해주세요"></textarea><br/>
				</div>
				
				
				<!-- [부고] -->
				<div id="obituaryForm" style="display: none;">
		
					<input type="text" class="form-control dob-picker flatpickr-input" id="obtDmDt" placeholder="별세일 : YYYY-MM-DD"><br/>
		
					<input type="text" class="form-control dob-picker flatpickr-input" id="obtFpDt" placeholder="발인일 : YYYY-MM-DD"><br/>
					
					<div id="adressArea">			
						<input type="text" class="form-control" id="obtAddress" placeholder="빈소"/>
						<button type="button" class="btn btn-primary waves-effect waves-light" id="obtAddDe">상세주소</button><br/>
					</div>
						<br/><input type="text" class="form-control" id="obtDaddr" placeholder="상세주소" readonly/><br/>
						<textarea rows="5" class="form-control" id="obtCon" placeholder="상세 내용을 입력해주세요"></textarea><br/>
				</div>
				<!-- 결혼 / 부고 선택 시 변경 영역 구분 [ 종료 ] ----------- -->
		
				<input type="file" class="form-control" id="atchfileSn" accept=".jpg, .jpeg, .png" />

				<hr/>
				<div style="display: flex; margin-left: 460px;">
					<button type="button" id="exampleBtn" style="margin-right: 15px; background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
					<button type="button" class="btn btn-primary waves-effect waves-light" id="submitBtn">등록</button>
					<button type="button" class="btn btn-secondary waves-effect waves-light" id="cancelBtn">취소</button>
				</div>
				
			</div>
			
		</div>
			
		<div class="card" id="leftBottomDefPanel">
           	<div>
				<!-- 공백 -->
           	</div>
		</div>
		<div class="card" id="leftBottomMrgPanel" style="display: none;">
           	<div>
	           	<h3 id="congMent" style="margin: 0px;">
	           		두 분의 인생이 더욱 아름답고 빛나는 순간들로 가득하길 기원합니다.
	           	</h3>
           	</div>
		</div>
		<div class="card" id="leftBottomObtPanel" style="display: none;">
           	<div>
	           	<h3 id="ripMent" style="margin: 0px;">
	           		삼가 고인의 冥福을 빌며, 평안한 安息을 기원합니다.
	           	</h3>
           	</div>
		</div>
		
	</div>

	<div class="card" id="rightPanel">
		<img alt="우측이미지" src="\resources\images\경조사글작성이미지샘플.png" id="rightPicture" style="border-radius: 15px;">
		<div id="textOverlay" style="position: absolute; color: rgb(23 98 191);">
			<hr style="color: rgb(23 98 191);">
			<small>이미지 미리보기 영역</small>
			<hr style="color: rgb(23 98 191);">
    	</div>
	</div>
	
</div>


<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>