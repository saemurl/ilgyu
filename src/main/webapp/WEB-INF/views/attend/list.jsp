<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>

<style>

</style>

<script type="text/javascript">
$(document).ready(function() {
	
	let attnTable;
	
	function createAttnTable() {
    
		if (attnTable) {
    		attnTable.destroy();	// 이미 있으면 제거
   	 	}
		
		let selectMonth = $('#monthSelect').val();
		
		$.ajax({
	        contentType: "application/json;charset=utf-8",
	        data: JSON.stringify({ selectMonth: selectMonth }),
	        url: "/attendance/loadAttnTable",
	        type: "post",
	        beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
	        success: function(attendanceVOList) {
	        	
	        	console.log("근태 테이블 받아온 값 체크 : ", attendanceVOList);	
	        	
	        	let str = `<table id="attnTable" class="table table-hover">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>일자</th>
                            <th>출근시간</th>
                            <th>퇴근시간</th>
                            <th>근무시간</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>`;

                $.each(attendanceVOList, function(index, attendanceVO) {
                	
                	const formatDate = (dateTime) => {
                        return dateTime ? dateTime.substring(0, 10) : 'N/A';
                    };

                    const formatTime = (dateTime) => {
                        return dateTime ? dateTime.substring(11, 19) : '-';
                    };
                    
                    let attnBgng = attendanceVO.attnBgng ? new Date(attendanceVO.attnBgng) : null;
                    let attnEnd = attendanceVO.attnEnd ? new Date(attendanceVO.attnEnd) : null;
                    
                    let attnWorkHour = '-';
                    if (attnBgng && attnEnd) {
                        let differenceInMillis = attnEnd - attnBgng;
                        let hours = Math.floor(differenceInMillis / (1000 * 60 * 60));
                        let minutes = Math.floor((differenceInMillis / (1000 * 60)) % 60);
                        let seconds = Math.floor((differenceInMillis / 1000) % 60);
                        attnWorkHour = `\${hours.toString().padStart(2, '0')}:\${minutes.toString().padStart(2, '0')}:\${seconds.toString().padStart(2, '0')}`;
                    }
                    
                    str += `
                        <tr>
                            <td>\${index + 1}</td>
                            <td>\${formatDate(attendanceVO.attnBgng)}</td>
                            <td>\${formatTime(attendanceVO.attnBgng)}</td>
                            <td>\${formatTime(attendanceVO.attnEnd)}</td>
                            <td>\${attnWorkHour}</td>`;
	                        if(attendanceVO.attnStts == 'AS00'){
	                            str += `<td><span class="badge bg-label-success">정상 근무</span></td>`;
	                        };    
	                        if(attendanceVO.attnStts == 'AS01'){
	                            str += `<td><span class="badge bg-label-warning">오전 반차</span></td>`;
	                        };    
	                        if(attendanceVO.attnStts == 'AS02'){
	                            str += `<td><span class="badge bg-label-danger">오후 반차</span></td>`;
	                        };    
                    str +=  `</tr>`;
                });

                str += `</tbody></table>`;

                $('#myAttnTableArea').html(str);

                const myAttnTable = document.querySelector("#attnTable");
                attnTable = new simpleDatatables.DataTable(myAttnTable, {
                    labels : {
                        placeholder : "검색어를 입력해 주세요.",
                        noRows : "출근 정보가 존재하지 않습니다.",
                        info : "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
                        noResults : "검색 결과가 없습니다."
                    },
                    searchable: false,
                    perPageSelect : false,
                    perPage : 5
                });
	        }
		});
		
	
	}
	
	$('#monthArea').on('change', function () {
		let selectMonth = $('#monthSelect').val();
		console.log("선택된 달 : " + selectMonth);
		// 테이블 호출
		createAttnTable();
	});
	
	
	function createChart() {
		
		$.ajax({
	        contentType: "application/json;charset=utf-8",
	        url: "/attendance/loadAttnChart",
	        type: "post",
	        beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
	        success: function(attnMonthMapList) {
	        	
	        	console.log("가져온 값 체크 : ", attnMonthMapList);
	        	
	        	const chartColors = {
	        	        column: {
	        	            bg: 'rgba(0, 0, 0, 0.1)',
	        	            series1: '#28c76f',
	        	            series2: '#ff9f43',
	        	            series3: '#ea5455',
	        	        },
	        	        label: '#6c757d',
	        	        border: '#f1f3fa'
	        	    };

	        	    const months = [];
	        	    const attnFullData = [];
	        	    const morningOffData = [];
	        	    const afternoonOffData = [];

	        	    attnMonthMapList.forEach(function(item) {
	        	        months.push(item.MONTH);
	        	        attnFullData.push(Number(item.ATTN_FULL));
	        	        morningOffData.push(Number(item.MORNING_OFF));
	        	        afternoonOffData.push(Number(item.AFTERNOON_OFF));
	        	    });

	        	    console.log("Months: ", months);
	        	    console.log("Attn Full Data: ", attnFullData);
	        	    console.log("Morning Off Data: ", morningOffData);
	        	    console.log("Afternoon Off Data: ", afternoonOffData);

	        	    const barChartEl = document.querySelector('#myChartArea'),
	        	        barChartConfig = {
	        	            chart: {
	        	                height: 280, // 원하는 높이
	        	                width: '100%', // 원하는 너비
	        	                type: 'bar',
	        	                stacked: true,
	        	                parentHeightOffset: 0,
	        	                toolbar: {
	        	                    show: false
	        	                }
	        	            },
	        	            plotOptions: {
	        	                bar: {
	        	                    columnWidth: '15%',
	        	                    colors: {
	        	                        backgroundBarColors: Array(12).fill(chartColors.column.bg),
	        	                        backgroundBarRadius: 10
	        	                    }
	        	                }
	        	            },
	        	            dataLabels: {
	        	                enabled: false
	        	            },
	        	            legend: {
	        	                show: true,
	        	                position: 'top',
	        	                horizontalAlign: 'start',
	        	                labels: {
	        	                    colors: chartColors.label,
	        	                    useSeriesColors: false
	        	                }
	        	            },
	        	            colors: [chartColors.column.series1, chartColors.column.series2, chartColors.column.series3],
	        	            stroke: {
	        	                show: true,
	        	                colors: ['transparent']
	        	            },
	        	            grid: {
	        	                borderColor: chartColors.border,
	        	                xaxis: {
	        	                    lines: {
	        	                        show: true
	        	                    }
	        	                }
	        	            },
	        	            series: [
	        	                {
	        	                    name: '정상 출근',
	        	                    data: attnFullData
	        	                },
	        	                {
	        	                    name: '오전 반차',
	        	                    data: morningOffData
	        	                },
	        	                {
	        	                    name: '오후 반차',
	        	                    data: afternoonOffData
	        	                }
	        	            ],
	        	            xaxis: {
	        	                categories: months,
	        	                axisBorder: {
	        	                    show: false
	        	                },
	        	                axisTicks: {
	        	                    show: false
	        	                },
	        	                labels: {
	        	                    style: {
	        	                        colors: chartColors.label,
	        	                        fontSize: '13px'
	        	                    }
	        	                }
	        	            },
	        	            yaxis: {
	        	                max: 31, // 최대값을 31로 설정하여 각 달의 일수를 기준으로 설정
	        	                labels: {
	        	                    style: {
	        	                        colors: chartColors.label,
	        	                        fontSize: '13px'
	        	                    }
	        	                }
	        	            },
	        	            fill: {
	        	                opacity: 1
	        	            }
	        	        };

	        	    if (typeof barChartEl !== undefined && barChartEl !== null) {
	        	        const barChart = new ApexCharts(barChartEl, barChartConfig);
	        	        barChart.render();
	        	    }
	        }
		});  
	}
	
	createChart();
	
	// 페이지 로딩 후 이번 달 자동선택 처리 스크립트 
	let currentMonth = new Date().getMonth() + 1;
	if(currentMonth < 10) {
		currentMonth = '0' + currentMonth
	}
	$('#monthSelect').val(currentMonth);
    createAttnTable();
	
});
</script>

<div class="card" id="topArea" style="width: auto; height: 450px; margin-bottom: 10px;">
	<div style="padding: 20px;">
		
		<div id="monthArea" style="display: flex;">
			<input type="text" class="form-control" id="nowYear" value="2024" readonly style="width: 100px; margin-right: 20px; text-align: center;">
			<select class="form-select" id="monthSelect" style="width: 200px;">
				<option value="선택" selected disabled>선택해주세요</option>
		        <option value="01">1월</option>
		        <option value="02">2월</option>
		        <option value="03">3월</option>
		        <option value="04">4월</option>
		        <option value="05">5월</option>
		        <option value="06">6월</option>
		        <option value="07">7월</option>
		        <option value="08">8월</option>
		        <option value="09">9월</option>
		        <option value="10">10월</option>
		        <option value="11">11월</option>
		        <option value="12">12월</option>
	        </select>
		</div>
		<small style="color: #E57373">※ 근태 조회는 한 해 기준으로만 가능합니다. 이전 년도 정보 조회가 필요할 경우 관리팀에 별도 문의주세요.</small>
		
		<div id="myAttnTableArea">
			<!-- 내 근태 현황 테이블 영역 -->
			<div style="text-align: center;">
				<hr/><br/><br/><br/><br/><br/><br/>
					<small style="text-align: center;">[ 조회할 날짜를 선택해주세요 ]</small>
				<br/><br/><br/><br/><br/><br/><hr/>
			</div>
		</div>
	
	</div>
</div>

<div class="card" id="bottomArea" style="width: auto; height: auto;">
	<div class="bg-primary" style="border-top-left-radius: 5px; border-top-right-radius: 5px; color: white; padding: 3px; text-align: center; width:auto;">
		<p style="margin: 0px">
			<strong>월 별 근무 현황</strong>
		</p>
	</div>
	<div id="myChartArea" style="padding: 20px;">
		<!-- 월별 차트 영역 -->
	</div>
</div>

