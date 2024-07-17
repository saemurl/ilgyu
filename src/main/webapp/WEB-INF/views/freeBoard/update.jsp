<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<style>
    .card {
        padding: 20px;
    }
    #message{
    	display: none;
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
</style>
<div style="display: none">
    <input type="text" id="fbNo" value="${freeBoardVO.fbNo}">
    <input type="text" id="fbTtl" value="${freeBoardVO.fbTtl}">
    <textarea id="fBContent" style="">${freeBoardVO.fbCn}</textarea>
</div>

<div class="card">

    <div class="form-password-toggle">
        <label class="form-label" for="basic-default-title">제목</label>
        <div class="input-group input-group-merge">
            <input type="text" class="form-control fbTtl" id="basic-default-title" placeholder="제목을 입력해 주세요" aria-describedby="basic-default-title" value="${freeBoardVO.fbTtl }" />
            <span id="basic-default-title" class="input-group-text cursor-pointer"></span>
        </div>
    </div>





    <!--     <p>제목 : <input type="text" id="fbTtl"></p> -->
    내용 : <div id="ckMessage"></div>
    <textarea id="message" name="message" class="form-control" rows="4" cols="30" placeholder="문의글을 입력해 주세요"></textarea>
    <!-- <p>첨부파일 : <input type="file" id="atchfileSn"></p> -->
    <br>
    <div>
        <button class="btn btn-primary" id="freeUpdate"> 수정 </button>
        <button class="btn btn-primary" id="freeCencal"> 취소 </button>
    </div>
</div>


























<script type="text/javascript">
    let fBContent = $("#fBContent").val();


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
            editor.setData(fBContent);
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

    $("#freeUpdate").on("click", function() {
        let fbNo = $("#fbNo").val();
        let fbTtl = $(".fbTtl").val();
        let message = $("#message").val();
        let fbFrstWrtr = $("#fbFrstWrtr").val();
        let fbLastRgtr = $("#fbLastRgtr").val();
        let fbStts = $("#fbStts").val();

        let data = {
            "fbNo": fbNo,
            "fbTtl": fbTtl,
            "fbCn": message
        }
        console.log("data", data);

        $.ajax({
            url: "/board/freeUpdatePost",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("result : ", result);
                location.href = "/board/freeDetail?fbNo=" + fbNo;
            }
        });

    })
    $("#freeCencal").on("click", function() {
    	let fbNo = $("#fbNo").val();
    	location.href = "/board/freeDetail?fbNo=" + fbNo;
    })
</script>