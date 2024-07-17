<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript" src="/resources/js/jquery.min.js"></script>
    <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
    <title>정보 수정</title>
    <style>
        /* 스타일 정의 */
        body {
            font-family: Arial, sans-serif;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-container {
            width: 50%;
            margin: 0 auto;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .profile-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .profile-container input[type="text"],
        .profile-container input[type="password"],
        .profile-container input[type="date"],
        .profile-container input[type="email"],
        .profile-container input[type="file"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .profile-container .address-container {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .profile-container .address-container input[type="text"] {
            flex: 1;
            margin-right: 5px;
        }
        .profile-container .address-container button {
            flex: 0 0 auto;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        .profile-container button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            margin: 5px;
            cursor: pointer;
        }
        .profile-container #cancel {
            background-color: #6c757d;
            color: #fff;
        }
        .profile-container #confirm {
            background-color: #28a745;
            color: #fff;
        }
        .profile-container img {
            display: block;
            margin: 0 auto 20px;
            border-radius: 50%;
            width: 150px;
            height: 150px;
            object-fit: cover;
            position: relative;
            cursor: pointer; /* 이미지에 커서 포인터 추가 */
        }
        .delete-photo {
            position: absolute;
            bottom: 0;
            right: 0;
            background-color: #dc3545;
            color: #fff;
            border: none;
            padding: 5px;
            border-radius: 50%;
            cursor: pointer;
        }
        .button-container {
            text-align: center;
        }
        input[type="file"]::-webkit-file-upload-button {
            visibility: hidden;
        }
        input[type="file"]::before {
            content: '파일 선택';
            display: inline-block;
            background: -webkit-linear-gradient(top, #f9f9f9, #e3e3e3);
            border: 1px solid #999;
            border-radius: 3px;
            padding: 5px 8px;
            outline: none;
            white-space: nowrap;
            -webkit-user-select: none;
            cursor: pointer;
            text-shadow: 1px 1px #fff;
            font-weight: 700;
            font-size: 10pt;
        }
        input[type="file"]:hover::before {
            border-color: black;
        }
        input[type="file"]:active::before {
            background: -webkit-linear-gradient(top, #e3e3e3, #f9f9f9);
        }
        .fileLabel {
            padding: 6px 25px;
            background-color: #FF6600;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            display: inline-block;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        let empId = "${employeeVO.empId}"
        let empPass = "${employeeVO.empPass}"
        let empName = "${employeeVO.empNm}"
        let empEmail = "${employeeVO.empMail}"
        let empEml = "${employeeVO.empEml}"
        let empTelno = "${employeeVO.empTelno}"
        let empAddr = "${employeeVO.empAddr}"
        let empDaddr = "${employeeVO.empDaddr}"
        let empBrdt = "${employeeVO.empBrdt}"
        let empJncmpYmd = "${employeeVO.empJncmpYmd}"
        let deptCd = "${employeeVO.deptCd}"
        let jbgdCd = "${employeeVO.jbgdCd}"

        $(function() {
            $("#uploadFile").on("change", handleImg);

            $(".readonly").removeAttr("readonly");
            $("#frm").attr("action", "/mypage/profilePost?${_csrf.parameterName}=${_csrf.token}");

            $("#cancel").on("click", function() {
                $(".readonly").attr("readonly", true);
                $("input[name='empNm']").val(empName);
                $("input[name='empMail']").val(empEmail);
                $("input[name='empEml']").val(empEml);
                $("input[name='empTelno']").val(empTelno);
                $("input[name='empAddr']").val(empAddr);
                $("input[name='empDaddr']").val(empDaddr);
                $("input[name='empBrdt']").val(empBrdt);
                $("input[name='empJncmpYmd']").val(empJncmpYmd);
                $("input[name='deptCd']").val(deptCd);
                $("input[name='jbgdCd']").val(jbgdCd);
            });

            $("#cancel").on("click", function() {
                location.href = "/main/index";
            });

            $("#deletePhoto").on("click", function() {
                Swal.fire({
                    title: '',
                    text: "프로필 사진을 삭제하시겠습니까?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '예, 삭제합니다',
                    cancelButtonText: '취소',
                    customClass: {
                        confirmButton: 'swal2-cancel btn btn-label-danger',
                        cancelButton: 'btn btn-label-secondary waves-effect waves-light'
                    },
                    buttonsStyling: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: '/mypage/deletePhoto',
                            type: 'POST',
                            data: {
                                empId: empId,
                                _csrf: '${_csrf.token}'
                            },
                            success: function(response) {
                                if (response.success) {
                                    Swal.fire({
                                        title: '삭제 완료!',
                                        text: '프로필 사진이 삭제되었습니다.',
                                        icon: 'success',
                                        confirmButtonText: '확인',
                                        customClass: {
                                            confirmButton: 'btn btn-success waves-effect waves-light'
                                        },
                                        buttonsStyling: false
                                    });
                                    $("#pImg").attr("src", "/resources/images/default-profile.png");
                                } else {
                                    Swal.fire({
                                        title: '실패!',
                                        text: '프로필 사진 삭제에 실패했습니다.',
                                        icon: 'error',
                                        confirmButtonText: '확인',
                                        customClass: {
                                            confirmButton: 'btn btn-danger waves-effect waves-light'
                                        },
                                        buttonsStyling: false
                                    });
                                }
                            },
                            error: function() {
                                Swal.fire({
                                    title: '서버 오류!',
                                    text: '서버 오류로 인해 프로필 사진을 삭제할 수 없습니다.',
                                    icon: 'error',
                                    confirmButtonText: '확인',
                                    customClass: {
                                        confirmButton: 'btn btn-danger waves-effect waves-light'
                                    },
                                    buttonsStyling: false
                                });
                            }
                        });
                    }
                });
            });
            
            $('#confirm').on("click", function(){
                Swal.fire({
                    title: '',
                    text: '저장하시겠습니까?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: '저장',
                    cancelButtonText: '취소',
                    customClass: {
                        confirmButton: 'btn btn-primary me-3 waves-effect waves-light',
                        cancelButton: 'btn btn-label-secondary waves-effect waves-light'
                    },
                    buttonsStyling: false
                }).then(function (result) {
                    if (result.isConfirmed) {
                        Swal.fire({
                            icon: 'success',
                            title: '',
                            text: '저장이 완료되었습니다.',
                            customClass: {
                                confirmButton: 'btn btn-success waves-effect waves-light'
                            }
                        }).then(function(result){
                            if (result.isConfirmed) {
                                $("#frm").submit();
                            }
                        });
                    }
                });
            });

            // 이미지 클릭 이벤트 추가
            $("#pImg").on("click", function() {
                $("#uploadFile").click();
            });
        });

        function handleImg(e) {
            let files = e.target.files;
            let fileArr = Array.prototype.slice.call(files);
            fileArr.forEach(function(f) {
                if (!f.type.match("image.*")) {
                    alert("이미지 확장자만 가능합니다.");
                    return;
                }
                let reader = new FileReader();
                $("#pImg").html("");
                reader.onload = function(e) {
                    $("#pImg").attr("src", e.target.result);
                }
                reader.readAsDataURL(f);
            });
        }

        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    let addr = '';
                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }
                    document.getElementById('address').value = addr;
                }
            }).open();
        }
        
    </script>
</head>
<body>
   <div class="row">
    <form id="frm" name="frm" method="post" enctype="multipart/form-data">
     <div class="col-md-12">
       <div class="card mb-4">
         <h5 class="card-header">프로필 사진</h5>
         <!-- Account -->
         <div class="card-body">
           <div class="d-flex align-items-start align-items-sm-center gap-4">
             <img src="<c:choose>
                        <c:when test="${employeeVO.atchfileSn == null}">
                            /resources/images/default-profile.png
                        </c:when>
                        <c:otherwise>
                            /upload${employeeVO.atchfileDetailVOList[0].atchfileDetailPhysclPath}
                        </c:otherwise>
                      </c:choose>" 
                 alt="Profile Picture" class="d-block w-px-100 rounded" id="pImg" />
             <p id="fileName"></p>
             <div class="button-wrapper">
               <input type="file" name="uploadFile" id="uploadFile" style="display: none;"/>
               <label for="uploadFile" class="btn btn-primary me-2 mb-3" tabindex="0">
                 <span class="d-none d-sm-block">사진 업로드</span>
                 <script>
                     $("#uploadFile").on('change', function(e) {
                         const fileInput = $(this)[0];
                         if (fileInput.files.length > 0) {
                             const fileName = fileInput.files[0].name;
                             $('#fileName').text(`Selected file: ${fileName}`);
                         } else {
                             $('#fileName').text('');
                         }
                     });
                 </script>
                 <i class="ti ti-upload d-block d-sm-none"></i>
                 <input
                   type="file"
                   id="upload"
                   class="account-file-input"
                   hidden
                   accept="image/png, image/jpeg" />
               </label>
               <button type="button" class="btn btn-label-secondary account-image-reset mb-3" id="deletePhoto">
                 <i class="ti ti-refresh-dot d-block d-sm-none"></i>
                 <span class="d-none d-sm-block">삭제</span>
               </button>
               <div class="text-muted">${employeeVO.deptNm} ${employeeVO.jbgdNm}</div>
             </div>
           </div>
         </div>
         <hr class="my-0" />
         <div class="card-body">
               <div class="row">
                <div class="mb-3 col-md-6">
                  <label for="empId" class="form-label">아이디</label>
                  <input
                    class="form-control"
                    type="text"
                    name="empId"
                    value="${employeeVO.empId}"
                    autofocus readonly disabled />
                </div>
               <div class="mb-3 col-md-6">
                 <label for="email" class="form-label">비밀번호</label>
                 <input
                   class="form-control"
                   type="password"
                   name="empPass"
                   placeholder="비밀번호를 입력하세요." />
                 <input type="hidden" name="empPass" value="${employeeVO.empPass}" class="form-control" readonly disabled /> 
               </div>
               <div class="mb-3 col-md-6">
                 <label for="empNm" class="form-label">이름</label>
                 <input class="form-control" type="text" name="empNm" value="${employeeVO.empNm}" />
               </div>
               <div class="mb-3 col-md-6">
			     <label class="form-label" for="phoneNumberInput">전화번호</label>
			     <div class="input-group input-group-merge">
			         <!-- <span class="input-group-text">Korea, Republic of(+82)</span> -->
			         <input
			             type="text"
			             id="phoneNumberInput"
			             name="empTelno"
			             class="form-control"
			             value="${employeeVO.empTelno}" />
			     </div>
			   </div>
               <div class="mb-3 col-md-6">
                 <label for="empMail" class="form-label">사내 이메일</label>
                 <input type="text" class="form-control" name="empMail" value="${employeeVO.empMail}" readonly />
               </div>
               <div class="mb-3 col-md-6">
                 <label for="empEml" class="form-label">이메일</label>
                 <input class="form-control" type="text" name="empEml" value="${employeeVO.empEml}" />
               </div>
               <div class="mb-3 col-md-6">
               <label for="empAddr" class="form-label">주소</label>
                <div class="input-group">
                 <input
                    type="text"
                    class="form-control"
                    id="address"
                    name="empAddr"
                    value="${employeeVO.empAddr}" />
                   <button type="button" class="btn btn-outline-primary waves-effect" 
                    onclick="execDaumPostcode()">주소 찾기</button> 
                </div>
               </div>
               <div class="mb-3 col-md-6">
                 <label for="empDaddr" class="form-label">상세 주소</label>
                 <input type="text" class="form-control" id="detailAddress" name="empDaddr" value="${employeeVO.empDaddr}" />
               </div>
               <div class="mb-3 col-md-6">
                 <label for="empBrdt" class="form-label">입사날짜</label>
                 <input
                   type="date"
                   class="form-control"
                   name="empJncmpYmd"
                   value="<fmt:formatDate value='${employeeVO.empJncmpYmd}'
                   pattern='yyyy-MM-dd'/>" readonly disabled />
               </div>
               <div class="mb-3 col-md-6">
                 <label for="empBrdt" class="form-label">생년월일</label>
                 <input
                   type="date"
                   class="form-control"
                   name="empBrdt"
                   value="<fmt:formatDate value='${employeeVO.empBrdt}'
                   pattern='yyyy-MM-dd'/>" readonly disabled />
               </div>
               <!-- <div class="mb-3 col-md-6">
                 <label class="form-label" for="country">Country</label>
                 <select id="country" class="select2 form-select">
                   <option value="">Select</option>
                   <option value="Australia">Australia</option>
                   <option value="Bangladesh">Bangladesh</option>
                   <option value="Belarus">Belarus</option>
                   <option value="Brazil">Brazil</option>
                   <option value="Canada">Canada</option>
                   <option value="China">China</option>
                   <option value="France">France</option>
                   <option value="Germany">Germany</option>
                   <option value="India">India</option>
                   <option value="Indonesia">Indonesia</option>
                   <option value="Israel">Israel</option>
                   <option value="Italy">Italy</option>
                   <option value="Japan">Japan</option>
                   <option value="Korea">Korea, Republic of</option>
                   <option value="Mexico">Mexico</option>
                   <option value="Philippines">Philippines</option>
                   <option value="Russia">Russian Federation</option>
                   <option value="South Africa">South Africa</option>
                   <option value="Thailand">Thailand</option>
                   <option value="Turkey">Turkey</option>
                   <option value="Ukraine">Ukraine</option>
                   <option value="United Arab Emirates">United Arab Emirates</option>
                   <option value="United Kingdom">United Kingdom</option>
                   <option value="United States">United States</option>
                 </select>
               </div>
               <div class="mb-3 col-md-6">
                 <label for="language" class="form-label">Language</label>
                 <select id="language" class="select2 form-select">
                   <option value="">Select Language</option>
                   <option value="en">English</option>
                   <option value="fr">French</option>
                   <option value="de">German</option>
                   <option value="pt">Portuguese</option>
                 </select>
               </div>
               <div class="mb-3 col-md-6">
                 <label for="timeZones" class="form-label">Timezone</label>
                 <select id="timeZones" class="select2 form-select">
                   <option value="">Select Timezone</option>
                   <option value="-12">(GMT-12:00) International Date Line West</option>
                   <option value="-11">(GMT-11:00) Midway Island, Samoa</option>
                   <option value="-10">(GMT-10:00) Hawaii</option>
                   <option value="-9">(GMT-09:00) Alaska</option>
                   <option value="-8">(GMT-08:00) Pacific Time (US & Canada)</option>
                   <option value="-8">(GMT-08:00) Tijuana, Baja California</option>
                   <option value="-7">(GMT-07:00) Arizona</option>
                   <option value="-7">(GMT-07:00) Chihuahua, La Paz, Mazatlan</option>
                   <option value="-7">(GMT-07:00) Mountain Time (US & Canada)</option>
                   <option value="-6">(GMT-06:00) Central America</option>
                   <option value="-6">(GMT-06:00) Central Time (US & Canada)</option>
                   <option value="-6">(GMT-06:00) Guadalajara, Mexico City, Monterrey</option>
                   <option value="-6">(GMT-06:00) Saskatchewan</option>
                   <option value="-5">(GMT-05:00) Bogota, Lima, Quito, Rio Branco</option>
                   <option value="-5">(GMT-05:00) Eastern Time (US & Canada)</option>
                   <option value="-5">(GMT-05:00) Indiana (East)</option>
                   <option value="-4">(GMT-04:00) Atlantic Time (Canada)</option>
                   <option value="-4">(GMT-04:00) Caracas, La Paz</option>
                 </select>
               </div>
               <div class="mb-3 col-md-6">
                 <label for="currency" class="form-label">Currency</label>
                 <select id="currency" class="select2 form-select">
                   <option value="">Select Currency</option>
                   <option value="usd">USD</option>
                   <option value="euro">Euro</option>
                   <option value="pound">Pound</option>
                   <option value="bitcoin">Bitcoin</option>
                 </select>
               </div>
             </div> -->
             <div class="mt-2">
               <button type="button" id="confirm" class="btn btn-primary me-2">저장</button>
               <button type="button"  id="cancel" class="btn btn-label-secondary">취소</button>
             </div>
             <sec:csrfInput/>
         </div>
         <!-- /Account -->
       </div>
     </div>
    </form>
   </div>
</body>
</html>
