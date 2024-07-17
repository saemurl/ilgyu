<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Page CSS -->
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/css/pages/app-data.css" />
<link rel="stylesheet" href="/resources/vuexy/assets/vendor/libs/dropzone/dropzone.css" />

<script>
$(document).ready(function() {
    // CSRF 토큰 및 헤더 이름을 변수에 저장
    var csrfHeaderName = "${_csrf.headerName}";
    var csrfToken = "${_csrf.token}";

    // 현재 네비게이션 경로를 저장할 배열
    var currentPath = [];

    // 검색 기능 구현
    $('.data-search-input').on('keyup', function() {
        var searchTerm = $(this).val().toLowerCase(); // 검색어를 소문자로 변환하여 저장
        filterFilesAndFolders(searchTerm); // 검색어를 사용하여 파일 및 폴더 필터링
    });

    // 파일 및 폴더를 검색어에 따라 필터링하는 함수
    function filterFilesAndFolders(searchTerm) {
        $('.data-list-item').each(function() {
            var itemText = $(this).find('.search-item').text().toLowerCase(); // 각 아이템의 텍스트를 소문자로 변환
            if (itemText.includes(searchTerm)) {
                $(this).show(); // 검색어가 포함된 아이템을 표시
            } else {
                $(this).hide(); // 검색어가 포함되지 않은 아이템을 숨김
            }
        });
    }

    // 휴지통 여부를 확인하는 함수
    function isTrash(folderId) {
	    return folderId === "TRASH01" || folderId === "TRASH02";
	}
    
    // 휴지통 ID를 결정하는 함수
    function getTrashId(dataTarget) {
        if (dataTarget === "DR004" || dataTarget === "DR005") {
            return "TRASH01";
        } else if (dataTarget === "DR001" || dataTarget === "DR002" || dataTarget === "DR003") {
            return "TRASH02";
        }
        return null;
    }

    // 휴지통 상태에 따라 UI 업데이트하는 함수
    function updateUIForTrash(folderId) {
	    if (isTrash(folderId)) {
	        $('#folderAddLabel').hide();
	        $('#downloadSelected').hide();
	        if ($('#emptyTrashButton').length === 0) {
	            $('.btnCtrlWrap').append('<button type="button" class="btn btn-sm btn-label-secondary waves-effect" id="emptyTrashButton">휴지통 비우기</button>');
	            $('#emptyTrashButton').on('click', emptyTrash);
	        }
	    } else {
	        $('#folderAddLabel').show();
	        $('#downloadSelected').show();
	        $('#emptyTrashButton').remove();
	    }
	}

	// 휴지통 비우기 기능을 별도로 정의
    function emptyTrash() {
        var folderId = currentPath[currentPath.length - 1].id;
        if (isTrash(folderId)) {
            Swal.fire({
                title: '휴지통을 비우시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '네',
                cancelButtonText: '취소',
                customClass: {
                    confirmButton: 'btn btn-danger waves-effect waves-light',
                    cancelButton: 'btn btn-secondary waves-effect waves-light'
                },
                buttonsStyling: false
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('/dataFolder/deleteAllInTrash', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [csrfHeaderName]: csrfToken
                        },
                        body: JSON.stringify({ folderId: folderId })
                    })
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        } else {
                            throw new Error('Network response was not ok');
                        }
                    })
                    .then(data => {
                        if (data.status === 'success') {
                            updateStorageInfo();  // 휴지통 비우기 후 스토리지 정보 업데이트
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
                    })
                    .catch(error => {
                        console.error('Error:', error);
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
                    });
                }
            });
        }
    }

 	// 네비게이션 바를 업데이트하는 함수
    function updateNavigation() {
        // 네비게이션 바 컨테이너를 가져온다
        var navContainer = $('.data-nav');
        // 네비게이션 바 컨테이너를 비운다
        navContainer.empty();

        // 현재 경로(currentPath)의 각 폴더를 순회한다
        currentPath.forEach(function(folder, index) {
            // 첫 번째 폴더가 아닌 경우 화살표 아이콘을 추가한다
            if (index > 0) {
                navContainer.append('<i class="data-next ti ti-chevron-right ti-xs px-2"></i>');
            }
            // 마지막 폴더인 경우 텍스트만 추가한다
            if (index === currentPath.length - 1) {
                navContainer.append('<span data-id="' + folder.id + '">' + folder.name + '</span>');
            } else {
                // 마지막 폴더가 아닌 경우 링크로 추가한다
                navContainer.append('<a href="javascript:void(0);" class="navigate-folder" data-id="' + folder.id + '">' + folder.name + '</a>');
            }
        });

        // 폴더 이동 링크의 클릭 이벤트를 제거하고 새로 설정한다
        $('.navigate-folder').off('click').on('click', function() {
            // 클릭된 폴더의 ID를 가져온다
            var folderId = $(this).data('id');
            // 해당 폴더로 이동하는 함수를 호출한다
            navigateToFolder(folderId);
        });
    }


    // 폴더로 이동하는 함수
    function navigateToFolder(folderId) {
        var folder = getFolderById(folderId);
        if (folder === null) {
            currentPath.push({ id: folderId, name: 'Unknown Folder' });
        } else {
            var existingFolderIndex = currentPath.findIndex(function(f) {
                return f.id === folderId;
            });

            if (existingFolderIndex !== -1) {
                currentPath = currentPath.slice(0, existingFolderIndex + 1);
            } else {
                currentPath.push(folder);
            }
        }

        applyFilter(folderId);
        updateNavigation();
        updateUIForTrash(folderId);
    }

    // 폴더 정보를 가져오는 함수 (필요에 따라 수정 가능)
    function getFolderById(folderId) {
        var folder = null;
        $.ajax({
            url: '/dataFolder/getFolder', // 폴더 정보를 가져올 URL
            type: 'GET', // GET 요청
            data: { id: folderId }, // 폴더 ID를 데이터로 전송
            async: false, // 동기식 요청으로 설정
            success: function(response) {
                if (response && response.length > 0) {
                    folder = {
                        id: response[0].fdNo,
                        name: response[0].fdNm
                    };
                }
            },
            error: function() {
                console.log('Failed to retrieve folder information');
            }
        });
        return folder; // 폴더 정보를 반환
    }

    // 파일 영구 삭제 함수
    function permanentDeleteFile(fileId) {
        $.ajax({
            url: '/dataFolder/permanentDeleteFile',
            type: 'POST',
            data: { id: fileId },
            success: function(response) {
                if (response.status === 'success') {
                    console.log('File deleted successfully');
                } else {
                    console.log('Failed to delete file');
                }
            },
            error: function() {
                console.log('Failed to delete file');
            }
        });
    }

    // 선택된 항목 영구 삭제 함수
    function permanentDeleteSelected(selectedIds) {
        $.ajax({
            url: '/dataFolder/permanentDeleteSelected',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ ids: selectedIds }),
            success: function(response) {
                if (response.status === 'success') {
                    console.log('Selected items deleted successfully');
                } else {
                    console.log('Failed to delete selected items');
                }
            },
            error: function() {
                console.log('Failed to delete selected items');
            }
        });
    }

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

    // 파일 목록을 불러오는 함수 정의
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

                // 폴더와 파일 개수 계산
                var folderCount = folders.length;
                var fileCount = files.length;

                // 폴더와 파일 개수 표시
                $('.data-pagination .text-muted').text(`폴더 ${folderCount}, 파일 ${fileCount}`);

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

                // 필터 적용
                applyFilter();

                // 폴더와 파일 개수를 업데이트하는 함수 호출
                updateFolderAndFileCount();

                // 폴더/파일 삭제 버튼에 클릭 이벤트 리스너 추가
                $('.data-delete').on('click', function() {
                    var id = $(this).find('i').data('id');
                    var type = $(this).find('i').data('type');
                    var dataTarget = $(this).closest('.data-list-item').data('target');
                    var isTrashFolder = isTrash(dataTarget);
                    var trashId = isTrashFolder ? dataTarget : getTrashId(dataTarget);

                    console.log("Deleting item ID:", id, "Type:", type, "Trash ID:", trashId, "isTrashFolder:", isTrashFolder);

                    var deleteUrl;
                    if (isTrashFolder) {
                        deleteUrl = '/dataFolder/permanentDelete';
                    } else {
                        deleteUrl = type === 'folder' ? '/dataFolder/deleteFolder' : '/dataFolder/delete';
                    }

                    var requestData = { id: id, trashId: trashId, type: type };

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
                            $.ajax({
                                url: deleteUrl,
                                type: 'POST',
                                data: JSON.stringify(requestData),
                                contentType: 'application/json; charset=utf-8',
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader(csrfHeaderName, csrfToken);
                                },
                                success: function(response) {
                                    if (response.status === 'success') {
                                        updateStorageInfo();  // 파일 삭제 후 스토리지 정보 업데이트
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


    // 폴더와 파일 개수를 업데이트하는 함수 정의
    function updateFolderAndFileCount() {
        var visibleFolders = $('.data-list-item:visible[folder-up]').length;
        var visibleFiles = $('.data-list-item:visible[folder-no]').length;

        console.log('Visible Folders:', visibleFolders, 'Visible Files:', visibleFiles);

        $('.data-pagination .text-muted').text(`폴더 \${visibleFolders}, 파일 \${visibleFiles}`);
    }

    
    $('#nameEdit').on('hidden.bs.modal', function() {
        $(this).off('shown.bs.modal'); // 모달이 숨겨질 때 이벤트 리스너 제거
    });
	
    
    // 현재 폴더 정보 가져오기
    function getCurrentFolderInfo() {
        var navItems = $('.data-nav').children();
        var drNo = navItems.first().data('id');
        var fdNo = navItems.length > 1 ? navItems.last().data('id') : "";
        return { drNo: drNo, fdNo: fdNo };
    }
    
    // 파일 업로드 폼 제출 시 실행되는 함수 정의
    $('#uploadForm').on('submit', function(event) {
        event.preventDefault(); // 폼의 기본 제출 동작 방지
        var formData = new FormData(this); // 폼 데이터를 FormData 객체로 생성

        var folderInfo = getCurrentFolderInfo();
        formData.append('drNo', folderInfo.drNo);
        formData.append('fdNo', folderInfo.fdNo);

        $.ajax({
            url: '/dataFolder/upload', // 파일 업로드 URL
            type: 'POST', // HTTP POST 요청
            data: formData, // 폼 데이터 전송
            contentType: false, // contentType 설정 해제
            processData: false, // processData 설정 해제
            beforeSend: function(xhr) {
                xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}'); // CSRF 토큰 헤더 설정
            },
            success: function(response) { // 요청이 성공했을 때 실행되는 함수
                console.log('Upload Response:', response);  // 서버 응답을 콘솔에 출력
                if (response.status === "success") { // 업로드 성공 시
                    updateStorageInfo();    // 파일 업로드 후 스토리지 정보 업데이트
                    Swal.fire({
                        title: '업로드 완료!', // 성공 알림 제목
                        icon: 'success', // 성공 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-success waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                } else { // 업로드 실패 시
                    Swal.fire({
                        title: '업로드 실패!', // 실패 알림 제목
                        icon: 'error', // 실패 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-danger waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                }
                loadFileList(); // 파일 목록 다시 불러오기
                $('#dataComposeSidebar').modal('hide'); // 모달 닫기
                $('#uploadForm')[0].reset(); // 폼 초기화
            },
            error: function(jqXHR, textStatus, errorThrown) { // 요청이 실패했을 때 실행되는 함수
                console.log('Upload Error:', jqXHR.responseText);  // 콘솔 로그 추가
                Swal.fire({
                    title: '업로드 실패!', // 실패 알림 제목
                    icon: 'error', // 실패 아이콘
                    timer: 1000, // 1초 후 자동 닫힘
                    showConfirmButton: false, // 확인 버튼 숨김
                    customClass: {
                        confirmButton: 'btn btn-danger waves-effect waves-light'
                    },
                    buttonsStyling: false
                }).then(function (result) {
                    if (result.dismiss === Swal.DismissReason.timer) {
                        console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                    }
                });
            }
        });
    });

    // 스토리지 정보 업데이트 함수
    function updateStorageInfo() {
        $.ajax({
            url: '/dataFolder/storageInfo',
            type: 'GET',
            success: function(response) {
                var usedSize = response.usedSize + " KB";
                var totalSize = response.totalSize + " KB";
                var percentageUsed = response.percentageUsed + "%";

                $('#usedSize').text(usedSize);
                $('#totalSize').text(totalSize);
                $('#storageProgressBar').css('width', percentageUsed).attr('aria-valuenow', response.percentageUsed);
            },
            error: function(xhr, status, error) {
                $('#usedSize').text('Error');
                $('#totalSize').text('Error');
            }
        });
    }

    // 폴더 추가 폼 제출 이벤트 리스너 추가
    $('#folderAddForm').on('submit', function(event) {
        event.preventDefault(); // 폼의 기본 제출 동작 방지
        var formData = new FormData(this); // 폼 데이터를 FormData 객체로 생성

        var folderInfo = getCurrentFolderInfo();
        formData.append('drNo', folderInfo.drNo);
        formData.append('fdUp', folderInfo.fdNo); // 현재 폴더를 상위 폴더로 설정

        $.ajax({
            url: '/dataFolder/addFolder', // 폴더 추가 URL
            type: 'POST', // HTTP POST 요청
            data: formData, // 폼 데이터 전송
            contentType: false, // contentType 설정 해제
            processData: false, // processData 설정 해제
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeaderName, csrfToken); // CSRF 토큰 헤더 설정
            },
            success: function(response) { // 요청이 성공했을 때 실행되는 함수
                console.log('Add Folder Response:', response);  // 콘솔 로그 추가
                if (response.status === "success") { // 폴더 추가 성공 시
                    Swal.fire({
                        title: '폴더 추가 완료!', // 성공 알림 제목
                        icon: 'success', // 성공 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-success waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                    loadFileList(); // 파일 및 폴더 목록 다시 불러오기
                } else { // 폴더 추가 실패 시
                    Swal.fire({
                        title: '폴더 추가 실패!', // 실패 알림 제목
                        icon: 'error', // 실패 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-danger waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                }
                $('#folderAdd').modal('hide'); // 모달 닫기
                $('#folderAddForm')[0].reset(); // 폼 초기화
            },
            error: function(jqXHR, textStatus, errorThrown) { // 요청이 실패했을 때 실행되는 함수
                console.log('Add Folder Error:', jqXHR.responseText);  // 콘솔 로그 추가
                Swal.fire({
                    title: '폴더 추가 실패!', // 실패 알림 제목
                    icon: 'error', // 실패 아이콘
                    timer: 1000, // 1초 후 자동 닫힘
                    showConfirmButton: false, // 확인 버튼 숨김
                    customClass: {
                        confirmButton: 'btn btn-danger waves-effect waves-light'
                    },
                    buttonsStyling: false
                }).then(function (result) {
                    if (result.dismiss === Swal.DismissReason.timer) {
                        console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                    }
                });
            }
        });
    });

    // 파일/폴더명 저장 버튼 클릭 이벤트 리스너 추가
    $('#saveNameEdit').off('click').on('click', function() {
        var id = $('#itemId').val(); // 아이템 ID 가져오기
        var type = $('#itemType').val(); // 아이템 타입 가져오기
        var newName = $('#modalNameEdit').val(); // 새로운 이름 가져오기

        console.log("New file name:", newName);

        var url = type === 'folder' ? '/dataFolder/updateFolderName' : '/dataFolder/updateFileName'; // URL 설정
        var data = type === 'folder' ? { fdNo: id, fdNm: newName } : { dfNo: id, dfOrgnlFileNm: newName, dfChgFileNm: newName }; // 데이터 설정

        $.ajax({
            url: url, // 요청 URL
            type: 'POST', // HTTP POST 요청
            data: type === 'folder' ? JSON.stringify(data) : JSON.stringify(data), // 데이터 전송
            contentType: 'application/json', // contentType 설정
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeaderName, csrfToken); // CSRF 토큰 헤더 설정
            },
            success: function(response) {
                console.log('Save Name Edit Response:', response);  // 콘솔 로그 추가
                if (response.status === "success") { // 이름 변경 성공 시
                    Swal.fire({
                        title: '변경 완료!', // 성공 알림 제목
                        icon: 'success', // 성공 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-success waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                    loadFileList(); // 파일 목록 다시 불러오기
                    $('#nameEdit').modal('hide'); // 모달 닫기
                } else { // 이름 변경 실패 시
                    Swal.fire({
                        title: '변경 실패!', // 실패 알림 제목
                        icon: 'error', // 실패 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-danger waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                }
            },
            error: function() {
                Swal.fire({
                    title: '변경 실패!', // 실패 알림 제목
                    icon: 'error', // 실패 아이콘
                    timer: 1000, // 1초 후 자동 닫힘
                    showConfirmButton: false, // 확인 버튼 숨김
                    customClass: {
                        confirmButton: 'btn btn-danger waves-effect waves-light'
                    },
                    buttonsStyling: false
                }).then(function (result) {
                    if (result.dismiss === Swal.DismissReason.timer) {
                        console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                    }
                });
            }
        });
    });

    // 전체 선택/해제 기능
    $('#data-select-all').on('change', function() {
        var isChecked = $(this).is(':checked'); // 체크 여부 확인
        $('.data-list-item').each(function() {
            if ($(this).css('display') !== 'none') { // display: none; 상태가 아닌 항목들만 선택
                $(this).find('.data-list-item-input').prop('checked', isChecked); // 해당 항목의 체크 상태 변경
            }
        });
    });

    // 선택된 항목 삭제 기능
    $('#deleteSelected').on('click', function() {
        var selectedItems = []; // 선택된 아이템의 정보를 저장할 배열
        
        // 체크된 아이템의 정보를 배열에 추가
        $('.data-list-item-input:checked').each(function() {
            var $item = $(this).closest('.data-list-item');
            selectedItems.push({
                id: $(this).attr('id').split('-')[1], // ID에서 불필요한 부분 제거
                type: $(this).attr('id').startsWith('data-FD') ? 'folder' : 'file', // 폴더인지 파일인지 구분
                drNo: $item.data('target') // 현재 위치한 자료실 번호
            });
        });

        // 선택된 아이템이 없으면 알림 표시
        if (selectedItems.length === 0) {
            Swal.fire({
                title: '삭제할 항목을 선택하세요!',
                icon: 'warning',
                timer: 1000,
                showConfirmButton: false
            });
            return;
        }

        var currentFolderId = currentPath[currentPath.length - 1].id; // 현재 폴더 ID
        var isTrashFolder = isTrash(currentFolderId); // 현재 폴더가 휴지통인지 확인
        var title = isTrashFolder ? '완전 삭제하시겠습니까?' : '삭제하시겠습니까?';
        var ajaxUrl = isTrashFolder ? '/dataFolder/permanentDeleteSelected' : '/dataFolder/deleteSelected';

        // 삭제 확인 알림 표시
        Swal.fire({
            title: title,
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
                // AJAX 요청을 통해 서버에 삭제 요청 전송
                $.ajax({
                    url: ajaxUrl,
                    type: 'POST',
                    data: JSON.stringify({ items: selectedItems }),
                    contentType: 'application/json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader(csrfHeaderName, csrfToken);
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            Swal.fire({
                                title: '삭제 완료!',
                                icon: 'success',
                                timer: 1000,
                                showConfirmButton: false
                            });
                            loadFileList(); // 파일 목록 새로고침
                        } else {
                            Swal.fire({
                                title: '삭제 실패!',
                                text: response.message,
                                icon: 'error',
                                timer: 1000,
                                showConfirmButton: false
                            });
                        }
                    },
                    error: function() {
                        Swal.fire({
                            title: '삭제 실패!',
                            icon: 'error',
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                });
            }
        });
    });

    // 다운로드 버튼 클릭 이벤트 리스너 추가
    $('#downloadSelected').on('click', function() {
        var selectedIds = []; // 선택된 아이템의 ID를 저장할 배열
        $('.data-list-item-input:checked').each(function() {
            selectedIds.push($(this).attr('id').split('-')[1]); // 체크된 아이템의 ID를 배열에 추가
        });

        if (selectedIds.length === 0) { // 선택된 아이템이 없으면 알림 표시
            Swal.fire({
                title: '다운로드할 항목을 선택하세요!', // 알림 제목
                icon: 'warning', // 경고 아이콘
                timer: 1000, // 1초 후 자동 닫힘
                showConfirmButton: false, // 확인 버튼 숨김
                customClass: {
                    confirmButton: 'btn btn-warning waves-effect waves-light'
                },
                buttonsStyling: false
            });
            return;
        }

        if (selectedIds.length === 1) { // 선택된 아이템이 하나일 때
            window.location.href = '/dataFolder/download/file/' + selectedIds[0]; // 해당 아이템 다운로드
            // 다운로드가 완료되었으므로 체크박스 해제
            $('.data-list-item-input:checked').prop('checked', false);
        } else { // 선택된 아이템이 여러 개일 때
            $.ajax({
                url: '/dataFolder/downloadSelected', // 선택된 아이템 다운로드 URL
                type: 'POST', // HTTP POST 요청
                data: JSON.stringify(selectedIds), // 선택된 아이템의 ID를 JSON 문자열로 변환하여 전송
                contentType: 'application/json', // contentType 설정
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeaderName, csrfToken); // CSRF 토큰 설정
                },
                xhrFields: {
                    responseType: 'blob' // 응답 타입을 blob으로 설정
                },
                success: function(response) {
                    var blob = new Blob([response], { type: 'application/zip' }); // 응답 데이터를 Blob으로 변환
                    var link = document.createElement('a'); // 링크 요소 생성
                    link.href = window.URL.createObjectURL(blob); // Blob URL 생성
                    link.download = 'selected_files.zip'; // 다운로드 파일 이름 설정
                    link.click(); // 링크 클릭하여 다운로드 시작

                    // 다운로드가 완료되었으므로 체크박스 해제
                    $('.data-list-item-input:checked').prop('checked', false);
                },
                error: function() { // 요청 실패 시
                    Swal.fire({
                        title: '다운로드 실패!', // 실패 알림 제목
                        icon: 'error', // 실패 아이콘
                        timer: 1000, // 1초 후 자동 닫힘
                        showConfirmButton: false, // 확인 버튼 숨김
                        customClass: {
                            confirmButton: 'btn btn-danger waves-effect waves-light'
                        },
                        buttonsStyling: false
                    }).then(function(result) {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                        }
                    });
                }
            });
        }
    });

    // 폴더 필터 적용 함수 정의
    function applyFilter(folderId = null) {
        var activeFilter = folderId ? folderId : $('.data-filter-folders .active').data('target');

        $('.data-list-item').each(function() {
            var itemFolderUp = $(this).attr('folder-up');
            var itemFolderNo = $(this).attr('folder-no');

            // 최상위 폴더와 파일을 구분하여 표시
            if (folderId == null) {
                if ((itemFolderUp === "" || itemFolderUp === "null") && $(this).data('target') == activeFilter) {
                    $(this).show();
                } else if ((itemFolderNo === "" || itemFolderNo === "null") && $(this).data('target') == activeFilter) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            } 
            // 네비게이션의 첫 번째 항목을 클릭했을 때 최상위 폴더와 파일을 표시
            else if (currentPath.length === 1 && ((itemFolderUp === "" || itemFolderUp === "null") || (itemFolderNo === "" || itemFolderNo === "null")) && $(this).data('target') == activeFilter) {
                $(this).show();
            }
            // 하위 폴더와 파일을 구분하여 표시
            else {
                if (itemFolderUp == folderId || itemFolderNo == folderId) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            }
        });

        // 필터 적용 후 폴더와 파일 개수 업데이트
        updateFolderAndFileCount();
    }

    $('.data-filter-folders li').on('click', function() {
        $('.data-filter-folders li').removeClass('active');
        $(this).addClass('active');
        var folderId = $(this).data('target');
        var folderName = $(this).find('span').text();
        currentPath = [{
            id: folderId,
            name: folderName
        }];
        $('.data-search-input').val('');
        updateNavigation();
        applyFilter(folderId);
        updateUIForTrash(folderId);
    });

    // 폴더 링크 클릭 이벤트 리스너 추가
    $(document).on('click', '.folder-link', function() {
        var folderId = $(this).data('id');
        $('.data-search-input').val('');
        navigateToFolder(folderId);
    });

    // 초기 네비게이션 설정
    initializeNavigation();

    // 선택된 항목 영구 삭제 기능
    $('#permanentDeleteSelected').on('click', function() {
        var selectedIds = []; // 선택된 아이템의 ID를 저장할 배열
        $('.data-list-item-input:checked').each(function() {
            selectedIds.push($(this).attr('id').split('-')[1]); // 체크된 아이템의 ID를 배열에 추가
        });

        if (selectedIds.length === 0) { // 선택된 아이템이 없으면 알림 표시
            Swal.fire({
                title: '영구 삭제할 항목을 선택하세요!', // 알림 제목
                icon: 'warning', // 경고 아이콘
                timer: 1000, // 1초 후 자동 닫힘
                showConfirmButton: false, // 확인 버튼 숨김
                customClass: {
                    confirmButton: 'btn btn-warning waves-effect waves-light'
                },
                buttonsStyling: false
            });
            return;
        }

        // SweetAlert2를 사용하여 삭제 확인 알림 표시
        Swal.fire({
            title: '영구 삭제하시겠습니까?', // 알림 제목
            icon: 'warning', // 경고 아이콘
            showCancelButton: true, // 취소 버튼 표시
            confirmButtonText: '삭제', // 확인 버튼 텍스트
            cancelButtonText: '취소', // 취소 버튼 텍스트
            customClass: {
                confirmButton: 'btn btn-danger waves-effect waves-light',
                cancelButton: 'btn btn-secondary waves-effect waves-light'
            },
            buttonsStyling: false // 기본 버튼 스타일 사용 안함
        }).then((result) => {
            if (result.isConfirmed) { // 사용자가 확인 버튼을 클릭했을 때
                $.ajax({
                    url: '/dataFolder/permanentDeleteSelected', // 선택된 아이템 삭제 URL
                    type: 'POST', // HTTP POST 요청
                    data: JSON.stringify(selectedIds), // 선택된 아이템의 ID를 JSON 문자열로 변환하여 전송
                    contentType: 'application/json', // contentType 설정
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader(csrfHeaderName, csrfToken); // CSRF 토큰 헤더 설정
                    },
                    success: function(response) {
                        console.log('Permanent Delete Selected Response:', response); // 서버 응답을 콘솔에 출력
                        if (response.status === 'success') { // 삭제 성공 시
                            Swal.fire({
                                title: '삭제 완료!', // 성공 알림 제목
                                icon: 'success', // 성공 아이콘
                                timer: 1000, // 1초 후 자동 닫힘
                                showConfirmButton: false, // 확인 버튼 숨김
                                customClass: {
                                    confirmButton: 'btn btn-success waves-effect waves-light'
                                },
                                buttonsStyling: false
                            }).then(function (result) {
                                if (result.dismiss === Swal.DismissReason.timer) {
                                    console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                                }
                            });
                            loadFileList(); // 파일 목록 다시 불러오기
                        } else { // 삭제 실패 시
                            Swal.fire({
                                title: '삭제 실패!', // 실패 알림 제목
                                icon: 'error', // 실패 아이콘
                                timer: 1000, // 1초 후 자동 닫힘
                                showConfirmButton: false, // 확인 버튼 숨김
                                customClass: {
                                    confirmButton: 'btn btn-danger waves-effect waves-light'
                                },
                                buttonsStyling: false
                            }).then(function (result) {
                                if (result.dismiss === Swal.DismissReason.timer) {
                                    console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                                }
                            });
                        }
                    },
                    error: function() { // 요청 실패 시
                        Swal.fire({
                            title: '삭제 실패!', // 실패 알림 제목
                            icon: 'error', // 실패 아이콘
                            timer: 1000, // 1초 후 자동 닫힘
                            showConfirmButton: false, // 확인 버튼 숨김
                            customClass: {
                                confirmButton: 'btn btn-danger waves-effect waves-light'
                            },
                            buttonsStyling: false
                        }).then(function (result) {
                            if (result.dismiss === Swal.DismissReason.timer) {
                                console.log('The alert was closed by the timer'); // 알림이 타이머에 의해 닫혔을 때 로그 출력
                            }
                        });
                    }
                });
            }
        });
    });

    // 초기 페이지 로드 시 스토리지 정보 업데이트
    updateStorageInfo();

    // 페이지 로드 시 파일 목록 불러오기
    loadFileList();
});
</script>
    
<div class="app-data card">
    <div class="row g-0">
        <!-- Data Sidebar -->
        <div class="col app-data-sidebar border-end flex-grow-0" id="app-data-sidebar">
            <div class="btn-compost-wrapper d-grid">
                <div class="data-aside-header">
				    <div class="status-title">Storage</div>
				    <div class="progress w-100 me-3" style="height: 6px;">
				        <div id="storageProgressBar" class="progress-bar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
				    </div>
				    <div class="status-info">
				        <span id="usedSize">0 KB</span> / <span id="totalSize">1024 KB</span>
				    </div>
				</div>

                <button class="btn btn-primary btn-compose" data-bs-toggle="modal" data-bs-target="#dataComposeSidebar" id="dataComposeSidebarLabel">
                    파일 업로드
                </button>
            </div>
            <!-- Data Filters -->
            <div class="data-filters py-2">
			    <!-- Data Filters: Folder -->
			    <small class="fw-normal text-uppercase text-muted m-4">개인 자료실</small>
			    <ul class="data-filter-folders list-unstyled mb-4">
			        <li class="active d-flex justify-content-between" data-target="DR001">
			            <a href="javascript:void(0);" class="navigate-folder" data-id="DR001">
			                <i class="ti ti-file-text ti-sm"></i>
			                <span class="align-middle ms-2">프로젝트 자료</span>
			            </a>
			        </li>
			        <li class="d-flex justify-content-between" data-target="DR002">
			            <a href="javascript:void(0);" class="navigate-folder" data-id="DR002">
			                <i class="ti ti-user ti-sm"></i>
			                <span class="align-middle ms-2">개인 자료</span>
			            </a>
			        </li>
			        <li class="d-flex justify-content-between" data-target="DR003">
			            <a href="javascript:void(0);" class="navigate-folder" data-id="DR003">
			                <i class="ti ti-star ti-sm"></i>
			                <span class="align-middle ms-2">중요 자료</span>
			            </a>
			        </li>
			        <li class="d-flex justify-content-between" data-target="TRASH02">
			            <a href="javascript:void(0);" class="navigate-folder" data-id="TRASH02">
			                <i class="ti ti-trash ti-sm"></i>
			                <span class="align-middle ms-2">휴지통</span>
			            </a>
			        </li>
			    </ul>
			    <small class="fw-normal text-uppercase text-muted m-4">전사 자료실</small>
			    <ul class="data-filter-folders list-unstyled mb-4">
                    <li class="d-flex justify-content-between" data-target="DR004">
                        <a href="javascript:void(0);" class="navigate-folder" data-id="DR004">
			                <i class="ti ti-building ti-sm"></i>
			                <span class="align-middle ms-2">경영 자료</span>
			            </a>
			        </li>
			        <li class="d-flex justify-content-between" data-target="DR005">
                        <a href="javascript:void(0);" class="navigate-folder" data-id="DR005">
                            <i class="ti ti-slideshow ti-sm"></i>
			                <span class="align-middle ms-2">홍보 자료</span>
			            </a>
			        </li>
                    <li class="d-flex justify-content-between" data-target="TRASH01">
                        <a href="javascript:void(0);" class="navigate-folder" data-id="TRASH01">
                            <i class="ti ti-trash ti-sm"></i>
                            <span class="align-middle ms-2">휴지통</span>
                        </a>
                    </li>
			    </ul>
			</div>
        </div>
        <!--/ Data Sidebar -->
        
        <!-- Data List -->
        <div class="col app-datas-list">
            <div class="shadow-none border-0">
                <div class="datas-list-header p-3 py-lg-3 py-2">
                    <!-- Data List: Nav / Search -->
                    <div class="d-flex justify-content-between align-items-center mb-md-2">
                        <div class="data-nav d-flex align-items-center mb-0">
                            <!-- AJAX로 네비게이션이 추가될 영역 -->
                        </div>
                        <div class="search-area d-flex align-items-center">
                            <i class="ti ti-menu-2 ti-sm cursor-pointer d-block d-lg-none me-3" data-bs-toggle="sidebar" data-target="#app-data-sidebar" data-overlay></i>
                            <div class="mb-0 w-100">
                                <div class="input-group input-group-merge shadow-none">
                                    <span class="input-group-text border-0 ps-0" id="data-search">
                                        <i class="ti ti-search"></i>
                                    </span>
                                    <input type="text" class="form-control data-search-input border-0" placeholder="검색" aria-label="Search data" aria-describedby="data-search" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr class="mx-n3 datas-list-header-hr" />
                    <!-- Data List: Actions / Page -->
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="btnCtrlWrap d-flex align-items-center">
                            <div class="form-check mb-0 me-3">
                                <input class="form-check-input" type="checkbox" id="data-select-all" />
                                <label class="form-check-label" for="data-select-all"></label>
                            </div>
                            <!-- 삭제 -->
                            <button type="button" class="btn_reset" id="deleteSelected"><i class="ti ti-trash ti-sm data-list-delete cursor-pointer me-2"></i></button>
                            <!-- 폴더 추가 -->
                            <i 
                              class="ti ti-folder-plus ti-sm data-list-read cursor-pointer me-2"
                              data-bs-toggle="modal"
                              data-bs-target="#folderAdd"
                              id="folderAddLabel"></i>
                            <!-- 다운로드 -->
                            <i class="ti ti-download ti-sm data-list-read cursor-pointer me-2" id="downloadSelected"></i>
                            <!-- 휴지통 비우기 -->
                        </div>
                        <div class="data-pagination d-sm-flex d-none align-items-center flex-wrap justify-content-between justify-sm-content-end">
                            <span class="d-sm-block d-none text-muted"></span>
                        </div>
                    </div>
                </div>
                <hr class="container-m-nx m-0" />
                <!-- Data List: Items -->
                <div class="data-list pt-0" id="dataList">
                    <ul class="list-unstyled m-0">
                    <!-- AJAX로 파일 목록이 추가될 영역 -->
                    </ul>
                </div>
            </div>
            <div class="app-overlay"></div>
        </div>
        <!-- /Data List -->

    </div>

    <!-- Modal : 파일업로드 -->
    <div class="modal fade" id="dataComposeSidebar" tabindex="-1" aria-labelledby="dataComposeSidebarLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel1">파일 업로드</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="uploadForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input class="form-control" type="file" name="file" id="formFileMultiple" multiple />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary" id="uploadButton">업로드</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- /Modal : 파일업로드 -->

    <!-- Modal : 파일/폴더명 변경 -->
    <div class="modal fade" id="nameEdit" tabindex="-1" aria-labelledby="exampleModalLabel2" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel2">파일명 변경</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input id="modalNameEdit" name="modalNameEdit" class="form-control" type="text" value="" autofocus="">
                    <input type="hidden" id="itemType" name="itemType" value="">
                    <input type="hidden" id="itemId" name="itemId" value="">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="saveNameEdit">저장</button>
                </div>
            </div>
        </div>
    </div>
    <!-- /Modal : 파일/폴더명 변경 -->
    
    <!-- Modal : 폴더 추가 -->
    <div class="modal fade" id="folderAdd" tabindex="-1" aria-labelledby="folderAddLabel" aria-hidden="true">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLabel3">폴더 추가</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <form id="folderAddForm">
	                <div class="modal-body">
	                    <div class="col-12 fv-plugins-icon-container">
	                        <div class="input-group input-group-merge has-validation">
	                            <input id="modalFolderAdd" name="folderName" class="form-control" type="text" placeholder="폴더명을 입력해주세요" autofocus />
	                            <span class="input-group-text cursor-pointer p-1" id="modalAddCard2"><span class="card-type"></span></span>
	                        </div>
	                        <div class="fv-plugins-message-container fv-plugins-message-container--enabled invalid-feedback"></div>
	                    </div>
	                </div>
	                <div class="modal-footer">
	                    <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">취소</button>
	                    <button type="submit" class="btn btn-primary" id="folderAddButton">저장</button>
	                </div>
	            </form>
	        </div>
	    </div>
	</div>
    <!-- /Modal : 폴더 추가 -->
</div>

<!-- Page JS -->
<script src="/resources/vuexy/assets/js/app-data.js"></script>
<!-- <script src="/resources/vuexy/assets/vendor/libs/dropzone/dropzone.js"></script> -->
<!-- <script src="/resources/vuexy/assets/js/forms-file-upload.js"></script> -->

<script>
$(document).ready(function() {
    $.ajax({
        url: '/dataFolder/storageInfo',
        method: 'GET',
        success: function(response) {
            $('#storage-progress-bar').css('width', response.percentageUsed + '%');
            $('#storage-progress-bar').attr('aria-valuenow', response.percentageUsed);
            $('#storage-status-info').text(response.usedSize + ' MB / ' + response.totalSize + ' MB');
        },
        error: function() {
            $('#storage-status-info').text('Error loading storage info');
        }
    });
});
</script>