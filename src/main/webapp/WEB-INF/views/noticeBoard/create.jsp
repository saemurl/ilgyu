<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>
<style>
    .card {
        padding: 20px;
    }
    #message {
        display: none;
    }
    #ckMessage {
        height: 50%;
    }
    .ck.ck-editor {
        max-width: 100%;
    }
    .ck-editor__editable {
        height: 500px;
    }
</style>
<div class="card">
    <div class="form-password-toggle">
        <label class="form-label" for="basic-default-title">제목</label>
        <div class="input-group input-group-merge">
            <input type="text" class="form-control ntcTtl" id="basic-default-title" placeholder="제목을 입력해 주세요" aria-describedby="basic-default-title" />
            <span id="basic-default-title" class="input-group-text cursor-pointer"></span>
        </div>
    </div>
    내용<div id="ckMessage"></div>
    <textarea id="message" name="message" class="form-control" rows="4" cols="30" placeholder="문의글을 입력해 주세요"></textarea>
    <br>
    <div>
        <button type="button" class="btn btn-primary" id="create" class="btn btn-primary" style="margin-right: 10px;">등록</button>
        <button type="button" class="btn btn-primary" id="cancel" class="btn btn-primary">취소</button>
        <button type="button" id="exampleBtn" style="background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
    </div>
</div>

<script type="text/javascript">
    ClassicEditor.create(document.querySelector('#ckMessage'), {
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
        $(".ck-blurred").keydown(function() {
            console.log("str : " + window.editor.getData());
            $("#message").val(window.editor.getData());
        });

        $(".ck-blurred").on("focusout", function() {
            $("#message").val(window.editor.getData());
        });
        //이미지 미리보기 시작 //
        $("#pictures").on("change", handleImg);
    })

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

    $("#create").on("click", function() {
        let ntcTtl = $(".ntcTtl").val();  //제목
        let message = $("#message").val();
        let ntcFrstRgtr = $("#ntcFrstRgtr").val();  //최초등록자
        let ntcLastRgtr = $("#ntcLastRgtr").val();  //최종등록자

        let data = {
            "ntcTtl": ntcTtl,
            "ntcCn": message
        }
        console.log("data", data);

        Swal.fire({
            title: '등록하시겠습니까?',
            text: "작성한 글을 등록합니다.",
            icon: 'info',
            showCancelButton: true,
            confirmButtonText: '등록',
            cancelButtonText: '취소',
            customClass: {
                confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
                cancelButton: 'btn btn-label-secondary waves-effect waves-light'
            },
            buttonsStyling: false
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "/board/noticeCreatePost",
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
                            title: '등록 완료!',
                            text: "작성한 글이 성공적으로 등록되었습니다.",
                            icon: 'success',
                            confirmButtonText: '확인',
                            customClass: {
                                confirmButton: 'btn btn-success waves-effect waves-light'
                            }
                        }).then(() => {
                            location.href = "/board/noticeList";
                        });
                    }
                });
            }
        });
    });

    $("#cancel").on("click",function(){
        Swal.fire({
            title: '',
            text: "작성글 등록을 취소하시겠습니까?",
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
                location.href="/board/noticeList";
            }
        });
    });
    
$(document).ready(function() {
    $('#exampleBtn').on('click', function () {
		console.log("샘플 생성 버튼 체크");
		
		$('#basic-default-title').val("2024년 07월 조직개편, 부서이동 및 인사발령 안내");
		editor.setData(`안녕하세요, Groovit 사원 여러분. 2024년 7월부로 조직의 효율성과 업무의 원활한 진행을 위해 일부 조직개편 및 부서이동, 인사발령을 실시하게 되어 안내드립니다.<br>
				이번 개편을 통해 보다 유기적이고 창의적인 업무 환경을 조성하고, 회사의 성장을 도모하고자 합니다.<br><br>

				<strong>1. 부서 이동</strong><br>
				◾ 개발 1팀의 일부 인원이 개발 2팀으로 이동하게 되었습니다. 새로운 팀에서도 최고의 역량을 발휘해주시기 바랍니다.<br><br>
				&nbsp;&nbsp;&nbsp;&nbsp;- 이동 인원: 홍길동, 김철수, 박영희<br><br>

				<strong>2. 인사 발령</strong><br><br>
				◾ 신입사원 인사 발령이 아래와 같이 진행되었습니다.<br>
				&nbsp;&nbsp;&nbsp;&nbsp;- 김지은: 개발 1팀<br>
				&nbsp;&nbsp;&nbsp;&nbsp;- 이민호: 개발 2팀<br>
				&nbsp;&nbsp;&nbsp;&nbsp;- 박소연: 디자인팀<br><br>

				<strong>새로운 환경에서도 모두가 각자의 자리에서 최고의 성과를 낼 수 있도록 최선을 다해주시기 바랍니다.<br>
				앞으로도 Groovit의 지속적인 발전을 위해 함께 노력해주시길 바랍니다.</strong><br><br>

				<strong>감사합니다.</strong><br><br>

				<strong>Groovit 인사팀 드림</strong>`);
	})
});
    
</script>
