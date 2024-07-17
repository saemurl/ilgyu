<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 외부 스크립트 및 스타일시트 추가 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="/resources/vuexy/assets/vendor/libs/datatables-bs5/datatables-bootstrap5.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<!-- 사용자 정의 스타일 -->
<style>
    .dropdown {
        position: relative;
        display: inline-block;
    }
    .dropdown-content {
        display: none;
        position: absolute;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1;
    }
    .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        transition: background-color 0.3s, color 0.3s;
    }
    .dropdown-content .badge.bg-label-success:hover {
        background-color: #000000; /* Black hover effect */
        color: white;
    }
    .dropdown-content .badge.bg-label-danger:hover {
        background-color: #000000; /* Black hover effect */
        color: white;
    }
    .dropdown-content .badge.bg-label-warning:hover {
        background-color: #000000; /* Black hover effect */
        color: white;
    }
    .dropdown-content .badge.bg-label-primary:hover {
        background-color: #000000; /* Black hover effect */
        color: white;
    }
    .show {
        display: block;
    }
    .badge {
        cursor: pointer;
        display: inline-block;
        padding: 0.5em 1em;
        border-radius: 0.25em;
        text-align: center;
    }
    .bg-label-success {
        background-color: #d4edda;
        color: #155724;
    }
    .bg-label-danger {
        background-color: #f8d7da;
        color: #721c24;
    }
    .bg-label-warning {
        background-color: #fff3cd;
        color: #856404;
    }
    .bg-label-primary {
        background-color: #cce5ff;
        color: #004085;
    }
    .modal-dialog {
        max-width: 600px; /* 원하는 너비로 설정 */
        margin: 1.50rem auto; /* 기본 마진 */
    }
    .modal-content {
        padding: 1rem; /* 모달 내부 여백 조정 */
    }
    .modal-header, .modal-body, .modal-footer {
        padding: 0.5rem; /* 모달 내부 여백 조정 */
    }
</style>

<!-- 사용자 정의 스크립트 -->
<script>
var statusChart, universityChart, applicationTypeChart, majorChart;

$(document).ready(function () {
    // CSRF 토큰 설정
    var csrfToken = $('meta[name="_csrf"]').attr('content');
    var csrfHeader = $('meta[name="_csrf_header"]').attr('content');

    $(document).ajaxSend(function (e, xhr, options) {
        xhr.setRequestHeader(csrfHeader, csrfToken);
    });

    // DataTables 초기화
    var table = $('#DataTables_Table_3').DataTable({
        language: {
            search: "",
            lengthMenu: "_MENU_ entries",
            info: "총 _TOTAL_건 &nbsp | &nbsp 현재 페이지 _PAGE_ / _PAGES_",
            infoEmpty: "등록된 지원자가 없습니다.",
            infoFiltered: "(filtered from _MAX_ total entries)",
            zeroRecords: "검색 결과가 없습니다.",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            },
        },
        lengthChange: true,
        searching: true,
        paging: true,
        info: true,
        ordering: true
    });
    
    // 면접 지원자 등록 버튼 클릭 시 모달 창 열기
    $('#addApplicantBtn').click(function () {
        $('#addApplicantModal').modal('show');
    });
    
 	// 자동 완성 버튼 클릭 시 데이터 자동 입력
    $('#exampleBtn').on('click',function () {
        console.log("자동 완성 버튼 클릭 체크");
        $('#modalapplicantName').val("한서윤");
        $('#status').val("1차 면접 합격");
        $('#modalapplicationType').val("2024 공채");
        $('#modalapplicantContact').val("010-5483-9457");
        $('#modalapplicantEmail').val("seoyun@naver.com");
        $('#modalapplicantUniversity').val("KAIST");
        $('#modalapplicantMajor').val("컴퓨터공학과");
    });

    // 면접 지원자 등록 폼 제출 시
    $('#addApplicantForm').submit(function (e) {
        e.preventDefault();
        var formData = $(this).serialize();
        
        $.ajax({
            url: '/interviews/addApplicant',
            method: 'POST',
            data: formData,
            success: function (response) {
            	console.log("response : ", response);
                if (response.success) {
                    // DataTable에 새로운 데이터 추가
                    var newRow = [
                        '<input type="checkbox" class="dt-checkboxes form-check-input">',
                        response.data.no || '',
                        response.data.status || '',
                        response.data.applicationType || '',
                        response.data.applicantsVOList[0].applicantNm || '',
                        response.data.applicantsVOList[0].university || '',
                        response.data.applicantsVOList[0].major || '',
                        response.data.firstIntrvwDate || '',
                        response.data.secondIntrvwDate || '',
                        response.data.registrationDate || ''
                    ];
                    table.row.add(newRow).draw(false);
                    
                    // 폼 초기화
                    $('#addApplicantForm')[0].reset();

                    // 모달 창 닫기
                    $('#addApplicantModal').modal('hide');
                    
                    // 새로 고침
                    location.href = '/interviews/list';
                } else {
                    alert('Error: ' + response.message);
                }
            },
            error: function (xhr, status, error) {
                console.error('AJAX Error:', error);
                alert('Error: ' + error);
            }
        });
    });

    // 전체 선택/해제 기능 구현
    $('#DataTables_Table_3').on('click', '.dt-checkboxes-select-all input[type="checkbox"]', function () {
        var isChecked = $(this).is(':checked');
        $('#DataTables_Table_3 tbody input[type="checkbox"]').prop('checked', isChecked);
    });

    $('#DataTables_Table_3').on('click', 'tbody input[type="checkbox"]', function () {
        var allChecked = $('#DataTables_Table_3 tbody input[type="checkbox"]').length === $('#DataTables_Table_3 tbody input[type="checkbox"]:checked').length;
        $('.dt-checkboxes-select-all input[type="checkbox"]').prop('checked', allChecked);
    });

    // 엑셀 다운로드 버튼 클릭 이벤트 처리
    $('#exportToExcelBtn').click(function () {
        var selectedIds = [];
        $('#DataTables_Table_3 tbody input[type="checkbox"]:checked').each(function () {
            selectedIds.push($(this).closest('tr').find('td:eq(1)').text());
        });

        if (selectedIds.length > 0) {
            $.ajax({
                url: '/interviews/export',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(selectedIds),
                xhrFields: {
                    responseType: 'blob'
                },
                success: function (data, status, xhr) {
                    var now = new Date();
                    var year = now.getFullYear().toString().substr(-2); // 연도의 마지막 두 자리
                    var month = (now.getMonth() + 1).toString().padStart(2, '0'); // 월
                    var day = now.getDate().toString().padStart(2, '0'); // 일

                    var filename = "인사팀 채용 면접 관리_" + year + month + day + ".xlsx";
                    var blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

                    if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                        window.navigator.msSaveOrOpenBlob(blob, filename);
                    } else {
                        var link = document.createElement('a');
                        link.href = window.URL.createObjectURL(blob);
                        link.download = filename;
                        link.click();
                        window.URL.revokeObjectURL(link.href);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error exporting to Excel:', error);
                }
            });
        } else {
            alert('엑셀로 내보낼 항목을 선택하세요.');
        }
    });

    // 초기 통계 데이터 로드
    updateStatistics();
});

// 드롭다운 표시 함수
function showDropdown(element) {
    event.stopPropagation();  // 이벤트 전파를 막음
    // 다른 열린 드롭다운 메뉴 닫기
    $('.dropdown-content').not($(element).next('.dropdown-content')).hide();
    $(element).next('.dropdown-content').toggle();
}

// 상태 업데이트 함수
function updateStatus(intrvwId, status, element) {
    var csrfToken = $('meta[name="_csrf"]').attr('content');
    var csrfHeader = $('meta[name="_csrf_header"]').attr('content');

    $.ajax({
        url: '/interviews/updateStatus',
        method: 'POST',
        data: {
            intrvwId: intrvwId,
            status: status
        },
        beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        },
        success: function(response) {
            if (response.success) {
                // DOM 업데이트
                var badge = $(element).closest('.dropdown').find('.badge');
                badge.removeClass('bg-label-success bg-label-danger bg-label-warning bg-label-primary');
                badge.text(status);  // 상태 텍스트 업데이트
                switch (status) {
                    case '1차 면접 합격':
                        badge.addClass('bg-label-success');
                        break;
                    case '1차 면접 불합격':
                        badge.addClass('bg-label-danger');
                        break;
                    case '2차 면접 불합격':
                        badge.addClass('bg-label-warning');
                        break;
                    case '최종 합격':
                        badge.addClass('bg-label-primary');
                        break;
                }
                // 드롭다운 숨기기
                $(element).closest('.dropdown-content').hide();

                // 통계 데이터 갱신
                updateStatistics();

                // 드롭다운 메뉴 초기화
                resetDropdownOptions(element.closest('.dropdown'), intrvwId, status);
            } else {
                alert('Error updating status: ' + response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', error);
            alert('Error updating status: ' + error);
        }
    });
}

// 드롭다운 옵션 초기화 함수
function resetDropdownOptions(dropdown, intrvwId, status) {
    var dropdownContent = $(dropdown).find('.dropdown-content');
    dropdownContent.empty();

    if (status !== '1차 면접 합격') {
        dropdownContent.append('<a href="#" class="badge bg-label-success" onclick="updateStatus(\'' + intrvwId + '\', \'1차 면접 합격\', this)">1차 면접 합격</a>');
    }
    if (status !== '1차 면접 불합격') {
        dropdownContent.append('<a href="#" class="badge bg-label-danger" onclick="updateStatus(\'' + intrvwId + '\', \'1차 면접 불합격\', this)">1차 면접 불합격</a>');
    }
    if (status !== '2차 면접 불합격') {
        dropdownContent.append('<a href="#" class="badge bg-label-warning" onclick="updateStatus(\'' + intrvwId + '\', \'2차 면접 불합격\', this)">2차 면접 불합격</a>');
    }
    if (status !== '최종 합격') {
        dropdownContent.append('<a href="#" class="badge bg-label-primary" onclick="updateStatus(\'' + intrvwId + '\', \'최종 합격\', this)">최종 합격</a>');
    }
}

// 통계 데이터 갱신 함수
function updateStatistics() {
    $.ajax({
        url: '/interviews/statistics',
        method: 'GET',
        success: function (data) {
            // 통계 데이터 업데이트 로직
            let statusData = data.statusCount;
            let universityData = data.universityCount;
            let applicationTypeData = data.applicationTypeCount;
            let majorData = data.majorCount;

            // 2024 공채 관련 데이터
            let total2024Applicants = data.total2024Applicants;
            let total2024Pass = data.total2024Pass;
            let total2024Fail = data.total2024Fail;

            // 수시 채용 관련 데이터
            let totalSusiApplicants = data.totalSusiApplicants;
            let totalSusiPass = data.totalSusiPass;
            let totalSusiFail = data.totalSusiFail;

            // 인턴 채용 관련 데이터
            let totalInternApplicants = data.totalInternApplicants;
            let totalInternPass = data.totalInternPass;
            let totalInternFail = data.totalInternFail;

            // 상태 순서를 변경
            const orderedStatusLabels = ['1차 면접 합격', '1차 면접 불합격', '2차 면접 불합격', '최종 합격'];
            const orderedStatusData = orderedStatusLabels.map(label => statusData[label] || 0);

            // 차트를 업데이트
            updateChart(statusChart, orderedStatusLabels, orderedStatusData);
            updateChart(universityChart, Object.keys(universityData), Object.values(universityData));
            updateChart(applicationTypeChart, Object.keys(applicationTypeData), Object.values(applicationTypeData));
            updateChart(majorChart, Object.keys(majorData), Object.values(majorData));

            // 2024 공채 관련 통계 업데이트
            $('#2024Applicants').text('2024 공채 지원자: ' + total2024Applicants);
            $('#2024Pass').text('2024 공채 최종 합격자: ' + total2024Pass);
            $('#2024Fail').text('2024 공채 불합격자: ' + total2024Fail);

            // 수시 채용 관련 통계 업데이트
            $('#SusiApplicants').text('수시 채용 지원자: ' + totalSusiApplicants);
            $('#SusiPass').text('수시 채용 최종 합격자: ' + totalSusiPass);
            $('#SusiFail').text('수시 채용 불합격자: ' + totalSusiFail);

            // 인턴 채용 관련 통계 업데이트
            $('#InternApplicants').text('인턴 채용 지원자: ' + totalInternApplicants);
            $('#InternPass').text('인턴 채용 최종 합격자: ' + totalInternPass);
            $('#InternFail').text('인턴 채용 불합격자: ' + totalInternFail);
        }
    });
}

// 차트 업데이트 함수
function updateChart(chart, labels, data) {
    chart.data.labels = labels;
    chart.data.datasets[0].data = data;
    chart.update();
}

//지원자 상세 정보 보기 함수
function showApplicantDetails(row) {
    // 행에서 data-* 속성 값 가져오기
    var applicantId = $(row).data('applicant-id');
    var applicantName = $(row).data('applicant-name');
    var status = $(row).data('status');
    var applicationType = $(row).data('application-type');
    var applicantContact = $(row).data('applicant-contact');
    var applicantEmail = $(row).data('applicant-email');
    var applicantUniversity = $(row).data('applicant-university');
    var applicantMajor = $(row).data('applicant-major');

    // 모달 창에 데이터 설정
    $('#applicantName').text(applicantName);
    $('#applicantStatus').text(status);
    $('#applicationType').text(applicationType);
    $('#applicantContact').text(applicantContact);
    $('#applicantEmail').text(applicantEmail);
    $('#applicantUniversity').text(applicantUniversity);
    $('#applicantMajor').text(applicantMajor);

    // 모달 창 열기
    $('#applicantModal').modal('show');
}

$(document).ready(function () {
    // AJAX 요청을 통해 통계 데이터를 가져옴
    $.ajax({
        url: '/interviews/statistics',
        method: 'GET',
        success: function (data) {
            console.log(data);

            // Color Variables
            const purpleColor = '#836AF9',
                yellowColor = '#ffe800',
                cyanColor = '#28dac6',
                orangeColor = '#FF8132',
                orangeLightColor = '#FDAC34',
                oceanBlueColor = '#299AFF',
                greyColor = '#4F5D70',
                greyLightColor = '#EDF1F4',
                blueColor = '#2B9AFF',
                blueLightColor = '#84D0FF';

            let cardColor, headingColor, labelColor, borderColor, legendColor;

            if (isDarkStyle) {
                cardColor = config.colors_dark.cardColor;
                headingColor = config.colors_dark.headingColor;
                labelColor = config.colors_dark.textMuted;
                legendColor = config.colors_dark.bodyColor;
                borderColor = config.colors_dark.borderColor;
            } else {
                cardColor = config.colors.cardColor;
                headingColor = config.colors.headingColor;
                labelColor = config.colors.textMuted;
                legendColor = config.colors.bodyColor;
                borderColor = config.colors.borderColor;
            }

            let statusData = data.statusCount;
            let universityData = data.universityCount;
            let applicationTypeData = data.applicationTypeCount;
            let majorData = data.majorCount;

            // 2024 공채 관련 데이터
            let total2024Applicants = data.total2024Applicants;
            let total2024Pass = data.total2024Pass;
            let total2024Fail = data.total2024Fail;

            // 수시 채용 관련 데이터
            let totalSusiApplicants = data.totalSusiApplicants;
            let totalSusiPass = data.totalSusiPass;
            let totalSusiFail = data.totalSusiFail;

            // 인턴 채용 관련 데이터
            let totalInternApplicants = data.totalInternApplicants;
            let totalInternPass = data.totalInternPass;
            let totalInternFail = data.totalInternFail;

            // 상태 순서를 변경
            const orderedStatusLabels = ['1차 면접 합격', '1차 면접 불합격', '2차 면접 불합격', '최종 합격'];
            const orderedStatusData = orderedStatusLabels.map(label => statusData[label] || 0);

            // Chart.js를 사용하여 차트 생성
            // 면접 상태 통계
            statusChart = new Chart(document.getElementById('statusChart').getContext('2d'), {
                type: 'bar',
                data: {
                    labels: orderedStatusLabels,
                    datasets: [{
                        label: '면접 상태 결과',
                        data: orderedStatusData,
                        backgroundColor: purpleColor,
                        borderColor: 'transparent',
                        maxBarThickness: 15,
                        borderRadius: {
                            topRight: 15,
                            topLeft: 15
                        }
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 500
                    },
                    plugins: {
                        tooltip: {
                            rtl: isRtl,
                            backgroundColor: cardColor,
                            titleColor: headingColor,
                            bodyColor: legendColor,
                            borderWidth: 1,
                            borderColor: borderColor
                        },
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                color: borderColor,
                                drawBorder: false,
                                borderColor: borderColor
                            },
                            ticks: {
                                color: labelColor
                            }
                        },
                        y: {
                            grid: {
                                color: borderColor,
                                borderColor: borderColor
                            },
                            ticks: {
                                stepSize: 1,
                                color: labelColor
                            }
                        }
                    }
                }
            });

            // 출신 대학 통계
            universityChart = new Chart(document.getElementById('universityChart').getContext('2d'), {
                type: 'bar',
                data: {
                    labels: Object.keys(universityData),
                    datasets: [{
                        label: '출신 대학',
                        data: Object.values(universityData),
                        backgroundColor: purpleColor,
                        borderColor: 'transparent',
                        maxBarThickness: 15,
                        borderRadius: {
                            topRight: 15,
                            topLeft: 15
                        }
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 500
                    },
                    elements: {
                        bar: {
                            borderRadius: {
                                topRight: 15,
                                bottomRight: 15
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            rtl: isRtl,
                            backgroundColor: cardColor,
                            titleColor: headingColor,
                            bodyColor: legendColor,
                            borderWidth: 1,
                            borderColor: borderColor
                        },
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                color: borderColor,
                                borderColor: borderColor
                            },
                            ticks: {
                                color: labelColor,
                                callback: function (value, index, values) {
                                    return Number.isInteger(value) ? value : null;
                                }
                            }
                        },
                        y: {
                            grid: {
                                borderColor: borderColor,
                                display: false,
                                drawBorder: false
                            },
                            ticks: {
                                stepSize: 1,
                                color: labelColor
                            }
                        }
                    }
                }
            });

            // 지원 구분 통계
            applicationTypeChart = new Chart(document.getElementById('applicationTypeChart').getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: Object.keys(applicationTypeData),
                    datasets: [{
                        label: '지원 구분',
                        data: Object.values(applicationTypeData),
                        backgroundColor: [config.colors.primary, orangeLightColor, cyanColor],
                        pointStyle: 'rectRounded',
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    animation: {
                        duration: 500
                    },
                    cutout: '68%',
                    plugins: {
                        legend: {
                            display: true,     // 범례 표시 여부
                            position: 'right', // 범례 위치
                            labels: {
                                usePointStyle: true,
                                padding: 25,
                                boxWidth: 8,
                                boxHeight: 8,
                                color: legendColor
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.labels || '',
                                        value = context.parsed;
                                    const output = ' ' + label + ' : ' + value + ' %';
                                    return output;
                                }
                            },
                            // Updated default tooltip UI
                            rtl: isRtl,
                            backgroundColor: cardColor,
                            titleColor: headingColor,
                            bodyColor: legendColor,
                            borderWidth: 1,
                            borderColor: borderColor
                        }
                    }
                }
            });

            // 세부 전공 통계
            majorChart = new Chart(document.getElementById('majorChart').getContext('2d'), {
                type: 'polarArea',
                data: {
                    labels: Object.keys(majorData),
                    datasets: [{
                        label: '세부 전공',
                        data: Object.values(majorData),
                        backgroundColor: [purpleColor, yellowColor, orangeColor, oceanBlueColor, greyColor, cyanColor],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 500
                    },
                    scales: {
                        r: {
                            ticks: {
                                display: false,
                                color: labelColor
                            },
                            grid: {
                                display: false
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            // Updated default tooltip UI
                            rtl: isRtl,
                            backgroundColor: cardColor,
                            titleColor: headingColor,
                            bodyColor: legendColor,
                            borderWidth: 1,
                            borderColor: borderColor
                        },
                        legend: {
                            rtl: isRtl,
                            position: 'right',
                            labels: {
                                usePointStyle: true,
                                padding: 25,
                                boxWidth: 8,
                                boxHeight: 8,
                                color: legendColor
                            }
                        }
                    }
                }
            });
            
            // 드롭다운 외부 클릭 시 드롭다운 메뉴 닫기
            $(document).click(function() {
                $('.dropdown-content').hide();
            });

            // 드롭다운 메뉴 클릭 시 이벤트 전파를 막아 드롭다운 메뉴가 닫히지 않도록 합니다.
            $('.dropdown-content').click(function(event) {
                event.stopPropagation();
            });

            // 2024 공채 관련 통계 표시
            $('#2024Applicants').text('2024 공채 지원자: ' + total2024Applicants);
            $('#2024Pass').text('2024 공채 최종 합격자: ' + total2024Pass);
            $('#2024Fail').text('2024 공채 불합격자: ' + total2024Fail);

            // 수시 채용 관련 통계 표시
            $('#SusiApplicants').text('수시 채용 지원자: ' + totalSusiApplicants);
            $('#SusiPass').text('수시 채용 최종 합격자: ' + totalSusiPass);
            $('#SusiFail').text('수시 채용 불합격자: ' + totalSusiFail);

            // 인턴 채용 관련 통계 표시
            $('#InternApplicants').text('인턴 채용 지원자: ' + totalInternApplicants);
            $('#InternPass').text('인턴 채용 최종 합격자: ' + totalInternPass);
            $('#InternFail').text('인턴 채용 불합격자: ' + totalInternFail);
        }
    });
});
</script>

<!-- 통계 차트 -->
<div class="row">
    <div class="col-md-6 mb-4">
        <div class="card" style="min-height: 300px;">
            <h5 class="card-header">면접 결과</h5>
            <div class="card-body">
                <canvas id="statusChart" style="max-height: 300px;"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-6 mb-4">
        <div class="card" style="min-height: 300px;">
            <h5 class="card-header">출신 대학</h5>
            <div class="card-body">
                <canvas id="universityChart" style="max-height: 300px;"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-6 mb-4">
        <div class="card" style="min-height: 300px;">
            <h5 class="card-header">지원 구분</h5>
            <div class="card-body">
                <canvas id="applicationTypeChart" style="max-height: 300px;"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-6 mb-4">
        <div class="card" style="min-height: 300px;">
            <h5 class="card-header">세부 전공</h5>
            <div class="card-body">
                <canvas id="majorChart" style="max-height: 300px;"></canvas>
            </div>
        </div>
    </div>
</div>
<hr>

<!-- 2024 공채 통계 -->
<div class="row">
    <div class="col-md-4">
        <div class="card">
            <h5 class="card-header">2024 공채 통계</h5>
            <div class="table-responsive text-nowrap">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>합격/불합격자 수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span id="2024Applicants"></span></td>
                        </tr>
                        <tr>
                            <td><span id="2024Pass"></span></td>
                        </tr>
                        <tr>
                            <td><span id="2024Fail"></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 수시 채용 통계 -->
    <div class="col-md-4">
        <div class="card">
            <h5 class="card-header">수시 채용 통계</h5>
            <div class="table-responsive text-nowrap">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>합격/불합격자 수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span id="SusiApplicants"></span></td>
                        </tr>
                        <tr>
                            <td><span id="SusiPass"></span></td>
                        </tr>
                        <tr>
                            <td><span id="SusiFail"></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 인턴 채용 통계 -->
    <div class="col-md-4">
        <div class="card">
            <h5 class="card-header">인턴 채용 통계</h5>
            <div class="table-responsive text-nowrap">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>합격/불합격자 수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span id="InternApplicants"></span></td>
                        </tr>
                        <tr>
                            <td><span id="InternPass"></span></td>
                        </tr>
                        <tr>
                            <td><span id="InternFail"></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<hr>

<!-- 면접 지원자 리스트 -->
<div class="card">
    <div class="d-flex justify-content-between align-items-center mb-3" style="margin-bottom: 0px !important;">
        <h5 class="card-header m-0">면접 지원자 리스트</h5>
        <!-- 면접 지원자 등록 버튼 -->
        <button id="addApplicantBtn" class="btn rounded-pill btn-outline-primary waves-effect" style="margin-left: 910px;">지원자 등록</button>
        <!-- 면접 지원자 삭제 버튼 -->
		<!-- <button id="deleteApplicantBtn" class="btn rounded-pill btn-outline-danger waves-effect">지원자 삭제</button> -->
        <!-- 엑셀 다운로드 버튼 추가 -->
        <button id="exportToExcelBtn" class="btn rounded-pill btn-outline-success waves-effect" style="margin-right: 16px;">리스트 다운로드</button>
    </div>
    <div class="card-datatable dataTable_select text-nowrap">
        <div id="DataTables_Table_3_wrapper" class="dataTables_wrapper dt-bootstrap5 no-footer">
            <div class="table-responsive">
                <table class="dt-select-table table dataTable no-footer dt-checkboxes-select"
                    id="DataTables_Table_3" aria-describedby="DataTables_Table_3_info"
                    style="width: 1399px;">
                    <thead>
                        <tr>
                            <th class="sorting_disabled dt-checkboxes-cell dt-checkboxes-select-all"
                                rowspan="1" colspan="1" style="width: 18px;" data-col="0"
                                aria-label=""><input type="checkbox"
                                class="form-check-input"></th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="No.: activate to sort column ascending"
                                style="width: 50px;">No.</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="Status: activate to sort column ascending"
                                style="width: 100px;">상태</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="지원 구분: activate to sort column ascending"
                                style="width: 100px;">지원 구분</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="지원자: activate to sort column ascending"
                                style="width: 100px;">지원자</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="출신대학: activate to sort column ascending"
                                style="width: 100px;">출신대학</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="세부전공: activate to sort column ascending"
                                style="width: 100px;">세부전공</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="1차 면접일: activate to sort column ascending"
                                style="width: 100px;">1차 면접일</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="2차 면접일: activate to sort column ascending"
                                style="width: 100px;">2차 면접일</th>
                            <th class="sorting" tabindex="0"
                                aria-controls="DataTables_Table_3" rowspan="1" colspan="1"
                                aria-label="등록일: activate to sort column ascending"
                                style="width: 100px;">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
				    <c:forEach var="interviewsVO" items="${interviewsList}" varStatus="stat">
				        <tr>
				            <td class="dt-checkboxes-cell"><input name="check" type="checkbox" class="dt-checkboxes form-check-input" value="${interviewsVO.applicantsVOList[0].applicantId}"></td>
				            <td>${stat.count}</td>
				            <td>
				                <div class="dropdown">
				                    <span class="badge bg-label-${interviewsVO.status == '1차 면접 합격' ? 'success' : interviewsVO.status == '2차 면접 불합격' ? 'warning' : interviewsVO.status == '1차 면접 불합격' ? 'danger' : 'primary'}" onclick="showDropdown(this)">${interviewsVO.status}</span>
				                    <div class="dropdown-content">
				                        <c:if test="${interviewsVO.status != '1차 면접 합격'}">
				                            <a href="#" class="badge bg-label-success" onclick="updateStatus('${interviewsVO.intrvwId}', '1차 면접 합격', this)">1차 면접 합격</a>
				                        </c:if>
				                        <c:if test="${interviewsVO.status != '1차 면접 불합격'}">
				                            <a href="#" class="badge bg-label-danger" onclick="updateStatus('${interviewsVO.intrvwId}', '1차 면접 불합격', this)">1차 면접 불합격</a>
				                        </c:if>
				                        <c:if test="${interviewsVO.status != '2차 면접 불합격'}">
				                            <a href="#" class="badge bg-label-warning" onclick="updateStatus('${interviewsVO.intrvwId}', '2차 면접 불합격', this)">2차 면접 불합격</a>
				                        </c:if>
				                        <c:if test="${interviewsVO.status != '최종 합격'}">
				                            <a href="#" class="badge bg-label-primary" onclick="updateStatus('${interviewsVO.intrvwId}', '최종 합격', this)">최종 합격</a>
				                        </c:if>
				                    </div>
				                </div>
				            </td>
				            <td>${interviewsVO.applicationType}</td>
				            <c:forEach var="applicantsVO" items="${interviewsVO.applicantsVOList}" varStatus="stat">
				                <td class="applicant-name" 
				                    onclick="showApplicantDetails(this)" 
				                    data-applicant-id="${applicantsVO.applicantId}"
				                    data-status="${interviewsVO.status}"
				                    data-application-type="${interviewsVO.applicationType}" 
				                    data-applicant-name="${applicantsVO.applicantNm}" 
				                    data-applicant-contact="${applicantsVO.contact}" 
				                    data-applicant-email="${applicantsVO.applicantEmail}" 
				                    data-applicant-university="${applicantsVO.university}" 
				                    data-applicant-major="${applicantsVO.major}">${applicantsVO.applicantNm}</td>
				                <td>${applicantsVO.university}</td>
				                <td>${applicantsVO.major}</td>
				            </c:forEach>
				            <td><fmt:formatDate value="${interviewsVO.firstIntrvwDate}" pattern="yyyy-MM-dd"/></td>
				            <td><fmt:formatDate value="${interviewsVO.secondIntrvwDate}" pattern="yyyy-MM-dd"/></td>
				            <td><fmt:formatDate value="${interviewsVO.registrationDate}" pattern="yyyy-MM-dd"/></td>
				        </tr>
				    </c:forEach>
				</tbody>
                </table>
                <div style="width: 1%;"></div>
            </div>
        </div>
    </div>
</div>
<!-- 상세 정보 보기 모달 -->
<div class="modal fade" id="applicantModal" tabindex="-1" aria-labelledby="applicantModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="applicantModalLabel">지원자 상세 정보</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <table class="table table-bordered">
          <tbody>
            <tr>
              <th>이름</th>
              <td id="applicantName"></td>
            </tr>
            <tr>
              <th>상태</th>
              <td id="applicantStatus"></td>
            </tr>
            <tr>
              <th>지원 구분</th>
              <td id="applicationType"></td>
            </tr>
            <tr>
              <th>연락처</th>
              <td id="applicantContact"></td>
            </tr>
            <tr>
              <th>이메일</th>
              <td id="applicantEmail"></td>
            </tr>
            <tr>
              <th>출신 대학</th>
              <td id="applicantUniversity"></td>
            </tr>
            <tr>
              <th>세부 전공</th>
              <td id="applicantMajor"></td>
            </tr>
            <!-- 추가적인 지원자 정보가 있다면 여기에 추가 -->
          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<!-- 면접 지원자 등록 모달 -->
<div class="modal fade" id="addApplicantModal" tabindex="-1" aria-labelledby="addApplicantModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addApplicantModalLabel">지원자 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addApplicantForm">
                    <div class="mb-3">
                        <label for="applicantName" class="form-label">이름</label>
                        <input type="text" class="form-control" id="modalapplicantName" name="applicantName" required>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">상태</label>
                        <select class="form-control" id="status" name="status" required>
                        	<option value="">상태 구분 선택</option>
                            <option value="1차 면접 합격">1차 면접 합격</option>
                            <option value="1차 면접 불합격">1차 면접 불합격</option>
                            <option value="2차 면접 불합격">2차 면접 불합격</option>
                            <option value="최종 합격">최종 합격</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="applicationType" class="form-label">지원 구분</label>
                        <select class="form-control" id="modalapplicationType" name="applicationType" required>
		                    <option value="">지원 구분 선택</option>
		                    <option value="2024 공채">2024 공채</option>
		                    <option value="수시 채용">수시 채용</option>
		                    <option value="인턴 채용">인턴 채용</option>
		                </select>
                    </div>
                    <div class="mb-3">
                        <label for="applicantContact" class="form-label">연락처</label>
                        <input type="text" class="form-control" id="modalapplicantContact" name="applicantContact" required>
                    </div>
                    <div class="mb-3">
                        <label for="applicantEmail" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="modalapplicantEmail" name="applicantEmail" required>
                    </div>
                    <div class="mb-3">
                        <label for="applicantUniversity" class="form-label">출신 대학</label>
                        <input type="text" class="form-control" id="modalapplicantUniversity" name="applicantUniversity" required>
                    </div>
                    <div class="mb-3">
                        <label for="applicantMajor" class="form-label">세부 전공</label>
                        <input type="text" class="form-control" id="modalapplicantMajor" name="applicantMajor" required>
                    </div>
                    <button type="submit" class="btn btn-primary">등록</button>
		            <button type="button" id="exampleBtn" style="background-color: #f0f0f0; border: none; width: 5px; height: 10px; align-self: center;"></button>
                </form>
            </div>
        </div>
    </div>
</div>
