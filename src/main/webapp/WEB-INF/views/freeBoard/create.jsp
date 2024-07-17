<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 외부 스크립트 및 스타일시트 추가 -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<!-- 사용자 정의 스타일 -->
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
            <input type="text" class="form-control fbTtl"  id="basic-default-title" placeholder="제목을 입력해 주세요" aria-describedby="basic-default-title"  />
            <span id="basic-default-title" class="input-group-text cursor-pointer"></span>
        </div>
    </div>
	<!--     <p>제목 : <input type="text" id="fbTtl"></p> -->
    내용 : <div id="ckMessage"></div>
    <textarea id="message" name="message" class="form-control" rows="4" cols="30" placeholder="문의글을 입력해 주세요"></textarea>
    <!-- <p>첨부파일 : <input type="file" id="atchfileSn"></p> -->
    <br>
    <div>
        <button class="btn btn-primary" id="freeCreate"> 등록 </button>
        <button class="btn btn-primary" id="freeCencal"> 취소 </button>
    	<button type="button" id="exampleBtn" style="background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
    </div>
</div>
<!-- 사용자 정의 스크립트 -->
<script type="text/javascript">
    /*
		ClassicEditor : ckeditor5.js 에서 제공해주는 객체
		uploadUrl : 이미지 업로드를 수행할 URL
		window.editor=editor : editor객체를 window.editor 라고 부름
 	*/
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
        //ckeditor 내용 => textarea로 복사
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

    $("#freeCreate").on("click", function() {
        let fbTtl = $(".fbTtl").val();
        let message = $("#message").val();
        let fbFrstWrtr = $("#fbFrstWrtr").val();
        let fbLastRgtr = $("#fbLastRgtr").val();
        let fbStts = $("#fbStts").val();

        let data = {
            "fbTtl": fbTtl,
            "fbCn": message,
        }
        console.log("data", data);

        $.ajax({
            url: "/board/freeCreatePost",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("result : ", result);
                location.href = "/board/freeList";
            }
        });
    })
    
	$("#freeCencal").on("click", function() {
	    if (confirm("게시글 작성을 취소합니다.")) {
	        location.href = "/board/freeList";
	    }
	});
    
    // 자동 완성 버튼 클릭 시 데이터 자동 입력
    $(document).ready(function() {
        $('#exampleBtn').on('click', function () {
    		console.log("샘플 생성 버튼 체크");
    		
    		$('#basic-default-title').val("야 이종진!!");
    		editor.setData(`안녕하세요, 디자인팀 이종진 대리님!!<br>
    				저는 개발1팀 이한별 대리입니다.<br><br>

    				친하게 지내고 싶어서 자유게시판에 글을 남겨봤어요.<br><br>
    				앞으로 종종 인사하고 지내요 친하게 지내봅시다!<br><br>

    				<strong>새로운 환경에서도 모두가 각자의 자리에서 최고의 성과를 낼 수 있도록 최선을 다해주시기 바랍니다.<br>
    				앞으로도 Groovit의 지속적인 발전을 위해 함께 노력해주시길 바랍니다.</strong><br><br>

    				<strong>감사합니다.</strong><br><br>

    				<strong>Groovit 인사팀 드림</strong>`);
    	})
    });
</script>