<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String currentURI = (String) request.getAttribute("currentURI");
    if (currentURI == null) {
        currentURI = "";
    }

    // 관리 하위 메뉴 URI 체크
    boolean isHrmActive = currentURI.startsWith("/hrm");
    boolean isRoomAdminActive = currentURI.startsWith("/room/adminList");
    boolean isDeclareActive = currentURI.startsWith("/declare");
    boolean isInterviewsActive = currentURI.startsWith("/interviews/list");
    boolean isManagementActive = isHrmActive || isRoomAdminActive || isDeclareActive || isInterviewsActive;
%>

<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
    <div class="app-brand demo">
        <a href="/main/index" class="app-brand-link">
            <span class="app-brand-logo demo">
                <svg width="32" height="22" viewBox="0 0 32 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path fill-rule="evenodd" clip-rule="evenodd"
                          d="M0.00172773 0V6.85398C0.00172773 6.85398 -0.133178 9.01207 1.98092 10.8388L13.6912 21.9964L19.7809 21.9181L18.8042 9.88248L16.4951 7.17289L9.23799 0H0.00172773Z"
                          fill="#7367F0"/>
                    <path opacity="0.06" fill-rule="evenodd" clip-rule="evenodd"
                          d="M7.69824 16.4364L12.5199 3.23696L16.5541 7.25596L7.69824 16.4364Z"
                          fill="#161616"/>
                    <path opacity="0.06" fill-rule="evenodd" clip-rule="evenodd"
                          d="M8.07751 15.9175L13.9419 4.63989L16.5849 7.28475L8.07751 15.9175Z"
                          fill="#161616"/>
                    <path fill-rule="evenodd" clip-rule="evenodd"
                          d="M7.77295 16.3566L23.6563 0H32V6.88383C32 6.88383 31.8262 9.17836 30.6591 10.4057L19.7824 22H13.6938L7.77295 16.3566Z"
                          fill="#7367F0"/>
                </svg>
            </span>
            <span class="app-brand-text demo menu-text fw-bold">Groovit</span>
        </a>

        <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto">
            <i class="ti menu-toggle-icon d-none d-xl-block ti-sm align-middle"></i>
            <i class="ti ti-x d-block d-xl-none ti-sm align-middle"></i>
        </a>
    </div>

    <div class="menu-inner-shadow"></div>

    <!-- Menu List -->
    <ul class="menu-inner py-1">
        <li class="menu-item ${currentURI.startsWith('/main/index') ? 'active' : ''}">
            <a href="/main/index" class="menu-link">
                <i class="menu-icon tf-icons ti ti-smart-home"></i>
                <div>대시보드</div>
            </a>
        </li>
        <li class="menu-item ${currentURI.startsWith('/approval') ? 'active' : ''}">
            <a href="/approval/index" class="menu-link">
                <i class="menu-icon tf-icons ti ti-clipboard-text"></i>
                <div>전자결재</div>
            </a>
        </li>
        <li class="menu-item ${currentURI.startsWith('/mail/inbox') ? 'active' : ''}">
            <a href="/mail/inbox" class="menu-link">
                <i class="menu-icon tf-icons ti ti-mail"></i>
                <div>메일</div>
            </a>
        </li>
        <li class="menu-item ${currentURI.startsWith('/schedule') ? 'active open' : ''}">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class="menu-icon tf-icons ti ti-calendar"></i>
                <div>일정관리</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item ${currentURI.startsWith('/schedule/list') ? 'active' : ''}">
                    <a href="/schedule/list" class="menu-link">
                        <div>일정</div>
                    </a>
                </li>
                <li class="menu-item ${currentURI.startsWith('/schedule/todoList') ? 'active' : ''}">
                    <a href="/schedule/todoList" class="menu-link">
                        <div>TO DO</div>
                    </a>
                </li>
            </ul>
        </li>
        <li class="menu-item ${currentURI.startsWith('/room') && !currentURI.startsWith('/room/adminList') ? 'active open' : ''}">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class="menu-icon tf-icons ti ti-layout-grid"></i>
                <div>회의실 예약</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item ${currentURI.startsWith('/room/list') ? 'active' : ''}">
                    <a href="/room/list" class="menu-link">
                        <div>회의실 예약</div>
                    </a>
                </li>
                <li class="menu-item ${currentURI.startsWith('/room/rentList') ? 'active' : ''}">
                    <a href="/room/rentList" class="menu-link">
                        <div>예약 조회</div>
                    </a>
                </li>
            </ul>
        </li>
        <li class="menu-item ${currentURI.startsWith('/attendance') ? 'active open' : ''}">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class="menu-icon tf-icons ti ti-users"></i>
                <div>근태관리</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item ${currentURI.startsWith('/attendance/list') ? 'active' : ''}">
                    <a href="/attendance/list" class="menu-link">
                        <div>내 근태 현황</div>
                    </a>
                </li>
                <li class="menu-item ${currentURI.startsWith('/attendance/vacationList') || currentURI.startsWith('/attendance/leaveInsert') ? 'active open' : ''}">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <div>연차 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item ${currentURI.startsWith('/attendance/vacationList') ? 'active' : ''}">
                            <a href="/attendance/vacationList" class="menu-link">
                                <div>내 연차 현황</div>
                            </a>
                        </li>
                        <li class="menu-item ${currentURI.startsWith('/attendance/leaveInsert') ? 'active' : ''}">
                            <a href="/attendance/leaveInsert" class="menu-link">
                                <div>휴가 신청</div>
                            </a>
                        </li>
                    </ul>
                </li>
                <c:if test="${loginVO.empMng == 'Y'}">
	                <li class="menu-item ${currentURI.startsWith('/attendance/departList') ? 'active' : ''}">
	                    <a href="/attendance/departList" class="menu-link">
	                        <div>부서 근태현황</div>
	                    </a>
	                </li>
                </c:if>
            </ul>
        </li>
        <li class="menu-item ${currentURI.startsWith('/dataFolder/list') ? 'active' : ''}">
            <a href="/dataFolder/list" class="menu-link">
                <i class="menu-icon tf-icons ti ti-cloud-data-connection"></i>
                <div>자료실</div>
            </a>
        </li>
        <li class="menu-item ${currentURI.startsWith('/survey') ? 'active open' : ''}">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class="menu-icon tf-icons ti ti-checkbox"></i>
                <div>설문</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item ${currentURI.startsWith('/survey/list') ? 'active' : ''}">
                    <a href="/survey/list" class="menu-link">
                        <div>설문하기</div>
                    </a>
                </li>
                <li class="menu-item ${currentURI.startsWith('/survey/myList') ? 'active' : ''}">
                    <a href="/survey/myList" class="menu-link">
                        <div>나의 설문내역</div>
                    </a>
                </li>
                <c:if test="${loginVO.empMng == 'Y'}">
	                <li class="menu-item ${currentURI.startsWith('/survey/manage') ? 'active' : ''}">
	                    <a href="/survey/manage" class="menu-link">
	                        <div>설문 관리</div>
	                    </a>
	                </li>
                </c:if>
            </ul>
        </li>
        <li class="menu-item ${currentURI.startsWith('/board') ? 'active open' : ''}">
            <a href="javascript:void(0);" class="menu-link menu-toggle">
                <i class="menu-icon tf-icons ti ti-file-description"></i>
                <div>게시판</div>
            </a>
            <ul class="menu-sub">
                <li class="menu-item ${currentURI.startsWith('/board/noticeList') ? 'active' : ''}">
                    <a href="/board/noticeList" class="menu-link">
                        <div>공지사항</div>
                    </a>
                </li>
                <li class="menu-item ${currentURI.startsWith('/board/freeList') ? 'active' : ''}">
                    <a href="/board/freeList" class="menu-link">
                        <div>자유게시판</div>
                    </a>
                </li>
                <li class="menu-item ${currentURI.startsWith('/board/eventList') ? 'active' : ''}">
                    <a href="/board/eventList" class="menu-link">
                        <div>경조사</div>
                    </a>
                </li>
            </ul>
        </li>
        <li class="menu-item ${currentURI.startsWith('/orgchart/list') ? 'active' : ''}">
            <a href="/orgchart/list" class="menu-link">
                <i class="menu-icon tf-icons ti ti-sitemap"></i>
                <div>조직도</div>
            </a>
        </li>
        <c:if test="${roleNames == '[ROLE_ADMIN]'}">
	        <li class="menu-item ${isManagementActive ? 'active open' : ''}">
	            <a href="javascript:void(0);" class="menu-link menu-toggle">
	                <i class="menu-icon tf-icons ti ti-filters"></i>
	                <div>관리</div>
	            </a>
	            <ul class="menu-sub">
	                <li id="hrm-management" class="menu-item ${isHrmActive ? 'active' : ''}">
	                    <a href="javascript:void(0);" class="menu-link menu-toggle">
	                        <div>인사 관리</div>
	                    </a>
	                    <ul class="menu-sub">
	                        <li class="menu-item ${currentURI.startsWith('/hrm/createForm') ? 'active' : ''}">
	                            <a href="/hrm/createForm" class="menu-link">
	                                <div>입사처리</div>
	                            </a>
	                        </li>
	                        <li class="menu-item ${currentURI.startsWith('/hrm/list') ? 'active' : ''}">
	                            <a href="/hrm/list" class="menu-link">
	                                <div>직원조회</div>
	                            </a>
	                        </li>
	                        <li class="menu-item ${currentURI.startsWith('/hrm/ptplist') ? 'active' : ''}">
	                            <a href="/hrm/ptplist" class="menu-link">
	                                <div>인사이동처리</div>
	                            </a>
	                        </li>
	                    </ul>
	                </li>
	                <li id="room-admin-management" class="menu-item ${isRoomAdminActive ? 'active' : ''}">
	                    <a href="/room/adminList" class="menu-link">
	                        <div>회의실 관리</div>
	                    </a>
	                </li>
	                <li id="declare-management" class="menu-item ${isDeclareActive ? 'active' : ''}">
	                    <a href="javascript:void(0);" class="menu-link menu-toggle">
	                        <div>신고 관리</div>
	                    </a>
	                    <ul class="menu-sub">
	                        <li class="menu-item ${currentURI.startsWith('/declare/boardList') ? 'active' : ''}">
	                            <a href="/declare/boardList" class="menu-link">
	                                <div>게시글 신고관리</div>
	                            </a>
	                        </li>
	                        <li class="menu-item ${currentURI.startsWith('/declare/commentList') ? 'active' : ''}">
	                            <a href="/declare/commentList" class="menu-link">
	                                <div>댓글 신고관리</div>
	                            </a>
	                        </li>
	                    </ul>
	                </li>
	                <li id="interviews-management" class="menu-item ${currentURI.startsWith('/interviews/list') ? 'active' : ''}">
	                    <a href="/interviews/list" class="menu-link">
	                        <div>면접 관리</div>
	                    </a>
	                </li>
	            </ul>
	        </li>
        </c:if>
    </ul>
</aside>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var activeMenuItems = document.querySelectorAll('.menu-item.active');

        activeMenuItems.forEach(function(activeMenuItem) {
            var parent = activeMenuItem.closest('.menu-item');
            while (parent) {
                parent.classList.add('open');
                parent = parent.parentElement.closest('.menu-item');
            }
        });

        var currentURI = '<%= currentURI %>';
        var managementParent;

        if (currentURI.startsWith('/room/adminList')) {
            managementParent = document.getElementById('room-admin-management').closest('.menu-item');
        } else if (currentURI.startsWith('/hrm')) {
            managementParent = document.getElementById('hrm-management').closest('.menu-item');
        } else if (currentURI.startsWith('/declare')) {
            managementParent = document.getElementById('declare-management').closest('.menu-item');
        } else if (currentURI.startsWith('/interviews/list')) {
            managementParent = document.getElementById('interviews-management').closest('.menu-item');
        }

        if (managementParent) {
            managementParent.classList.add('active', 'open');
            var parent = managementParent.parentElement.closest('.menu-item');
            while (parent) {
                parent.classList.add('open');
                parent = parent.parentElement.closest('.menu-item');
            }
        }
    });
</script>

