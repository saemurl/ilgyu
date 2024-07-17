<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="/resources/css/sweetalert2.min.css">
<script type="text/javascript" src="/resources/js/sweetalert2.min.js"></script>
<style>
    .card {
        padding: 20px;
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

    .freeBtn {
        display: flex;
        justify-content: end;
    }
    #boardLike {
    	display: flex;
    	justify-content: center;
    	margin: 50px;
    }
    #boardLike .btn{
    	width: 100px;
    	height: 100px;
    	margin: 10px;
    }
    #likeInfo p {
    margin: 3px;
    }
</style>

<div style="display: none;">
    <h1>글번호 : <input type="text" id="fbNo" value="${freeBoardVO.fbNo}"> </h1>
    <h1>제목 : <input type="text" id="fbTtl" value="${freeBoardVO.fbTtl}"> </h1>
    <p>내용 : <textarea cols="50" rows="3" readonly>${freeBoardVO.fbCn}</textarea></p>
    <p>게시글 등록 회원번호 : <input type="text" id="fbFrstWrtr" value="${freeBoardVO.fbFrstWrtr}" readonly></p>
    <p>로그인 회원번호 : <input type="text" id="empId" value="${empId}" readonly></p>
    <p>작성자 : <input type="text" id="empNm" value="${freeBoardVO.empNm}" readonly></p>
    <p>추천수 : <input type="text" id="fbLikeCnt" value="${freeBoardVO.fbLikeCnt}" readonly></p>
    <p>비추천수 : <input type="text" id="fbDisllikeCnt" value="${freeBoardVO.fbDisllikeCnt}" readonly></p>
    <p>조회수 : <input type="text" id="fbCnt" value="${freeBoardVO.fbCnt}" readonly></p>
    <p>등록일 :
        <fmt:formatDate value="${freeBoardVO.fbFrstRegDt}" pattern="yyyy/MM/dd" />
        <c:set var="loginEmp" value="${empId}"></c:set>
        <c:set var="fbFrstWrtr" value="${freeBoardVO.fbFrstWrtr}"></c:set>
</div>

<div class="card">
    <br>
    <a href="<%=request.getContextPath() %>/board/freeList">자유게시판 ></a>
    <br>
    <div class="detail-header col-12">
        <div class="title">
            <h3>${freeBoardVO.fbTtl}</h3>
        </div>
        <div class="info">
            <div>작성자 : ${freeBoardVO.empNm}</div>
            <div>작성일 :
                <fmt:formatDate value="${freeBoardVO.fbFrstRegDt}" type="both" dateStyle="medium" timeStyle="medium" />
            </div>
            <div>조회수 : ${freeBoardVO.fbCnt}</div>
        </div>
    </div>
    <hr>

    <div class="col-12">
        <p>${freeBoardVO.fbCn}</p>
    </div>
    <div id="boardLike">
		<button type="button" class="btn rounded-pill me-2 btn-label-success" id="btnLikeCnt">
			<div id="likeInfo">
				<p>좋아요</p>
				<p id="btnLikeCntP">${freeBoardVO.fbLikeCnt}</p>
			</div>
		</button>
		<button type="button" class="btn rounded-pill me-2 btn-label-warning" id="btnDisllikeCnt">
			<div id="likeInfo">
				<p>싫어요<p>
				<p id="btnDisllikeCntP">${freeBoardVO.fbDisllikeCnt}</p>
			</div>
		</button>
    </div>

    <hr class="mt-0" />
        <div class="freeBtn">
        	<c:if test="${loginEmp ne fbFrstWrtr}">
        		<button type="button" class="btn rounded-pill me-2 btn-label-warning report-btn" data-bs-toggle="modal" data-bs-target="#exampleModal1">신고</button>
        	</c:if>
    		<c:if test="${loginEmp eq fbFrstWrtr}">
            	<button type="button" id="edit" class="btn rounded-pill me-2 btn-label-success">수정</button>
            	<button type="button" id="delete" class="btn rounded-pill me-2 btn-label-danger">삭제</button>
	    	</c:if>
        </div>
</div>
<br>
<div class="card">
    <div class="card">
        <div class="input-group mb-3">
            <input type="text" class="form-control" id="cmntContent" placeholder="댓글을 입력해 주세요" aria-label="Recipient's username" aria-describedby="button-addon2">
            <button class="btn btn-outline-primary" id="cmntInsert" type="button" id="button-addon2">등록</button>
        </div>
    </div>
    <br>
    <div class="col-12">
        <div id="commentList">

        </div>
    </div>
</div>






<!-- post Modal -->
<div class="modal fade" id="exampleModal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="exampleModalLabel">게시글 신고</h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body">
                <div class="card">
                    <div>
                    	<h5>신고사유</h5>
                    </div>
                    
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="report_board_answer" value="욕설,비방" id="report_board1" checked>
                        <label class="form-check-label" for="report_board1">
                            욕설,비방
                        </label>
                    </div>
					<div class="form-check">
                        <input class="form-check-input" type="radio" name="report_board_answer" value="홍보,영리목적" id="report_board2">
                        <label class="form-check-label" for="report_board2">
                            홍보,영리목적
                        </label>
                    </div>
					<div class="form-check">
                        <input class="form-check-input" type="radio" name="report_board_answer" value="정치" id="report_board3">
                        <label class="form-check-label" for="report_board3">
                            정치
                        </label>
                    </div>
					<div class="form-check">
                        <input class="form-check-input" type="radio" name="report_board_answer" value="기타" id="report_board4">
                        <label class="form-check-label" for="report_board4">
                            기타
                        </label>
	                    <div>
	                        <textarea rows="5" cols="60" id="report_board5"></textarea>
	                    </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="report_board_post">신고</button>
            </div>
        </div>
    </div>
</div>


<!-- Comment Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="exampleModalLabel">댓글 신고</h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body">
                <div class="card">
                    <div>
                    	<h5>신고사유</h5>
                    </div>
                    
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="report_answer" value="욕설,비방" id="report1" checked>
                        <label class="form-check-label" for="report1">
                            욕설,비방
                        </label>
                    </div>
					<div class="form-check">
                        <input class="form-check-input" type="radio" name="report_answer" value="홍보,영리목적" id="report2">
                        <label class="form-check-label" for="report2">
                            홍보,영리목적
                        </label>
                    </div>
					<div class="form-check">
                        <input class="form-check-input" type="radio" name="report_answer" value="정치" id="report3">
                        <label class="form-check-label" for="report3">
                            정치
                        </label>
                    </div>
					<div class="form-check">
                        <input class="form-check-input" type="radio" name="report_answer" value="기타" id="report4">
                        <label class="form-check-label" for="report4">
                            기타
                        </label>
	                    <div>
	                        <textarea rows="5" cols="60" id="report5"></textarea>
	                    </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="report_post">신고</button>
            </div>
        </div>
    </div>
</div>






<script>
    $(function() {
        // 초기 댓글 리스트 로드
        commentList();
        /* 댓글 리스트 출력 시작 */
        function commentList() {
            let fbNo = $("#fbNo").val();
            let data = {
                "fbNo": fbNo
            };
            $.ajax({
                url: "/comment/list",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(data) {
                    console.log("data : ", data);
                    
                    $("#commentList").empty();
                    $.each(data, function(index, item) {
                        let comdate = new Date(item.cmntWrtDt); // 날짜 문자열을 Date 객체로 변환

                        let year = comdate.getFullYear();
                        let month = ('0' + (comdate.getMonth() + 1)).slice(-2);
                        let day = ('0' + comdate.getDate()).slice(-2);

                        let hours = comdate.getHours();
                        let minutes = ('0' + comdate.getMinutes()).slice(-2);
                        let period = hours >= 12 ? 'PM' : 'AM';
                        hours = hours % 12;
                        hours = hours ? hours : 12; // 0을 12로 변환

                        let formattedDate = `\${year}/\${month}/\${day} \${period} \${hours}:\${minutes}`;
                        
                        let loginEmp = $('#empId').val();
                        let commentEmp = item.empId

						console.log("loginEmp",loginEmp);
						console.log("commentEmp",commentEmp);
					
					
					

						let comment =  ``;
							comment += `<div class="card mb-2" id="commentArea">`;
							comment += `<div class="card-body">`;
							comment += `<h5 class="card-title">\${item.empNm}</h5>`;
							comment += `<div class="card-subtitle text-muted mb-3">`;
							comment += `\${formattedDate}`;
							comment += `</div>`;
							comment += `<p class="card-text">`;
							if (item.cmntStts == 2) {
								comment += `<strong>블라인드 처리된 댓글입니다.</strong>`;
							}else {
								comment += `\${item.cmntContent}`;
							}
							comment += `</p>`;
							comment += `<div style =  "display: flex; justify-content: end;" >`;
							          
							          
// 							comment += `<div class="input-group mb-3">`;
// 							comment += `<input type="text" class="form-control re-value" id="re-value" placeholder="댓글을 입력해 주세요" aria-label="Recipient's username" aria-describedby="button-addon2">`;
// 							comment += `<button class="btn btn-outline-primary" id="cmntInsert" type="button" id="button-addon2">등록</button>`;
// 							comment += `</div>`;
							           
							           
							comment += `<div>`;
// 							comment += `<button type="button" class="btn btn-label-primary re-comment">댓글</button>`;
							if (item.cmntStts != 2 && loginEmp != commentEmp) {
									comment += `<button type="button" class="btn rounded-pill me-2 btn-label-danger report-btn" data-bs-toggle="modal" data-bs-target="#exampleModal">신고</button>`;
							}

							if (loginEmp === commentEmp) {
// 								comment += `<button type="button" class="btn btn-label-warning re-update" >수정</button>`;
								comment += `<button type="button" class="btn rounded-pill me-2 btn-label-dark re-delete">삭제</button>`;
							}
							                        
							comment += `<input type="hidden" class="cmntNo" value="\${item.cmntNo}"/>`;
							comment += `</div>`;
							comment += `</div>`;
							comment += `</div>`;
							comment += `</div>`;
                        $("#commentList").append(comment);
                    });
                }
            });
        }
        /* 댓글 리스트 출력 끝 */
        
// 		/* 대댓글 등록 시작 */
// 		$("#commentList").on("click", ".re-comment", function() {
// 		    let cmntUp = $(this).parent().children(".cmntNo").val();
// 		    console.log("대댓글 작성 할 댓글 번호:", cmntUp);
		
// 		    // .re-comment 버튼의 부모 요소 (.card-body)를 찾기
// 		    let parentCardBody = $(this).closest('.card-body');
// 		    let commentArea = parentCardBody.find('.re-value').parent();
		
// // 		    // 기존 대댓글 영역 제거
// // 		    commentArea.find('.recomment').remove();
		
// 		    // 부모 요소 내의 .re-value 요소를 찾기
// 		    let reInput = parentCardBody.find('.re-value');
// 		    let reInputValue = reInput.val();
		
		    
// 		    let reply = "";
// 		    reply += `<div class="input-group mb-3 recomment">`;
// 		    reply += `<input type="hidden" id="recommentId" placeholder="부모댓글ID" value="">`;
// 		    reply += `<input type="text" class="form-control re-value" id="re-value" placeholder="댓글을 입력해 주세요" aria-label="Recipient's username" aria-describedby="button-addon2">`;
// 		    reply += `<button class="btn btn-outline-primary" id="recommentInsert" type="button">등록</button>`;
// 		    reply += `</div>`;
		
// 		    commentArea.append(reply);
		
// 		    let fbNo = $("#fbNo").val();
		
// 		    // 새롭게 추가된 .re-value 요소의 값을 가져오기
// 		    let reValue = commentArea.find("#re-value").val();
// 		    console.log(reValue);
// 		});
// 		/* 대댓글 등록 끝 */

        
        
        
        
        
        
        
        
        /* 댓글 삭제 시작 */
        $("#commentList").on("click", ".re-delete", function() {
        	 let cmntNo = $(this).parent().children(".cmntNo").val();
             console.log("삭제 할 댓글 번호:", cmntNo);
             
             
             if(confirm("댓글을 삭제 하시겠습니까 ?")){
            	 let data ={
            			 "cmntNo":cmntNo
            	 }
            	 $.ajax({
            			url:"/comment/delete",
            			contentType:"application/json;charset=utf-8",
            			data:JSON.stringify(data),
            			type:"post",
            			dataType:"json",
            			beforeSend:function(xhr){
            				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            			},
            			success:function(result){
            				console.log("result : ", result);
            				alert("정상적으로 삭제되었습니다.");
            				commentList();
            			},
            			error:function(request,status,error){        
            				alert("댓글 삭제중 오류가 발생하였습니다.")
            				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            			}
            		});
         		
         	}else{
         		alert("삭제를 취소 했습니다.");
         	}
        	
        	
        });
        /* 댓글 삭제 끝 */
        
        
        
        
        
        
        

        /* 댓글 신고 시작*/
        $("#commentList").on("click", ".report-btn", function() {
            // 신고 버튼이 클릭된 댓글의 cmntNo 값을 가져오기
            let cmntNo = $(this).parent().children(".cmntNo").val();
            console.log("신고할 댓글 번호:", cmntNo);
            
            let fbNo = $("#fbNo").val();
            
            $("#report_post").on("click",function(){
	            let reportvalue = $("input[name='report_answer']:checked").val();
	            if (reportvalue == "기타") {
	            	reportvalue = $("#report5").val();
				}
	            console.log("신고유형 : " ,reportvalue);
	            let data = {
	            		"cmntNo":cmntNo,
	            		"dcType":reportvalue
	            }
	            console.log("data",data);
	            
	            $.ajax({
	            	url:"/comment/declaration",
	            	contentType:"application/json;charset=utf-8",
	            	data:JSON.stringify(data),
	            	type:"post",
	            	dataType:"json",
	            	beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
	            	success:function(result){
	            		console.log("result : ", result);
	            		alert("신고가 완료되었습니다.")
	            		$("#exampleModal").modal('hide');
// 	            		location.href = "/board/freeDetail?fbNo=" + fbNo;
	            		cmntNo;
	            		reportvalue;
	            		data = {};
	            	}
	            });
	            
            });
            
        });
        /* 댓글 신고 끝*/
        
        /* 게시글 신고 */
        $("#report_board_post").on("click",function(){
        	let fbNo = $("#fbNo").val();
        	let dclrType = $("input[name='report_board_answer']:checked").val();
            if (dclrType == "기타") {
            	dclrType = $("#report_board5").val();
			}
            let data = {
            		"fbNo":fbNo,
            		"dclrType":dclrType
            }
        	
        	
        	 $.ajax({
	            	url:"/board/freeReportBoard",
	            	contentType:"application/json;charset=utf-8",
	            	data:JSON.stringify(data),
	            	type:"post",
	            	dataType:"json",
	            	beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
	            	success:function(result){
	            		console.log("result : ", result);
						alert("신고가 완료되었습니다.")
						$("#exampleModal1").modal('hide');
// 	            		location.href = "/board/freeDetail?fbNo=" + fbNo;
	            	}
	            });
        });
        /* 게시글 신고 끝*/
        
        
		/* 댓글 등록 시작 */
        $("#cmntInsert").on("click", function() {
            let cmntContent = $("#cmntContent").val();
            let fbNo = $("#fbNo").val();
            let data = {
                "cmntContent": cmntContent,
                "fbNo": fbNo
            };
            console.log("data", data);

            $.ajax({
                url: "/comment/create",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result : ", result);
                    $("#commentList").val('');
                    $("#cmntContent").val(''); // 입력란 초기화
                    alert("댓글이 등록 되었습니다.")
                    commentList();
                    
                    
                    
                    /* 게시글 댓글 알람 시작 */
                    let loginEmpId = $('#empId').val();
                    let fbTtl = $("#fbTtl").val();
                    let fbFrstWrtr = $("#fbFrstWrtr").val();
                    let freeBoard = "freeBoard";
                    
                    if (loginEmpId != fbFrstWrtr) {
	                   	let socketMsg	=	{
	                   			"title":freeBoard,
	                   			"senderId":loginEmpId,
	                   			"receiverId":fbFrstWrtr,
	                   			"fbNo":fbNo,
	                   			"fbTtl":fbTtl
	                   	}
	                   	socket.send(JSON.stringify(socketMsg));
					}
                }
            });
        });
        /* 댓글 등록 끝 */
        
        
        /* 게시판 리스트 이동 시작 */
        $("#list").on("click", function() {
            location.href = "/freeBoard/list";
        });
        /* 게시판 리스트 이동 끝 */
        
        
        /* 게시판 수정 이동 시작 */
        $("#edit").on("click", function() {
        	if (confirm("게시글 수정으로 이동하시겠습니까 ?")) {
        		location.href = "/board/freeUpdate?fbNo=${freeBoardVO.fbNo}";	
			}else {
				alert("취소했습니다.")
			}
        	
        	
        	
        });
        /* 게시판 수정 이동 끝 */
        
        
        /* 게시판 게시글 삭제 시작 */
        $("#delete").on("click", function() {

            if (confirm("게시글을 삭제 하시겠습니까 ?")) {
                let data = {
                    fbNo: "${freeBoardVO.fbNo}"
                }

                $.ajax({
                    url: "/board/freeDelete",
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify(data),
                    type: "post",
                    dataType: "json",
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(result) {
                        console.log("result : ", result);
                        alert("게시글이 삭제 되었습니다.")
                        location.href = "/board/freeList";
                    }
                });
            } else {
                alert("삭제를 취소 했습니다.")
            }


        });
        /* 게시판 게시글 삭제 끝 */
        
        
        
        
        
        $("#btnLikeCnt").on("click",function(){
        	let fbNo = $("#fbNo").val();
        	let fbLikeCnt = $("#fbLikeCnt").val();
        	let data = {
        			"fbNo":fbNo
        	}
        	console.log(data);
        	
        	$.ajax({
        		url:"/board/freeBoardLike",
        		contentType:"application/json;charset=utf-8",
        		data:JSON.stringify(data),
        		type:"post",
        		dataType:"json",
        		beforeSend:function(xhr){
        			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        		},
        		success:function(result){
        			console.log("result : ", result);
        			ajaxDetail();
        		}
        	});
        });
        
        $("#btnDisllikeCnt").on("click",function(){
        	let fbNo = $("#fbNo").val();
        	let data = {
        			"fbNo":fbNo
        	}
        	console.log(data);
        	
        	$.ajax({
        		url:"/board/freeBoardDisLike",
        		contentType:"application/json;charset=utf-8",
        		data:JSON.stringify(data),
        		type:"post",
        		dataType:"json",
        		beforeSend:function(xhr){
        			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        		},
        		success:function(result){
        			console.log("result : ", result);
        			ajaxDetail();
        		}
        	});
        });
        
        function ajaxDetail(){
        	let fbNo = $("#fbNo").val();
        	let data = {
        			"fbNo":fbNo
        	}
        	$.ajax({
        		url:"/board/ajaxDetail",
        		contentType:"application/json;charset=utf-8",
        		data:JSON.stringify(data),
        		type:"post",
        		dataType:"json",
        		beforeSend:function(xhr){
        			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        		},
        		success:function(result){
        			console.log("result : ", result);
        			let likeCntVal = `\${result.fbLikeCnt}`;
        			let dislikeCntVal = `\${result.fbDisllikeCnt}`;
        			console.log("likeCntVal",likeCntVal);
        			console.log("dislikeCntVal",dislikeCntVal);
        			
        			$("#btnLikeCntP").text(likeCntVal);
        			$("#btnDisllikeCntP").text(dislikeCntVal);
        		}
        	});
        };
        
    });
</script>