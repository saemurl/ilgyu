<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    
    <title>Groovit - 로그인</title>
	
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
	
	<!-- 흔들리는 애니메이션 정의 -->
    <style>
        @keyframes shake {
            0% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            50% { transform: translateX(5px); }
            75% { transform: translateX(-5px); }
            100% { transform: translateX(0); }
        }

        .shake {
            animation: shake 0.5s;
        }
    </style>
</head>
<body>
    <div class="container-xxl">
        <div class="authentication-wrapper authentication-basic container-p-y">
            <div class="authentication-inner py-4">
                <!-- Login -->
                <div class="card">
                    <div class="card-body">
                        <!-- Logo -->
                        <div class="app-brand justify-content-center mb-4 mt-2">
                            <a href="/login" class="app-brand-link gap-2">
                                <span class="app-brand-logo demo">
                                    <svg width="32" height="22" viewBox="0 0 32 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M0.00172773 0V6.85398C0.00172773 6.85398 -0.133178 9.01207 1.98092 10.8388L13.6912 21.9964L19.7809 21.9181L18.8042 9.88248L16.4951 7.17289L9.23799 0H0.00172773Z"
                                        fill="#7367F0" />
                                        <path
                                        opacity="0.06"
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M7.69824 16.4364L12.5199 3.23696L16.5541 7.25596L7.69824 16.4364Z"
                                        fill="#161616" />
                                        <path
                                        opacity="0.06"
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M8.07751 15.9175L13.9419 4.63989L16.5849 7.28475L8.07751 15.9175Z"
                                        fill="#161616" />
                                        <path
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M7.77295 16.3566L23.6563 0H32V6.88383C32 6.88383 31.8262 9.17836 30.6591 10.4057L19.7824 22H13.6938L7.77295 16.3566Z"
                                        fill="#7367F0" />
                                    </svg>
                                </span>
                                <span class="app-brand-text demo text-body fw-bold ms-1">Groovit</span>
                            </a>
                        </div>
                        <!-- /Logo -->
                        
                        <form id="formAuthentication" action="/login" method="post">

                            <!-- 아이디 -->
                            <div class="mb-3">
                                <label for="username" class="form-label">아이디</label>
                                <input
                                type="text"
                                class="form-control"
                                id="username"
                                name="username"
                                placeholder="사번"
                                maxlength="12"
								pattern="\d{12}"
                                autofocus />
                            </div>

                            <!-- 비밀번호 -->
                            <div class="mb-3 form-password-toggle">
                                <div class="d-flex justify-content-between">
                                    <label class="form-label" for="password">비밀번호</label>
                                </div>
                                <div class="input-group input-group-merge">
                                    <input
                                    type="password"
                                    id="password"
                                    class="form-control"
                                    name="password"
                                    placeholder="비밀번호"
                                    aria-describedby="password" />
                                    <span class="input-group-text cursor-pointer"><i class="ti ti-eye-off"></i></span>
                                </div>
                            </div>

                            <!-- 로그인 상태 유지 체크박스 -->
                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="remember-me" name="remember-me" />
                                    <label class="form-check-label" for="remember-me"> 계정 저장 </label>
                                </div>
                            </div>
                            
                            <!-- 로그인 버튼 -->
                            <div class="mb-3">
                                <button class="btn btn-primary d-grid w-100" type="submit">로그인</button>
                            </div>
                            
                            <!-- csrf : Cross Site Request Forgery -->
                            <sec:csrfInput/>
                            
                            <!-- 에러 메시지 출력 -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger shake" role="alert" style="text-align: center;">${error}</div>
                            </c:if>
                        </form>
        
                        <p class="text-center tc1">
                            <a href="/searchId" class="border-right"><span>아이디 찾기</span></a>
                            <a href="/searchPw"><span>비밀번호 찾기</span></a>
                        </p>
                    </div>
                </div>
                <!-- /Login -->
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
