$(document).ready(function () {
    // CSRF 토큰 및 헤더 이름을 변수에 저장
    var csrfHeaderName = "${_csrf.headerName}";
    var csrfToken = "${_csrf.token}";

    const previewTemplate = `<div class="dz-preview dz-file-preview">
        <div class="dz-details">
            <div class="dz-thumbnail">
                <img data-dz-thumbnail>
                <span class="dz-nopreview">No preview</span>
                <div class="dz-success-mark"></div>
                <div class="dz-error-mark"></div>
                <div class="dz-error-message"><span data-dz-errormessage></span></div>
                <div class="progress">
                    <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuemin="0" aria-valuemax="100" data-dz-uploadprogress></div>
                </div>
            </div>
            <div class="dz-filename" data-dz-name></div>
            <div class="dz-size" data-dz-size></div>
        </div>
    </div>`;

    const dropzoneUpload = document.querySelector('#dropzone-upload');
    let myDropzone;

    if (dropzoneUpload) {
        myDropzone = new Dropzone(dropzoneUpload, {
            url: "/dataFolder/upload",
            autoProcessQueue: false,
            addRemoveLinks: true,
            parallelUploads: 100,
            maxFilesize: 5,
            uploadMultiple: true,
            previewTemplate: previewTemplate,
            init: function() {
                var self = this;

                this.on("addedfile", function(file) {
                    console.log("파일이 추가됨:", file.name);
                });

                this.on("sendingmultiple", function(files, xhr, formData) {
                    var folderInfo = getCurrentFolderInfo();
                    formData.append('drNo', folderInfo.drNo);
                    formData.append('fdNo', folderInfo.fdNo);
                    formData.append(csrfHeaderName, csrfToken);
                });

                this.on("successmultiple", function(files, response) {
                    console.log('Upload Response:', response);
                    if (response.status === "success") {
                        Swal.fire({
                            title: '업로드 완료!',
                            icon: 'success',
                            timer: 1000,
                            showConfirmButton: false
                        }).then(function() {
                            loadFileList();
                            $('#dataComposeSidebar').modal('hide');
                            self.removeAllFiles(); // 업로드 후 파일 목록 초기화
                        });
                    } else {
                        Swal.fire({
                            title: '업로드 실패!',
                            icon: 'error',
                            timer: 1000,
                            showConfirmButton: false
                        }).then(function() {
                            $('#dataComposeSidebar').modal('hide');
                            self.removeAllFiles(); // 업로드 실패 후 파일 목록 초기화
                        });
                    }
                });

                this.on("errormultiple", function(files, message) {
                    console.log('Upload Error:', message);
                    Swal.fire({
                        title: '업로드 실패!',
                        icon: 'error',
                        timer: 1000,
                        showConfirmButton: false
                    }).then(function() {
                        $('#dataComposeSidebar').modal('hide');
                        self.removeAllFiles(); // 오류 발생 후 파일 목록 초기화
                    });
                });

                $('#dataComposeSidebar').on('hidden.bs.modal', function () {
                    self.removeAllFiles(); // 모달이 닫힐 때 파일 목록 초기화
                });
            }
        });
    }

    // 파일 업로드 폼 제출 시 실행되는 함수 정의
    $('#uploadForm').on('submit', function(event) {
        event.preventDefault();
        myDropzone.processQueue(); // Dropzone 큐를 처리하여 파일을 업로드
    });

    // 현재 폴더 정보를 가져오는 함수
    function getCurrentFolderInfo() {
        var navItems = $('.data-nav').children();
        var drNo = navItems.first().data('id');
        var fdNo = navItems.length > 1 ? navItems.last().data('id') : "";
        return { drNo: drNo, fdNo: fdNo };
    }

    // 파일 목록을 새로고침하는 함수
    function loadFileList() {
        $.ajax({
            url: '/dataFolder/listFiles', // 파일 목록을 불러올 URL
            type: 'GET', // GET 요청
            success: function(response) { // 요청 성공 시 실행되는 함수
                console.log('File List Response:', response);  // 서버 응답을 콘솔에 출력
                var dataList = $('#dataList ul'); // 파일 목록을 표시할 요소 선택
                dataList.empty(); // 기존 목록을 비움

                var folders = response.folders; // 폴더 목록
                var files = response.dataFiles; // 파일 목록

                // 폴더와 파일이 없으면 "파일이 없습니다" 메시지 추가
                if (folders.length === 0 && files.length === 0) {
                    dataList.append('<li class="data-list-empty text-center">파일이 없습니다</li>');
                } else {
                    // 자료실 폴더 목록을 추가
                    appendFoldersAndFiles(folders, files, null);
                }

                // 폴더와 파일을 계층적으로 추가하는 함수
                function appendFoldersAndFiles(folders, files, parentId) {
                    folders.forEach(function(folder) {
                        if (folder.fdUp == parentId) {
                            var listItem = 
                                '<li class="data-list-item" data-target="' + folder.drNo + '" folder-up="' + (folder.fdUp ? folder.fdUp : '') + '">' +
                                '<div class="d-flex align-items-center">' +
                                '<div class="form-check mb-0 me-3">' +
                                '<input class="data-list-item-input form-check-input" type="checkbox" id="data-' + folder.fdNo + '" />' +
                                '<label class="form-check-label" for="data-' + folder.fdNo + '"></label>' +
                                '</div>' +
                                '<div class="data-list-item-content ms-2 ms-sm-0 me-2">' +
                                '<a href="javascript:void(0);" class="folder-link" data-id="' + folder.fdNo + '"><span class="h6 data-list-item-username"><i class="ti ti-folder-filled ti-md me-3"></i><span class="search-item">' + folder.fdNm + '</span></span></a>' +
                                '</div>' +
                                '<div class="data-list-item-meta ms-auto d-flex align-items-center">' +
                                '<ul class="list-inline data-list-item-actions text-nowrap">' +
                                '<li class="list-inline-item">' +
                                '<button type="button" data-bs-toggle="modal" data-bs-target="#nameEdit" class="btn_reset data-edit" data-id="' + folder.fdNo + '" data-type="folder" data-name="' + folder.fdNm + '">' +
                                '<i class="ti ti-edit ti-sm cursor-pointer"></i></button></li>' +
                                '<li class="list-inline-item data-delete"><i class="ti ti-trash ti-sm cursor-pointer" data-id="' + folder.fdNo + '" data-type="folder"></i></li>' +
                                '</ul>' +
                                '</div>' +
                                '<input type="hidden" name="fdNo" value="' + folder.fdNo + '">' +
                                '<input type="hidden" name="drNo" value="' + folder.drNo + '">' +
                                '<input type="hidden" name="fdNm" value="' + folder.fdNm + '">' +
                                '<input type="hidden" name="fdUp" value="' + folder.fdUp + '">' +
                                '<input type="hidden" name="empId" value="' + folder.empId + '">' +
                                '</div>' +
                                '</li>';
                            dataList.append(listItem); // 생성한 리스트 아이템을 목록에 추가
                            appendFoldersAndFiles(folders, files, folder.fdNo); // 하위 폴더 및 파일 추가
                        }
                    });

                    files.forEach(function(file) {
                        if (file.fdNo == parentId) {
                            var listItem = 
                                '<li class="data-list-item" data-target="' + file.drNo + '" folder-no="' + file.fdNo + '">' +
                                '<div class="d-flex align-items-center">' +
                                '<div class="form-check mb-0 me-3">' +
                                '<input class="data-list-item-input form-check-input" type="checkbox" id="data-' + file.dfNo + '" />' +
                                '<label class="form-check-label" for="data-' + file.dfNo + '"></label>' +
                                '</div>' +
                                '<div class="data-list-item-content ms-2 ms-sm-0 me-2">' +
                                '<a href="/dataFolder/download/file/' + file.dfNo + '"><span class="h6 data-list-item-username"><i class="ti ti-file ti-md me-3"></i><span class="search-item">' + file.dfOrgnlFileNm + '</span></span></a>' +
                                '</div>' +
                                '<div class="data-list-item-meta ms-auto d-flex align-items-center">' +
                                '<small class="data-list-item-time text-muted">' +
                                (file.dfFileSz / 1048576).toFixed(2) + ' MB</small>' +
                                '<small class="data-list-item-time text-muted">' +
                                new Date(file.dfUldDt).toISOString().slice(0, 10) + '</small>' +
                                '<ul class="list-inline data-list-item-actions text-nowrap">' +
                                '<li class="list-inline-item">' +
                                '<button type="button" data-bs-toggle="modal" data-bs-target="#nameEdit" class="btn_reset data-edit" data-id="' + file.dfNo + '" data-type="file" data-name="' + file.dfOrgnlFileNm + '">' +
                                '<i class="ti ti-edit ti-sm cursor-pointer"></i></button></li>' +
                                '<li class="list-inline-item data-delete"><i class="ti ti-trash ti-sm cursor-pointer" data-id="' + file.dfNo + '" data-type="file"></i></li>' +
                                '</ul>' +
                                '</div>' +
                                '<input type="hidden" name="dfFilePath" value="' + file.dfFilePath + '">' +
                                '<input type="hidden" name="dfChgFileNm" value="' + file.dfChgFileNm + '">' +
                                '<input type="hidden" name="dfFileStts" value="' + file.dfFileStts + '">' +
                                '<input type="hidden" name="empId" value="' + file.empId + '">' +
                                '<input type="hidden" name="dfExtn" value="' + file.dfExtn + '">' +
                                '<input type="hidden" name="fdNo" value="' + file.fdNo + '">' +
                                '<input type="hidden" name="drNo" value="' + file.drNo + '">' +
                                '</div>' +
                                '</li>';
                            dataList.append(listItem); // 생성한 리스트 아이템을 목록에 추가
                        }
                    });

                    // 폴더 링크 클릭 이벤트 리스너
                    $('.folder-link').off('click').on('click', function() {
                        var folderId = $(this).data('id'); // 클릭된 폴더의 ID를 가져옴
                        navigateToFolder(folderId); // 폴더 이동 함수 호출하여 하위 항목 필터링
                    });
                }

                // 검색 대상 요소 선택
                var nodeList = document.querySelectorAll('.data-list-item .search-item');
                // NodeList를 배열로 변환합니다.
                var nodeItems = [].slice.call(nodeList);
                // 각 요소의 outerHTML에 접근하여 출력합니다.
                nodeItems.forEach(function(item) {
                    // 검색 보완할때 풀어서 테스트하기
                    // console.log(item.innerHTML);
                });

                // 필터 적용
                applyFilter();

                // 폴더/파일 삭제 버튼에 클릭 이벤트 리스너 추가
                $('.data-delete').on('click', function() {
                    var id = $(this).find('i').data('id');
                    var type = $(this).find('i').data('type');
                    var folderId = currentPath[currentPath.length - 1].id;
                    var trashId;
                    var isTrashFolder = isTrash(folderId);

                    if (isTrashFolder) {
                        trashId = $(this).closest('li.data-list-item').data('target'); // 현재 휴지통 ID 가져오기
                    } else {
                        trashId = getTrashId(folderId); // 휴지통 ID 결정
                    }

                    console.log("Deleting item ID:", id, "Type:", type, "Trash ID:", trashId);

                    var deleteUrl = isTrashFolder ? '/dataFolder/permanentDeleteFile' : '/dataFolder/delete';

                    Swal.fire({
                        title: isTrashFolder ? '완전 삭제하시겠습니까?' : '삭제하시겠습니까?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소',
                        customClass: {
                            confirmButton: 'btn btn-danger waves-effect waves-light',
                            cancelButton: 'btn btn-secondary waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then((result) => {
                        if (result.isConfirmed) {
                            var requestData = { id: id, trashId: trashId }; // 삭제 요청에 trashId 포함

                            $.ajax({
                                url: deleteUrl,
                                type: 'POST',
                                data: JSON.stringify(requestData),
                                contentType: 'application/json; charset=utf-8', // Content-Type 설정
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader(csrfHeaderName, csrfToken);
                                },
                                success: function(response) {
                                    if (response.status === 'success') {
                                        Swal.fire({
                                            title: '삭제 완료!',
                                            icon: 'success',
                                            timer: 1000,
                                            showConfirmButton: false,
                                            customClass: {
                                                confirmButton: 'btn btn-success waves-effect waves-light'
                                            },
                                            buttonsStyling: false
                                        }).then(function (result) {
                                            if (result.dismiss === Swal.DismissReason.timer) {
                                                console.log('The alert was closed by the timer');
                                            }
                                        });
                                        loadFileList();
                                    } else {
                                        Swal.fire({
                                            title: '삭제 실패!',
                                            icon: 'error',
                                            timer: 1000,
                                            showConfirmButton: false,
                                            customClass: {
                                                confirmButton: 'btn btn-danger waves-effect waves-light'
                                            },
                                            buttonsStyling: false
                                        });
                                    }
                                },
                                error: function() {
                                    Swal.fire({
                                        title: '삭제 실패!',
                                        icon: 'error',
                                        timer: 1000,
                                        showConfirmButton: false,
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

                // 파일/폴더명 수정 버튼에 클릭 이벤트 리스너 추가
                $('.data-edit').off('click').on('click', function() {
                    var id = $(this).data('id'); // 아이템의 ID를 가져옴
                    var type = $(this).data('type'); // 아이템의 타입(폴더 또는 파일)을 가져옴
                    var name = $(this).data('name'); // 아이템의 이름을 가져옴

                    $('#itemId').val(id); // 모달에 아이템 ID 설정
                    $('#itemType').val(type); // 모달에 아이템 타입 설정
                    $('#modalNameEdit').val(name); // 모달에 아이템 이름 설정

                    // 모달이 표시될 때 실행되는 함수
                    $('#nameEdit').on('shown.bs.modal', function() {
                        var input = $('#modalNameEdit')[0]; // 이름 입력 필드 선택

                        if (type === 'folder') { // 폴더일 때
                            $('#exampleModalLabel2').text('폴더명 변경'); // 모달 제목 설정
                            input.focus(); // 입력 필드에 포커스
                            input.select(); // 입력 필드 내용 선택
                        } else { // 파일일 때
                            $('#exampleModalLabel2').text('파일명 변경'); // 모달 제목 설정
                            var dotIndex = name.lastIndexOf('.'); // 파일 확장자 위치 찾기
                            input.focus(); // 입력 필드에 포커스
                            if (dotIndex !== -1) {
                                input.setSelectionRange(0, dotIndex); // 파일 이름 부분만 선택
                            } else {
                                input.select(); // 전체 내용 선택
                            }
                        }
                    });

                    $('#nameEdit').modal('show'); // 파일/폴더명 수정 모달 표시
                });
            },
            error: function() {
                alert('Failed to load file list'); // 파일 목록 불러오기 실패 시 알림
            }
        });
    }

    $('#nameEdit').on('hidden.bs.modal', function() {
        $(this).off('shown.bs.modal'); // 모달이 숨겨질 때 이벤트 리스너 제거
    });

    // 초기 네비게이션 설정
    function initializeNavigation() {
        var initialFolderId = $('.data-filter-folders .active').data('target');
        var initialFolderName = $('.data-filter-folders .active span').text();
        currentPath = [{
            id: initialFolderId,
            name: initialFolderName
        }];
        updateNavigation();
        applyFilter(initialFolderId);
        updateUIForTrash(initialFolderId);
    }

    // 페이지 로드 시 파일 목록 불러오기
    loadFileList();
    initializeNavigation();
});
