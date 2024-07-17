<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<!-- Page CSS -->
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-email.css" />

<div class="app-email card" id="approval">
  <div class="row g-0">
  
    <!-- Email Sidebar -->
    <div class="col app-email-sidebar border-end flex-grow-0" id="app-email-sidebar">
    
      <div class="btn-compost-wrapper d-grid">
        <button
          class="btn btn-primary btn-compose "
          data-bs-toggle="modal"
          data-bs-target="#newApprovalModal"
          id="newApproval">
                 새 결재
        </button>
      </div>
      
      <!-- 문서함 리스트 -->
      <div class="email-filters py-2 fnoto">
        <!-- Email Filters: Folder -->
      	<small class="fw-medium text-uppercase text-muted m-4">결재 상신함</small>
        <ul class="email-filter-folders list-unstyled mb-4 mt-2">
          <li class="active d-flex justify-content-between" data-target="inbox">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-ballpen ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">결재진행</span>
            </a>
            <div class="badge bg-label-primary rounded-pill badge-center">4</div>
          </li>
          <li class="d-flex" data-target="sent">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-checkbox ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">결재완료</span>
            </a>
          </li>
          <li class="d-flex" data-target="draft">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-file ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">임시저장</span>
            </a>
          </li>
        </ul>
        <small class="fw-normal text-uppercase text-muted m-4">결재 수신함</small>
        <ul class="email-filter-folders list-unstyled mb-4 mt-2">
          <li class="d-flex justify-content-between" data-target="starred">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-alert-circle ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">결재요청</span>
            </a>
            <div class="badge bg-label-warning rounded-pill badge-center">10</div>
          </li>
          <li class="d-flex align-items-center" data-target="spam">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-clipboard-text ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">결재내역</span>
            </a>
          </li>
          <li class="d-flex align-items-center" data-target="trash">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-progress ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">결재예정</span>
            </a>
          </li>
          <li class="d-flex align-items-center" data-target="trash">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-user ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">대리결재</span>
            </a>
          </li>
          <li class="d-flex justify-content-between" data-target="trash">
            <a href="javascript:void(0);" class="d-flex flex-wrap align-items-center">
              <i class="ti ti-archive ti-sm"></i>
              <span class="align-middle ms-2 fw-normal">수신참조</span>
            </a>
            <div class="badge bg-label-warning rounded-pill badge-center">10</div>
          </li>
        </ul>
        
        <!-- Email Filters: Labels -->
        <div class="email-filter-labels mt-5">
          <div class="d-flex justify-content-between align-items-center m-4 mb-0">
            <small class="fw-normal text-uppercase text-muted">보관함</small>
            <i class="ti ti-folder-plus ti-xs cursor-pointer"
               data-bs-toggle="modal"
               data-bs-target="#newArchiveModal"
               id="newArchive"></i>
          </div>
          <ul class="list-unstyled mb-0 mt-2">
            <li data-target="work">
              <a href="javascript:void(0);">
	            <i class="ti ti-inbox ti-sm"></i>
                <span class="align-middle ms-2 fw-normal">개인 보관함</span>
              </a>
            </li>
            <li data-target="company">
              <a href="javascript:void(0);">
	            <i class="ti ti-inbox ti-sm"></i>
                <span class="align-middle ms-2 fw-normal">부서 보관함</span>
              </a>
            </li>
            <li data-target="important">
              <a href="javascript:void(0);">
	            <i class="ti ti-inbox ti-sm"></i>
                <span class="align-middle ms-2 fw-normal">기타 보관함</span>
              </a>
            </li>
          </ul>
        </div>
        <!--/ Email Filters -->
      </div>
    </div>
    <!--/ Email Sidebar -->
  </div>
</div>


<!-- 새 결재 모달 -->
<div class="modal fade" id="newApprovalModal" tabindex="-1" aria-labelledby="newApproval" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
          </button>
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

<!-- 보관함 추가 모달 -->
<div class="modal fade" id="newArchiveModal" tabindex="-1" aria-labelledby="newArchive" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
          </button>
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




<!-- Page JS -->
<script src="/resources/vuexy/assets/js/app-email.js"></script>