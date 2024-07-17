<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<style>
    .card {
        padding: 20px;
    }
    #message{
    	display: 
    }
    #ckMessage{
    	height: 50%;
    }
    .ck.ck-editor {
   		max-width: 100%;
	}
	.ck-editor__editable {
	   	height: 500px;
	}
	img {
	    width: 450px;
	    height: 600px;
    }
</style>
<div style="display: ">

    <input type="text" id="empId" value="${loginVO.empId}">
    <input type="text" id="ntcNo" value="${noticeBoardVO.ntcNo}">
    <input type="text" id="ntcTtl" value="${noticeBoardVO.ntcTtl}">
    <textarea id="ntcContent">${noticeBoardVO.ntcCn}</textarea>
</div>

<div class="card">
    <div class="form-password-toggle">
        <label class="form-label" for="basic-default-title">제목</label>
        <div class="input-group input-group-merge">
            <input type="text" class="form-control ntcTtl" id="basic-default-title" placeholder="제목을 입력해 주세요" aria-describedby="basic-default-title" value="${noticeBoardVO.ntcTtl}" />
            <span id="basic-default-title" class="input-group-text cursor-pointer"></span>
        </div>
    </div>
    내용 : <div id="ckMessage"></div>
    <textarea id="message" name="message" class="form-control" rows="4" cols="30" placeholder="문의글을 입력해 주세요"></textarea>
    <br>
    <div>
        <button type="button" class="btn btn-primary" id="confirm" class="btn btn-primary">저장</button>
        <button type="button" class="btn btn-primary" id="cancel" class="btn btn-primary">취소</button>
    </div>
</div>

<script type="text/javascript">
    let ntcContent = $("#ntcContent").val();

    ClassicEditor.create(document.querySelector('#ckMessage'), {
        ckfinder: {
            uploadUrl: '/resources/upload?${_csrf.parameterName}=${_csrf.token}'
        }
    }).then(editor => {
        window.editor = editor;
        editor.setData(ntcContent);
    }).catch(err => {
        console.error(err.stack);
    });

    $(function(){
        $(".ck-blurred").keydown(function(){
            console.log("str : " + window.editor.getData());
            $("#message").val(window.editor.getData());
        });
        $(".ck-blurred").on("focusout", function(){
            $("#message").val(window.editor.getData());
        });

        //이미지 미리보기 시작 //
        $("#pictures").on("change", handleImg);
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

    // 저장 버튼 클릭 이벤트
    $("#confirm").on("click",function(){
        // 수정
        let ntcNo = $("#ntcNo").val();
        let ntcTtl = $("#ntcTtl").val();
        let message = $("#message").val();
        let ntcFrstRgtr = $("#ntcFrstRgtr").val();
        let ntcLastRgtr = $("#ntcLastRgtr").val();
		let empId = $("#empId").val();

        Swal.fire({
            title: '',
            text: "작성글을 수정하시겠습니까?",
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: "취소",
            confirmButtonText: "확인",
            customClass: {
                confirmButton: 'btn btn-primary me-1',
                cancelButton: 'btn btn-label-secondary'
            },
            buttonsStyling: false
        }).then(function(result) {
            if (result.value) {
                let data = {
                	"ntcLastRgtr":empId,
                    "ntcNo": ntcNo,
                    "ntcTtl": ntcTtl,
                    "ntcCn": message
                };
                console.log("data",data)
                $.ajax({
                    url:"/board/noticeUpdatePost",
                    contentType:"application/json;charset=utf-8",
                    data:JSON.stringify(data),
                    type:"post",
                    dataType : "json",
                    beforeSend:function(xhr){
                        xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
                    },
                    success:function(result){
                        console.log("result : ", result);
                        location.href="/board/noticeList";
                    }
                });
            }
        });
    });
    $("#cancel").on("click",function(){
        Swal.fire({
            title: '',
            text: "작성글 수정을 취소하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: "취소",
            confirmButtonText: "확인",
            customClass: {
                confirmButton: 'btn btn-primary me-1',
                cancelButton: 'btn btn-label-secondary'
            },
            buttonsStyling: false
        }).then(function(result) {
            if (result.value) {
                // 수정 페이지
                location.href="/board/noticeDetail?ntcNo=${noticeBoardVO.ntcNo}";
            }
        });
    });
</script>