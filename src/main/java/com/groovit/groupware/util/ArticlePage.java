package com.groovit.groupware.util;

import java.util.List;
import java.util.Map;

//페이징 관련 정보 + 게시글 정보
public class ArticlePage<T> {
	//전체글 수
		private int total;
		// 현재 페이지 번호
		private int currentPage;
		// 전체 페이지수
		private int totalPages;
		// 블록의 시작 페이지 번호
		private int startPage;
		//블록의 종료 페이지 번호
		private int endPage;
		//검색어
		private String keyword = "";
		//요청URL
		private String url = "";
		//select 결과 데이터
		private List<T> content;
		//페이징 처리
		private String pagingArea = "";

		private Map<String,Object> map;
		
		private String pagingArea2 = "";
		
		
		


		public ArticlePage(int total, int currentPage, int size, List<T> content) {
			// size : 한 화면에 보여질 목록의 행 수
			this.total = total;
			this.currentPage = currentPage;
			this.content = content;

			// 전체글 수가 0이면?
			if (total == 0) {
				totalPages = 0; // 전체 페이지 수
				startPage = 0; // 블록 시작번호
				endPage = 0; // 블록 종료번호
			} else {// 글이 있다면
				// 전체글 수 / 한 화면에 보여질 목록의 행 수 => 전체 페이지 수
				totalPages = total / size;

				// 전체글 수 % 한 화면에 보여질 목록의 행 수
				// => 0이아니면. 나머지가 있다면, 페이지 1증가
				if (total % size > 0) {
					totalPages++;
				}

				//페이지 블록  시작페이지를 구하는 공식!
				// 시작페이지 = 현재페이지 / 페이지크기 * 페이지크기 + 1
				startPage = currentPage / 5 * 5 + 1;

				// 현재페이지 % 페이지크기 => 0일 때 보정
				if (currentPage % 5 == 0) {
					// 페이지크기를 빼줌
					startPage -= 5;
				}

				// 종료페이지번호 = 시작페이지번호 + (페이지크기-1)
				endPage = startPage + 4;

				// 종료페이지번호 > 전체페이지수보다 클 때
				if (endPage > totalPages) {
					endPage = totalPages;
				}
			}
		}//end 생성자





		//생성자(Constructor) : 페이징 정보를 생성
		//               753            1            10         select결과10행
		public ArticlePage(int total, int currentPage, int size, List<T> content, String keyword) {
		   //size : 한 화면에 보여질 목록의 행 수
		   this.total = total;//753
		   this.currentPage = currentPage;//1
		   this.content = content;
		   this.keyword = keyword;

		   //전체글 수가 0이면?
		   if(total==0) {
		      totalPages = 0;//전체 페이지 수
		      startPage = 0;//블록 시작번호
		      endPage = 0; //블록 종료번호
		   }else {//글이 있다면
		      //전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
		      //3 = 31 / 10
		      totalPages = total / size;//75

		      //나머지가 있다면, 페이지를 1 증가
		      if(total % size > 0) {//나머지3
		         totalPages++;//76
		      }

		      //페이지 블록 시작번호를 구하는 공식
		      // 블록시작번호 = 현재페이지 / 페이지크기 * 페이지크기 + 1
		      startPage = currentPage / 5 * 5 + 1;//1

		      //현재페이지 % 페이지크기 => 0일 때 보정
		      if(currentPage % 5 == 0) {
		         startPage -= 5;
		      }

		      //블록종료번호 = 시작페이지번호 + (페이지크기 - 1)
		      //[1][2][3][4][5][다음]
		      endPage = startPage + (5 - 1);//5

		      //종료페이지번호 > 전체페이지수
		      if(endPage > totalPages) {
		         endPage = totalPages;
		      }
		   }

		   pagingArea += "<div class='col-sm-12 col-md-7'>";
		   pagingArea += "<div class='dataTables_paginate paging_simple_numbers' id='example2_paginate'>";
		   pagingArea += "<ul class='pagination'>";
		   pagingArea += "<li class='paginate_button page-item previous ";
		   if(this.startPage<6) {
		      pagingArea += "disabled ";
		   }
		   pagingArea += "'";
		   pagingArea += "id='example2_previous'>";
		   pagingArea += "<a href='"+this.url+"?currentPage="+(this.startPage-5)+"&keyword="+this.keyword+"' aria-controls='example2' data-dt-idx='0' tabindex='0' ";
		   pagingArea += "class='page-link'>Previous</a></li>";

		   for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
		   pagingArea += "<li class='paginate_button page-item ";
		      if(this.currentPage == pNo) {
		         pagingArea += "active";
		      }
		      pagingArea += "'>";
		      pagingArea += "<a href='"+this.url+"?currentPage="+pNo+"&keyword="+this.keyword+"' aria-controls='example2' data-dt-idx='1' tabindex='0' ";
		      pagingArea += "class='page-link'>"+pNo+"</a>";
		      pagingArea += "</li>";
		   }
		   pagingArea += "<li class='paginate_button page-item next ";
		   if(this.endPage>=this.totalPages) {
		      pagingArea += "disabled";
		   }
		   pagingArea += "' id='example2_next'><a ";
		   pagingArea += "href='"+this.url+"?currentPage="+(this.startPage+5)+"&keyword="+this.keyword+"' aria-controls='example2' data-dt-idx='7' ";
		   pagingArea += "tabindex='0' class='page-link'>Next</a></li>";
		   pagingArea += "</ul>";
		   pagingArea += "</div>";
		   pagingArea += "</div>";
		}//end 생성자

		//비동기 방식의 페이징
		//map =>
		//{"keyword": "","currentPage": 1,"deptUpCd": "X001","deptCd": "D005"}
		//or
		//{"keyword": "","currentPage": 1,"jbgdCd": "J006"}
		//생성자(Constructor) : 페이징 정보를 생성
		//               753            1            10         select결과10행
		public ArticlePage(int total, int currentPage, int size, List<T> content, String keyword, Map<String,Object> map) {
			//size : 한 화면에 보여질 목록의 행 수
			this.total = total;//753
			this.currentPage = currentPage;//1
			this.content = content;
			this.keyword = keyword;

			//전체글 수가 0이면?
			if(total==0) {
				totalPages = 0;//전체 페이지 수
				startPage = 0;//블록 시작번호
				endPage = 0; //블록 종료번호
			}else {//글이 있다면
				//전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
				//3 = 31 / 10
				totalPages = total / size;//75

				//나머지가 있다면, 페이지를 1 증가
				if(total % size > 0) {//나머지3
					totalPages++;//76
				}

				//페이지 블록 시작번호를 구하는 공식
				// 블록시작번호 = 현재페이지 / 페이지크기 * 페이지크기 + 1
				startPage = currentPage / 5 * 5 + 1;//1

				//현재페이지 % 페이지크기 => 0일 때 보정
				if(currentPage % 5 == 0) {
					startPage -= 5;
				}

				//블록종료번호 = 시작페이지번호 + (페이지크기 - 1)
				//[1][2][3][4][5][다음]
				endPage = startPage + (5 - 1);//5

				//종료페이지번호 > 전체페이지수
				if(endPage > totalPages) {
					endPage = totalPages;
				}
			}

			this.map = map;

			String deptUpCd = "";
			String deptCd = "";
			String jbgdCd = "";

			if(map.get("deptUpCd")!=null) {
				deptUpCd = map.get("deptUpCd").toString();
			}
			if(map.get("deptCd")!=null) {
				deptCd = map.get("deptCd").toString();
			}
			if(map.get("jbgdCd")!=null) {
				jbgdCd = map.get("jbgdCd").toString();
			}

			pagingArea += "<div class='col-sm-12 col-md-7'>";
			pagingArea += "<div class='dataTables_paginate paging_simple_numbers' id='example2_paginate'>";
			pagingArea += "<ul class='pagination'>";
			pagingArea += "<li class='paginate_button page-item previous ";
			if(this.startPage<6) {
				pagingArea += "disabled ";
			}
			pagingArea += "'";
			pagingArea += "id='example2_previous'>";
			pagingArea += "<a href='#' onclick=\"ajaxPaging('"+this.keyword+"', "+(this.startPage-5)+", '"+deptUpCd+"', '"+deptCd+"', '"+jbgdCd+"')\" aria-controls='example2' data-dt-idx='0' tabindex='0' ";
			pagingArea += "class='page-link'>Previous</a></li>";

			for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
				pagingArea += "<li class='paginate_button page-item ";
				if(this.currentPage == pNo) {
					pagingArea += "active";
				}
				pagingArea += "'>";
				pagingArea += "<a href='#' onclick=\"ajaxPaging('"+this.keyword+"', "+pNo+", '"+deptUpCd+"', '"+deptCd+"', '"+jbgdCd+"')\" aria-controls='example2' data-dt-idx='1' tabindex='0' ";
				pagingArea += "class='page-link'>"+pNo+"</a>";
				pagingArea += "</li>";
			}
			pagingArea += "<li class='paginate_button page-item next ";
			if(this.endPage>=this.totalPages) {
				pagingArea += "disabled";
			}
			pagingArea += "' id='example2_next'><a ";
			pagingArea += "href='#' onclick=\"ajaxPaging('"+this.keyword+"', "+(this.startPage+5)+", '"+deptUpCd+"', '"+deptCd+"', '"+jbgdCd+"')\" aria-controls='example2' data-dt-idx='7' ";
			pagingArea += "tabindex='0' class='page-link'>Next</a></li>";
			pagingArea += "</ul>";
			pagingArea += "</div>";
			pagingArea += "</div>";
			
			String tabId = "";

			if(map.get("stts")!=null) {
				tabId = map.get("stts").toString();
			}
			

			pagingArea2 +="<nav aria-label='Page navigation' class='d-flex align-items-center justify-content-center'>";
			pagingArea2 +="<ul class='pagination'>";
			pagingArea2 +="<li class='page-item prev ";
			if(this.startPage<6) {
				pagingArea2 += "disabled";
			}
			pagingArea2 +="'>";
			pagingArea2 +="<a class='page-link' href='javascript:void(0);' onclick='ajaxPaging(\"" +(this.startPage-5) + "\"," + this.keyword + "\"," + tabId + ")'>";
			pagingArea2 +="<i class='ti ti-chevron-left ti-xs scaleX-n1-rtl'></i></a></li>";

			for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
				pagingArea2 +="<li class='page-item ";
					if(this.currentPage==pNo) {
						pagingArea2 +="active";
					}
				pagingArea2 +="'>";
				pagingArea2 +="<a class='page-link' href='javascript:void(0);' onclick='ajaxPaging(" + pNo + ", \"" + this.keyword + "\", \"" + tabId + "\")'>";
				pagingArea2 +=pNo+"</a></li>";
			}
			pagingArea2 +="<li class='page-item next'";
				if(this.endPage>=this.totalPages) {
					pagingArea2 +="disabled";
				}
			pagingArea2 +="><a class='page-link' href='javascript:void(0);'>";
			pagingArea2 +="<i class='ti ti-chevron-right ti-xs scaleX-n1-rtl'></i></a>";
			pagingArea2 +="</li></ul></nav>";
		}//end 생성자

		public int getTotal() {
		      return total;
		   }

		   public void setTotal(int total) {
		      this.total = total;
		   }

		   public int getCurrentPage() {
		      return currentPage;
		   }

		   public void setCurrentPage(int currentPage) {
		      this.currentPage = currentPage;
		   }

		   public int getTotalPages() {
		      return totalPages;
		   }

		   public void setTotalPages(int totalPages) {
		      this.totalPages = totalPages;
		   }

		   public int getStartPage() {
		      return startPage;
		   }

		   public void setStartPage(int startPage) {
		      this.startPage = startPage;
		   }

		   public int getEndPage() {
		      return endPage;
		   }

		   public void setEndPage(int endPage) {
		      this.endPage = endPage;
		   }

		   public String getKeyword() {
		      return keyword;
		   }

		   public void setKeyword(String keyword) {
		      this.keyword = keyword;
		   }

		   public String getUrl() {
		      return url;
		   }

		   public void setUrl(String url) {
		      this.url = url;
		   }

		   public List<T> getContent() {
		      return content;
		   }

		   public void setContent(List<T> content) {
		      this.content = content;
		   }

		   // 전체 글의 수가 0인가?
		   public boolean hasNoArticles() {
		      return this.total == 0;
		   }

		   // 데이터가 있나?
		   public boolean hasArticles() {
		      return this.total > 0;
		   }

		   public void setPagingArea(String pagingArea) {
		      this.pagingArea = pagingArea;
		   }

		   // 페이징 블록을 자동화
		   public String getPagingArea() {
		      return this.pagingArea;
		   }

		   public Map<String, Object> getMap() {
			   return map;
		   }

		   public void setMap(Map<String, Object> map) {
			   this.map = map;
		   }

		   // 페이징 블록을 자동화2
		   public String getPagingAreaTab() {
			   return this.pagingArea2;
		   }
		 








		 //페이징 블록을 자동화
			public String getPagingArea3() {
				String pagingArea = "";

				pagingArea +="<div class='col-sm-12 col-md-7'>";
				pagingArea +="<div class='dataTables_paginate paging_simple_numbers' id='dataTable_paginate'>";
				pagingArea +="<ul class='pagination'>";
				pagingArea +="<li class='paginate_button page-item previous ";
				if(this.startPage<6) {
					pagingArea += "disabled";
				}
				pagingArea +="' id='dataTable_previous'>";
				pagingArea +="<a href='"+this.url+"?keyword="+this.keyword+"&currentPage="+(this.startPage-5)+"'";
				pagingArea +="aria-controls='dataTable' data-dt-idx='0' tabindex='0'";
				pagingArea +="class='page-link'>Previous</a></li>";

				for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
					pagingArea +="<li class='paginate_button page-item ";
						if(this.currentPage==pNo) {
							pagingArea +="active";
						}
					pagingArea +="'>";
					pagingArea +="<a href='"+this.url+"?keyword="+this.keyword+"&currentPage="+pNo+"' ";
					pagingArea +="aria-controls='dataTable' data-dt-idx='1' tabindex='0' ";
					pagingArea +="class='page-link'>"+pNo+"</a></li>";
				}
				pagingArea +="<li class='paginate_button page-item next ";
					if(this.endPage>=this.totalPages) {
						pagingArea +="disabled";
					}
				pagingArea +="' id='dataTable_next'><a href='"+this.url+"?keyword="+this.keyword+"&currentPage="+(this.startPage+5)+"' ";
				pagingArea +="aria-controls='dataTable' data-dt-idx='7' tabindex='0' ";
				pagingArea +="class='page-link'>Next</a></li></ul></div></div>";

				return pagingArea;
			}

			public String getPagingArea2() {
				String pagingArea = "";

				pagingArea +="<nav aria-label='Page navigation' class='d-flex align-items-center justify-content-center'>";
				pagingArea +="<ul class='pagination'>";
				pagingArea +="<li class='page-item prev ";
				if(this.startPage<6) {
					pagingArea += "disabled";
				}
				pagingArea +="'>";
				pagingArea +="<a class='page-link' href='javascript:void(0);' onclick='getList(\"" + (this.startPage-5) + "\"," + this.keyword + ")'>";
				pagingArea +="<i class='ti ti-chevron-left ti-xs scaleX-n1-rtl'></i></a></li>";

				for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
					pagingArea +="<li class='page-item ";
						if(this.currentPage==pNo) {
							pagingArea +="active";
						}
					pagingArea +="'>";
					pagingArea +="<a class='page-link' href='javascript:void(0);' onclick='getList(\"" + pNo + "\"," + this.keyword + ")'>";
					pagingArea +=pNo+"</a></li>";
				}
				pagingArea +="<li class='page-item next'";
					if(this.endPage>=this.totalPages) {
						pagingArea +="disabled";
					}
				pagingArea +="><a class='page-link' href='javascript:void(0);'>";
				pagingArea +="<i class='ti ti-chevron-right ti-xs scaleX-n1-rtl'></i></a>";
				pagingArea +="</li></ul></nav>";

				return pagingArea;
			}

			public String getPagingArea4() {
				String pagingArea = "";

				pagingArea +="<nav aria-label='Page navigation' class='d-flex align-items-center justify-content-center'>";
				pagingArea +="<ul class='pagination'>";
				pagingArea +="<li class='page-item prev ";
				if(this.startPage<6) {
					pagingArea += "disabled";
				}
				pagingArea +="'>";
				pagingArea +="<a class='page-link' href='javascript:void(0);' onclick='getList(" + (this.startPage-5) + ")'>";
				pagingArea +="<i class='ti ti-chevron-left ti-xs scaleX-n1-rtl'></i></a></li>";

				for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
					pagingArea +="<li class='page-item ";
					if(this.currentPage==pNo) {
						pagingArea +="active";
					}
					pagingArea +="'>";
					pagingArea +="<a class='page-link' href='javascript:void(0);' onclick='getList(" + pNo + ")'>";
					pagingArea +=pNo+"</a></li>";
				}
				pagingArea +="<li class='page-item next'";
				if(this.endPage>=this.totalPages) {
					pagingArea +="disabled";
				}
				pagingArea +="><a class='page-link' href='javascript:void(0);'>";
				pagingArea +="<i class='ti ti-chevron-right ti-xs scaleX-n1-rtl'></i></a>";
				pagingArea +="</li></ul></nav>";

				return pagingArea;
			}
}






