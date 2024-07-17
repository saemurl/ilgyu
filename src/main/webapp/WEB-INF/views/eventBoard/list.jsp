<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<style>

.btn-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.btn-group {
    display: flex;
}


.custom-swal {
        width: 600px !important; /* 알림 창의 너비 */
        height: 400px !important; /* 알림 창의 높이 */
}

.btn-check{
	width: 200px;
}
</style>

<script>

$(document).ready(function() {

// 상단 결혼 / 부고 버튼 클릭에 따른 테이블 가리기 스크립트 영역 [ 시작 ] -----------------------------------------------------
	$('#ripTableArea').hide();

    $('#marryBtn').click(function() {
        $('#marryTableArea').show();
        $('#ripTableArea').hide();
    });

    $('#ripBtn').click(function() {
        $('#marryTableArea').hide();
        $('#ripTableArea').show();
    });
// 상단 결혼 / 부고 버튼 클릭에 따른 테이블 가리기 스크립트 영역 [ 종료 ] -----------------------------------------------------

// 테이블 생성 비동기 [ 시작 ] -----------------------------------------------------------------------------------------------------------
	let marryTable;        
    let ripTable;
    
    function createMarryTable() {
    	if (marryTable) {
    		marryTable.destroy();	// 이미 있으면 제거
        }

        $.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/board/loadMarryTable",
            type: "get",
            success: function(eventBoardVOList) {
            	console.log("아작스 결혼테이블 값 받아온 데이터 체크 : ", eventBoardVOList);
            	
            	let loadMarryTbl = ``;
            	
            	loadMarryTbl += `<table id="marryTable" class="table table-hover">
    			<thead>
    				<tr>
    					<th>NO</th>
    					<th>제목</th>
    					<th>등록일</th>
    					<th>조회수</th>
    					<th>작성자</th>
    				</tr>
    			</thead>
    			<tbody>`;
    			
    			$.each(eventBoardVOList, function(index, eventBoardVO) {
    	        loadMarryTbl += `
    	            <tr>
    	                <td>\${index + 1}</td>
    	                <td> <a href="/board/detail?evtbNo=\${eventBoardVO.evtbNo}&evtbSe=\${eventBoardVO.evtbSe}"> \${eventBoardVO.evtbTtl} </a> </td>
    	                <td>\${new Date(eventBoardVO.evtbDt).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/\.$/, '')}</td>
    	                <td>\${eventBoardVO.evtbCnt}</td>
    	                <td>\${eventBoardVO.empNm}</td>
    	            </tr>`;
    	    	});
    	    
	    	    loadMarryTbl += `
	    	        </tbody>
	    	    </table>`;
	    	    
	    	    $('#marryTableArea').html(loadMarryTbl);

                const myMarryTable = document.querySelector("#marryTable");
                marryTable = new simpleDatatables.DataTable(myMarryTable, {
                    labels : {
                        placeholder : "검색어를 입력해 주세요.",
                        noRows : "게시판에 작성된 글이 없습니다.",
                        info : "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
                        noResults : "검색 결과가 없습니다."
                    },
                    perPageSelect : false,
                    perPage : 10
                });
        	}
    	});
    }
	createMarryTable();	// 호출

	
    function createRipTable() {
    	if (ripTable) {
    		ripTable.destroy();	// 이미 있으면 제거
        }

    	$.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/board/loadRipTable",
            type: "get",
            success: function(eventBoardVOList) {
            	
				console.log("아작스 부고테이블 값 받아온 데이터 체크 : ", eventBoardVOList);
            	
            	let loadRipTbl = ``;
            	
            	loadRipTbl += `<table id="ripTable" class="table table-hover">
    			<thead>
    				<tr>
    					<th>NO</th>
    					<th>제목</th>
    					<th>등록일</th>
    					<th>조회수</th>
    					<th>작성자</th>
    				</tr>
    			</thead>
    			
    			
    			<tbody>`;
    			
    			$.each(eventBoardVOList, function(index, eventBoardVO) {
    				loadRipTbl += `
    	            <tr>
    	                <td>\${index + 1}</td>
    	                <td> <a href="/board/detail?evtbNo=\${eventBoardVO.evtbNo}&evtbSe=\${eventBoardVO.evtbSe}"> \${eventBoardVO.evtbTtl} </a> </td>
    	                <td>\${new Date(eventBoardVO.evtbDt).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/\.$/, '')}</td>
    	                <td>\${eventBoardVO.evtbCnt}</td>
    	                <td>\${eventBoardVO.empNm}</td>
    	            </tr>`;
    	    	});
    	    
    			loadRipTbl += `
	    	        </tbody>
	    	    </table>`;
	    	    
	    	    $('#ripTableArea').html(loadRipTbl);
            
	    	    const myRipTable = document.querySelector("#ripTable");
	            ripTable = new simpleDatatables.DataTable(myRipTable, {
	            	labels : {
	        			placeholder : "검색어를 입력해 주세요.",
	        			noRows : "게시판에 작성된 글이 없습니다.",
	        			info : "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
	        			noResults : "검색 결과가 없습니다."
	        		},
	        		perPageSelect : false,
	        		perPage : 10
	            });
            }
    	})
    };
    createRipTable();
// 테이블 생성 비동기 [ 종료 ] -----------------------------------------------------------------------------------------------------------    
   
// 게시글 등록 버튼 클릭 [ 시작 ] ------------------------------------------------------------------
	$('#insertBtn').on('click', function () {
		console.log("등록 버튼 클릭 체크");
		
		location.href = "/board/eventCreate";
	});    
// 게시글 등록 버튼 클릭 [ 종료 ] ------------------------------------------------------------------
    
    
    
});
	
    
    
    

</script>


<div class="card" style="height: 660px;">

	<div class="bg-primary"
		style="border-top-left-radius: 3px; border-top-right-radius: 3px; color: white; padding: 10px; text-align: center;">
		<p style="margin: 0px">
			<strong>경조사게시판</strong>
		</p>
	</div>


	<div style="padding: 20px;">
		<div class="btn-toolbar" role="toolbar" aria-label="Toolbar with button groups">
		    <div class="btn-group me-2" role="group" aria-label="First group" style="margin-left: 20px; width: 250px;">
		        <input type="radio" class="btn-check" name="btnradio" id="marryBtn" checked>
		        <label class="btn btn-outline-primary waves-effect" for="marryBtn">결혼</label>
		
		        <input type="radio" class="btn-check" name="btnradio" id="ripBtn">
		        <label class="btn btn-outline-primary waves-effect" for="ripBtn">부고</label>
		    </div>
		    <button class="btn btn-primary" id="insertBtn" style="margin-right: 60px;">게시글 등록</button>
		</div>
		
	    <div id="marryTableArea">
			<!-- 결혼 테이블 생성 영역 -->
		</div>
	
	
		<div id="ripTableArea">
			<!-- 부고 테이블 생성 영역 -->
		</div>
	</div>
</div>
