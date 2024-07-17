<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.min.js"></script>


<style>
#toggleBtn { 
	width: 150px;
}

#pdfDownload, #pagePrint{
	display: block;
	border: 1px solid #868686;
    border-radius: 3px;
	width: 30px;
    height: 30px;
    text-align: center;
    align-content: center;
    margin: 5px;
}

@media print {
    body * {
        visibility: hidden;
    }
    #userConArea, #userConArea * {
        visibility: visible;
    }
    #userConArea {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
    }
    #pdfDownload, #pagePrint {
        display: none;
    }
}

</style>

<div class="card-container" style="display: flex; gap: 20px;">
    <div class="card" style="width: 400px; height: 790px; display: flex; flex-direction: column;">
    
    	<div class="bg-primary" style="border-top-left-radius: 3px; border-top-right-radius: 3px; color: white; padding: 2px; text-align: center;">
			<p style="margin: 0px">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-diagram-3-fill" viewBox="0 0 16 16">
  				<path fill-rule="evenodd" d="M6 3.5A1.5 1.5 0 0 1 7.5 2h1A1.5 1.5 0 0 1 10 3.5v1A1.5 1.5 0 0 1 8.5 6v1H14a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-1 0V8h-5v.5a.5.5 0 0 1-1 0V8h-5v.5a.5.5 0 0 1-1 0v-1A.5.5 0 0 1 2 7h5.5V6A1.5 1.5 0 0 1 6 4.5zm-6 8A1.5 1.5 0 0 1 1.5 10h1A1.5 1.5 0 0 1 4 11.5v1A1.5 1.5 0 0 1 2.5 14h-1A1.5 1.5 0 0 1 0 12.5zm6 0A1.5 1.5 0 0 1 7.5 10h1a1.5 1.5 0 0 1 1.5 1.5v1A1.5 1.5 0 0 1 8.5 14h-1A1.5 1.5 0 0 1 6 12.5zm6 0a1.5 1.5 0 0 1 1.5-1.5h1a1.5 1.5 0 0 1 1.5 1.5v1a1.5 1.5 0 0 1-1.5 1.5h-1a1.5 1.5 0 0 1-1.5-1.5z"/>
				</svg>
			</p>
		</div>
    	<div style="padding: 20px;">
	        <div style="display: flex; align-items: center; margin-bottom: 20px;">
	            <input id="schName" name="keyword" type="search" class="form-control" placeholder="이름/부서" style="width: 80%; max-width: 250px; margin-right: 10px;" />
	            <button type="button" id="toggleBtn" onclick="jsTree()" class="btn btn-primary" style="padding: 8px 15px; font-size: 16px;">전체닫기</button>
	        </div>
	
	        <!-- jstree 영역 -->
	        <div style="flex: 1;">
	            <div id="jstree" style=" border-radius: 5px; background-color: #fff; overflow-y: auto; max-height: 700px; padding: 10px; height: 660px;"></div>
	        </div>
    	</div>
    </div>

    <!-- 상세정보 영역 -->
    <div>
	    <div style="display: flex;">
			<a id="pdfDownload" href="" role="button" onclick="downloadPDF(); return false;">
				<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="#868686" class="bi bi-filetype-pdf" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M14 4.5V14a2 2 0 0 1-2 2h-1v-1h1a1 1 0 0 0 1-1V4.5h-2A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v9H2V2a2 2 0 0 1 2-2h5.5zM1.6 11.85H0v3.999h.791v-1.342h.803q.43 0 .732-.173.305-.175.463-.474a1.4 1.4 0 0 0 .161-.677q0-.375-.158-.677a1.2 1.2 0 0 0-.46-.477q-.3-.18-.732-.179m.545 1.333a.8.8 0 0 1-.085.38.57.57 0 0 1-.238.241.8.8 0 0 1-.375.082H.788V12.48h.66q.327 0 .512.181.185.183.185.522m1.217-1.333v3.999h1.46q.602 0 .998-.237a1.45 1.45 0 0 0 .595-.689q.196-.45.196-1.084 0-.63-.196-1.075a1.43 1.43 0 0 0-.589-.68q-.396-.234-1.005-.234zm.791.645h.563q.371 0 .609.152a.9.9 0 0 1 .354.454q.118.302.118.753a2.3 2.3 0 0 1-.068.592 1.1 1.1 0 0 1-.196.422.8.8 0 0 1-.334.252 1.3 1.3 0 0 1-.483.082h-.563zm3.743 1.763v1.591h-.79V11.85h2.548v.653H7.896v1.117h1.606v.638z"/>
				</svg>
			</a>

			<a id="pagePrint" href="" role="button" onclick="printPage(); return false;">
				<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" fill="#868686" class="bi bi-printer-fill" viewBox="0 0 16 16">
				  <path d="M5 1a2 2 0 0 0-2 2v1h10V3a2 2 0 0 0-2-2zm6 8H5a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1"/>
				  <path d="M0 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2h-1v-2a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2H2a2 2 0 0 1-2-2zm2.5 1a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1"/>
				</svg>
			</a>
		</div>
		<hr/>
	    <div class="card" id="userConArea" style="padding: 20px; width: 1000px; height: 716px;">
	        <div style="flex: 1;">
	            <div id="detail" style="border-radius: 5px; background-color: #fff; padding: 20px;"></div>
	        </div>
	    </div>
	</div>
</div>


<script>

$(document).ready(function() {
    new PerfectScrollbar(document.getElementById('jstree'), {
		  wheelPropagation: false
	});
    
});

// 페이지 인쇄, PDF 출력 처리 버튼 영역 -------------------------------------------------------
	var initBodyHtml;
	
	function printPage() {
	    const element = document.getElementById('userConArea');
	    const printContent = element.innerHTML;

        window.print();
	}
	
	function downloadPDF() {

	    const element = document.getElementById('userConArea');
	    html2canvas(element).then((canvas) => {
	        const imgData = canvas.toDataURL('image/png');
	        const pdf = new jspdf.jsPDF();
	        const imgProps = pdf.getImageProperties(imgData);
	        const pdfWidth = pdf.internal.pageSize.getWidth();
	        const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

	        pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
	        pdf.save("download.pdf");
	    });
	}
//페이지 인쇄, PDF 출력 처리 버튼 영역 -------------------------------------------------------

	let id = "";
    let str = "";
    

    function fSch() {
        console.log("검색할께요");
        $('#jstree').jstree(true).search($("#schName").val());
    }

    $("#schName").on("input", function(){
        $('#jstree').jstree(true).search($("#schName").val());
        if($("#schName").val() == ""){
            str = "";
            $("#detail").html(str);
        }
    });

    function closeTree(){
        console.log("전체닫기 클릭")
        $('#jstree').jstree(true).open_all();
    }

    let isTreeOpen = true; // 초기값을 true로 설정하여 전체닫기로 시작
    function jsTree(){
        if(isTreeOpen) {
            $('#jstree').jstree(true).close_all();
            str = "";
            $("#detail").html(str);
            $("#toggleBtn").text("전체열기");
        } else {
            $('#jstree').jstree(true).open_all();
            $("#toggleBtn").text("전체닫기");
        }
        isTreeOpen = !isTreeOpen;
    }

    // Default 설정 바꾸기
    $.jstree.defaults.core.themes.variant = "large";

    // 데이터를 Ajax로 불러온 후 정렬하여 JSTree에 설정
    $.ajax({
        url: "select", // 서버에서 데이터를 받아올 URL
        type: "GET",
        success: function(data) {
            // 데이터를 PARENT에 따라 그룹화
            let groupedData = data.reduce((acc, item) => {
                if (!acc[item.parent]) {
                    acc[item.parent] = [];
                }
                acc[item.parent].push(item);
                return acc;
            }, {});

            // 자식 노드가 없는 D001의 자식 노드를 먼저 추가
            let treeData = [];
            let addedNodes = new Set();

            // D001의 자식 중 자식이 없는 노드 찾기
            let d001Children = groupedData['D001'] || [];
            let noChildD001Children = d001Children.filter(item => !(groupedData[item.id] && groupedData[item.id].length));

            // 자식이 없는 D001의 자식 노드를 먼저 추가
            noChildD001Children.forEach(item => {
                if (!addedNodes.has(item.id)) {
                    treeData.push(item);
                    addedNodes.add(item.id);
                }
            });

            // 일반적인 노드 추가 함수
            function addNodeAndChildren(nodeId) {
                if (groupedData[nodeId]) {
                    groupedData[nodeId].forEach(item => {
                        if (!addedNodes.has(item.id)) {
                            treeData.push(item);
                            addedNodes.add(item.id);
                            addNodeAndChildren(item.id);
                        }
                    });
                }
            }

            // D001의 나머지 자식 노드 추가
            d001Children.forEach(item => {
                if (!noChildD001Children.includes(item)) {
                    if (!addedNodes.has(item.id)) {
                        treeData.push(item);
                        addedNodes.add(item.id);
                        addNodeAndChildren(item.id);
                    }
                }
            });

            // 나머지 노드들 추가
            for (let parent in groupedData) {
                if (parent !== 'D001') {
                    groupedData[parent].forEach(item => {
                        if (!addedNodes.has(item.id)) {
                            treeData.push(item);
                            addedNodes.add(item.id);
                            addNodeAndChildren(item.id);
                        }
                    });
                }
            }

            $("#jstree").jstree({
                "plugins": ["search"],
                'core': {
                    'data': treeData,
                    "check_callback": true,
                }
            }).on("loaded.jstree", function() {
                $(this).jstree("open_all");
            });
        }
    });

    // 이벤트
    $('#jstree').on("changed.jstree", function (e, data) {
        console.log(data.selected);
    });

    // Node 선택했을 때
    $('#jstree').on("select_node.jstree", function (e, data) {
        console.log("선택했을 때", data.node);
        id = data.node.id;

        console.log("id : " + id);

        let dataId = {
            "id" : id	
        };

        console.log("dataId : ", dataId);

        $.ajax({
            url : "/orgchart/detail",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(dataId),
            type: "post",
            dataType: "json",
            beforeSend: function(xhr){
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result){
                console.log("result : ", result);

                str = "<p></p>";
               	str += "<h3 class='badge bg-label-primary' style='font-size:15px;'>" + result.departmentVO.deptNm + "</h3><br><br>";
                str += "<div style='text-align: center;'>";
                if(result.atchfileSn == null){
                    str += "<img src='/resources/images/default-profile.png' style='width:160px; height:180px;'><br><br>";
                } else {
                    str += "<img src='/upload" + result.atchfileDetailVOList[0].atchfileDetailPhysclPath + "' style='width:160px; height:180px;'><br><br>";
                }
                str += "</div><br><br>";
                str += "<div style='display: flex; gap: 20px;'>";
				str += "<div style='flex: 1;'>";
				str += "<label for='empId'>사원번호 :</label>";
				str += "<input type='text' id='empId' name='empId' class='form-control' style='width: 100%; margin-bottom: 20px;' value='" + result.empId + "' readonly />";
				str += "<label for='empNm'>이름 :</label>";
				str += "<input type='text' id='empNm' name='empNm' class='form-control' style='width: 100%; margin-bottom: 20px;' value='" + result.empNm + "' readonly />";
				str += "<label for='empTelno'>연락처 :</label>";
				str += "<input type='text' id='empTelno' name='empTelno' class='form-control' style='width: 100%; margin-bottom: 20px;' value='" + result.empTelno + "' readonly />";
				str += "</div>";
				
				str += "<div style='flex: 1;'>";
				str += "<label for='empMail'>이메일 :</label>";
				str += "<input type='text' id='empMail' name='empMail' class='form-control' style='width: 100%; margin-bottom: 20px;' value='" + result.empMail + "' readonly />";
				str += "<label for='empEml'>직급 :</label>";
				str += "<input type='text' id='empEml' name='empEml' class='form-control' style='width: 100%; margin-bottom: 20px;' value='" + result.jobGradeVO.jbgdNm + "' readonly />";
				str += "</div>";
				
				str += "</div>";
                
                
                console.log("str : ", str);
                $("#detail").html(str);
            },
            error: function (request, status, error) {
                console.log("code: " + request.status)
                console.log("message: " + request.responseText)
                console.log("error: " + error);
            }
        });
    });


</script>

<script src="/resources/vuexy/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
