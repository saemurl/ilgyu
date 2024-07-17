<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="modal.jsp" %>
<%
    String currentURI = (String) request.getAttribute("currentURI");
%>

<script type="text/javascript">
    console.log("Current URI: <%= currentURI %>");
    
$(function(){
	fetch("/approval/getTotalBySubmenu")
		.then((resp)=>{
			resp.json().then((data)=>{
				console.log(data);
				$('#progressTotal').text(data.progressTotal);
				$('#requestTotal').text(data.requestTotal);
				$('#referenceTotal').text(data.referenceTotal);
			})
		})
})
</script>

<div class="app-email-sidebar border-end flex-grow-0" id="app-email-sidebar">
    <div class="btn-compost-wrapper d-grid">
        <button
            class="btn btn-primary btn-compose"
            data-bs-toggle="modal"
            data-bs-target="#newApprovalModal"
            id="newApproval">
            	새 결재
        </button>
    </div>
    <div class="email-filters py-2">
        <small class="fw-medium text-uppercase text-muted m-4">결재 상신함</small>
        <ul class="email-filter-folders list-unstyled mb-4 mt-2">
            <c:if test="${currentURI.contains('/approval/progress')}">
                <li class="active d-flex justify-content-between" data-target="inbox">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/progress')}">
                <li class="d-flex justify-content-between" data-target="inbox">
            </c:if>
                <a href="/approval/progress" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-ballpen ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">결재진행</span>
                </a>
                <div class="badge bg-label-primary rounded-pill badge-center" id="progressTotal"></div>
            </li>
            <c:if test="${currentURI.contains('/approval/completed')}">
                <li class="active d-flex justify-content-between" data-target="sent">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/completed')}">
                <li class="d-flex justify-content-between" data-target="sent">
            </c:if>
                <a href="/approval/completed" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-checkbox ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">결재완료</span>
                </a>
            </li>
            <c:if test="${currentURI.contains('/approval/tempsave')}">
                <li class="active d-flex justify-content-between" data-target="draft">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/tempsave')}">
                <li class="d-flex justify-content-between" data-target="draft">
            </c:if>
                <a href="/approval/tempsave" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-file ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">임시저장</span>
                </a>
            </li>
        </ul>
        <small class="fw-normal text-uppercase text-muted m-4">결재 수신함</small>
        <ul class="email-filter-folders list-unstyled mb-4 mt-2">
            <c:if test="${currentURI.contains('/approval/request')}">
                <li class="active d-flex justify-content-between" data-target="starred">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/request')}">
                <li class="d-flex justify-content-between" data-target="starred">
            </c:if>
                <a href="/approval/request" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-alert-circle ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">결재요청</span>
                </a>
                <div class="badge bg-label-primary rounded-pill badge-center" id="requestTotal"></div>
            </li>
            <c:if test="${currentURI.contains('/approval/details')}">
                <li class="active d-flex align-items-center" data-target="spam">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/details')}">
                <li class="d-flex align-items-center" data-target="spam">
            </c:if>
                <a href="/approval/details" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-clipboard-text ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">결재내역</span>
                </a>
            </li>
            <c:if test="${currentURI.contains('/approval/upcoming')}">
                <li class="active d-flex align-items-center" data-target="trash">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/upcoming')}">
                <li class="d-flex align-items-center" data-target="trash">
            </c:if>
                <a href="/approval/upcoming" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-progress ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">결재예정</span>
                </a>
            </li>
<%--             <c:if test="${currentURI.contains('/approval/proxy')}"> --%>
<!--                 <li class="active d-flex align-items-center" data-target="trash"> -->
<%--             </c:if> --%>
<%--             <c:if test="${!currentURI.contains('/approval/proxy')}"> --%>
<!--                 <li class="d-flex align-items-center" data-target="trash"> -->
<%--             </c:if> --%>
<!--                 <a href="/approval/proxy" class="d-flex flex-wrap align-items-center"> -->
<!--                     <i class="ti ti-user ti-sm"></i> -->
<!--                     <span class="align-middle ms-2 fw-normal">대리결재</span> -->
<!--                 </a> -->
<!--             </li> -->
            <c:if test="${currentURI.contains('/approval/reference')}">
                <li class="active d-flex justify-content-between" data-target="trash">
            </c:if>
            <c:if test="${!currentURI.contains('/approval/reference')}">
                <li class="d-flex justify-content-between" data-target="trash">
            </c:if>
                <a href="/approval/reference" class="d-flex flex-wrap align-items-center">
                    <i class="ti ti-archive ti-sm"></i>
                    <span class="align-middle ms-2 fw-normal">수신참조</span>
                </a>
                <div class="badge bg-label-primary rounded-pill badge-center" id="referenceTotal"></div>
            </li>
        </ul>
        <div class="email-filter-labels mt-5">
            <div class="d-flex justify-content-between align-items-center m-4 mb-0">
                <small class="fw-normal text-uppercase text-muted">보관함</small>
                <i class="ti ti-folder-plus ti-xs cursor-pointer"
                data-bs-toggle="modal"
                data-bs-target="#newArchiveModal"
                id="newArchive"></i>
            </div>
            <ul class="list-unstyled mb-0 mt-2">
                <c:if test="${currentURI.contains('/approval/docbox')}">
                    <li class="active d-flex align-items-center" data-target="work">
                </c:if>
                <c:if test="${!currentURI.contains('/approval/docbox')}">
                    <li class="d-flex align-items-center" data-target="work">
                </c:if>
                    <a href="/approval/docbox">
                        <i class="ti ti-inbox ti-sm"></i>
                        <span class="align-middle ms-2 fw-normal">개인 보관함</span>
                    </a>
                </li>
                <c:if test="${currentURI.contains('/approval/docbox')}">
                    <li class="active d-flex align-items-center" data-target="company">
                </c:if>
                <c:if test="${!currentURI.contains('/approval/docbox')}">
                    <li class="d-flex align-items-center" data-target="company">
                </c:if>
                    <a href="/approval/docbox">
                        <i class="ti ti-inbox ti-sm"></i>
                        <span class="align-middle ms-2 fw-normal">부서 보관함</span>
                    </a>
                </li>
                <c:if test="${currentURI.contains('/approval/docbox')}">
                    <li class="active d-flex align-items-center" data-target="important">
                </c:if>
                <c:if test="${!currentURI.contains('/approval/docbox')}">
                    <li class="d-flex align-items-center" data-target="important">
                </c:if>
                    <a href="/approval/docbox">
                        <i class="ti ti-inbox ti-sm"></i>
                        <span class="align-middle ms-2 fw-normal">기타 보관함</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
