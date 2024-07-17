<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
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
    img {
	    width: 450px;
	    height: 600px;
    }
</style>
<div style="display: none;">
    <h1>No : <input type="text" class="ntcTtl" id="ntcNo" value="${noticeBoardVO.ntcNo}"></h1>
    <h1>제목 : <input type="text" class="ntcTtl" id="ntcTtl" value="${noticeBoardVO.ntcTtl}"></h1>
    <p>내용 : <textarea cols="50" rows="3" readonly>${noticeBoardVO.ntcCn}</textarea></p>
    <p>최초 등록자 : <input type="text" id="ntcFrstRgtr" value="${noticeBoardVO.ntcFrstRgtr}" readonly></p>
    <p>로그인 회원번호 : <input type="text" id="empId" value="${empId}" readonly></p>
    <p>작성자 : <input type="text" id="empNm" value="${noticeBoardVO.empNm}" readonly></p>
    <p>등록일 :
        <fmt:formatDate value="${noticeBoardVO.ntcFrstRegYmd}" pattern="yyyy/MM/dd" />
        <c:set var="loginEmp" value="${empId}"></c:set>
        <c:set var="ntcFrstRgtr" value="${noticeBoardVO.ntcFrstRgtr}"></c:set>
</div>
<div class="card">
    <br>
    <a href="<%=request.getContextPath() %>/board/noticeList">공지사항 ></a>
    <br>
    <div class="detail-header col-12">
        <div class="title">
            <h3>${noticeBoardVO.ntcTtl}</h3>
        </div>
        <div class="info">
            <div>작성자 : ${noticeBoardVO.empNm}</div>
            <div>작성일 :
                <fmt:formatDate value="${noticeBoardVO.ntcFrstRegYmd}" type="both" dateStyle="medium" timeStyle="medium" />
            </div>
        </div>
    </div>

<hr>

<div class="col-12">
		<!-- 게시판 내용 -->
	    <p>${noticeBoardVO.ntcCn}</p>
</div>


<hr class="mt-0" />
        <div class="freeBtn">
        		<button type="button" id="list" class="btn rounded-pill me-2 btn-label-warning report-btn">목록</button>
    		<c:if test="${loginEmp eq ntcFrstRgtr}">
            	<button type="button" id="edit" class="btn rounded-pill me-2 btn-label-success">수정</button>
            	<button type="button" id="delete" class="btn rounded-pill me-2 btn-label-danger">삭제</button>
	    	</c:if>
        </div>
</div>

<script type="text/javascript">
$(function() {

    $("#list").on("click",function(){
        //목록
        location.href="/board/noticeList";
    });
    
    $("#edit").on("click",function(){
        //수정
        location.href="/board/noticeUpdate?ntcNo=${noticeBoardVO.ntcNo}";
    });
    
    $("#delete").on("click",function(){
        //삭제
        Swal.fire({
             title: '',
             text: "작성글을 삭제하시겠습니까?",
             icon: 'warning',
             showCancelButton: true,
             confirmButtonColor: '#3085d6',
             cancelButtonColor: '#d33',
             cancelButtonText: "취소",
             confirmButtonText: "삭제",
             customClass: {
               confirmButton: 'btn btn-primary me-1',
               cancelButton: 'btn btn-label-secondary'
             },
             buttonsStyling: false
           }).then(function(result) {
             if (result.value) {
                 let data = {
                      ntcNo: "${noticeBoardVO.ntcNo}"
                 };
                 $.ajax({
                     url:"/board/noticeDelete",
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
});
</script>

<script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>
