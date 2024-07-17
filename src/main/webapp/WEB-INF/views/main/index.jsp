<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- 게시판 스크립트 및 스타일시트 추가 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<link rel="stylesheet" href="/resources/css/simple-datatables.css">

<style>
.ck-editor__editable {
	   height: 500px;
}
</style>


<div class="row" id="main-dashboard">
  <!-- 근태관리 -->
  <div class="col-lg-4 col-sm-6 mb-4 order-1 order-md-0">
    <div class="card">
      <div class="card-body">
        <div class="customer-avatar-section" id="user-card">
          <div class="d-flex align-items-center flex-column">
            <img class="img-fluid rounded my-3" src="<c:choose><c:when test="${loginVO.atchfileSn == null}">/resources/images/default-profile.png</c:when><c:otherwise>/upload${loginVO.atchfileDetailVOList[0].atchfileDetailPhysclPath}</c:otherwise></c:choose>" alt="${loginVO.deptNm} ${loginVO.empNm}" />
            <div class="customer-info text-center">
              <h4 class="mb-1">${loginVO.jbgdNm} ${loginVO.empNm}</h4>
              <small>${loginVO.deptNm}</small>
              <input type="hidden" id="indexEmpId" value="${loginVO.empId}">
              <input type="hidden" id="indexEmpDeptCd" value="${loginVO.deptCd}">
            </div>
          </div>
        </div>
        <div class="d-flex justify-content-around flex-wrap my-4 border-top pt-4">
          <div class="d-flex align-items-center gap-2">
            <div class="avatar">
              <div class="avatar-initial rounded bg-label-primary">
                <i class="ti ti-clock ti-md"></i>
              </div>
            </div>
            <div class="gap-0 d-flex flex-column">
              <p class="mb-0 fw-medium" id="startTime">-</p>
              <small>출근시간</small>
            </div>
          </div>
          <div class="d-flex align-items-center gap-2">
            <div class="avatar">
              <div class="avatar-initial rounded bg-label-primary">
                <i class="ti ti-logout ti-md"></i>
              </div>
            </div>
            <div class="gap-0 d-flex flex-column">
              <p class="mb-0 fw-medium" id="endTime">-</p>
              <small>퇴근시간</small>
            </div>
          </div>
          <div class="d-flex align-items-center gap-2">
            <div class="avatar">
              <div class="avatar-initial rounded bg-label-primary">
                <i class="ti ti-calendar ti-md"></i>
              </div>
            </div>
            <div class="gap-0 d-flex flex-column">
              <p class="mb-0 fw-medium" id="workDuration">-</p>
              <small>근로시간</small>
            </div>
          </div>
        </div>
        <button class="btn btn-primary w-100 waves-effect waves-light" id="workButton"  onclick="handleWorkButtonClick()">출근하기</button>
<!--         <a href="javascript:void(0);" class="btn btn-primary w-100 waves-effect waves-light" id="workButton"  onclick="handleWorkButtonClick()">출근하기</a> -->
        <div class="d-flex align-items-center gap-2" style="margin-top:17px;">
          <button type="button" class="btn btn-outline-primary waves-effect w-100" onclick="location.href='/attendance/vacationList'">연차현황</button>
          <button type="button" class="btn btn-outline-primary waves-effect w-100" onclick="location.href='/attendance/leaveInsert'">휴가신청</button>
        </div>
      </div>
    </div>
  </div>

  <div class="col-lg-8 mb-4 col-md-12">

    <!-- 전자결재 / 메일 -->
    <div class="card">
      <div class="card-body">
        <div class="row gy-3">
          <div class="col-md-3 col-6">
            <div class="d-flex align-items-center cursor-pointer" id="approvProg">
              <div class="badge rounded bg-label-primary me-3 p-2">
                <i class="ti ti-ballpen ti-sm"></i>
              </div>
              <div class="card-info">
                <h5 class="mb-0" id="progTotal"></h5>
                <small>결재 진행</small>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-6">
            <div class="d-flex align-items-center cursor-pointer" id="approvReq">
              <div class="badge rounded bg-label-info me-3 p-2">
                <i class="ti ti-alert-circle ti-sm"></i>
              </div>
              <div class="card-info">
                <h5 class="mb-0" id="reqTotal"></h5>
                <small>결재 요청</small>
              </div>
            </div>
          </div>

          <div class="col-md-3 col-6">
            <div class="d-flex align-items-center cursor-pointer" id="approvRef">
              <div class="badge rounded bg-label-danger me-3 p-2">
                <i class="ti ti-archive ti-sm"></i>
              </div>
              <div class="card-info">
                <h5 class="mb-0" id="refTotal"></h5>
                <small>수신 참조</small>
              </div>
            </div>
          </div>

          <div class="col-md-3 col-6">
			  <div class="d-flex align-items-center cursor-pointer" id="mail">
			    <div class="badge rounded bg-label-success me-3 p-2">
			      <i class="ti ti-mail ti-sm"></i>
			    </div>
			    <div class="card-info">
			      <h5 class="mb-0">
			        <span id="receiverCnt"></span><small>건</small>
			      </h5>
			      <small>읽지 않은 메일</small>
			    </div>
			  </div>
			</div>
        </div>
      </div>
    </div>

    <div class="row mt-4">
      <!-- 일정 -->
      <div class="col-xl-6 col-lg-6 h-100">
        <div class="card" style="height: 334px;">
          <div class="card-header d-flex align-items-center justify-content-between">
            <div class="card-title mb-0">
              <h5 class="m-0 me-2">오늘의 일정</h5>
            </div>
            <button class="btn p-0" type="button" id="todoMoveBtn">
              <i class="ti ti-chevron-right"></i>
            </button>
          </div>
          <div class="card-body pb-0" style="padding-left: 40px; padding-top:15px;" id="vertical-schedule">
            <ul class="timeline mb-0" id="todoArea">

              <!-- 비동기로 오늘 일정 데이터 가져와서 넣는 영역 -->
            </ul>
          </div>
        </div>
      </div>

      <!-- 부서 조직도 -->
      <div class="col-xl-6 col-lg-6 col-md-6">
        <div class="card"  style="height: 334px; padding: 10px; padding-top: 0px;">
          <div class="card-header d-flex align-items-center justify-content-between">
            <div class="card-title mb-0">
              <h5 class="m-0 me-2">부서 조직도</h5>
            </div>
            <button class="btn p-0" type="button" id="" onclick="location.href='/orgchart/list'">
              <i class="ti ti-chevron-right"></i>
            </button>
          </div>
          <div class="card-body pb-0 ps" id="vertical-orgchart">
            <div class="table-responsive">
              <table class="table table-borderless orgChart">
                <tbody id="deptListArea">

                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 월간 근무 통계 -->
  <div class="col-lg-4 mb-4">
    <div class="card h-100">
      <div class="card-header pb-0 d-flex justify-content-between mb-lg-n4">
        <div class="card-title mb-0">
          <h5 class="mb-0">월간 근무 통계</h5>
          <small class="text-muted">24년 7월 기준</small>
        </div>
        <button class="btn p-0" type="button" id="goAttendanceBtn">
          <i class="ti ti-chevron-right"></i>
        </button>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-12 col-md-4 d-flex flex-column align-self-end">
            <div class="d-flex gap-2 align-items-center mb-2 pb-1 flex-wrap">
              <h1 class="mb-0" id="avgWork"></h1>
              <div class="badge rounded bg-label-success">+4.2%</div>
            </div>
            <small>주당 평균 근무 시간</small>
          </div>
          <div class="col-12 col-md-8">
            <div id="monthlyWorkStats"></div>
          </div>
        </div>
        <div class="border rounded p-3 pb-1 mt-4">
          <div class="row gap-4 gap-sm-0">
            <div class="col-12 col-sm-4">
              <div class="d-flex gap-2 align-items-center">
                <div class="badge rounded bg-label-primary p-1">
                  <i class="ti ti-clock ti-sm"></i>
                </div>
                <h6 class="mb-0">총 근무</h6>
              </div>
              <h5 class="my-2 pt-1" id="totalWork"></h5>
            </div>
            <div class="col-12 col-sm-4">
              <div class="d-flex gap-2 align-items-center">
                <div class="badge rounded bg-label-info p-1">
                  <i class="ti ti-alarm ti-sm"></i>
                </div>
                <h6 class="mb-0">연장 근무</h6>
              </div>
              <h5 class="my-2 pt-1">34시간</h5>
            </div>
            <div class="col-12 col-sm-4">
              <div class="d-flex gap-2 align-items-center">
                <div class="badge rounded bg-label-danger p-1">
                  <i class="ti ti-calendar-check ti-sm"></i>
                </div>
                <h6 class="mb-0">연차 사용</h6>
              </div>
              <h5 class="my-2 pt-1">1일</h5>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 커뮤니티 -->
  <div class="col-md-8 col-xl-8 col-xl-8 mb-4">
    <div class="card h-100" style="padding: 10px; padding-top: 0px;">
      <div class="card-header d-flex justify-content-between pb-2 mb-1">
        <div class="card-title mb-1">
          <h5 class="m-0 me-2">커뮤니티</h5>
        </div>
        <button class="btn p-0" type="button" id="cycleTabsButton">
          <i class="ti ti-chevron-right"></i>
        </button>
      </div>
      <div class="card-body p-0">
        <div class="nav-align-top">
          <ul class="nav nav-tabs nav-fill m-0" role="tablist">
            <li class="nav-item">
              <button
                type="button"
                class="nav-link active"
                role="tab"
                data-bs-toggle="tab"
                data-bs-target="#navs-justified-notice"
                aria-controls="navs-justified-notice"
                aria-selected="true">
                공지사항
              </button>
            </li>
            <li class="nav-item">
              <button
                type="button"
                class="nav-link"
                role="tab"
                data-bs-toggle="tab"
                data-bs-target="#navs-justified-free"
                aria-controls="navs-justified-free"
                aria-selected="false">
                자유게시판
              </button>
            </li>
            <li class="nav-item">
              <button
                type="button"
                class="nav-link"
                role="tab"
                data-bs-toggle="tab"
                data-bs-target="#navs-justified-event"
                aria-controls="navs-justified-event"
                aria-selected="false">
                경조사
              </button>
            </li>
          </ul>

          <div class="tab-content p-0">
            <!-- 공지사항 -->
		    <div class="tab-pane fade show active p-0" id="navs-justified-notice" role="tabpanel">
		        <table class="table table-sm no-footer dtr-column main_baords">
		            <colgroup>
		                <col style="width: 60%">
		                <col style="width: 20%">
		                <col style="width: 20%">
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>제목</th>
		                    <th>작성자</th>
		                    <th>등록일</th>
		                </tr>
		            </thead>
		        </table>
		        <div style="height: 241px;" class="community-scroll">
		            <table class="table table-sm no-footer dtr-column main_baords">
		                <colgroup>
		                    <col style="width: 60%">
		                    <col style="width: 20%">
		                    <col style="width: 20%">
		                </colgroup>
		                <tbody>
		                    <c:forEach var="notice" items="${noticeBoardVOList}">
		                        <tr>
		                            <td><a href="/board/noticeDetail?ntcNo=${notice.ntcNo}">${notice.ntcTtl}</a></td>
		                            <td>${notice.empNm}</td>
		                            <td><fmt:formatDate value="${notice.ntcFrstRegYmd}" pattern="yyyy-MM-dd" /></td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		        </div>
		    </div>

		    <!-- 자유게시판 -->
		    <div class="tab-pane fade" id="navs-justified-free" role="tabpanel">
		        <table class="table table-sm no-footer dtr-column main_baords">
		            <colgroup>
		                <col style="width: 60%">
		                <col style="width: 20%">
		                <col style="width: 20%">
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>제목</th>
		                    <th>작성자</th>
		                    <th>등록일</th>
		                </tr>
		            </thead>
		        </table>
		        <div style="height: 241px;" class="community-scroll">
		            <table class="table table-sm no-footer dtr-column main_baords">
		                <colgroup>
		                    <col style="width: 60%">
		                    <col style="width: 20%">
		                    <col style="width: 20%">
		                </colgroup>
		                <tbody>
		                    <c:forEach var="free" items="${freeBoardVOList}">
		                        <tr>
		                            <td><a href="/board/freeDetail?fbNo=${free.fbNo}">${free.fbTtl}</a></td>
		                            <td>${free.empNm}</td>
		                            <td><fmt:formatDate value="${free.fbFrstRegDt}" pattern="yyyy-MM-dd" /></td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		        </div>
		    </div>

		    <!-- 경조사 -->
		    <div class="tab-pane fade" id="navs-justified-event" role="tabpanel">
		        <table class="table table-sm no-footer dtr-column main_baords">
		            <colgroup>
		                <col style="width: 60%">
		                <col style="width: 20%">
		                <col style="width: 20%">
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>제목</th>
		                    <th>작성자</th>
		                    <th>등록일</th>
		                </tr>
		            </thead>
		        </table>
		        <div style="height: 241px;" class="community-scroll">
		            <table class="table table-sm no-footer dtr-column main_baords">
		                <colgroup>
		                    <col style="width: 60%">
		                    <col style="width: 20%">
		                    <col style="width: 20%">
		                </colgroup>
		                <tbody>
		                    <c:forEach var="event" items="${eventBoardVOList}">
		                        <tr>
		                            <td>
		                                <a href="/board/detail?evtbNo=${event.evtbNo}&evtbSe=${event.evtbSe}">${event.evtbTtl}</a>
		                            </td>
		                            <td>${event.empNm}</td>
		                            <td><fmt:formatDate value="${event.evtbDt}" pattern="yyyy-MM-dd" /></td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		        </div>
		    </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 근무 유형별 분포 -->
  <div class="col-md-4 col-xl-4">
    <div class="card h-100">
      <div class="card-header d-flex justify-content-between">
        <div class="card-title mb-0">
          <h5 class="mb-0">근무 유형별 분포</h5>
          <small class="text-muted">최근 6개월</small>
        </div>
      </div>
      <div class="card-body">
        <div id="salesLastMonth"></div>
      </div>
    </div>
  </div>

  <!-- 설문 -->
  <input type="hidden" value="${empTotal}" id="empTotal">
  <div class="col-4">
    <div class="card h-100">
      <div class="card-header d-flex align-items-center justify-content-between">
        <h5 class="card-title m-0 me-2">설문</h5>
        <button class="btn p-0" type="button" id="goSurveyBtn">
          <i class="ti ti-chevron-right"></i>
        </button>
      </div>
      <div class="card-body">
        <ul class="p-0 m-0" id="areaSurveyList">
          	<!-- 설문 리스트 비동기로 뿌림 -->
        </ul>
      </div>
    </div>
  </div>

  <!-- 회의실 예약 -->
  <div class="col-4">
    <div class="card h-100">
      <div
        id="carouselExampleDark"
        class="carousel carousel-dark slide carousel-fade h-100"
        data-bs-ride="carousel">
        <div class="carousel-indicators">
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="0"
            class="active"
            aria-current="true"
            aria-label="Slide 1"></button>
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="1"
            aria-label="Slide 2"></button>
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="2"
            aria-label="Slide 3"></button>
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="3"
            aria-label="Slide 4"></button>
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="4"
            aria-label="Slide 5"></button>
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="5"
            aria-label="Slide 6"></button>
          <button
            type="button"
            data-bs-target="#carouselExampleDark"
            data-bs-slide-to="6"
            aria-label="Slide 7"></button>
        </div>
        <div class="carousel-inner h-100">
          <div class="carousel-item active h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/2b3672a8-9f9a-42fd-9ef0-ea9b180bddae_회의실101실.jpg" alt="회의실 101실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 101실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
          <div class="carousel-item h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/5f746b94-4244-4dbc-aba4-a6b1c6552fe4_회의실102실.jpg" alt="회의실 102실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 102실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
          <div class="carousel-item h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/61cfd39c-ad93-4968-902f-82d8a65f8ca8_회의실103실.jpg" alt="회의실 103실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 103실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
          <div class="carousel-item h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/fa07d5ea-0e4e-47db-bcb6-c10018af46e7_회의실104실.jpg" alt="회의실 104실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 104실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
          <div class="carousel-item h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/6080d82b-7de7-4505-ba62-6193f5cc8ef1_회의실105실.jpg" alt="회의실 105실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 105실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
          <div class="carousel-item h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/3f829d58-aeb8-42ae-a202-c4ca4c324e93_회의실201실.jpg" alt="회의실 201실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 201실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
          <div class="carousel-item h-100">
            <div class="carousel-img-wrap">
              <img class="d-block w-100 card-img-top" src="/upload/49a4fde8-558f-40e5-83c2-944753ecd2f2_회의실202실.jpg" alt="회의실 202실" />
            </div>
            <div class="carousel-caption d-none d-md-block">
              <h4>회의실 202실</h4>
              <a href="/room/list" class="btn btn-outline-secondary waves-effect">예약하기</a>
            </div>
          </div>
        </div>
        <a class="carousel-control-prev" href="#carouselExampleDark" role="button" data-bs-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Previous</span>
        </a>
        <a class="carousel-control-next" href="#carouselExampleDark" role="button" data-bs-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Next</span>
        </a>
      </div>
    </div>
  </div>
</div>





<!-- 메일 모달  -->
<div class="app-email-compose modal fade" id="emailComposeSidebar" tabindex="-1" aria-labelledby="emailComposeSidebarLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg">
        <div class="modal-content p-0">
            <div class="modal-header py-3 bg-body">
                <h5 class="modal-title fs-5 TS" id="emailComposeSidebarLabel">메일 작성</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body flex-grow-1 pb-sm-0 p-4 py-2">
                <form id="frm" class="email-compose-form" action="" enctype="multipart/form-data">
                    <div id="addEmpNm" class="email-compose-to d-flex justify-content-between align-items-center">
                        <label class="form-label mb-0" for="emailContacts">To:</label>
                        <div class="select2-primary border-0 shadow-none flex-grow-1 mx-2">
                            <div class="position-relative">
                                <select class="select2 select-email-contacts form-select select2-hidden-accessible" id="emailContacts" name="emailContacts" multiple="" data-select2-id="emailContacts" tabindex="-1" aria-hidden="true" disabled>
                                    <c:forEach var="employeeVO" items="${employeeList}" varStatus="stat">
                                        <option data-avatar="/view/${employeeVO.empId}" value="${employeeVO.empId}">${employeeVO.empNm}</option>
                                    </c:forEach>
                                </select>
                                <span class="select2 select2-container select2-container--default" dir="ltr" data-select2-id="1" style="width: auto;">
                                    <span class="selection"></span>
                                    <span class="text-truncate" _msthidden="1">
                                    <span class="dropdown-wrapper" aria-hidden="true"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <label class="switch switch-primary switch-me">중요
                        <input type="checkbox" class="switch-input" value="" id="sendImportant">
                        <span class="switch-toggle-slider" style="margin-left : 7px;">
                            <span class="switch-on"></span>
                        </span>
                    </label>
<!--                     <hr class="container-m-nx my-2"> -->
                    <div class="email-compose-subject d-flex align-items-center mb-2">
                        <label for="email-title" class="form-label mb-0" style="width : 35px">제목 : </label>
                        <input type="text" class="form-control border-0 shadow-none flex-grow-1 mx-2" id="email-title" placeholder="제목을 입력해주세요">
                    </div>
                        <div class="fileBox">
							<span class="dd_text">파일첨부</span>
							<div id="dropZone" class="dd_attach dd_zone">
								<div class="area_txt">
									<span class="ic_attach ic_upload"></span>
									<span class="msg">이곳에 파일을 드래그 하세요. 또는
										<span class="btn_file">
											<span class="txt">파일선택</span>
											<input type="file" title="파일선택" data-file="send" multiple id="attach-file">
										</span>
									</span>
								</div>
								<div class="area_img" id="areaImg">

								</div>
								<div class="area_file" id="areaFile">

								</div>
							</div>
						</div><br>
                    <div class="email-compose-message container-m-nx" id="ckMessage"></div>
                    <textarea style="display : none;" id="message" name="message" class="form-control" rows="4" cols="30"></textarea>
                    <hr class="container-m-nx mt-0 mb-2">
                    <div class="email-compose-actions d-flex justify-content-between align-items-center mt-3 mb-3">
                        <div class="d-flex align-items-center">
                            <div id="mailSendDiv" class="btn-group">
                                <button id="SendS" type="reset" class="btn btn-primary waves-effect waves-light" data-bs-dismiss="modal" aria-label="Close">
                                    <i class="ti ti-send ti-xs me-1"></i>Send
                                </button>
                                <button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split waves-effect waves-light" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span class="visually-hidden">Send Options</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a id="Tsave" class="dropdown-item" href="javascript:void(0);">임시저장</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <button type="reset" class="btn" data-bs-dismiss="modal" aria-label="Close">
                                <i class="ti ti-trash"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>




<script>

const loginEmp = '${loginVO.empId}';

  $('#goAttendanceBtn').on('click', function(){
	  location.href = "/attendance/list";
  })
//   getAttenStatic();

  /******* 커뮤니티 *******/
  document.getElementById("cycleTabsButton").addEventListener("click", function() {
    const tabs = document.querySelectorAll('.nav-tabs .nav-link');
    let activeTab;

    tabs.forEach((tab, index) => {
      if (tab.classList.contains('active')) {
        activeTab = index;
      }
    });

    const nextTab = (activeTab + 1) % tabs.length;
    let targetPage;

    switch (nextTab) {
      case 1:
        targetPage = "/board/noticeList"; // 공지사항 페이지 URL
        break;
      case 2:
        targetPage = "/board/freeList"; // 자유게시판 페이지 URL
        break;
      /* case 3:
        targetPage = "/board/eventList";
        break; */
      default:
        targetPage = "/board/eventList"; // 경조사 페이지 URL
      	break;
    }

    window.location.href = targetPage;
  });
  /******* // 커뮤니티 *******/

  /******* 근태관리 *******/
  $(function(){

    	// 오늘 날짜 비교위한 데이터
    	let today = new Date();

    	let year = today.getFullYear();
    	let month = ('0' + (today.getMonth()+1)).slice(-2);
    	let day = ('0' + today.getDate()).slice(-2);

    	let daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
    	let date = daysOfWeek[today.getDay()];

    	let dayString = `\${year}-\${month}-\${day}`;
    	let dateString = `\${year}.\${month}.\${day}(\${date})`;
    	console.log("dayString :" + dayString); //2024-07-05
    	console.log("dateString :" + dateString);

    	//attnFrstRegDt 1720168892000 sysdate

		//출근시간
    	  $.ajax({
              url: "/attendance/createList",
              contentType: "application/json;charset=utf-8",
              type: "get",
              beforeSend: function(xhr) {
                  xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
              },
              success: function(result) {
              	console.log("아작스 결과 리스트 result", result);

              	  let attnFrstRegDt = result.attnFrstRegDt;
	              console.log("attnFrstRegDt", attnFrstRegDt);

	              let formattedDate = formatDate(attnFrstRegDt);
	              console.log("formattedDate:", formattedDate);

				  //오늘날자랑 비교.
                  if (formattedDate == dayString) {
                     $('#startTime').text(result.attnBgng);
                     $('#workButton').text('퇴근하기');
                  } else if(result.attnFrstRegDt == null) {
                	 $('#startTime').text('-');

                  }
              }
          });
		//퇴근시간
    	  $.ajax({
              url: "/attendance/createList",
              contentType: "application/json;charset=utf-8",
              type: "get",
              beforeSend: function(xhr) {
                  xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
              },
              success: function(result) {
              	console.log("아작스 결과: result", result);
	              let attnLastRegDt = result.attnLastRegDt;
	              console.log("attnFrstRegDt", attnLastRegDt);

	              let formattedDate = formatDate(attnLastRegDt);
	              console.log("formattedDate:", formattedDate);

                  if (formattedDate == dayString) {
                      $('#endTime').text(result.attnEnd);
                  } else if(result.attnLastRegDt == null) {
                	  $('#endTime').text('-');
                  }
              }
          });

		//일한시간
    	  $.ajax({
              url: "/attendance/selectAttnList",
              contentType: "application/json;charset=utf-8",
              type: "get",
              beforeSend: function(xhr) {
                  xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
              },
              success: function(result) {
            	  console.log("셀렉리스트 결과:", result.worked);
                  if(result.worked == null){

	                  $('.time-display-ing').text('일한 시간: ');
                  // 화면에 일한 시간 표시
                  }else{
	                  // 초를 시간과 분으로 변환
	                  let totalSeconds = result.worked; // 초 값을받아옴.
	                  let hours = Math.floor(totalSeconds / 3600);
	                  let minutes = Math.floor((totalSeconds % 3600) / 60);

                  // 시간과 분을 HH:mm 형식으로 표시 9시간 8분
	                  let formattedTime = ('0' + hours).slice(-2)+'시간' + ':' + ('0' + minutes).slice(-2)+'분';
                  	$('#workDuration').text(formattedTime);
                  }
              }
          });

    });
	//오늘 날짜 비교를 위한 타임
  function formatDate(timestamp) {
      let date = new Date(timestamp);
      let year = date.getFullYear();
      let month = ('0' + (date.getMonth() + 1)).slice(-2); // 월은 0부터 시작하므로 +1을 해줌
      let day = ('0' + date.getDate()).slice(-2);

      return `\${year}-\${month}-\${day}`;
  }


//   let isWorking = false; // 출근 상태를 나타내는 변수

  function handleWorkButtonClick() {

//       if (!isWorking) {
      if ($('#startTime').text() == '-') {
          // 출근하기 로직
          $.ajax({
              url: "/attendance/createPost",
              contentType: "application/json;charset=utf-8",
              type: "POST",
              beforeSend: function(xhr) {
                  xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
              },
              success: function(result) {
                  if (result != null && result.attnBgng) {
                      document.getElementById("workButton").innerText = "퇴근하기";
                      isWorking = true;
                      $('#startTime').text(result.attnBgng);
                      //스위트 알러트 출근
                      Swal.fire({
					        icon: 'success',
					        title: '',
					        text: '출근이 완료되었습니다.',
					        customClass: {
					            confirmButton: 'btn btn-success'
					        }
					 })
                  } else {
                      alert("출근 기록에 실패했습니다.");
                  }
              }
          });
      } else {
		  // 스위트 알러트 퇴근
    	  Swal.fire({
  		    html: "퇴근하시겠습니까?",
  		    icon: 'question',
  		    showCancelButton: true,
  		    confirmButtonColor: '#3085d6',
  		    cancelButtonColor: '#d33',
  		    cancelButtonText: "취소",
  		    confirmButtonText: "퇴근",
  		    customClass: {
  		        confirmButton: 'btn btn-info me-1',
  		        cancelButton: 'btn btn-label-secondary'
  		    },
  		    buttonsStyling: false
  		  }).then(function(result) {
  		    if (result.isConfirmed) {

  		   // 퇴근하기 로직
  	          $.ajax({
  	              url: "/attendance/updatePost",
  	              contentType: "application/json;charset=utf-8",
  	              type: "POST",
  	              beforeSend: function(xhr) {
  	                  xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
  	              },
  	              success: function(result) {
  	            	  if (result != null && result.attnEnd) {
  	                      const now = new Date();

  	                      isWorking = false;
  	                      $('#endTime').text(result.attnEnd)

  	            	  } else {
  	                      alert("퇴근 기록에 실패했습니다.");
  	                  }
					  //일한 시간 로직
  	            	  $.ajax({
  	                  	url: "/attendance/selectAttnList",
  	                  	contentType: "application/json;charset=utf-8",
  	  					type:"get",
  	  					beforeSend: function(xhr) {
  	  		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
  	  		            },
  	  		            success: function(result) {
  	            			console.log("result List:", result);
  	            			let times = Number(result.worked);
  	            			console.log("times", times);
  	  						let hour = 0;
  	  	                	let mins = 0;
  	  	                	if(times > 3600){
  	  	                		hour = Math.floor(times / 3600, 0);
  	  	                	    mins = Math.floor((times % 3600) / 60);
  	  	                	}else if(times > 60){

  	  							mins =  Math.floor(times / 60);
  	  	                	}

  	  	                	if(hour < 10){
  	  	                		hour = '0' + hour;
  	  	                	}
  	  	                	if(mins < 10){
  	  	                		mins = '0' + mins;
  	  	                	}

  	  	                	let str = hour+ "시간" + ":" + mins+ "분";

  	  	                 	$('#workDuration').text(str);
							console.log('str >>>>>>>' ,str);
  	  		         }
  	              })
  	            }
  	      	 });
  		    }
  		  })
         }
      }
  /******* // 근태관리 *******/

  // 오늘 일정 출력 비동기 영역 [일정 시작] ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
  document.getElementById('todoMoveBtn').addEventListener('click', function() {
      window.location.href = '/schedule/list';
  });

  function todoListAjax() {
      $.ajax({
          contentType: "application/json;charset=utf-8",
          url: "/main/todoListAjax",
          type: "get",
          beforeSend: function(xhr) {
              xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
          },
          success: function(scheduleList) {
              console.log("오늘 일정 jsp 쪽 값 체크 : ", scheduleList);

              let str = '';
              scheduleList.forEach((schedule, index) => {
                  let category;
                  switch (schedule.color) {
                      case '#ff9f43':
                          category = '부서';
                          break;
                      case '#28c76f':
                          category = '회사';
                          break;
                      case '#7367f0':
                          category = '개인';
                          break;
                      default:
                          category = '기타';
                  }

                  if (index < scheduleList.length - 1) {
                      str += `<li class="timeline-item timeline-item-transparent">`;
                  } else {
                      str += `<li class="timeline-item timeline-item-transparent border-transparent">`;
                  }

                  if (category == '개인') {
                      str += `<span class="timeline-point timeline-point-primary"></span>`;
                  } else if (category == '부서') {
                      str += `<span class="timeline-point timeline-point-warning"></span>`;
                  } else if (category == '회사') {
                      str += `<span class="timeline-point timeline-point-success"></span>`;
                  }

                  str += `
                      <div class="timeline-event">
                          <div class="timeline-header mb-1">
                              <h6 class="mb-0">\${schedule.title}</h6>
                  `;
                  if (category == '개인') {
                      str += `<small class="ms-4 badge bg-label-primary">\${category}</small>`;
                  } else if (category == '부서') {
                      str += `<small class="ms-4 badge bg-label-warning">\${category}</small>`;
                  } else if (category == '회사') {
                      str += `<small class="ms-4 badge bg-label-success">\${category}</small>`;
                  }

                  str += `
                          </div>
                          <p class="mb-2">\${schedule.description}</p>
                          <small class="text-muted">\${schedule.location} <span style="float: right;">\${schedule.start} ~ \${schedule.end}</span> </small>
                      </div>
                  </li>
                  `;

              });



              // 해당 HTML 요소에 str을 추가합니다. 예를 들어, id가 "timeline"인 요소에 추가
              $('#todoArea').html(str);
          }
      });
  }
  todoListAjax(); // 최초 호출용 [일정 종료] ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

  /******* // 전자결재  *******/

  $('#approvProg').on('click', function(){
	  location.href = '/approval/progress';
  });

  $('#approvReq').on('click', function(){
	  location.href = '/approval/request';
  });

  $('#approvRef').on('click', function(){
	  location.href = '/approval/reference';
  });


  // 결재진행/결재요청/수신참조 개수 가져오기
  fetch("/approval/getTotalBySubmenu")
	.then((resp)=>{
		resp.json().then((data)=>{
			console.log(data);
			$('#progTotal').html(`\${data.progressTotal}<small>건</small>`);
			$('#reqTotal').html(`\${data.requestTotal}<small>건</small>`);
			$('#refTotal').html(`\${data.referenceTotal}<small>건</small>`);
		})
   })

   /******* // 전자결재 끝  *******/


/******* // 설문  *******/

let cardColor, labelColor, shadeColor, legendColor, borderColor, headingColor, grayColor;
  cardColor = config.colors.cardColor;
  labelColor = config.colors.textMuted;
  legendColor = config.colors.bodyColor;
  borderColor = config.colors.borderColor;
  shadeColor = '';
  headingColor = config.colors.headingColor;
  grayColor = '#817D8D';



// 설문 목록 페이지로 이동
$('#goSurveyBtn').on('click', function() {
	location.href = '/survey/list';
});

// 설문 참여 상태 확인
async function getParticipationStatus(participateData) {
	try {
		let participateResult = await $.ajax({
			url: "/survey/checkParticipate",
			contentType: "application/json",
			data: JSON.stringify(participateData),
			type: "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			}
		});
		return participateResult === 'TRUE';
	} catch (error) {
		console.error("참여 여부 확인 중 오류 발생: ", error);
		return false;
	}
}

// 설문 목록 가져오기 및 표시
async function getSurveyList() {
	try {
		let result = await $.ajax({
			url: "/main/mainSurveyList",
			type: "get",
		});

		let str = "";
		let total = $('#empTotal').val();
		for (const surveyVO of result) {
			let ratio = total > 0 ? (surveyVO.participantCount / total * 100).toFixed(0) : 0;
			let participateData = {
				"empId": loginEmp,
				"srvyNo": surveyVO.srvyNo
			};
			let link = `/survey/detail?srvyNo=\${surveyVO.srvyNo}`;
			const isParticipated = await getParticipationStatus(participateData);
			if (isParticipated) {
				link = `/survey/result?srvyNo=\${surveyVO.srvyNo}`;
			}

			str += `
				<li class="d-flex mb-3 pb-1">
					<div
						class="chart-progress me-3"
						data-color="primary"
						data-series="\${ratio}"
						data-progress_variant="true"></div>
					<div class="row w-100 align-items-center">
						<div class="col-9">
							<div class="me-2">
								<h6 class="mb-2">\${surveyVO.srvyTtl}</h6>
								<small>\${surveyVO.srvyEndYmd} 까지</small>
							</div>
						</div>
						<div class="col-3 text-end">
							<a class="btn btn-sm btn-icon btn-label-secondary" href="\${link}">
								<i class="ti ti-chevron-right scaleX-n1-rtl"></i>
							</a>
						</div>
					</div>
				</li>`;
		}
		$('#areaSurveyList').html(str);

		// 차트 초기화 함수 호출
		initializeCharts();
	} catch (error) {
		console.error("설문조사 리스트를 가져오는 중 오류 발생: ", error);
	}
}

// 차트 초기화 함수
function initializeCharts() {
	function radialBarChart(color, value, show) {
		return {
			chart: {
				height: show == 'true' ? 58 : 53,
				width: show == 'true' ? 58 : 43,
				type: 'radialBar'
			},
			plotOptions: {
				radialBar: {
					hollow: {
						size: show == 'true' ? '50%' : '33%'
					},
					dataLabels: {
						show: show == 'true' ? true : false,
						value: {
							offsetY: -10,
							fontSize: '15px',
							fontWeight: 500,
							fontFamily: 'Public Sans',
							color: headingColor
						}
					},
					track: {
						background: config.colors_label.secondary
					}
				}
			},
			stroke: {
				lineCap: 'round'
			},
			colors: [color],
			grid: {
				padding: {
					top: show == 'true' ? -12 : -15,
					bottom: show == 'true' ? -17 : -15,
					left: show == 'true' ? -17 : -5,
					right: -15
				}
			},
			series: [value],
			labels: show == 'true' ? [''] : ['Progress']
		};
	}

	const surveyChartProgressList = document.querySelectorAll('.chart-progress');
	if (surveyChartProgressList) {
		surveyChartProgressList.forEach(function (chartProgressEl) {
			const color = config.colors[chartProgressEl.dataset.color],
				series = chartProgressEl.dataset.series;
			const progress_variant = chartProgressEl.dataset.progress_variant
				? chartProgressEl.dataset.progress_variant
				: 'false';
			const optionsBundle = radialBarChart(color, series, progress_variant);
			const chart = new ApexCharts(chartProgressEl, optionsBundle);
			chart.render();
		});
	}
}

// DOM이 로드된 후 설문 목록 가져오기 실행
$(document).ready(function() {
	getSurveyList();
	receiverCnt();
});



 // 부서 조직도 시작 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
  function deptEmpListAjax(){
	  let empId = $("#indexEmpId").val();
	  let empDept = $("#indexEmpDeptCd").val();

	  let data = {
			  "empDept":empDept
	  }
	  $.ajax({
			url:"/main/deptEmpListAjax",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
							xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				console.log("deptEmpListAjax : ", result);
				let str = ``;

				$.each(result, function(index, deptList) {
					str += ``;
					if (empId != deptList.EMP_ID) {

						str += `<tr>`;
						str += `<td>`;
						str += `<div class='d-flex justify-content-start align-items-center'>`;
						str += `<div class='avatar me-3 avatar-sm'>`;
						str += `<img src='/view/\${deptList.EMP_ID}' alt='Avatar' class='rounded-circle' />`;
						str += `</div>`;
						str += `<div class='d-flex flex-column'>`;
						str += `<h6 class='mb-0'>\${deptList.JBGD_NM} \${deptList.EMP_NM}</h6>`;
						str += `<small class='text-truncate text-muted'>\${deptList.DEPT_NM}</small>`;
						str += `</div>`;
						str += `</div>`;
						str += `</td>`;
						str += `<td class='text-end'>`;
						str += `<a href='javascript:void(0)' data-bs-toggle="modal" data-bs-target="#emailComposeSidebar" id="emailComposeSidebarLabel"`;
						str += `class='btn btn-text-secondary rounded-pill btn-icon shadow-none mailBtn' `;
						str += `data-bs-toggle='tooltip' `;
						str += `data-bs-placement='top' `;
						str += `aria-label='Mark all as read' `;
						str += `data-bs-original-title='Mail' data-empid='\${deptList.EMP_ID}'>`;
						str += `<i class='ti ti-mail-opened text-heading'></i>`;
						str += `</a>`;
						str += `<a href='/chat/list?empId=\${deptList.EMP_ID}' `;
						str += `class='btn btn-text-secondary rounded-pill btn-icon shadow-none' `;
						str += `data-bs-toggle='tooltip' `;
						str += `data-bs-placement='top' `;
						str += `aria-label='Mark all as read' `;
						str += `data-bs-original-title='Chat'>`;
						str += `<i class='ti ti-messages text-heading'></i>`;
						str += `</a>`;
						str += `</td>`;
						str += `</tr>`;

					}


				});

				$('#deptListArea').html(str);
			}
		});
  }
  deptEmpListAjax();

  // 부서 조직도 (메일) ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
  let empList = [];
  let mlStts = "M01";

  $(document).on("click", ".mailBtn", function(){
	  empList = []
	  let empId = $(this).data("empid");
	  empList.push(empId);
	  console.log("empId >> " ,empId);
	  $("#emailContacts").val(empId).trigger('change');
	  console.log("empList >> " ,empList);

  });

   let TSaveText = "(임시저장)";
   var $tsElement = $(".TS");
  $("#emailComposeSidebar").on("show.bs.modal", function(){
	    $tsElement.text($tsElement.text().replace(TSaveText, ""));
  });

      $("#Tsave").on("click", function(){
			if ($tsElement.text().includes(TSaveText)) {
		        // "(임시저장)"이 이미 존재하면 제거
		        $tsElement.text($tsElement.text().replace(TSaveText, ""));
		        mlStts = "M01";
		    } else {
		        // "(임시저장)"이 없으면 추가
		        $tsElement.append(TSaveText);
		        mlStts = "M00";
		    }
			console.log("Tsave_mlStts >> ", mlStts);

      });



  $("#SendS").on("click", function() {
	    let title = $("#email-title").val();
	    let message = $("#message").val();

	    if ($("#sendImportant").is(":checked")) {
	        $("#sendImportant").val("Y");
	    } else {
	        $("#sendImportant").val("N");
	    }
	    let important = $("#sendImportant").val();
	    let formData = new FormData();

	    // 파일 추가
	    let fileList = f_ckFileList();
		    console.log("fileList", fileList);
		  	fileList.forEach(file => {
		      	formData.append("file", file);
		    });

	    let mailVO = {
	        "mlTtl": title,
	        "mlCn": message,
	        "mlIptYn": important,
	        "empList": empList,
	        "mlStts" : mlStts
	    };

	    console.log("mailVO >>> ", mailVO);
	    console.log("empList: ", empList);
	    console.log("title: ", title);
	    console.log("message: ", message);
	    console.log("important: ", important);

	    formData.append("mailVO", new Blob([JSON.stringify(mailVO)], {type: "application/json"}));
	    formData.append("${_csrf.parameterName}", "${_csrf.token}");

	    fetch("/main/mailSend", {
	        method: "POST",
	        body: formData
	    })
	    .then((response) => response.text())
	    .then((data) => {
	        console.log("mailVO >> ", data);
	        empList = [];
	        if (window.editor) {
      			 window.editor.setData('');
   			}
	        // 파일 리스트 초기화
			$("#attach-file").val("");
	        $("#areaImg").html("");

	        mlStts = "M01";
	    })
	    .catch((error) => {
	        console.log('Error:', error);
	    });
	});



  let id = "";
  let str = "";
  let dataFile = "";
  let attachFileList = [];

  const dropZone = document.querySelector('#dropZone');
  const atchFile = document.querySelector('#attach-file');
  const areaImg = document.querySelector('#areaImg');
  const areaFile = document.querySelector('#areaFile');

  $('#dropZone').on('dragover', function(){
  	  event.preventDefault();
  	  event.stopPropagation();
  	})

  	$('#dropZone').on('drop', function(){
  	  event.preventDefault();
  	  event.stopPropagation();

  	  let userSelFiles = event.dataTransfer.files;
  	  // console.log("끌어온 외부파일 이름 : ", userSelFiles);
  	  for(let i=0; i<userSelFiles.length; i++){
  	    console.log(userSelFiles[i].name);
  	    f_readOneFile(i, userSelFiles[i]);
  	  }

  	});

  	atchFile.addEventListener('change', function() {
  	  dataFile = $(this).data("file");
  	  let userSelFiles = event.target.files;
  	  for(let i = 0; i < userSelFiles.length; i++) {
  	    f_readOneFile(i, userSelFiles[i]);
  	  }
  	});

  	function addImageFile(fileReader, pFile) {
  	    let str = `
  	        <span class="item_image ms-3">
  	            <span class="imgPreview">
  	                <img src="\${fileReader.result}" alt="\${pFile.name}">
  	            </span>
  	            <span class="name">\${pFile.name}</span>
  	            <span class="delete-icon"><i class="ti ti-x"></i></span>
  	        </span>`;

  	    	areaImg.innerHTML += str;

  	    	attachRemoveEvent();
  	}


  	function addGeneralFile(pFile) {
  	    let str = `
  	        <span class="item_file ms-3">
  	            <span class="name">\${pFile.name}</span>
  	            <span class="delete-icon"><i class="ti ti-x"></i></span>
  	        </span>`;

      	    areaFile.innerHTML += str;
  	    	attachRemoveEvent();
  	}

  	function f_readOneFile(pIdx, pFile){
  	  attachFileList.push(pFile);
  	  let fileType = pFile.type.split("/")[0];
  	  let fileReader = new FileReader();
  	  fileReader.readAsDataURL(pFile);
  	  fileReader.onload = function(){
  	    if(fileType == 'image'){
  	    	addImageFile(fileReader, pFile);
  	    }else{
  	    	addGeneralFile(pFile);
  	    }
  	  }
  	}

  	function f_ckFileList() {
  	    // 보낼 파일 리스트
  	    let sendFileList = document.querySelectorAll(".name");
//  	     console.log("sendFileList" ,sendFileList[0].innerText);

  	    //파일 고르깅
  	    let selFiles = attachFileList.filter(aFile => {
  	        for (let i = 0; i < sendFileList.length; i++) {
  	            if (aFile.name == sendFileList[i].innerText) {
  	                return true;
  	            }
  	        }
  	        return false;
  	    })
  	    return selFiles;
  	}

		function attachRemoveEvent() {
	        $('.delete-icon').off('click').on('click', function(){
	            let fileName = $(this).siblings('.name').text();
	            attachFileList = attachFileList.filter(file => file.name !== fileName);
	            $(this).parent().remove();

	            // input[type="file"]의 파일 목록 갱신
	            let dataTransfer = new DataTransfer();
	            attachFileList.forEach(file => {
	                dataTransfer.items.add(file);
	            });
	            atchFile.files = dataTransfer.files;
	        });
	    }


  window.addEventListener("dragover", function(){
      event.preventDefault();
  });
  window.addEventListener("drop", function(){
      event.preventDefault();
  });



  ClassicEditor.create(document.querySelector('#ckMessage'), {
      ckfinder: {
          uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
      }
  })
  .then(editor => {
      window.editor = editor;
  })
  .catch(err => {
      console.error(err.stack);
  });

	$(function() {
	  //ckeditor 내용 => textarea로 복사
	  $(".ck-blurred").keydown(function() {
	      console.log("str : " + window.editor.getData());
	      $("#message").val(window.editor.getData());
	  });

	  $(".ck-blurred").on("focusout", function() {
	      $("#message").val(window.editor.getData());
	  });
	});

// 부서 조직도 (메일) 끝―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
// 부서 조직도 끝 ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

   // 읽지않은 메일 수
   function receiverCnt(){
        $.ajax({
        	url : "/main/receiverCnt",
    		contentType : "application/json;charset=utf-8",
    		type : "post",
    		dataType : "text",
    		beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
    		success : function(result){
    			console.log("안읽은 메일 수 : ", result);

    			$("#receiverCnt").html(result);
    		}
        });
	}

   $(document).ready(function() {
		receiverCnt();
	});

   $("#mail").on("click", function(){
	   location.href = "/mail/inbox";
   });


</script>