<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
const urlParams = new URL(location.href).searchParams;
const currentPage = urlParams.get('currentPage') == null ? 1 : urlParams.get('currentPage');
const empId = ${loginVO.empId};
let tabId = 'all';
$(function(){
    getList(currentPage, "");
   
    $('.nav-link-survey').on('click', function(){
        tabId = $(this).data('tab');
        console.log(tabId);
        getList(1, "");
    });
    
	$('#btnSearch').on('click', function(){
		let keyword = $('#search').val();
		getList(currentPage, keyword);
	});
});

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
        console.error("Error participation data: ", error);
        return false;
    }
}

async function getList(currentPage, keyword) {
    let data = {
   		"currentPage": currentPage,
   		"stts":tabId,
   		"keyword":keyword
    };
    console.log("data : ", data);

    try {
        let result = await $.ajax({
            url: "/survey/getList",
            data: data,
            type: "get",
            dataType: "json"
        });
        console.log(result);
        let str = `<h6 class="text-muted m-0" >총 \${result.total}건</h6>`;
        let now = new Date();

        for (const surveyVO of result.content) {
        	let endTime = new Date(surveyVO.srvyEndYmd);
            console.log(endTime);
            str += `
                <div class="col-sm-6 col-lg-4">
                    <div class="card p-2 h-100 shadow-none border">
                        <div class="card-body p-3 pt-2">
                            <div class="d-flex justify-content-between align-items-center mb-3">`;

            if (endTime > now) {
                str += `<span class="badge bg-label-success">진행중</span>`;
            } else {
                str += `<span class="badge bg-label-primary">마감</span>`;
            }

            let participateData = {
                "empId": empId,
                "srvyNo": surveyVO.srvyNo
            };

            const isParticipated = await getParticipationStatus(participateData);
            if (isParticipated) {
                str += `<i class="ti ti-circle-check ti-sm"></i>`;
            }
            

            str += `</div>
                        <a class="h5">\${surveyVO.srvyTtl}</a>
                        <p class="mt-2"><i class="ti ti-pencil me-2 mt-n1"></i>\${surveyVO.empNm} \${surveyVO.writerJob}</p>
                        <p class="d-flex align-items-center"><i class="ti ti-user me-2 mt-n1"></i>참여자 \${surveyVO.participantCount}명</p>
                        <p class="d-flex align-items-center"><i class="ti ti-clock-play me-2 mt-n1"></i>\${surveyVO.srvyBgngYmd} ~ \${surveyVO.srvyEndYmd}</p>
                        <div class="progress mb-4" style="height: 8px">`
            if (endTime > now) {
                      str += `<div class="progress-bar w-50" role="progressbar" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>`;
            } else {
                      str += `<div class="progress-bar w-100" role="progressbar" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>`;
            }                  
               str += `
                  </div>
                  <div class="d-flex flex-column flex-md-row gap-2 text-nowrap">`;

            if (isParticipated || endTime < now) {
                str += `<a class="app-academy-md-50 btn btn-outline-secondary waves-effect me-md-2 d-flex align-items-center" href="/survey/result?srvyNo=\${surveyVO.srvyNo}">
                                <i class="ti ti-rotate-clockwise-2 align-middle scaleX-n1-rtl me-2 mt-n1 ti-sm"></i><span>결과보기</span></a>`;
            } else {
                str += `<a class="app-academy-md-50 btn btn-outline-primary waves-effect d-flex align-items-center" href="/survey/detail?srvyNo=\${surveyVO.srvyNo}">
                                <span class="me-2">설문하기</span><i class="ti ti-chevron-right scaleX-n1-rtl ti-sm"></i></a>`;
            }
            str += `</div></div></div></div>`;
        }

        $('.box').html(str);
        $('.pagingBox').html(result.pagingArea2);
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
			<div class="input-group input-group-merge apprSearch">
	        	<input type="search" id="search" placeholder=" 제목검색" class="form-control" value="">
	        	<button type="button" id="btnSearch" class="input-group-text"><i class="ti ti-search"></i></button>
	        </div>
				<div class="tab-pane fade show active" id="navs-top-all" role="tabpanel">
					<div class="app-academy">
			            <div class="row gy-4 mb-4 box" id="all"></div>
			            <!-- 페이징 -->
						<div class="pagingBox"></div>
					</div>
				</div>
				<div class="tab-pane fade" id="navs-top-progress" role="tabpanel">
					<div class="app-academy">
			            <div class="row gy-4 mb-4 box" id="progress"></div>
			            <!-- 페이징 -->
						<div class="pagingBox"></div>
					</div>
				</div>
				<div class="tab-pane fade" id="navs-top-done" role="tabpanel">
					<div class="app-academy">
			            <div class="row gy-4 mb-4 box" id="done"></div>
			            <!-- 페이징 -->
						<div class="pagingBox"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

