<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html
    lang="en"
    class="light-style layout-navbar-fixed layout-menu-fixed layout-compact"
    dir="ltr"
    data-theme="theme-default"
    data-assets-path="/resources/vuexy/assets/"
    data-template="vertical-menu-template-no-customizer">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <meta name="description" content="" />
    
    <title>Groovit - 아이디 찾기</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/resources/vuexy/assets/img/favicon/favicon.ico" />
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&ampdisplay=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

    <!-- Icons -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/fonts/fontawesome.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/fonts/tabler-icons.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/fonts/flag-icons.css" />

    <!-- Core CSS -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/rtl/core.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/rtl/theme-default.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/css/demo.css" />
    
    <!-- Vendors CSS -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/node-waves/node-waves.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/typeahead-js/typeahead.css" />
    <!-- Vendor -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/@form-validation/form-validation.css" />
    
    <!-- Page CSS -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/page-auth.css" />

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/resources/css/groovit.css" />

    <!-- Helpers -->
    <script src="/resources/vuexy/assets/vendor/js/helpers.js"></script>
    
    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="/resources/vuexy/assets/js/config.js"></script>
</head>
<body>
    <div class="container-xxl">
        <div class="authentication-wrapper authentication-basic container-p-y">
            <div class="authentication-inner py-4">
                <!-- Login -->
                <div class="card">
                    <div class="card-body">
                        
                        <h4 class="mb-3 pt-2 text-center tc1">아이디 찾기</h4>

                        <form id="formAuthentication" action="/searchId" method="post">
                            <!-- 아이디 -->
                            <div class="mb-3">
                                <label for="empNm" class="form-label">이름</label>
                                <input
                                type="text"
                                class="form-control"
                                id="empNm"
                                name="empNm"
                                placeholder="이름"
                                autofocus
                                required />
                            </div>

                            <!-- 생년월일 -->
                            <div class="mb-3">
                                <label for="empBrdt" class="form-label">생년월일</label>
                                <input
                                type="date"
                                class="form-control"
                                id="empBrdt"
                                name="empBrdt"
                                placeholder="생년월일"
                                required />
                            </div>

                            <!-- 전화번호 -->
                            <div class="mb-3">
                                <label for="empTelno" class="form-label">전화번호</label>
                                <input
                                type="text"
                                class="form-control"
                                id="empTelno"
                                name="empTelno"
                                placeholder="전화번호"
                                required />
                            </div>
                            
                            <div class="mb-3">
                                <button class="btn btn-primary d-grid w-100" type="submit">아이디 찾기</button>
                            </div>
                            <!-- csrf : Cross Site Request Forgery -->
                            <sec:csrfInput />
                        </form>
                        
                        <c:if test="${not empty employeeVO.empId}">
	                        <div class="bg-lighter rounded p-3 mt-5 mb-3">
	                               <div class="result-group visible">
	                                   <p class="text-center m-0">회원님의 아이디는 <span class="fw-medium text-primary">&nbsp;${employeeVO.empId}&nbsp;</span> 입니다.</p>
	                               </div>
	                        </div>
                        </c:if>
                        <c:if test="${not empty message}">
	                        <div class="bg-lighter rounded p-3 mt-5 mb-3">
								<div class="result-group visible">
								    <p class="text-center m-0">${message}</p>
								</div>
	                        </div>
                        </c:if>
                        <p class="text-center">
                            <a href="/login" class="border-right"><span>로그인</span></a>
                            <a href="/searchPw"><span>비밀번호 찾기</span></a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->

    <script src="/resources/vuexy/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/popper/popper.js"></script>
    <script src="/resources/vuexy/assets/vendor/js/bootstrap.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/node-waves/node-waves.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/hammer/hammer.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/i18n/i18n.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/typeahead-js/typeahead.js"></script>
    <script src="/resources/vuexy/assets/vendor/js/menu.js"></script>

    <!-- endbuild -->

    <!-- Vendors JS -->
    <script src="/resources/vuexy/assets/vendor/libs/@form-validation/popular.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/@form-validation/bootstrap5.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/@form-validation/auto-focus.js"></script>

    <!-- Main JS -->
    <script src="/resources/vuexy/assets/js/main.js"></script>

    <!-- Page JS -->
    <script src="/resources/vuexy/assets/js/pages-auth.js"></script>

</body>
</html>
