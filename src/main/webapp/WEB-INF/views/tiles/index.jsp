<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en" class="light-style layout-navbar-fixed layout-menu-fixed layout-compact"
      dir="ltr"
      data-theme="theme-default"
      data-assets-path="/resources/vuexy/assets/"
      data-template="vertical-menu-template-no-customizer">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <meta name="description" content="" />
    
    <!-- CSRF Token 설정 -->
    <tiles:insertAttribute name="csrfMetaTags" ignore="true"/>

    <title>Groovit</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/themes/default/style.min.css" />
<!--     <link rel="stylesheet" href="//static.jstree.com/3.3.15/assets/bootstrap/css/bootstrap.min.css" /> -->
    <script src="/resources/sbadmin/vendor/jquery/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/jstree.min.js"></script>

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/resources/vuexy/assets/img/favicon/favicon.ico" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&ampdisplay=swap"
          rel="stylesheet" />
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
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<!--     <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2.css" /> -->

    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/quill/katex.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/quill/editor.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/select2/select2.css" />      <!--매일 -->
    
<!--     <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/select2/select2.css" /> -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/quill/typography.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/quill/katex.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/quill/editor.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/datatables-bs5/datatables.bootstrap5.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/datatables-responsive-bs5/responsive.bootstrap5.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/datatables-checkboxes-jquery/datatables.checkboxes.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/datatables-buttons-bs5/buttons.bootstrap5.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/cards-advance.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-email.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/apex-charts/apex-charts.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/tagify/tagify.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/@form-validation/form-validation.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/bs-stepper/bs-stepper.css" />
    
    <!-- Page CSS -->
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/cards-advance.css" />
    <link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-email.css" /> <!-- 메일  -->

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/resources/css/groovit.css" />

    <!-- Helpers -->
    <script src="/resources/vuexy/assets/vendor/js/helpers.js"></script>
<!--     <script src="/resources/vuexy/assets/vendor/js/template-customizer.js"></script> -->
    <script src="/resources/vuexy/assets/js/config.js"></script>
</head>

<body>
    <!-- Layout wrapper 시작 -->
    <div class="layout-wrapper layout-content-navbar">
        <!-- Layout container 시작 -->
        <div class="layout-container">
            <!-- aside 시작 -->
            <tiles:insertAttribute name="aside" />
            <!-- // aside 끝 -->

            <!-- Layout page 시작 -->
            <div class="layout-page">
                <!-- header 시작 -->
                <tiles:insertAttribute name="header" />
                <!-- // header 끝 -->

                <!-- Content wrapper 시작 -->
                <div class="content-wrapper">
                    <!-- Content 시작 -->
                    <div class="container-xxl flex-grow-1 container-p-y">
                        <tiles:insertAttribute name="body" />
                    </div>
                    <!-- // Content 끝 -->
 
                    <!-- footer 시작 -->
                    <tiles:insertAttribute name="footer" />
                    <!-- // footer 끝 -->

                    <!-- dim background -->
                    <div class="content-backdrop fade"></div>
                </div>
                <!-- // Content wrapper 끝 -->
            </div>
            <!-- // Layout page 끝 -->
        </div>
        <!-- // Layout container 끝 -->

        <!-- Overlay -->
        <div class="layout-overlay layout-menu-toggle"></div>

        <!-- Drag Target Area To SlideIn Menu On Small Screens -->
        <div class="drag-target"></div>
    </div>
    <!-- // Layout wrapper 끝 -->

    <!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
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
     <script src="/resources/vuexy/assets/vendor/libs/moment/moment.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/flatpickr/flatpickr.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/jkanban/jkanban.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/quill/katex.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/quill/quill.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/select2/select2.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/block-ui/block-ui.js"></script>
    <script src="/resources/vuexy/assets/js/extended-ui-sweetalert2.js"></script>
    
    
    <script src="/resources/vuexy/assets/vendor/libs/apex-charts/apexcharts.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/swiper/swiper.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/datatables-bs5/datatables-bootstrap5.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.js"></script>
<!--     <script src="/resources/vuexy/assets/vendor/libs/jquery/jquery.js"></script> -->
    

    <!-- Main JS -->
    <script src="/resources/vuexy/assets/js/main.js"></script>

    <!-- Page JS -->
    <script src="/resources/vuexy/assets/js/app-email.js"></script>
    <script src="/resources/vuexy/assets/js/dashboards-analytics.js"></script>
    <script src="/resources/vuexy/assets/js/extended-ui-sweetalert2.js"></script>
    
    <script src="/resources/vuexy/assets/js/cards-statistics.js"></script>
    <script src="/resources/vuexy/assets/js/wizard-ex-property-listing.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/@form-validation/auto-focus.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/tagify/tagify.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/cleavejs/cleave.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/cleavejs/cleave-phone.js"></script>
    <script src="/resources/vuexy/assets/vendor/libs/bs-stepper/bs-stepper.js"></script>
    <script src="/resources/vuexy/assets/js/app-kanban.js"></script>
    
    <!-- main -->
    <script src="/resources/vuexy/assets/js/main-dashboard.js"></script>
    
</body>

</html>
