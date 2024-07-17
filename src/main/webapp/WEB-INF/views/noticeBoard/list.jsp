<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" defer></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/animate-css/animate.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/sweetalert2/sweetalert2.css" />
<link rel="stylesheet" href="/resources/css/simple-datatables.css">

<style>
#insertBtn {
	margin-left: 1200px;
	margin-top: 20px;
}

.custom-swal {
	width: 600px !important; /* 알림 창의 너비 */
	height: 400px !important; /* 알림 창의 높이 */
}

/* card 스타일 [시작] ---------------------------------------------- */
#tableArea {
 	padding: 20px;
}
/* card 스타일 [종료]  ---------------------------------------------- */
</style>

<script>
$(document).ready(function() {
    $("#insert").on("click", function() {
        location.href = "/board/noticeCreate";
    });

    let myTable;

    function myTableReload() {
        if (myTable) {
            myTable.destroy(); // 이미 있으면 제거
        }

        $.ajax({
            contentType: "application/json;charset=utf-8",
            url: "/board/noticeTable",
            type: "get",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(noticeBoardVOList) {
                console.log("아작스 공지테이블 값 받아온 데이터 체크 : ", noticeBoardVOList);

                let str = `<table id="myTable" class="table table-hover">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>`;

                $.each(noticeBoardVOList, function(index, noticeBoardVO) {
                    str += `<tr>
                        <td>\${index + 1}</td>
                        <td><a href="/board/noticeDetail?ntcNo=\${noticeBoardVO.ntcNo}">\${noticeBoardVO.ntcTtl}</a></td>
                        <td>\${noticeBoardVO.empNm}</td>
                        <td>\${new Date(noticeBoardVO.ntcFrstRegYmd).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/\.$/, '')}</td>
                    </tr>`;
                });

                str += `</tbody>
                    </table>`;

                $('#tableArea').html(str);

                const myTableElement = document.querySelector("#myTable");
                myTable = new simpleDatatables.DataTable(myTableElement, {
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



<div class="card" style="height: 660px;">

	<div class="bg-primary" style="border-top-left-radius: 3px; border-top-right-radius: 3px; color: white; padding: 10px; text-align: center;">
		<p style="margin: 0px">
			<strong>공지사항 게시판</strong>
		</p>
	</div>

	<div style="height: 0px;">
		<div id="insertBtn">
			<c:if test="${roleNames == '[ROLE_ADMIN]'}">
				<button type="button"
					class="btn btn-primary waves-effect waves-light" id="insert"
					class="btn btn-primary">공지사항 등록</button>
			</c:if>
		</div>
	</div>


	<div class="card-datatable table-responsive" id="tableArea">
		<!-- 테이블 영역 -->
	</div>

</div>