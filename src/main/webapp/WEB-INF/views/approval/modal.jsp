<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/perfect-scrollbar/1.5.3/css/perfect-scrollbar.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/perfect-scrollbar/1.5.3/perfect-scrollbar.min.js"></script>
<!-- 새 결재 모달 -->
<div class="modal fade" id="newApprovalModal" tabindex="-1" aria-labelledby="newApproval" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">결재 양식 선택</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body mBody">
				<div class="viewJstree">
					<div class="input-group input-group-merge">
						<input type="text" id="schName" class="form-control" value="">
						<button onclick="fSch()" class="input-group-text"><i class="ti ti-search"></i></button>
					</div>
					<div id="jstreeWrapper" class="jstreeWrapper">
						<div id="jstreeApprTemp"></div>
					</div>
				</div>
				<div id="containerApprTemp" class="viewTemp"><span>미리보기</span></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="btnOK">확인</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<!-- 문서 검색 모달 -->
<div class="modal fade" id="searchDocumentModal" tabindex="-1" aria-labelledby="newApproval" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">결재 문서 첨부</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body" >
				<div class="col-sm-12">
					<div class="card overflow-hidden mb-4">
<!-- 						<h5 class="card-header">Vertical Scrollbar</h5> -->
						<div class="input-group input-group-merge">
							<input type="search" id="search" class="form-control" placeholder=" 제목검색" >
							<button type="button" id="btnSearch" class="input-group-text"><i class="ti ti-search"></i></button>
						</div>
						<div class="card-body" id="searchDocumentModalBody" style="height: 450px">
			         		<table class="datatables-approval-index table border-top">
								<thead>
									<tr>
										<th></th>
										<th>문서번호</th>
                                        <th>제목</th>
                                        <th>기안자</th>
                                    </tr>
								</thead>
								<tbody id="documentBox">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="searchComplete"  data-bs-dismiss="modal">확인</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<!-- 결재정보 모달 -->
<div class="modal fade" id="aproveInfoModal" tabindex="-1" aria-labelledby="newApproval" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">결재 정보</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs tabs-line">
					<li class="nav-item">
						<button class="nav-link nav-link-info active" data-bs-toggle="tab" data-bs-target="#tab-approve" data-tab="approve">
							<i class="ti ti-edit me-2"></i>
							<span class="align-middle">결재선</span>
						</button>
					</li>
					<li class="nav-item">
						<button class="nav-link nav-link-info" data-bs-toggle="tab" data-bs-target="#tab-corbon" data-tab="corbon">
							<i class="ti ti-trending-up me-2"></i>
							<span class="align-middle">참조자</span>
						</button>
					</li>
				</ul>
				<div class="tab-content px-0 pb-0" style="display: flex;">
					<div class="viewEmpJstree">
						<div class="input-group input-group-merge">
							<input type="text" id="schEmpName" class="form-control" value="">
							<button class="input-group-text"><i class="ti ti-search"></i></button>
						</div>
						<div id="apprInfoJTWrapper" class="jstreeWrapper">
							<div id="jstree"></div>
						</div>
					</div>
					<!-- 결재선 -->
					<div class="tab-pane fade show active appr-pane" id="tab-approve" role="tabpanel">
						<div class="apprText">드래그하여 결재순서를 변경할 수 있습니다.</div>
						<ul class="list-group list-group-flush" id="approveList">
							<c:if test="${approvalVO.approvalLineList[0].approver != null}">
								<c:forEach var="approvalLine" items="${approvalVO.approvalLineList}" varStatus="stat">
									<c:if test="${approvalLine.alSeq != 1}">
									<li value="${approvalLine.alAutzrNm}" class="drag-handle cursor-move list-group-item lh-1 d-flex justify-content-between align-items-center" >
											${approvalLine.approverDept} ${approvalLine.approver} 
										<i class="ti ti-trash align-text-bottom me-2 item"></i>
									</li>
									</c:if>
								</c:forEach>
							</c:if>
						</ul>
					</div>
					<!-- 참조자 -->
					<div class="tab-pane fade appr-pane"  id="tab-corbon" role="tabpanel">
						<ul class="list-group list-group-flush" id="corbonList">
							<c:if test="${approvalVO.corbonCopyList[0].accCc != null}">
								<c:forEach var="corbonCopy" items="${approvalVO.corbonCopyList}" varStatus="stat">
									<li value="${corbonCopy.accCc}" class="drag-handle cursor-move list-group-item lh-1 d-flex justify-content-between align-items-center" >
											${corbonCopy.corbonDept} ${corbonCopy.corbon} 
										<i class="ti ti-trash align-text-bottom me-2 item"></i>
									</li>
								</c:forEach>
							</c:if>
						</ul>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="modalSave" data-bs-dismiss="modal">저장</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- Modal 끝 -->

<!-- 보관함 추가 모달 -->
<div class="modal fade" id="newArchiveModal" tabindex="-1" aria-labelledby="newArchive" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>Croissant jelly beans donut apple pie. Caramels bonbon lemon drops. Sesame snaps lemon drops lemon drops liquorice icing bonbon pastry pastry carrot cake. Dragée sweet sweet roll sugar plum.</p>
        <p>Jelly-o cookie jelly gummies pudding cheesecake lollipop macaroon. Sweet chocolate bar sweet roll carrot cake. Sweet roll sesame snaps fruitcake brownie bear claw toffee bonbon brownie.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>

<!-- 결재승인 모달 -->
<div class="modal fade" id="approveModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="exampleModalLabel2">결재 승인</h4>
        <button
          type="button"
          class="btn-close"
          data-bs-dismiss="modal"
          aria-label="Close"></button>
      </div>
      <div class="modal-body pb-0">
        <div class="row">
          <div class="col mb-3">
	          <table style="width: 100%">
	          	<colgroup>
	          		<col width="30%">
	          		<col width="*">
	          	</colgroup>
		          <tr>
		          	<th>결재문서명</th>
		          	<td>${approvalVO.aprvrDocTtl}</td>
		          </tr>
		          <tr>
		          	<th>기안자</th>
		          	<td>${approvalVO.writerDept} ${approvalVO.writer}</td>
		          </tr>
	          </table>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="btnApprove">승인</button>
        <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 결재반려 모달 -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="exampleModalLabel2">반려하기</h4>
        <button
          type="button"
          class="btn-close"
          data-bs-dismiss="modal"
          aria-label="Close"></button>
      </div>
      <div class="modal-body pb-0">
        <div class="row">
          <div class="col mb-3">
	          <table style="width: 100%">
	          	<colgroup>
	          		<col width="35%">
	          		<col width="*">
	          	</colgroup>
		          <tr>
		          	<th>결재문서명</th>
		          	<td>${approvalVO.aprvrDocTtl}</td>
		          </tr>
	          </table>
          </div>
        </div>
        <div class="row">
           <div class="col">
             <label for="alCm" class="form-label"><h6>반려의견</h6></label>
             <input type="text" id="alCm" class="form-control" placeholder="반려의견은 필수 입력입니다.">
             <p class="alCC" style="margin-top: 10px"></p>
           </div>
         </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="btnReject">반려</button>
        <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 상신취소 모달 -->
<div class="modal fade" id="cancelModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="exampleModalLabel2">상신 취소</h4>
        <button
          type="button"
          class="btn-close"
          data-bs-dismiss="modal"
          aria-label="Close"></button>
      </div>
      <div class="modal-body pb-0">
        <div class="row">
          <div class="col mb-3">
	          <table style="width: 100%">
	          	<colgroup>
	          		<col width="30%">
	          		<col width="*">
	          	</colgroup>
		          <tr>
		          	<th>결재문서명</th>
		          	<td>${approvalVO.aprvrDocTtl}</td>
		          </tr>
		          <tr>
		          	<th>기안자</th>
		          	<td>${approvalVO.writerDept} ${approvalVO.writer}</td>
		          </tr>
	          </table>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="btnCancelOK">확인</button>
        <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
getDocumentList("");

$('#btnOK').on('click', function(){
	console.log($('#jstreeApprTemp').jstree('get_selected'));
	let atCd = $('#jstreeApprTemp').jstree('get_selected')
	location.href="/approval/new?atCd="+atCd;
})

function fSch() {
    console.log("껌색할께영");
    $('#jstreeApprTemp').jstree(true).search($("#schName").val());
}

//일반적으로 요렇게만 사용해도 충분!
$("#jstreeApprTemp").jstree({
    "plugins": ["search"],
    'core': {
        'data': {
            "url": function (node) {
                return "/approval/getTemplateList"; // ajax로 요청할 URL
            }
            /*,
            "data": function (node) {
                return { 'id': node.id }  // ajax로 보낼 데이터(없어서 주석)
            }
            */,
        },
        "check_callback": true,  // 요거이 없으면, create_node 안먹음
    }
});

// Node 선택했을 땡
$('#jstreeApprTemp').on("select_node.jstree", function (e, data) {
    console.log("select했을땡", data.node.id);
	fetch("/approval/"+data.node.id)
	.then((resp)=>{
		resp.json().then((data)=>{
// 			console.log(data.atImg);
			let str = `<img src="/upload\${data.atImg}">`; 
			console.log(str);
			$('#containerApprTemp').html(str);
		})
	})
});

function getDocumentList(keyword){
	
	let data = {
		"keyword":keyword
	}
	
	$.ajax({
		url:"/approval/getDocument",
		data:data,
		type:"get",
		success:function(result){
			console.log(result);
			let str =""
			for(const approvalVO of result){
				str += `
					<tr>
						<td class="dt-checkboxes-cell"><input type="checkbox" class="dt-checkboxes form-check-input" value="\${approvalVO.aprvrDocNo}" /></td>
						<td>[\${approvalVO.aprvrDocNo}]</td>
						<td>\${approvalVO.aprvrDocTtl}</td>
						<td>\${approvalVO.writer}</td>
				 	</tr>
				`;
			}
			
			$('#documentBox').html(str);
		}
	})
	
}

$('#searchComplete').on('click', function(){
	let checkDocList = document.querySelectorAll("input:checked");
	console.log(checkDocList[0].value);
	let str = "";
	for(let i=0; i<checkDocList.length; i++){
		str += `
	    <span class="item_file">
            <span class="docNo" data-aval="\${checkDocList[i].value}">[\${checkDocList[i].value}]</span>
            <span class="delete-icon"><i class="ti ti-x"></i></span>
        </span>`;
        
		checkDocList[i].checked = false;		
	}
	
	$('#areaDoc').append(str);
	
})

document.addEventListener("DOMContentLoaded", function() {
    new PerfectScrollbar(document.getElementById('jstreeWrapper'), {
        wheelPropagation: false
    });
    new PerfectScrollbar(document.getElementById('apprInfoJTWrapper'), {
        wheelPropagation: false
    });
});

</script>