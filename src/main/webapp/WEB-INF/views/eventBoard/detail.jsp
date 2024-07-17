<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

<style>

img{
	width: 560px;
    height: 660px;
    border-radius: 15px;
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
	
	$('#listBtn').on('click', function () {		// 버튼 [목록]
		location.href = "/board/eventList";
	});
	
	$('#mrgEdit').on('click', function () {		// 버튼 [결혼 수정]
		let evtbNo = "${marriageVO.evtbNo}";
		location.href = "/board/update?evtbNo=" + evtbNo;
	});
	
	$('#mrgDelete').on('click', function () {	// 버튼 [결혼 삭제]
		let evtbNo = "${marriageVO.evtbNo}";
		console.log("삭제할 게시글 PK 값 : " + evtbNo);
		Swal.fire({
		    html: "해당 게시글을 삭제하시겠습니까?",
		    icon: 'warning',
		    showCancelButton: true,
		    confirmButtonColor: '#3085d6',
		    cancelButtonColor: '#d33',
		    cancelButtonText: "닫기",
		    confirmButtonText: "삭제",
		    customClass: {
		        confirmButton: 'btn btn-warning me-1',
		        cancelButton: 'btn btn-label-secondary'
		    },
		    buttonsStyling: false
		}).then(function(result) {
		    if (result.isConfirmed) {
				
		    	let data = {"evtbNo" : evtbNo};
		    	$.ajax({
					url:"/board/deleteMrg",
					contentType:"application/json;charset=utf-8",
					data:JSON.stringify(data),
					type:"post",
					dataType:"text",
					beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
					success:function(result){
						Swal.fire({
					        icon: 'success',
					        title: '',
					        text: '정상적으로 삭제되었습니다.',
					        customClass: {
					            confirmButton: 'btn btn-success'
					        }
					    }).then((result) => {
					        if (result.isConfirmed) {
					            location.href = "/board/eventList";
					        }
					    });
					}
            	});
		    	
		    }
		});
	});
	
	$('#obtEdit').on('click', function () {		// 버튼 [부고 수정]
		let evtbNo = "${obituaryVO.evtbNo}";
		location.href = "/board/update?evtbNo=" + evtbNo;
	});
	
	$('#obtDelete').on('click', function () {	// 버튼 [부고 삭제]
		let evtbNo = "${obituaryVO.evtbNo}";
		console.log("삭제할 게시글 PK 값 : " + evtbNo);
		Swal.fire({
		    html: "해당 게시글을 삭제하시겠습니까?",
		    icon: 'warning',
		    showCancelButton: true,
		    confirmButtonColor: '#3085d6',
		    cancelButtonColor: '#d33',
		    cancelButtonText: "닫기",
		    confirmButtonText: "삭제",
		    customClass: {
		        confirmButton: 'btn btn-warning me-1',
		        cancelButton: 'btn btn-label-secondary'
		    },
		    buttonsStyling: false
		}).then(function(result) {
		    if (result.isConfirmed) {
				
		    	let data = {"evtbNo" : evtbNo};
		    	$.ajax({
					url:"/board/deleteObt",
					contentType:"application/json;charset=utf-8",
					data:JSON.stringify(data),
					type:"post",
					dataType:"text",
					beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
					success:function(result){
						Swal.fire({
					        icon: 'success',
					        title: '',
					        text: '정상적으로 삭제되었습니다.',
					        customClass: {
					            confirmButton: 'btn btn-success'
					        }
					    }).then((result) => {
					        if (result.isConfirmed) {
					            location.href = "/board/eventList";
					        }
					    });
					}
            	});
		    	
		    }
		});
	});
	
	// PerfectScrollbar 초기화
	var evtbSe = '<%= request.getAttribute("evtbSe") %>';
	if (evtbSe === 'E01') {
		new PerfectScrollbar(document.getElementById('mrgScroll'), {
			wheelPropagation: false
		});
	} else if (evtbSe === 'E02') {
		new PerfectScrollbar(document.getElementById('obtScroll'), {
			wheelPropagation: false
		});
	}
	
});
</script>

<!-- [ 결혼 글 ]일 때 출력되는 영역 ───────────────────────────────────────────────────────────────────────────────────────────────────────── -->
<%
    String evtbSe = (String) request.getAttribute("evtbSe");
    if ("E01".equals(evtbSe)) {
%>
	<div style="display: flex; gap: 20px;">
	    <div class="card" id="leftPanel" style="padding: 20px; width: 40vw;">
	    	<a href="<%=request.getContextPath() %>/board/eventList">경조사게시판 ></a>
	    	<br>
	    	
	    	<div class="detail-header col-12">
		        <div class="title">
		            <h3>${marriageVO.mrgTtl}</h3>
		        </div>
		        <div class="info">
		            <div>작성자 : ${eventBoardVO.empNm}</div>
		            <div>작성일 : <fmt:formatDate value="${eventBoardVO.evtbDt}" pattern="yyyy-MM-dd"></fmt:formatDate></div>
		        </div>
		    </div>
	    	<hr/>
			
			<div class="col-12">
        		<p>예식일 : ${marriageVO.mrgDt}</p>
        		<p>장 소 : ${marriageVO.mrgAddr}</p>
        		<p>상세주소 : ${marriageVO.mrgDaddr}</p>
        		<div id="mrgScroll" style="white-space: pre-wrap; height: 320px; overflow: auto;">
				    <p>${marriageVO.mrgCon}</p>
				</div>
    		</div>
    		<hr class="mt-0" />
	        <div class="eventBtn">
	    		<c:if test="${eventBoardVO.empId eq loginEmpId}">
	            	<button type="button" id="mrgEdit" class="btn btn-label-warning waves-effect" style="margin-right: 10px;">수정</button>
	            	<button type="button" id="mrgDelete" class="btn btn-label-danger waves-effect" style="margin-right: 10px;">삭제</button>
		    	</c:if>
        			<button type="button" class="btn btn-label-secondary waves-effect" id="listBtn">목록</button>
	        </div>
	    </div>
	    
	    <div class="card" id="rightMrgPanel" style="flex: 1; height: 700px; align-items: center; justify-content: space-around;">
	    	<img alt="이미지" src="/upload${imgPath}">
	    </div>
	    
	</div>	    

	    <div class="card" id="leftBottomMrgPanel">
	        <div>
	           	<h3 id="mrgMent" style="margin: 0px;">
	           		두 분의 인생이 더욱 아름답고 빛나는 순간들로 가득하길 기원합니다.
	           	</h3>
	        </div>
		</div>
    
    
<!-- [ 부고 글 ]일 때 출력되는 영역 ───────────────────────────────────────────────────────────────────────────────────────────────────────── -->    
<%
    } else if ("E02".equals(evtbSe)) {
%>
	
	<div style="display: flex; gap: 20px;">
	    <div class="card" id="leftPanel" style="padding: 20px; width: 40vw; height: 700px;">
	        <a href="<%=request.getContextPath() %>/board/eventList">경조사게시판 ></a>
	        <br>
	        
	        <div class="detail-header col-12">
	            <div class="title">
	                <h3>${obituaryVO.obtTtl}</h3>
	            </div>
	            <div class="info">
	                <div>작성자 : ${eventBoardVO.empNm}</div>
	                <div>작성일 : <fmt:formatDate value="${eventBoardVO.evtbDt}" pattern="yyyy-MM-dd"></fmt:formatDate></div>
	            </div>
	        </div>
	        <hr/>
	        
	        <div class="col-12">
	            <p>별 세 : ${obituaryVO.obtDmDt}</p>
	            <p>발 인 : ${obituaryVO.obtFpDt}</p>
	            <p>빈 소 : ${obituaryVO.obtAddr}</p>
	            <p>상세주소 : ${obituaryVO.obtDaddr}</p>

	            <div id="obtScroll" style="white-space: pre-wrap; height: 320px; overflow: auto;">
	                <p>${obituaryVO.obtCon}</p>
	            </div>
	        </div>
	        <hr class="mt-0" />
	        <div class="eventBtn">
	            <c:if test="${eventBoardVO.empId eq loginEmpId}">
	                <button type="button" id="obtEdit" class="btn btn-label-warning waves-effect" style="margin-right: 10px;">수정</button>
	                <button type="button" id="obtDelete" class="btn btn-label-danger waves-effect" style="margin-right: 10px;">삭제</button>
	            </c:if>
	            <button type="button" class="btn btn-label-secondary waves-effect" id="listBtn">목록</button>
	        </div>
	    </div>
	
	    <div class="card" id="rightRipPanel" style="flex: 1; height: 700px; align-items: center; justify-content: space-around;">
	    	<img alt="이미지" src="/upload${imgPath}">
	    </div>
	</div>

	<div class="card" id="leftBottomRipPanel" style="margin-top: 10px;">
	    <div>
	        <h3 id="ripMent" style="margin: 0px;">
	            	삼가 고인의 冥福을 빌며, 평안한 安息을 기원합니다.
	        </h3>
	    </div>
	</div>

	
<%
    }
%>

<script src="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>