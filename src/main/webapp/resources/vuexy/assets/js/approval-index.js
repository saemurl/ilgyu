'use strict';

$(function () {
  let borderColor, bodyBg, headingColor;

  if (isDarkStyle) {
    borderColor = config.colors_dark.borderColor;
    bodyBg = config.colors_dark.bodyBg;
    headingColor = config.colors_dark.headingColor;
  } else {
    borderColor = config.colors.borderColor;
    bodyBg = config.colors.bodyBg;
    headingColor = config.colors.headingColor;
  }

  // Variable declaration for table
  var dt_user_table = $('.datatables-approval-index'),
    statusObj = {
      1: { title: '결재 완료', class: 'bg-label-success' },
      2: { title: '결재 대기', class: 'bg-label-warning' },
      3: { title: '반려됨', class: 'bg-label-danger' }
    };

  // Users datatable
  if (dt_user_table.length) {
    var dt_user = dt_user_table.DataTable({
      ajax: assetsPath + 'json/approval-index.json', // JSON file to add data
      columns: [
        { data: 'id' },  // id 추가
        { data: 'title' },
        { data: 'date' },
        { data: 'drafter' },
        { data: 'status' }
      ],
      columnDefs: [
        {
          // For ID
          targets: 0,
          visible: false,
          searchable: false
        },
        {
          // For title
          targets: 1,
          responsivePriority: 1,
          render: function (data, type, full, meta) {
            var $title = full['title'];
            return '<span>' + $title + '</span>';
          }
        },
        {
          // For date
          targets: 2,
          render: function (data, type, full, meta) {
            var $date = full['date'];
            return '<span>' + $date + '</span>';
          }
        },
        {
          // For drafter
          targets: 3,
          render: function (data, type, full, meta) {
            var $drafter = full['drafter'];
            return '<span>' + $drafter + '</span>';
          }
        },
        {
          // For status
          targets: 4,
          render: function (data, type, full, meta) {
            var $status = full['status'];
            return (
              '<span class="badge ' +
              statusObj[$status].class +
              '" text-capitalized>' +
              statusObj[$status].title +
              '</span>'
            );
          }
        }
      ],
      order: [[1, 'asc']],
      paging: false, // Disable pagination
      scrollY: false, // Scroll for tbody
      scrollX: true, // Enable horizontal scroll
      scrollCollapse: true,
      dom: 't',
      language: {
        sLengthMenu: '_MENU_'
      },
      initComplete: function (settings, json) {
        // Add the mti-n1 class to the first row in tbody
        dt_user_table.find('tbody tr:first').addClass('border-top-0');
        
        // Remove padding-right from dataTables_scrollHeadInner
        $('.dataTables_scrollHeadInner').css('padding-right', '0');
      }
    });

    $('.dataTables_length').addClass('mt-0 mt-md-3 me-2 ms-n2 ms-sm-0');
    $('.dt-action-buttons').addClass('pt-0');
  }

  // Filter form control to default size
  // ? setTimeout used for multilingual table initialization
  setTimeout(() => {
    $('.dataTables_filter .form-control').removeClass('form-control-sm');
    $('.dataTables_length .form-select').removeClass('form-select-sm');
  }, 300);
});
