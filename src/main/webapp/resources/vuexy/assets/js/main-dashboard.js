'use strict';

(function () {
  let cardColor, labelColor, shadeColor, legendColor, borderColor, headingColor, grayColor;
  cardColor = config.colors.cardColor;
  labelColor = config.colors.textMuted;
  legendColor = config.colors.bodyColor;
  borderColor = config.colors.borderColor;
  shadeColor = '';
  headingColor = config.colors.headingColor;
  grayColor = '#817D8D';

	getAttenStatic();


  // 근무 유형별 분포
  // --------------------------------------------------------------------
  const salesLastMonthEl = document.querySelector('#salesLastMonth'),
    salesLastMonthConfig = {
      series: [
        {
          name: '사무실 근무',
          data: [32, 27, 27, 30, 25, 25]
        },
        {
          name: '재택 근무',
          data: [25, 35, 20, 20, 20, 20]
        }
      ],
      chart: {
        height: 340,
        type: 'radar',
        toolbar: {
          show: false
        }
      },
      plotOptions: {
        radar: {
          polygons: {
            strokeColors: borderColor,
            connectorColors: borderColor
          }
        }
      },
      stroke: {
        show: false,
        width: 0
      },
      legend: {
        show: true,
        fontSize: '13px',
        position: 'bottom',
        labels: {
          colors: legendColor,
          useSeriesColors: false
        },
        markers: {
          height: 10,
          width: 10,
          offsetX: -3
        },
        itemMargin: {
          horizontal: 10
        },
        onItemHover: {
          highlightDataSeries: false
        }
      },
      colors: [config.colors.primary, config.colors.info],
      fill: {
        opacity: [1, 0.85]
      },
      markers: {
        size: 0
      },
      grid: {
        show: false,
        padding: {
          top: 0,
          bottom: -5
        }
      },
      xaxis: {
        categories: ['1월', '2월', '3월', '4월', '5월', '6월'],
        labels: {
          show: true,
          style: {
            colors: [labelColor, labelColor, labelColor, labelColor, labelColor, labelColor],
            fontSize: '13px',
            fontFamily: 'Public Sans'
          }
        }
      },
      yaxis: {
        show: false,
        min: 0,
        max: 40,
        tickAmount: 4
      },
      responsive: [
        {
          breakpoint: 769,
          options: {
            chart: {
              height: 400
            }
          }
        }
      ]
    };
  if (typeof salesLastMonthEl !== undefined && salesLastMonthEl !== null) {
    const salesLastMonth = new ApexCharts(salesLastMonthEl, salesLastMonthConfig);
    salesLastMonth.render();
  }

function getAttenStatic(){
  let labelList = [];
  let dataList = [];
  let total = 0;
	$.ajax({
    url: "/main/getAttendanceSumByWeek",
    type: "get",
    success: function(result) {
      let totalWorkEl = document.querySelector('#totalWork');
      let avgWorkEl = document.querySelector('#avgWork');
  
      if (totalWorkEl && avgWorkEl) {
        result.forEach(function(map, idx) {
          dataList.push(map.SUM);
          labelList.push(map.WEEK);
          total += Number(map.SUM);
        });
        totalWorkEl.innerHTML = total.toFixed(1) + "시간";
        avgWorkEl.innerHTML = (total / 5).toFixed(1) + "h";
      }
    }
  });
  // 월간 근무 통계
  // --------------------------------------------------------------------
  const monthlyWorkStatsEl = document.querySelector('#monthlyWorkStats'),
    weeklyEarningReportsConfig = {
      chart: {
        height: 200,
        parentHeightOffset: 0,
        type: 'bar',
        toolbar: {
          show: false
        }
      },
      plotOptions: {
        bar: {
          barHeight: '60%',
          columnWidth: '38%',
          startingShape: 'rounded',
          endingShape: 'rounded',
          borderRadius: 4,
          distributed: true
        }
      },
      grid: {
        show: false,
        padding: {
          top: -30,
          bottom: 0,
          left: -10,
          right: -10
        }
      },
      colors: [
        config.colors.primary,
        config.colors.primary,
        config.colors_label.primary,
        config.colors_label.primary,
        config.colors_label.primary
      ],
      dataLabels: {
        enabled: false,
      },
      series: [
        {
          data: dataList
        }
      ],
      legend: {
        show: false
      },
      xaxis: {
        categories: labelList,
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false
        },
        labels: {
          style: {
            colors: labelColor,
            fontSize: '13px',
            fontFamily: 'Public Sans'
          }
        }
      },
      yaxis: {
        labels: {
          show: false
        }
      },
      tooltip: {
        enabled: true
      },
      responsive: [
        {
          breakpoint: 1025,
          options: {
            chart: {
              height: 199
            }
          }
        }
      ]
    };
  if (monthlyWorkStatsEl !== undefined && monthlyWorkStatsEl !== null) {
    const weeklyEarningReports = new ApexCharts(monthlyWorkStatsEl, weeklyEarningReportsConfig);
    weeklyEarningReports.render();
  }
}

  // Filter form control to default size
  // ? setTimeout used for multilingual table initialization
  setTimeout(() => {
    $('.dataTables_filter .form-control').removeClass('form-control-sm');
    $('.dataTables_length .form-select').removeClass('form-select-sm');
  }, 300);
})();


// 퍼펙트 스크롤러
document.addEventListener('DOMContentLoaded', function () {
  (function () {
    const verticalExample = document.getElementById('vertical-example'),
      horizontalExample = document.getElementById('horizontal-example'),
      verticalSchedule = document.getElementById('vertical-schedule'),
      verticalOrgchart = document.getElementById('vertical-orgchart'), 
      communityScrolls = document.querySelectorAll('.community-scroll'),
      horizVertExample = document.getElementById('both-scrollbars-example');

    // vertical-schedule
    // --------------------------------------------------------------------
    if (verticalSchedule) {
      new PerfectScrollbar(verticalSchedule, {
        wheelPropagation: false
      });
    }
    // vertical-orgchart
    // --------------------------------------------------------------------
    if (verticalOrgchart) {
      new PerfectScrollbar(verticalOrgchart, {
        wheelPropagation: false
      });
    }

    // Vertical Example
    // --------------------------------------------------------------------
    if (verticalExample) {
      new PerfectScrollbar(verticalExample, {
        wheelPropagation: false
      });
    }

    // Horizontal Example
    // --------------------------------------------------------------------
    if (horizontalExample) {
      new PerfectScrollbar(horizontalExample, {
        wheelPropagation: false,
        suppressScrollY: true
      });
    }

    // Both vertical and Horizontal Example
    // --------------------------------------------------------------------
    if (horizVertExample) {
      new PerfectScrollbar(horizVertExample, {
        wheelPropagation: false
      });
    }

    // community-scroll
    communityScrolls.forEach(function(communityScroll) {
      new PerfectScrollbar(communityScroll, {
        wheelPropagation: false
      });
    });
  })();
});