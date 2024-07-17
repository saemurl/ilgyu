<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
.card-datatable {
		padding: 30px;
}
.form-control {
/*     margin-left: 80px; */
}
.form-label{
/*     margin-left: 80px; */
}
#select, #selectTeam {
/*     margin-left: 80px; */
}
table th, table td {
/*     text-align: center; */
/*     vertical-align: middle; */
}
#paginate_div {
	display: flex;
	justify-content: center;
}
</style>
<script>
$(function() {
    getList("", 1, {});

    // 모달
    $(document).on("click", ".clsEmpId", function() {
        console.log("clsEmpNo modal~~");
        
        let empId = $(this).data("empId");
        console.log("empId >> "+ empId);
        
        $.ajax({
             url :"/hrm/empDetail",
             contentType:"application/json;charset=utf-8",
             data :JSON.stringify(empId),
             type :"post",
             dataType : "json",
             beforeSend:function(xhr){
                    xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
            success:function(result){
                console.log("result : " , result);
                let Date = result.empJncmpYmd;
                let empJncmpYmd = formatDate(Date);
                
                $("#empId").val(result.empId);
                $("#empNm").val(result.empNm);
                $("#empTelno").val(result.empTelno);
                $("#deptNm").val(result.departmentVO.deptNm);
                $("#empMail").val(result.empMail);
                $("#empJncmpYmd").val(empJncmpYmd);
                $("#deptUpCd").val(result.departmentVO.deptUpCd);
                $("#jbgdNm").val(result.jobGradeVO.jbgdNm);

                if (result.atchfileSn == null) {
                    $("img[alt='증명사진']").attr("src", "/resources/images/default-profile.png");
                } else {
                    $("img[alt='증명사진']").attr("src", "/upload"+result.atchfileDetailVOList[0].atchfileDetailPhysclPath+"");
                }
                
            }
        }); // empId ajax end
    });
    
    let deptUpCd = '';  // 전역 변수로 부서 코드 저장

    // selectTeam : 부서 > 사업부 > 팀
    $(document).on("change", "#selectTeam", function() {
        if ($("#select").val() === "부서" && deptUpCd) {  // '부서'가 선택된 상태에서만 업데이트
            let deptCd = $(this).val();
            let selObj = {
                "deptUpCd": deptUpCd,
                "deptCd": deptCd
            };

            console.log("selObj : ", selObj);

            getList("", 1, selObj);
        }
    });

    // selectch : 직급 > 직급선택
    $(document).on("change", "#selectch", function() {
        if ($("#select").val() === "직급") {
            let jbgdCd = $(this).val();

            let selObj = {
                "jbgdCd": jbgdCd
            };

            console.log("selObj : ", selObj);

            getList("", 1, selObj);
            
        } else if ($("#select").val() === "부서") {
            deptUpCd = $(this).val();  // 부서 코드 저장
            console.log("deptUpCd : ", deptUpCd);
            
            getList("", 1, { "deptUpCd": deptUpCd });
        }
    });

    $("#select").on("change", function() {
        console.log($(this).val());
        let str = "";
        let str2 = "";

        $("#selectch").empty();
        $("#selectTeam").remove();
        deptUpCd = '';  // 초기화

        if ($(this).val() === "직급") {
            str += "<option value=''>전체보기</option>";
            str += "<c:forEach var='gobGradeVO' items='${jobGradeList}' varStatus='stat'>";
            str += "<option value='${gobGradeVO.jbgdCd}'>${gobGradeVO.jbgdNm}</option>";
            str += "</c:forEach>";
            $("#selectch").append(str);

        } else if ($(this).val() === "부서") {
            str += "<option value=''>전체보기</option>";
            str += "<c:forEach var='departmentVO' items='${DeptVOList}' varStatus='stat'>";
            str += "<option value='${departmentVO.deptCd}'>${departmentVO.deptNm}</option>";
            str += "</c:forEach>";

            $("#selectch").html(str);

            str2 += "<select id='selectTeam' name='selectTeam' class='select2 form-select d-inline-block' data-allow-clear='true' style='max-width: 120px; margin-left: 5px;'>";
            str2 += "<option value=''>팀 선택</option>";
            str2 += "</select>";

            $("#selectDiv").append(str2);

            // 부서가 선택되었을 때 팀 불러오기
            $("#selectch").on("change", function() {
                let str3 = "";
                $("#selectTeam").html(str3);
                deptUpCd = $(this).val();
                console.log("deptUpCd >> " + deptUpCd);

                if (deptUpCd) {
                    
                    let data = {
                        "deptUpCd": deptUpCd
                    };

                    $.ajax({
                        url: "/hrm/Team",
                        contentType: "application/json;charset=utf-8",
                        data: JSON.stringify(data),
                        type: "post",
                        dataType: "json",
                        beforeSend:function(xhr){
                            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
                        },
                        success: function(result) {
                            console.log("result >> ", result);

                            str3 += "<option value=''>팀 선택</option>";
                            $.each(result, function(index, department) {
                                str3 += "<option value='" + department.deptCd + "'>" + department.deptNm + "</option>";
                            });

                            $("#selectTeam").html(str3);
                        }
                    });
                }
            });
        } else if ($(this).val() === "") {
            getList("", 1, {});
        } else {
            $("#selectch").empty();
        }
    });

    // 검색 버튼 클릭 이벤트
    $("#btnSearch").on("click", function() {
        let keyword = $("input[name='keyword']").val();
        let selObj = {};

        // 현재 선택된 조건에 따라 조건을 설정
        let selectVal = $("#select").val();
        if (selectVal === "부서" && deptUpCd) {
            selObj = { "deptUpCd": deptUpCd };
        } else if (selectVal === "직급") {
            let jbgdCd = $("#selectch").val();
            selObj = { "jbgdCd": jbgdCd };
        }

        let data = {
            "keyword": keyword,
            "selObj": selObj
        };

        console.log("btnSearch data >> ", data);

        // 검색 요청 보내기
        getList(keyword, "1", selObj);
    });
}); // onload func end

    function ajaxPaging(keyword, currentPage, deptUpCd, deptCd, jbgdCd) {
        let selObj = {
            "deptUpCd": deptUpCd,
            "deptCd": deptCd,
            "jbgdCd": jbgdCd
        };

        console.log("ajaxPaging->selObj : ", selObj);

        getList(keyword, currentPage, selObj);
    }
    
    function formatDate(dateString) {
        let date = new Date(dateString);
        let year = date.getFullYear();
        let month = ("0" + (date.getMonth() + 1)).slice(-2);
        let day = ("0" + date.getDate()).slice(-2);
        return year + "/" + month + "/" + day;
    }
    
    function getList(keyword, currentPage, selObj) {
        console.log("getList selObj: ", selObj);

        let data = {
            "keyword": keyword,
            "currentPage": currentPage,
            "deptUpCd": selObj ? selObj.deptUpCd : null,
            "deptCd": selObj ? selObj.deptCd : null,
            "jbgdCd": selObj ? selObj.jbgdCd : null
        };
        console.log("getList data >> ", data);

        $.ajax({
            url: "/hrm/listAjax",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(data),
            type: "post",
            dataType: "json",
            beforeSend:function(xhr){
                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
            success: function(result) {
                console.log("result >> ", result);

                let list = "";

                $.each(result.content, function(idx, employeeVO) {
                    let rawDate = employeeVO.empJncmpYmd;
                    let formattedDate = formatDate(rawDate);

                    list += "<tr><td>" + (idx + 1) + 
                        "</td><td class='clsEmpId' data-bs-toggle='modal' data-bs-target='#modalEmp' data-emp-id='" + employeeVO.empId + "'>" + employeeVO.empId + "</td><td>"
                        + employeeVO.empNm + "</td><td>" + employeeVO.jobGradeVO.jbgdNm + "</td><td>"
                        + employeeVO.departmentVO.deptNm + "</td><td>" + formattedDate + "</td><td>관리자</td></tr>";
                        
                });

                $("#trShow").html(list);

                console.log("map : ", result.map);

                $(".clsPagingArea").html(result.pagingArea);
            }
        });
}
</script>
<div class="card">
    <div class="bg-primary" style="border-top-left-radius: 8px; border-top-right-radius: 8px; color: white; padding: 10px; text-align: center;">
        <p style="margin: 0px">
            <strong>직원 조회</strong>
        </p>
    </div>
    <br>
    <div class="card-datatable text-nowrap">
        <div style="display: flex; justify-content: space-between;">
            <div id="selectDiv" class="mb-3">
                <select id="select" name="select" class="select2 form-select d-inline-block" data-allow-clear="true" style="max-width: 120px; vertical-align: top;">
                    <option value="">전체보기</option>
                    <option>부서</option>
                    <option>직급</option>
                </select>
                <select id="selectch" name="selectch" class="select2 form-select d-inline-block" data-allow-clear="true" style="max-width: 120px; vertical-align: top; margin-left: 5px;">
                </select>
            </div>
            <div class="input-group mb-3" style="max-width: 400px;">
                <input id="keyword" name="keyword" type="search" class="form-control" placeholder="검색어를 입력하세요" aria-controls="DataTables_Table_0">
                <div class="input-group-append">
                    <button type="button" id="btnSearch" class="btn btn-primary btn-md">검색</button>
                </div>
            </div>
        </div>
        <div>
            <table class="datatables-ajax table">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>사번</th>
                        <th>성명</th>
                        <th>직위</th>
                        <th>소속</th>
                        <th>입사일</th>
                        <th>등록자</th>
                    </tr>
                </thead>
                <tbody id="trShow">
                    <!-- Data rows will be dynamically inserted here -->
                </tbody>
            </table>
        </div>
    </div>
    <div class="row clsPagingArea" style="align-self: center;">
        ${articlePage.pagingArea}
    </div>
</div>











<!-- 모달 영역 -->

<div class="modal fade" id="modalEmp" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-simple modal-add-new-cc" style="max-width: 600px;">
		<div class="modal-content p-3 p-md-1" >
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">직원 조회</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body" style="padding: 30px">
			
			
				<div class="row">
					<!-- 직원 사진을 넣을 공간 -->
					<div class="" style="display:flex; justify-content: space-around;">
						<div style="align-self: center;">
							<img src="" alt="증명사진" class="img-fluid" style="display: block; height: 230px;">
						</div>
						<div style="justify-content: space-around;">
							<div class="mb-1">
								<label class="form-label" for="empId">사번 :</label> <input
									type="text" id="empId" name="empId" class="form-control"
									readonly />
							</div>
							<div class=" mb-1">
								<label class="form-label" for="empNm">성명 :</label> <input
									type="text" id="empNm" name="empNm" class="form-control"
									readonly />
							</div>
							<div class=" mb-1">
								<label class="form-label" for="empTelno">연락처 :</label> <input
									type="text" id="empTelno" name="empTelno" class="form-control"
									readonly />
							</div>
							<div class=" mb-1">
								<label class="form-label" for="empMail">이메일 :</label> <input
									type="text" id="empMail" name="empMail" class="form-control"
									readonly />
							</div>
						</div>
					</div>


					<!-- 직원 상세 정보를 입력할 필드 -->
					<div >
						
						<div>
							<div class="mb-1">
								<label class="form-label" for="deptUpCd">부서 :</label> <input
									type="text" id="deptUpCd" name="deptUpCd" class="form-control"
									readonly />
							</div>
							<div class="mb-1">
								<label class="form-label" for="deptNm">팀 :</label> <input
									type="text" id="deptNm" name="deptNm" class="form-control"
									readonly />
							</div>
							<div class="mb-1">
								<label class="form-label" for="jbgdNm">직급 :</label> <input
									type="text" id="jbgdNm" name="jbgdNm" class="form-control"
									readonly />
							</div>
							<div class="mb-1">
								<label class="form-label" for="empJncmpYmd">입사일 :</label> <input
									type="text" id="empJncmpYmd" name="empJncmpYmd"
									class="form-control" readonly />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
