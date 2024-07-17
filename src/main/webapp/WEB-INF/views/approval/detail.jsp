<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/perfect-scrollbar/1.5.3/css/perfect-scrollbar.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/perfect-scrollbar/1.5.3/perfect-scrollbar.min.js"></script>
<input type="hidden" value="${approvalVO.empId}" id="writer">
<input type="hidden" value="${approvalVO.aprvrDocTtl}" id="apprTitle">
<div class="app-email card" id="approval">
    <div class="row g-0">
        <!-- 문서함 리스트 -->
        <%@ include file="subMenu.jsp" %>
        <!--// 문서함 리스트 -->
        
		<!-- 컨텐츠 영역 -->
        <div class="col flex-grow-0 approval-list scrollable-content" id="contentBox">
        <div class="detail">
        	<div class="detail-header pb-2">
        		<div style="margin-right: auto;">
					<c:if test="${approvalVO.aprvrEmgyn eq 'Y'}">
						<span class="badge bg-label-warning">긴급</span>
					</c:if>
						<span class="badge bg-label-primary">${approvalVO.atNm}</span>
					<div style="display: flex; align-items: center;" class="mt-1">
						<h3>${approvalVO.aprvrDocTtl}</h3>
<%-- 						<h6 class="text-muted apprTotal"> in ${approvalVO.atNm}</h6> --%>
					</div>
				</div>
				<table class="apprTable">
					<tr>
						<th rowspan="2">결재선</th>
					</tr>
					<tr>
						<c:forEach var="approvalLineVO" items="${approvalVO.approvalLineList}" varStatus="stat">
							<input type="hidden" value="${approvalLineVO.alAutzrNm}" class="alId">
							<td>
								<div class="bb-1">${approvalLineVO.approverJob}</div>
				                <div class="approved bb-1">
				                <c:choose>
				                	<c:when test="${approvalLineVO.alStts == 'A03' || approvalLineVO.alStts == 'A01'}">
				                		<img src="/resources/images/stamp_approved.png" />
				                	</c:when>
				                	<c:otherwise>
				                		<div style="height: 40px"></div>
				                	</c:otherwise>
				                </c:choose>
				                	<div>${approvalLineVO.approver}</div>  
				                </div>
									<c:if test="${approvalLineVO.alCmptnYmd != null}">
										<c:choose>
											<c:when test="${approvalLineVO.alStts == 'A02'}">
												<div style="color: red;"><fmt:formatDate value="${approvalLineVO.alCmptnYmd}" pattern="MM/dd"  />반려</div>
											</c:when>
											<c:otherwise>
												<div><fmt:formatDate value="${approvalLineVO.alCmptnYmd}" pattern="yyyy/MM/dd"  /></div>
											</c:otherwise>
										</c:choose>
									</c:if>
									<c:if test="${approvalLineVO.alCmptnYmd == null}">
										<div><br></div>
									</c:if>
							</td>
						</c:forEach>
					</tr>
				</table>
			</div>
			<hr>
			<div id="detail-con-wrap" class="pb-3" style="width: 100%">
				${approvalVO.aprvrDocCn}
			</div>
			<div id="attachView" class="mb-2">
			<div class="attach-header">
				<span><i class="ti ti-paperclip clipIcon"></i> 첨부파일</span>
				<span class="num">${fileTotal}</span>개
			</div>
				<c:choose>
					<c:when test="${approvalVO.fileList[0].atchfileSn != null}">
					<ul class="attach-body">
						<c:forEach var="fileVO" items="${approvalVO.fileList}" varStatus="stat">
							<li>
								<a href="/download/${fileVO.atchfileSn}/${fileVO.atchfileDetailSn}" >${fileVO.atchfileDetailLgclfl}</a>
								<span class="size">(${fileVO.atchfileDetailSize}KB)</span>
								<a href="/download/${fileVO.atchfileSn}/${fileVO.atchfileDetailSn}" ><i class="ti ti-download ms-2"></i></a>
							</li>
						</c:forEach>
					</ul>
					</c:when>
				</c:choose>
			</div>
			<div id="attachView" class="mb-2">
			<div class="attach-header">
				<span><i class="ti ti-paperclip clipIcon"></i> 관련문서</span>
			</div>
				<c:choose>
					<c:when test="${relatedApprovalList[0].raNo != null}">
					<ul class="attach-body">
						<c:forEach var="RelatedApprovalVO" items="${relatedApprovalList}" varStatus="stat">
							<li>
								<a href="/approval/detail?aprvrDocNo=${RelatedApprovalVO.raNo}" onclick="window.open(this.href, '_blank', 'width=800, height=600'); return false;">[${RelatedApprovalVO.raNo}] ${RelatedApprovalVO.raTitle}</a>
							</li>
						</c:forEach>
					</ul>
					</c:when>
				</c:choose>
			</div>
			<div class="pt-3">
				<ul class="nav nav-tabs tabs-line m-0">
					<li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-update">
                          <i class="ti ti-edit me-2"></i>
                          <span class="align-middle">결재선</span>
                        </button>
                      </li>
                      <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-activity">
                          <i class="ti ti-trending-up me-2"></i>
                          <span class="align-middle">참조자</span>
                        </button>
                      </li>
                    </ul>
                    <div class="tab-content px-0 pb-0 p-0">
                      <!-- Update item/tasks -->
                      <div class="tab-pane fade show active" id="tab-update" role="tabpanel">
                      		<c:forEach var="approvalLineVO" items="${approvalVO.approvalLineList}" varStatus="stat">
	                      		<div class="d-flex justify-content-start align-items-center order-name text-nowrap pt-3 pl-2">
	                               	<div class="avatar-wrapper">
	                                   	<div class="avatar me-2">
	                                   		<img src="/view/${approvalLineVO.alAutzrNm}" alt="Avatar" class="rounded-circle">
	                                   	</div>
	                               	</div>
	                              	<div class="d-flex flex-column">
	                                   	<h6 class="m-0">
	                                   		<a href="pages-profile-user.html" class="text-body">${approvalLineVO.approver} ${approvalLineVO.approverJob}</a>
	                                   	</h6>
	                               		<small class="text-muted">${approvalLineVO.approverDept}</small>
	                               		<small class="text-muted">${approvalLineVO.status} | ${approvalLineVO.strAlYmd}</small>
		                               	<c:if test="${approvalLineVO.alCm != null}">
		                               		<small class="text-muted rejectArea px-2">${approvalLineVO.alCm}</small>
		                               	</c:if>
	                               	</div>
	                           	</div> 
                            </c:forEach>
                      </div> 
                      <!-- Activities -->
                      <div class="tab-pane fade" id="tab-activity" role="tabpanel">
                      <c:choose>
	                      <c:when test="${approvalVO.corbonCopyList[0].corbon != null}">
	                      		<c:forEach var="corbonCopyVO" items="${approvalVO.corbonCopyList}" varStatus="stat">
	                      			<input type="hidden" value="${corbonCopyVO.accCc}" class="ccId">
		                      		<div class="d-flex justify-content-start align-items-center order-name text-nowrap  pt-3 pl-2">
										<div class="avatar-wrapper">
											<div class="avatar me-2">
												<img src="/view/${corbonCopyVO.accCc}" alt="Avatar" class="rounded-circle">
											</div>
										</div>
										<div class="d-flex flex-column">
											<h6 class="m-0">
												<a href="pages-profile-user.html" class="text-body">${corbonCopyVO.corbon}</a>
											</h6>
											<small class="text-muted">전략기획팀</small>
											<c:choose>
												<c:when test="${corbonCopyVO.accUseyn eq 'N' }">
													<small class="text-muted">미확인</small>
												</c:when>
												<c:when test="${corbonCopyVO.accUseyn eq 'Y' }">
													<small class="text-muted">확인일시 | <fmt:formatDate value="${corbonCopyVO.accIdntyDt}" pattern="yyyy.MM.dd(E) HH:mm"  /></small>
												</c:when>	
											</c:choose>
										</div>
									</div> 
	                      		</c:forEach>
							</c:when>
							<c:otherwise>
								<div class="pl-2 pt-3">지정된 참조자가 없습니다.</div>
	 						</c:otherwise>
						</c:choose>
					</div>
					</div>
				</div>
			<hr />  
            <div class="d-flex float-end pb-5">
            <c:forEach var="approvalLineVO" items="${approvalVO.approvalLineList}" varStatus="stat">
            	<c:if test="${approvalLineVO.alStts == 'A04' && approvalLineVO.alAutzrNm == loginVO.empId}">
		        	<div>
		        		<button type="button" class="btn btn-label-primary" data-bs-toggle="modal" data-bs-target="#approveModal">승인</button>
		        		<button type="button" class="btn btn-label-dark" data-bs-toggle="modal" data-bs-target="#rejectModal">반려</button>
		        	</div>
	        	</c:if>
	        </c:forEach>
	        	<div style="padding-left: 3px" id="writerTool">
	        		<button class="btn btn-outline-primary" id="reCreateBtn">재기안</button>
	        		<!-- 결재자가 결재 전일 경우에만 상신취소 가능 -->
		        	<c:if test="${approvalVO.approvalLineList[1].alStts == 'A04'}">
		        		<button class="btn btn-outline-dark" id="approveCancelBtn" data-bs-toggle="modal" data-bs-target="#cancelModal">상신취소</button>
		        	</c:if>	
	    		</div>
	    		<div style="padding-left: 3px">
<!-- 	        		<button>보관함</button> -->
	        		<button class="btn btn-outline-success" id="btnList">목록</button>
	    		</div>
    		</div>  
     	</div>
     	</div>
     	<!--// 컨텐츠 영역 -->
	</div>
</div>

<script type="text/javascript">
const urlParams = new URL(location.href).searchParams;
const aprvrDocNo= urlParams.get('aprvrDocNo');
const empId = ${loginVO.empId};
const writer = ${approvalVO.empId};
const header = "${_csrf.headerName}";
const token ="${_csrf.token}";
let apprTitle = $("#apprTitle").val();


let alId = document.querySelectorAll('.alId');
let ccId = document.querySelectorAll('.ccId');
let id = [];
let cId = [];

for(let i=0; i<alId.length; i++){
	id.push(alId[i].value);
}
for(let i=0; i<ccId.length; i++){
	cId.push(ccId[i].value);
}


// 로그인한 직원이 기안자가 아니라면 재기안/상신취소 버튼 가림
if(empId != writer){
	console.log(empId != writer);
	$('#writerTool').hide();
}

new PerfectScrollbar(document.getElementById('contentBox'), {
    wheelPropagation: false
});


ClassicEditor.create(document.querySelector('#ckMessage'), 
		{
			ckfinder:{
				uploadUrl:'/image/upload?${_csrf.parameterName}=${_csrf.token}'
			},
		})
		.then(editor=>{window.editor=editor;})
		.catch(err=>{console.error(err.stack);});

/* 목록 버튼을 눌렀을 때 */
$('#btnList').on('click', function(){
	history.back();
});

/* 재기안 버튼을 눌렀을 때 */
$('#reCreateBtn').on('click', function(){
	location.href = `/approval/reapply/\${aprvrDocNo}`;
})

/* 상신취소 버튼을 눌렀을 때 */
$('#btnCancelOK').on('click', function(){
	let data = {
		"aprvrDocNo":aprvrDocNo,
	}
	fetch("/approval/approveCancel",{
		method:"post",
		headers:{
			"Content-Type":"application/json;charset=UTF-8",
			[header]: token
		},
		body:JSON.stringify(data)
	}).then((resp)=>{
		resp.text().then((data)=>{
			console.log(data);
			
			let approveCL = "approveCL";
			
			for(let i= 0; i < id.length ; i++){
				if (id[i] == writer) {
					continue;
				}
				
				let socketMsg	=	{
		       			"title":approveCL,
		       			"senderId":writer,
		       			"receiverId":id[i],
		       			"apprTitle":apprTitle,
		       	}
		       	
		       	socket.send(JSON.stringify(socketMsg));
			}
			
			
			location.href = "/approval/tempsave";
		})
	})
})

/* 승인 버튼을 눌렀을 때 */
$('#btnApprove').on('click', function(){
	let data = {
		"aprvrDocNo":aprvrDocNo,
		"alAutzrNm":empId
	}
	fetch("/approval/approve",{
		method:"post",
		headers:{
			"Content-Type":"application/json;charset=UTF-8",
			[header]: token
		},
		body: JSON.stringify(data)
	}).then((resp)=>{
		resp.text().then((data)=>{
			console.log(data);
			
			if(id[id.length-1] == empId){
				console.log("마지막 결재자")
				
				let approve = "approve";
				let socketMsg	=	{
		       			"title":approve,
		       			"senderId":empId,
		       			"receiverId":writer,
		       			"apprTitle":apprTitle,
		       	}
		       	
		       	socket.send(JSON.stringify(socketMsg));
				
				if (cId.length > 0) {
					for(let i=0; i<cId.length; i++){
						
						let approvalCC = "approvalCC";
						
						let socketMsg1	=	{
				       			"title":approvalCC,
				       			"senderId":writer,
				       			"receiverId":cId[i],
				       			"apprTitle":apprTitle,
				       	}
				       	
				       	socket.send(JSON.stringify(socketMsg1));
						
					}
				}
				
				
			}
			
			location.href="/approval/details";
		})
	})
})


/* 반려 버튼을 눌렀을 때 */
$('#btnReject').on('click', function(){
	if($('#alCm').val() == ""){
		let str = `<p style="color: #7367F0;"> 의견을 작성해주세요</p>`
		$('.alCC').html(str);
		$('#alCm').focus();
		return;
	}
	
	let data = {
		"aprvrDocNo":aprvrDocNo,
		"alCm":$('#alCm').val(),
		"alAutzrNm":empId
	}
	console.log(data);
	fetch("/approval/reject",{
		method:"post",
		headers:{
			"Content-Type":"application/json;charset=UTF-8",
			[header]: token
		},
		body: JSON.stringify(data)
	}).then((resp)=>{
		resp.text().then((data)=>{
			console.log(data);
			
			
			let approvalRJ = "approvalRJ";
			let socketMsg	=	{
	       			"title":approvalRJ,
	       			"senderId":empId,
	       			"receiverId":writer,
	       			"apprTitle":apprTitle,
	       	}
	       	
	       	socket.send(JSON.stringify(socketMsg));
			
			location.href="/approval/details";
		})
	})
})

</script>