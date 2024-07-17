<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
<script src="/resources/vuexy/assets/vendor/libs/chartjs/chartjs.js"></script>
<style>
#fbCn {
	height: 387px;
	overflow: scroll;
	padding: 10px;
}
</style>


<div class="card">
    <div class="" style="display: flex; justify-content: space-between; align-items: center; padding: 10px ">
        <div>
            <h5 class="card-header">신고 이력</h5>
        </div>
        <div class="btn-group" role="group" aria-label="Basic radio toggle button group" style="height: ">
            <input type="radio" class="btn-check" name="btnradio" id="btnradio1" value="0" checked>
            <label class="btn btn-outline-primary" for="btnradio1">전체 보기</label>

            <input type="radio" class="btn-check" name="btnradio" id="btnradio2" value="1">
            <label class="btn btn-outline-primary" for="btnradio2">신고 접수</label>

            <input type="radio" class="btn-check" name="btnradio" id="btnradio3" value="2">
            <label class="btn btn-outline-primary" for="btnradio3">제재 완료</label>

            <input type="radio" class="btn-check" name="btnradio" id="btnradio4" value="3">
            <label class="btn btn-outline-primary" for="btnradio4">처리 완료</label>
        </div>
    </div>
    <div class="table-responsive" style="height: 250px">
        <table id="myTable" class="table table-hover" style="text-align: center; ">
            <thead>
                <tr>
                    <th>신고 번호</th>
                    <th>신고자 </th>
                    <th>신고 타입</th>
                    <th>게시글 번호</th>
                    <th>게시글 등록자</th>
                    <th>신고 발생 일자</th>
                    <th>처리 상태</th>
                    <!--                     <th>Actions</th> -->
                </tr>
            </thead>
            <tbody class="table-border-bottom-0" id="boardList" data-bs-toggle="modal" data-bs-target="#backDropModal">

                <c:forEach var="declareBoardList" items="${declareBoardList}" varStatus="stat">
                    <tr class="boardList" data-value = "${declareBoardList.DCLR_NO }">
                        <td>${declareBoardList.DCLR_NO } <input type="hidden" class="dclrNo" value="${declareBoardList.DCLR_NO }"></td>
                        <td>${declareBoardList.DECLARER_EMP_NM }</td>
                        <td>${declareBoardList.DCLR_TYPE }</td>
                        <td>${declareBoardList.FB_NO }</td>
                        <td>${declareBoardList.FB_FRST_WRTR_EMP_NM }</td>
                        <td>${declareBoardList.DCLR_DATE }</td>

                        <c:choose>
                            <c:when test="${declareBoardList.FB_STTS eq 1 }">
                                <td><span class="badge bg-label-danger  me-1">신고접수</span></td>
                            </c:when>
                            <c:when test="${declareBoardList.FB_STTS eq 2 }">
                                <td><span class="badge bg-label-warning  me-1">제재완료</span></td>
                            </c:when>
                            <c:when test="${declareBoardList.FB_STTS eq 3 }">
                                <td><span class="badge bg-label-success me-1">처리완료</span></td>
                            </c:when>
                        </c:choose>
                    </tr>
                </c:forEach>

            </tbody>
        </table>
    </div>
    <hr>
    <div class="row"  style="text-align: center;">
        <div class="col-8">
        	<div class="card-header header-elements">
                <h5 class="card-title mb-0" >월별 신고량 통계</h5>
                <div class="card-header-elements ms-auto py-0 dropdown">
                </div>
            </div>
        	<div class="card-body">
            	<canvas id="barChart" class="chartjs" data-height="400"></canvas>
            </div>
        </div>
        <div class="col-4">
            <div class="card-header header-elements">
                <h5 class="card-title mb-0"  >신고 타입 통계</h5>
                <div class="card-header-elements ms-auto py-0 dropdown">
                </div>
            </div>
            <div class="card-body">
                <canvas id="horizontalBarChart" class="chartjs" data-height="400"></canvas>
            </div>
        </div>
    </div>
</div>
<br>

















<!-- Modal -->
<div class="modal fade declareDetail" id="backDropModal"  data-bs-backdrop="static" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="col" style="display: flex; justify-content: space-between;">
                    <div>
                        <h4 class="modal-title" id="backDropModalTitle">신고 상세보기</h4>
                    </div>
                    <div>
                        <p id="dclrStts"></p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body container ">
                <div class="row">
                    <div class="col-4">
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="dclrNo" class="form-label">신고번호</label>
                                <input type="text" id="dclrNo" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="dclrDate" class="form-label">신고일시</label>
                                <input type="text" id="dclrDate" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="dclrEmpId" class="form-label">신고자 회원번호</label>
                                <input type="text" id="dclrEmpId" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="dclrEmpNm" class="form-label">신고자 이름</label>
                                <input type="text" id="dclrEmpNm" class="form-control" readonly>
                            </div>
                        </div>
                        <hr>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="fbNo" class="form-label">게시글 번호</label>
                                <input type="text" id="fbNo" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="fbfweNm" class="form-label">게시글 작성자 이름</label>
                                <input type="text" id="fbfweNm" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="dclrType" class="form-label">신고 사유</label>
                                <input type="text" id="dclrType" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="col-8">
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="fbTtl" class="form-label">게시글 제목</label>
                                <input type="text" id="fbTtl" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col mb-0">
                                <label for="fbCn" class="form-label">작성 내용</label>
<!--                                     <textarea class="form-control" id="fbCn" aria-label="With textarea" rows="16" readonly></textarea> -->
                                <div class="card" id="fbCn"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <hr>
            <p style="text-align: center;">게시물 신고 처리</p>
            <div style="display:flex; justify-content: center;">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="2" />
                    <label class="form-check-label" for="inlineRadio2">게시물 재제 처리</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio3" value="3" />
                    <label class="form-check-label" for="inlineRadio3">신고 완료 처리</label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="declareBoardCont">저장</button>
            </div>
        </div>
    </div>
</div>



<script>
$(document).ready(function(){

    $("input[name='btnradio']").on("change", function() {
        let btnradioVal = $("input[name='btnradio']:checked").val();
        console.log("btnradioVal", btnradioVal);

        if (btnradioVal == 0) {
            $.ajax({
                url: "/declare/declareDefaultList",
                contentType: "application/json;charset=utf-8",
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result : ", result);
                    $("#boardList").empty();
                    let str = ``;
                    $.each(result, function(index, item) {

                        str += `<tr  onclick="boardList(this)">`;
                        str += `<td>\${item.DCLR_NO } <input type="hidden" class="dclrNo" value="\${item.DCLR_NO }"></td>`;
                        str += `<td>\${item.DECLARER_EMP_NM }</td>`;
                        str += `<td>\${item.DCLR_TYPE }</td>`;
                        str += `<td>\${item.FB_NO }</td>`;
                        str += `<td>\${item.FB_FRST_WRTR_EMP_NM }</td>`;
                        str += `<td>\${item.DCLR_DATE }</td>`;

                        if (item.FB_STTS == 1) {
                            str += `<td><span class="badge bg-label-danger  me-1">신고접수</span></td>`;
                        } else if (item.FB_STTS == 2) {
                            str += `<td><span class="badge bg-label-warning  me-1">제재완료</span></td>`;
                        } else {
                            str += `<td><span class="badge bg-label-success me-1">처리완료</span></td>`;
                        }
                        str += ` </tr>`;


                        $("#boardList").append(str);
                        str = ``;

                    });
                }
            });
        } else {
            $("#boardList").empty();
            let data = {
                "btnradioVal": btnradioVal
            }
            console.log("data", data);
            $.ajax({
                url: "/declare/declareCateList",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify(data),
                type: "post",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("result : ", result);
                    $("#boardList").empty();
                    let str = ``;
                    $.each(result, function(index, item) {

                        str += `<tr  onclick="boardList(this)">`;
                        str += `<td>\${item.DCLR_NO } <input type="hidden" class="dclrNo" value="\${item.DCLR_NO }"></td>`;
                        str += `<td>\${item.DECLARER_EMP_NM }</td>`;
                        str += `<td>\${item.DCLR_TYPE }</td>`;
                        str += `<td>\${item.FB_NO }</td>`;
                        str += `<td>\${item.FB_FRST_WRTR_EMP_NM }</td>`;
                        str += `<td>\${item.DCLR_DATE }</td>`;

                        if (item.FB_STTS == 1) {
                            str += `<td><span class="badge bg-label-danger  me-1">신고접수</span></td>`;
                        } else if (item.FB_STTS == 2) {
                            str += `<td><span class="badge bg-label-warning  me-1">제재완료</span></td>`;
                        } else {
                            str += `<td><span class="badge bg-label-success me-1">처리완료</span></td>`;
                        }
                        str += ` </tr>`;


                        $("#boardList").append(str);
                        str = ``;

                    });

                }
            });
        }





    })


    let dclrNo;

$(document).on('click', '.boardList', function(){
	
	console.log("value체크  : " , $(this).data('value'));
	dclrNo = $(this).data('value');
	declareBoardDetail();
	
});


    function declareBoardDetail() {
        let data = {
            "dclrNo": dclrNo
        }
        $.ajax({
            url: "/declare/declareBoardDetail",
            contentType: "application/json;charset=utf-8",
            data: dclrNo,
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("result : ", result);
                $("#dclrStts").empty();
                let dclrStts = result.DCLR_STTS;
                console.log("dclrStts", dclrStts)
                if (dclrStts == 1) {
                    let str = `처리 상태 : <span class="badge bg-label-danger  me-1">신고접수</span>`
                    $("#dclrStts").append(str);
                } else if (dclrStts == 2) {
                    let str = `처리 상태 : <span class="badge bg-label-warning  me-1">제재완료</span>`
                    $("#dclrStts").append(str);
                } else {
                    let str = `처리 상태 : <span class="badge bg-label-success me-1">처리완료</span>`
                    $("#dclrStts").append(str);
                }


                $("#dclrNo").val(result.DCLR_NO);
                $("#dclrDate").val(result.DCLR_DATE);
                $("#dclrEmpId").val(result.EMP_ID);
                $("#dclrEmpNm").val(result.DECLARER_EMP_NM);

                $("#fbNo").val(result.FB_NO);
                $("#fbfweNm").val(result.FB_FRST_WRTR_EMP_NM);
                $("#dclrType").val(result.DCLR_TYPE);
                $("#fbTtl").val(result.FB_TTL);
//                 $("#fbCn").val(result.FB_CN);
                $("#fbCn").html(result.FB_CN);
            }
        });
    }

    $("#declareBoardCont").on("click", function() {
        let fbNo = $("#fbNo").val();
        let dclrNo = $("#dclrNo").val();
        let dclrStts = $("input[name='inlineRadioOptions']:checked").val();
        console.log("클릭 한 신고 게시글 번호 확인", fbNo);
        console.log("클릭 한 신고 처리 값 확인", dclrStts);

        if (dclrStts == null) {
            alert("처리방법을 선택하고 저장을 클릭해 주세요.")
            return;
        }
        let data = {
            "dclrNo": dclrNo,
            "fbNo": fbNo,
            "dclrStts": dclrStts
        }
        $.ajax({
            url: "/declare/declareBoardCnt",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("result : ", result);
                if (result == 2) {
                    alert("신고 정보가 수정되었습니다.");
                    location.href = "/declare/boardList";
                }
                declareBoardDetail();
                location.href = "/declare/boardList";
            }
        });


    });

    const ctx = document.getElementById('myChart');
    declareBoardCount();

    function declareBoardCount() {
        $.ajax({
            url: "/declare/declareBoardCount",
            contentType: "application/json;charset=utf-8",
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("result : ", result);

                // 모든 월의 이름
                const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

                // 초기화
                let monthCounts = Array(12).fill(0);

                // 결과를 순회하며 월별 데이터 추출
                result.forEach(item => {
                    const monthIndex = parseInt(item.MONTH_NUM, 10) - 1; // 월 번호를 인덱스로 변환 (0-11)
                    monthCounts[monthIndex] = item.DECLARATION_COUNT; // 해당 월의 신고 건수 저장
                });
                
                
                const barChart = document.getElementById('barChart');
                if (barChart) {
                  const barChartVar = new Chart(barChart, {
                    type: 'bar',
                    data: {
                      labels: monthNames,
                      datasets: [
                        {
                          data: monthCounts,
                          backgroundColor: cyanColor,
                          borderColor: 'transparent',
                          maxBarThickness: 15,
                          borderRadius: {
                            topRight: 15,
                            topLeft: 15
                          }
                        }
                      ]
                    },
                    options: {
                      responsive: true,
                      maintainAspectRatio: false,
                      animation: {
                        duration: 500
                      },
                      plugins: {
                        tooltip: {
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
                          min: 0,
                          max: 10,
                          grid: {
                            color: borderColor,
                            drawBorder: false,
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
                }
                
                
            },
            error: function(error) {
                console.error('Error fetching data', error);
            }
        });
    }


    // Color Variables
    const purpleColor = '#836AF9',
        yellowColor = '#ffe800',
        cyanColor = '#28dac6',
        orangeColor = '#FF8132',
        oceanBlueColor = '#299AFF',
        greyColor = '#4F5D70';
    let cardColor, headingColor, labelColor, borderColor, legendColor;
    const polarChart = document.getElementById('polarChart');
    declareBoardCountType();
    function declareBoardCountType() {
        $.ajax({
            url: "/declare/declareBoardCountType",
            contentType: "application/json;charset=utf-8",
            type: "post",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                console.log("result : ", result);
             // 초기화
                let types = [];
                let counts = [];

                // 결과를 순회하며 타입별 데이터 추출
                $.each(result, function(idx, item) {
                    types.push(item.DCLR_TYPE);
                    counts.push(item.DECLARATION_COUNT);
                });	                	
                	
                const horizontalBarChart = document.getElementById('horizontalBarChart');
                if (horizontalBarChart) {
                  const horizontalBarChartVar = new Chart(horizontalBarChart, {
                    type: 'bar',
                    data: {
                      labels: types,
                      datasets: [
                        {
                          data: counts,
                          backgroundColor: config.colors.info,
                          borderColor: 'transparent',
                          maxBarThickness: 15
                        }
                      ]
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
                          min: 0,
                          max: 10,
                          grid: {
                            color: borderColor,
                            borderColor: borderColor
                          },
                          ticks: {
                        	stepSize: 1,
                            color: labelColor
                          }
                        },
                        y: {
                          grid: {
                            borderColor: borderColor,
                            display: false,
                            drawBorder: false
                          },
                          ticks: {
                            color: labelColor
                          }
                        }
                      }
                    }
                  });
                }
            }
        });
    }
    new PerfectScrollbar(document.getElementById('fbCn'), {
  	  wheelPropagation: false
  	});
    
    
});


</script>

<script src="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"><script>