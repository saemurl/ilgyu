<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
const urlParams = new URL(location.href).searchParams;
const currentPage = urlParams.get('currentPage') == null ? 1 : urlParams.get('currentPage');

$(function(){
    let currentPage = 1;
    let keyword = '';
    
 	// 페이지 로드 시 초기 리스트 가져오기
    getList(currentPage, keyword);
    
 	// 검색 버튼 클릭 시 리스트 가져오기
    $('#btnRequestSearch').on('click', function(){
        keyword = $('#requestSearch').val();
        getList(currentPage, keyword);
    });
    
    // 검색란에서 엔터 키를 누르면 리스트 가져오기
    $('#requestSearch').on('keyup', function(event){
        if (event.keyCode === 13) { // 엔터 키의 keyCode는 13
            keyword = $(this).val();
            getList(currentPage, keyword);
        }
    });
});

function getList(currentPage, keyword){
	let data = { 
			"currentPage": currentPage,
			"keyword": keyword
			};
	$.ajax({
		url:"/approval/getRequestList",
		type:"get",
		data:data,
		success:function(result){
			console.log("result : ",result);
			let str = "";
			if(result.total == 0){
				str += `<td colspan="6" class="center" style="height:100px">결재요청 문서가 없습니다.</td>`;
			}
			for(const approvalVO of result.content){
		        str += `<tr>`;
		        if(approvalVO.aprvrEmgyn === 'Y'){
		        	str += `<td><h6 class="mb-0 align-items-center d-flex text-danger"><i class="ti ti-circle-filled fs-tiny me-2"></i>긴급</h6></td>`;
		        }else{
		        	str += `<td></td>`;
		        }
                str += `    
                    <td><a href="/approval/detail?aprvrDocNo=\${approvalVO.aprvrDocNo}">\${approvalVO.aprvrDocTtl}</a></td>
                    <td class="text-center">\${approvalVO.strWrtYmd}</td>
                    <td>
                    	<div class="d-flex justify-content-center align-items-center order-name text-nowrap">

                        	<div class="d-flex flex-column">
                            	<h6 class="m-0">
                            		<a href="pages-profile-user.html" class="text-body">\${approvalVO.writer}</a>
                            	</h6>
                        		<small class="text-muted">\${approvalVO.writerDept}</small>
                        	</div>
                    	</div>
                    </td>
                    <td class="text-center"><span class="badge bg-label-warning">진행</span></td>
	                    <td>
	                        <div class="progress-container">
	                            <div class="progress-line"></div>`;
	                for(const approvalLine of approvalVO.approvalLineList){
	                	console.log(approvalLine.alStts);
	                	if(approvalLine.alStts === 'A02'){
	                		str += `
	                			<div class="progress-step rejected">
	                                <div class="icon">
	                                    <i class="fa-solid ti ti-arrow-forward-up"></i>
	                                </div>
                                	<p>\${approvalLine.approver}</p>
                            	</div>
	                		`;
	                	}else if(approvalLine.alStts === 'A04' || approvalLine.alStts === 'A05'){
	                		str += `                            
		                		<div class="progress-step">
	                                <div class="icon">
	                                </div>
	                                <p>\${approvalLine.approver}</p>
	                            </div>
                            `;
	                	}else if(approvalLine.alStts === 'A03' || approvalLine.alStts === 'A01'){
	                		str += `
	                			<div class="progress-step completed">
	                                <div class="icon">
	                                <i class="fa-solid fa-check"></i>
	                                </div>
                                	<p>\${approvalLine.approver}</p>
                            	</div>
	                		`;
	                	}
	                }
                      str+=`
                        </div>
                    </td>
                </tr>
		        `; 
			}
			$('#test').html(str);
			$('.pagingBox').html(result.pagingArea2);
			$('#total').text(`총 \${result.total}건`);
		}
	})
}
</script>

<div class="app-email card" id="approval">
    <div class="row g-0">
        <!-- 문서함 리스트 -->
        <%@ include file="subMenu.jsp" %>
        <!--// 문서함 리스트 -->
        
		<!-- 컨텐츠 영역 -->
        <div class="col flex-grow-0 approval-list">
        
        	<!-- 건수/검색 영역 -->
			<div class="d-flex justify-content-between align-items-center">
			    <h6 class="text-muted total apprTotal m-0" id="total"></h6>
			    <div class="input-group input-group-merge apprSearch">
			        <input type="search" id="requestSearch" placeholder="제목검색" class="form-control" value="">
			        <button type="button" id="btnRequestSearch" class="input-group-text"><i class="ti ti-search"></i></button>
			    </div>
			</div>
			<!-- // 건수/검색 영역 -->
			
	        <div class="card noshadow">
	            <div class="card-datatable table-responsive">
	                <table class="datatables-approval-index table border-top">
	                	<colgroup>
	                		<col width="120px" />
	                		<col width="*" />
	                		<col width="15%" />
	                		<col width="10%" />
	                		<col width="10%" />
	                		<col width="240px" />
	                	</colgroup>
	                    <thead>
	                        <tr>
	                            <th>긴급</th>
	                            <th>제목</th>
	                            <th class="text-center">기안일</th>
	                            <th class="text-center">기안자</th>
	                            <th class="text-center">결재상태</th>
	                            <th></th>
	                        </tr>
	                    </thead>
	                    <tbody id="test">
	
	                    </tbody>
	                </table>
	            </div>
				<!-- 페이징 -->
				<div class="pagingBox"></div>
			</div>
        </div>
        <!--// 컨텐츠 영역 -->
    </div>
</div>
