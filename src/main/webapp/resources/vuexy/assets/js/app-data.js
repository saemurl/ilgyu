/**
 * App data
 */

'use strict';

// 문서의 모든 내용이 로드된 후 실행
document.addEventListener('DOMContentLoaded', function () {
    console.log('DOM fully loaded and parsed');  // 이 메시지가 콘솔에 출력되는지 확인
    (function () {
        // 데이터 목록 요소를 변수에 저장
        const dataList = document.querySelector('.data-list'),
            // 업로드 버튼 요소를 변수에 저장
            uploadButton = document.getElementById('uploadButton'),
            // 데이터 항목(목록 li)들을 배열로 저장
            dataListItems = [].slice.call(document.querySelectorAll('.data-list-item')),
            // 데이터 항목 입력란(체크박스)들을 배열로 저장
            dataListItemInputs = [].slice.call(document.querySelectorAll('.data-list-item-input')),
            // 데이터 필터 요소(자료실 목록 Wrap 영역)를 변수에 저장
            dataFilters = document.querySelector('.data-filters'),
            // 사이드 메뉴 요소를 배열로 저장
            dataFilterByFolders = [].slice.call(document.querySelectorAll('.data-filter-folders li')),
            // 사이드바 요소를 변수에 저장
            appdataSidebar = document.querySelector('.app-data-sidebar'),
            // 오버레이 요소를 변수에 저장
            appOverlay = document.querySelector('.app-overlay'),
            // 모든 데이터 선택 체크박스 요소를 변수에 저장
            selectAlldatas = document.getElementById('data-select-all'),
            // 데이터 검색 입력란 요소를 변수에 저장
            dataSearch = document.querySelector('.data-search-input'),
            // 데이터 삭제 버튼 요소를 변수에 저장
            dataListDelete = document.querySelector('.data-list-delete'),
            // 데이터 목록이 비었을 때 표시되는 요소를 변수에 저장
            dataListEmpty = document.querySelector('.data-list-empty'),
            // 데이터 항목 액션 요소들을 배열로 저장
            dataListItemActions = [].slice.call(document.querySelectorAll('.data-list-item-actions li'));

        // 데이터 목록 요소에 스크롤바 초기화
        if (dataList) {
            let dataListInstance = new PerfectScrollbar(dataList, {
                wheelPropagation: false,  // 마우스 휠로 스크롤할 때 이벤트 전파를 막음
                suppressScrollX: true  // 수평 스크롤을 막음
            });
        }

        // 데이터 필터 요소에 스크롤바 초기화
        if (dataFilters) {
            new PerfectScrollbar(dataFilters, {
                wheelPropagation: false,  // 마우스 휠로 스크롤할 때 이벤트 전파를 막음
                suppressScrollX: true  // 수평 스크롤을 막음
            });
        }

        console.log('JavaScript code executed');  // 이 메시지가 콘솔에 출력되는지 확인

        // 모든 데이터 선택 체크박스 클릭 이벤트 리스너 추가
        if (selectAlldatas) {
            selectAlldatas.addEventListener('click', e => {
                // 체크박스가 체크되었을 때
                if (e.currentTarget.checked) {
                    // 모든 데이터 항목 체크박스를 체크 상태로 변경
                    dataListItemInputs.forEach(c => (c.checked = 1));
                } else {
                    // 모든 데이터 항목 체크박스를 체크 해제 상태로 변경
                    dataListItemInputs.forEach(c => (c.checked = 0));
                }
            });
        }

        // 개별 데이터 항목 선택 기능 추가
        if (dataListItemInputs) {
            dataListItemInputs.forEach(dataListItemInput => {
                dataListItemInput.addEventListener('click', e => {
                    e.stopPropagation();  // 이벤트 전파를 막음
                    let dataListItemInputCount = 0;
                    dataListItemInputs.forEach(dataListItemInput => {
                        if (dataListItemInput.checked) {
                            dataListItemInputCount++;  // 체크된 항목 개수 카운트
                        }
                    });

                    // 전체 선택 체크박스의 상태를 업데이트
                    if (dataListItemInputCount < dataListItemInputs.length) {
                        if (dataListItemInputCount == 0) {
                            selectAlldatas.indeterminate = false;  // 중간 상태 해제
                        } else {
                            selectAlldatas.indeterminate = true;  // 중간 상태 설정
                        }
                    } else {
                        if (dataListItemInputCount == dataListItemInputs.length) {
                            selectAlldatas.indeterminate = false;  // 중간 상태 해제
                            selectAlldatas.checked = true;  // 전체 선택 체크박스 체크
                        } else {
                            selectAlldatas.indeterminate = false;  // 중간 상태 해제
                        }
                    }
                });
            });
        }

        // 검색 입력란에 키 입력 이벤트 리스너 추가
        if (dataSearch) {
            dataSearch.addEventListener('keyup', e => {
                let searchValue = e.currentTarget.value.toLowerCase(),  // 입력된 검색어를 소문자로 변환
                    searchdataListItems = {},  // 검색할 데이터 항목들을 저장할 객체
                    selectedFolderFilter = document.querySelector('.data-filter-folders .active').getAttribute('data-target');

                // 선택된 폴더 필터에 따른 데이터 항목 선택
                if (selectedFolderFilter != 'inbox') {
                    searchdataListItems = [].slice.call(
                        document.querySelectorAll('.data-list-item[data-' + selectedFolderFilter + '="true"]')
                    );
                } else {
                    searchdataListItems = [].slice.call(document.querySelectorAll('.data-list-item'));
                }

                // 검색어에 맞게 데이터 항목 필터링
                searchdataListItems.forEach(searchdataListItem => {
                    let searchdataListItemText = searchdataListItem.textContent.toLowerCase();
                    if (searchValue) {
                        if (-1 < searchdataListItemText.indexOf(searchValue)) {
                            searchdataListItem.classList.add('d-block');  // 검색어와 일치하면 보이도록 설정
                        } else {
                            searchdataListItem.classList.add('d-none');  // 검색어와 일치하지 않으면 숨김
                        }
                    } else {
                        searchdataListItem.classList.remove('d-none');  // 검색어가 없으면 모두 보이도록 설정
                    }
                });
            });
        }

        // 사이드 메뉴 버튼 클릭 이벤트 리스너
        dataFilterByFolders.forEach(dataFilterByFolder => {
            dataFilterByFolder.addEventListener('click', e => {
                let currentTarget = e.currentTarget,  // 클릭된 폴더 필터 요소
                    currentTargetData = currentTarget.getAttribute('data-target');  // 클릭된 폴더 필터의 데이터 속성 값

                appdataSidebar.classList.remove('show');  // 사이드바 숨김
                appOverlay.classList.remove('show');  // 오버레이 숨김

                // 모든 폴더 필터에서 활성 상태 제거
                Helpers._removeClass('active', dataFilterByFolders);
                // 클릭된 폴더 필터에 활성 상태 추가
                currentTarget.classList.add('active');
                // 데이터 항목들을 폴더 필터에 따라 필터링
                dataListItems.forEach(dataListItem => {
                    if (currentTargetData == 'inbox') {
                        dataListItem.classList.add('d-block');  // 받은 편지함이면 보이도록 설정
                        dataListItem.classList.remove('d-none');  // 숨김 해제
                    } else if (dataListItem.hasAttribute('data-' + currentTargetData)) {
                        dataListItem.classList.add('d-block');  // 해당 폴더에 속하면 보이도록 설정
                        dataListItem.classList.remove('d-none');  // 숨김 해제
                    } else {
                        dataListItem.classList.add('d-none');  // 해당 폴더에 속하지 않으면 숨김
                        dataListItem.classList.remove('d-block');  // 보임 해제
                    }
                });
            });
        });

        // 데이터 삭제 버튼 클릭 이벤트 리스너 추가
        if (dataListDelete) {
            dataListDelete.addEventListener('click', e => {
                dataListItemInputs.forEach(dataListItemInput => {
                    if (dataListItemInput.checked) {
                        dataListItemInput.parentNode.closest('li.data-list-item').remove();  // 선택된 데이터 항목 삭제
                    }
                });
                selectAlldatas.indeterminate = false;  // 중간 상태 해제
                selectAlldatas.checked = false;  // 전체 선택 체크 해제
                var dataListItem = document.querySelectorAll('.data-list-item');
                if (dataListItem.length == 0) {
                    dataListEmpty.classList.remove('d-none');  // 데이터 항목이 없으면 빈 목록 표시
                }
            });
        }

        // 데이터 리스트 아이템 액션 기능 추가
        if (dataListItemActions) {
            dataListItemActions.forEach(dataListItemAction => {
                dataListItemAction.addEventListener('click', e => {
                    e.stopPropagation();  // 이벤트 전파를 막음
                    let currentTarget = e.currentTarget;
                    if (Helpers._hasClass('data-delete', currentTarget)) {
                        currentTarget.parentNode.closest('li.data-list-item').remove();  // 데이터 항목 삭제
                        var dataListItem = document.querySelectorAll('.data-list-item');
                        if (dataListItem.length == 0) {
                            dataListEmpty.classList.remove('d-none');  // 데이터 항목이 없으면 빈 목록 표시
                        }
                    } else if (Helpers._hasClass('data-read', currentTarget)) {
                        currentTarget.parentNode.closest('li.data-list-item').classList.add('data-marked-read');  // 읽음 상태로 변경
                        Helpers._toggleClass(currentTarget, 'data-read', 'data-unread');  // 클래스 토글
                        Helpers._toggleClass(currentTarget.querySelector('i'), 'ti-mail-opened', 'ti-mail');  // 아이콘 토글
                    } else if (Helpers._hasClass('data-unread', currentTarget)) {
                        currentTarget.parentNode.closest('li.data-list-item').classList.remove('data-marked-read');  // 읽음 상태 해제
                        Helpers._toggleClass(currentTarget, 'data-read', 'data-unread');  // 클래스 토글
                        Helpers._toggleClass(currentTarget.querySelector('i'), 'ti-mail-opened', 'ti-mail');  // 아이콘 토글
                    }
                });
            });
        }
    })();
});
