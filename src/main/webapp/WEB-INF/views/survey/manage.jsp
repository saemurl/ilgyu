<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
const urlParams = new URL(location.href).searchParams;
const currentPage = urlParams.get('currentPage') == null ? 1 : urlParams.get('currentPage');
const empId = ${loginVO.empId};
const header = "${_csrf.headerName}";
const token ="${_csrf.token}";
let tabId = 'all';
$(function(){
    getList("", currentPage);
    
    $('#btnInsert').on('click', function(){
        location.href="/survey/insert";
    });
   
    $('.nav-link-survey').on('click', function(){
        tabId = $(this).data('tab');
        console.log(tabId);
        getList("", 1);
    });
    
	$('#btnSearch').on('click', function(){
		let keyword = $('#search').val();
		getList(keyword, currentPage);
	});
	
	$(document).on('click', '.updateStop', function(){
		 let srvyNo = $(this).data('val');
		 Swal.fire({
		        title: '설문을 마감하시겠습니까 ?',
		        text: "마감시 복구가 불가능합니다.",
		        icon: 'warning',
		        showCancelButton: true,
		        confirmButtonText: 'Yes',
		        customClass: {
					confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
					cancelButton: 'btn btn-label-secondary waves-effect waves-light'
		        },
		        buttonsStyling: false
			}).then(function (result) {
				if (result.isConfirmed) {
					$.ajax({
						url:"/survey/updateStop",
						contentType:"application/json;charset=UTF-8",
						data:srvyNo,
						type:"post",
						beforeSend:function(xhr){
							xhr.setRequestHeader(header, token);
						},
						success:function(result){
							Swal.fire({
			            	icon: 'success',
			            	title: '설문이 마감되었습니다.',
			            	showConfirmButton: false,
			            	timer: 1500
							});
							getList("", currentPage);
						}
					})
				}
			});
	})
	
	$(document).on('click', '.surveyDel', function(){
		 let srvyNo = $(this).data('val');
		 Swal.fire({
		        title: '설문을 삭제하시겠습니까 ?',
		        text: "삭제시 복구가 불가능합니다.",
		        icon: 'warning',
		        showCancelButton: true,
		        confirmButtonText: 'Yes',
		        customClass: {
					confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
					cancelButton: 'btn btn-label-secondary waves-effect waves-light'
		        },
		        buttonsStyling: false
			}).then(function (result) {
				if (result.isConfirmed) {
					$.ajax({
						url:"/survey/delete",
						contentType:"application/json;charset=UTF-8",
						data:srvyNo,
						type:"post",
						beforeSend:function(xhr){
							xhr.setRequestHeader(header,token);
						},
						success:function(result){
							Swal.fire({
				            	icon: 'success',
				            	title: '삭제되었습니다.',
				            	showConfirmButton: false,
				            	timer:1500
							});
						}
					})
				}
		 		getList("", currentPage);
			});
	})
});


async function getList(keyword, currentPage) {
    let data = {
   		"currentPage": currentPage,
   		"stts":tabId,
   		"keyword":keyword,
   		"empId":empId
    };
    console.log("data : ", data);

    try {
        let result = await $.ajax({
            url: "/survey/getManageList",
            data: data,
            type: "get",
            dataType: "json"
        });
        console.log(result);
        let now = new Date();
        let str = `
	    	<div class="table-responsive text-nowrap">
	    		<table class="table">
	    			<thead>
	    				<tr>
	    					<th>제목</th>
	    					<th>작성일</th>
	    					<th>설문기간</th>
	    					<th>상태</th>
	    					<th>Actions</th>
	    				</tr>
	    			</thead>
	                <tbody class="table-border-bottom-0">
	    				`;
	    				for(const surveyVO of result.content){		
	    					let endTime = new Date(surveyVO.srvyEndYmd);
	    					str += `
	    						<tr>
	     					<td>
	    						<a href="/survey/result?srvyNo=\${surveyVO.srvyNo}"><span class="fw-medium">\${surveyVO.srvyTtl}</span></a>
	    					</td>
	    					<td>\${surveyVO.srvyWrtYmd}</td>
	    					<td>\${surveyVO.srvyBgngYmd} - \${surveyVO.srvyEndYmd}</td>`;
	    					if(endTime > now){
	    						str += `<td><span class="badge bg-label-primary me-1">진행중</span></td>`;
	    					}else{
	    						str += `<td><span class="badge bg-label-dark me-1">마감</span></td>`;
	    					}
	    					str += `
	                        <td>
	    						<div class="dropdown">
	    							<button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
	    								<i class="ti ti-dots-vertical"></i>
	                                </button>
	                                <div class="dropdown-menu">`;
	                                if(endTime > now){
	                                	str += `
		    								<a class="dropdown-item" href="/survey/update?srvyNo=\${surveyVO.srvyNo}"><i class="ti ti-edit me-1"></i>수정</a>
		    								<a class="dropdown-item updateStop" href="javascript:void(0);" data-val="\${surveyVO.srvyNo}" ><i class="ti ti-ban me-1"></i>마감</a>
		    								`;
	                                }else{
	                                	str += `<a class="dropdown-item surveyDel" href="javascript:void(0);" data-val="\${surveyVO.srvyNo}"><i class="ti ti-trash me-1"></i>삭제</a>`;
	                                }
	                                str += `
	                                </div>
	    						</div>
	    					</td>
	    					</tr>`;
	    				}
	    				str += `
	    			</tbody>
	    		</table>
	    	</div>`;
           	$('.box').html(str);
        	$('.pagingBox').html(result.pagingArea2);
        	$('.card-header').text(`총 \${result.total}건`);
    } catch (error) {
        console.error(error);
    }
}
</script>
<div class="row">
	<div class="col-xl-12">
		<div class="nav-align-top nav-tabs-shadow mb-4">
			<ul class="nav nav-tabs" role="tablist">
				<li class="nav-item">
				  <button type="button" class="nav-link nav-link-survey active" role="tab"
				    data-bs-toggle="tab" data-bs-target="#navs-top-all" data-tab="all"
				    aria-controls="navs-top-home"  aria-selected="true">전체</button>
				</li>
				<li class="nav-item">
				  <button type="button" class="nav-link nav-link-survey" role="tab"
				    data-bs-toggle="tab" data-bs-target="#navs-top-progress" data-tab="progress"
				    aria-controls="navs-top-profile" aria-selected="false">진행중</button>
				</li>
				<li class="nav-item">
				  <button type="button" class="nav-link nav-link-survey" role="tab"
				    data-bs-toggle="tab" data-bs-target="#navs-top-done" data-tab="done"
				    aria-controls="navs-top-messages" aria-selected="false">마감</button>
				</li>
			</ul>
			<div class="tab-content">
			<div style="display: flex;">
				<h6 class="card-header"></h6>
	        	<div class="input-group input-group-merge apprSearch">
		        	<input type="search" id="search" placeholder=" 제목검색" class="form-control" value="">
		        	<button type="button" id="btnSearch" class="input-group-text"><i class="ti ti-search"></i></button>
		        </div>
	        </div>
				<div class="tab-pane fade show active" id="navs-top-all" role="tabpanel">
					<div class="box pb-4 pt-md-3">
					</div>
		            <!-- 페이징 -->
					<div class="pagingBox"></div>
				</div>
				<div class="tab-pane fade" id="navs-top-progress" role="tabpanel">
					<div class="box pb-4 pt-md-3">
					</div>
		            <!-- 페이징 -->
					<div class="pagingBox"></div>
				</div>
				<div class="tab-pane fade" id="navs-top-done" role="tabpanel">
					<div class="box pb-4 pt-md-3">
					</div>
		            <!-- 페이징 -->
					<div class="pagingBox"></div>
				</div>
				<button class="btn btn-outline-primary" id="btnInsert">설문 등록</button>
			</div>
		</div>
	</div>
</div>
