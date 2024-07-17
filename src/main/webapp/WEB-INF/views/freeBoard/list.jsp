<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<link rel="stylesheet" href="/resources/css/simple-datatables.css">
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<style>
#insertBtn {
	margin-left: 1200px;
	margin-top: 20px;
}
#tableArea {
	padding: 20px;
}
.custom-swal {
	width: 600px !important;
	height: 400px !important;
}
</style>

<script>
$(document).ready(function() {
    $("#insertPost").on("click", function() {
        location.href = "/board/freeCreate";
    });

    function myTableReload() {
        $.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/board/freeTable",
            type: "get",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(freeBoardVOList) {
                console.log("아작스 자유게시판 값 받아온 데이터 체크 : ", freeBoardVOList);

                let str = `<table id="myTable" class="table table-hover">
                    <thead>
                        <tr>
                            <th>글 번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>등록일</th>
                            <th>조회수</th>
                        </tr>
                    </thead>
                    <tbody>`;

                $.each(freeBoardVOList, function(index, freeBoardVO) {
                    if (freeBoardVO.fbStts == 2) {
                        str += `<tr>
                            <td>\${index + 1}</td>
                            <td> 블라인드 처리 된 게시물 입니다.</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>`;
                    } else {
                    	let formattedDate = new Date(freeBoardVO.fbFrstRegDt).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/\.$/, '');
                        str += `<tr>
                            <td>\${index + 1}</td>
                            <td><a href="/board/freeDetail?fbNo=\${freeBoardVO.fbNo}">\${freeBoardVO.fbTtl}</a></td>
                            <td>\${freeBoardVO.empNm}</td>
                            <td>\${formattedDate}</td>
                            <td>\${freeBoardVO.fbCnt}</td>
                        </tr>`;
                    }
                });

                str += `</tbody>
                    </table>`;

                $('#tableArea').html(str);

                const myTableElement = document.querySelector("#myTable");
                const dataTable = new simpleDatatables.DataTable(myTableElement, {
                    labels: {
                        placeholder: "검색어를 입력해 주세요.",
                        noRows: "게시판에 작성된 글이 없습니다.",
                        info: "총 {rows}건 &nbsp | &nbsp 현재 페이지 {page} / {pages}",
                        noResults: "검색 결과가 없습니다."
                    },
                    perPageSelect: false,
                    perPage: 10
                });
            }
        });
    }

    myTableReload(); // 초기 테이블 로드
});
</script>

<div class="card" style="height: 660px">
    <div class="bg-primary" style="border-top-left-radius: 8px; border-top-right-radius: 8px; color: white; padding: 10px; text-align: center;">
        <p style="margin: 0px">
            <strong>자유게시판</strong>
        </p>
    </div>

    <div style="height: 0px;">
        <div id="insertBtn">
            <button class="btn btn-primary ml-2" id="insertPost">게시글 등록</button>
        </div>
    </div>

    <div class="card-datatable table-responsive" id="tableArea">
        <!-- 테이블 생성 위치 -->
    </div>
</div>