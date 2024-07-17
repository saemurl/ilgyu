<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript">
$(function(){
	getList();
	
	fetch("/approval/getTotalBySubmenu")
	.then((resp)=>{
		resp.json().then((data)=>{
			console.log(data);
			$('#pTotal').text(data.progressTotal);
			$('#rTotal').text(data.requestTotal);
			$('#rfTotal').text(data.referenceTotal);
		})
	})
	
	$('#card-1').on('click', function(){
		location.href = "/approval/progress";
	});
	
	$('#card-2').on('click', function(){
		location.href = "/approval/request";
	});
	
	$('#card-3').on('click', function(){
		location.href = "/approval/reference";
	});
});


function getList(){
	$.ajax({
		url:"/approval/getAllList",
		type:"get",
		success:function(result){
			console.log(result);
			let str = "";
			for(const approvalVO of result){
		        str += `<tr>`;
		        if(approvalVO.aprvrEmgyn === 'Y'){
		        	str += `<td><h6 class="mb-0 align-items-center d-flex text-danger"><i class="ti ti-circle-filled fs-tiny me-2"></i>긴급</h6></td>`;
		        }else{
		        	str += `<td></td>`;
		        }
                str += `    
                    <td><a href="/approval/detail?aprvrDocNo=\${approvalVO.aprvrDocNo}">\${approvalVO.aprvrDocTtl}</a></td>
                    <td>\${approvalVO.strWrtYmd}</td>
                    <td>
                    	<div class="d-flex justify-content-start align-items-center order-name text-nowrap">

                        	<div class="d-flex flex-column">
                            	<h6 class="m-0">
                            		<a href="pages-profile-user.html" class="text-body">\${approvalVO.writer}</a>
                            	</h6>
                        		<small class="text-muted">\${approvalVO.writerDept}</small>
                        	</div>
                    	</div>
                    </td>
                    <td><span class="badge bg-label-warning">진행</span></td>
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
		}
	})
}

</script>
<div class="row">
    <div class="col-xl-10 mb-4 col-md-12">
        <div class="app-email card" id="approval">
            <div class="row g-0">
                <!-- 문서함 리스트 -->
                <%@ include file="subMenu.jsp" %>
                <!--// 문서함 리스트 -->
                <div class="col flex-grow-0 approval-list" id="approval-list">
                    <div class="row g-4 p-4">
                        <div class="col-sm-6 col-xl-4">
                            <div class="card" id="card-1">
                                <div class="card-body">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="content-left">
                                            <h4 class="mb-0" id="pTotal"></h4>
                                            <small>결재 진행</small>
                                        </div>
                                        <span class="badge bg-label-secondary rounded-circle p-2">
                                            <i class="ti ti-ballpen ti-md"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <div class="card" id="card-2">
                                <div class="card-body">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="content-left">
                                            <h4 class="mb-0" id="rTotal"></h4>
                                            <small>결재 요청</small>
                                        </div>
                                        <span class="badge bg-label-secondary rounded-circle p-2">
                                            <i class="ti ti-alert-circle ti-md"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <div class="card" id="card-3">
                                <div class="card-body">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="content-left">
                                            <h4 class="mb-0" id="rfTotal"></h4>
                                            <small>수신 참조</small>
                                        </div>
                                        <span class="badge bg-label-secondary rounded-circle p-2">
                                            <i class="ti ti-archive ti-md"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row g-0">
                    	<div class="p-2 text-muted"><i class="ti ti-exclamation-circle"></i> 최근 진행중인 문서</div>
                        <!-- datatables-approval-index -->
                        <div class="card noshadow">
                            <div class="card-datatable table-responsive">
                                <table class="datatables-approval-index table border-top">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>제목</th>
                                            <th>기안일</th>
                                            <th>기안자</th>
                                            <th>결재상태</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody id="test">
 
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-xl-2 col-sm-6 mb-4">
        <div class="row">
            <div class="col-xl-12 mb-4 col-md-6">
                <div id="wizard-property-listing" class="bs-stepper vertical">
                    <div class="bs-stepper-header" id="approval-link">
                        <div class="step" data-target="#personal-details">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT01'">
                                <span class="bs-stepper-circle"><i class="ti ti-clipboard-text ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">업무기안</span>
                                    <span class="bs-stepper-subtitle">일반</span>
                                </span>
                            </button>
                        </div>
                        <div class="line"></div>
                        <div class="step" data-target="#property-details">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT03'">
                                <span class="bs-stepper-circle"><i class="ti ti-clipboard-text ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">일반품의서</span>
                                    <span class="bs-stepper-subtitle">일반</span>
                                </span>
                            </button>
                        </div>
                        <div class="line"></div>
                        <div class="step" data-target="#property-features">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT04'">
                                <span class="bs-stepper-circle"><i class="ti ti-clipboard-text ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">회의록</span>
                                    <span class="bs-stepper-subtitle">일반</span>
                                </span>
                            </button>
                        </div>
                        <div class="line"></div>
                        <div class="step" data-target="#property-area">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT05'">
                                <span class="bs-stepper-circle"><i class="ti ti-coins ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">유류비청구서</span>
                                    <span class="bs-stepper-subtitle">지출</span>
                                </span>
                            </button>
                        </div>
                        <div class="line"></div>
                        <div class="step" data-target="#price-details">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT02'">
                                <span class="bs-stepper-circle"><i class="ti ti-coins ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">지출결의서</span>
                                    <span class="bs-stepper-subtitle">지출</span>
                                </span>
                            </button>
                        </div>
                        <div class="line"></div>
                        <div class="step" data-target="#price-details">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT06'">
                                <span class="bs-stepper-circle"><i class="ti ti-users ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">휴직원</span>
                                    <span class="bs-stepper-subtitle">인사</span>
                                </span>
                            </button>
                        </div>
                        <div class="line"></div>
                        <div class="step" data-target="#price-details">
                            <button type="button" class="step-trigger" onclick="location.href='/approval/new?atCd=AT10'">
                                <span class="bs-stepper-circle"><i class="ti ti-notebook ti-sm"></i></span>
                                <span class="bs-stepper-label">
                                    <span class="bs-stepper-title">사무용품 신청서</span>
                                    <span class="bs-stepper-subtitle">회계</span>
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders last week -->
            <div class="col-xl-12 col-md-6">
                <div class="card h-100">
                    <div class="card-header pb-3">
                        <h5 class="card-title mb-0">결재 통계</h5>
                        <small class="text-muted">지난 1주일</small>
                    </div>
                    <div class="card-body">
                        <div id="ordersLastWeek"></div>
                        <div class="d-flex justify-content-between align-items-center gap-3">
                            <h4 class="mb-0" id="staticTotal"></h4>
                            <small class="text-success">+12.6%</small>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>