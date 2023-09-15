<%@ page contentType="text/html; charset=euc-kr" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>

<c:choose>
	<c:when test="${ !empty menu && menu.equals('manage') }">
		<c:set var="title" value="상품 관리"/>
	</c:when>
	<c:when test="${ !empty menu && menu.equals('search') }">
		<c:set var="title" value="목록조회"/>
	</c:when>
</c:choose>

<head>
	<title>${ title }</title>

	<link rel="stylesheet" href="/css/admin.css" type="text/css">
	
	<meta charset="utf-8">
	 <meta name="viewport" content="width=device-width, initial-scale=1">
	 <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	 <link rel="stylesheet" href="/resources/demos/style.css">
	 <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
	 <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
 
	<script type="text/javascript" src="../javascript/calendar.js">
	</script>

	<script type="text/javascript">
	
	function fncGetProductList(currentPage, p){
		p = typeof p != "undefined" ? p : 0;
		
		if (p) {
			let op = $("select[name='searchCondition'] option:selected").val();
			
			let beginPrice = $("input[name='beginPrice']");
			let endPrice = $("input[name='endPrice']");
	
			if(op == "2") {
				if (beginPrice.val() == "" || endPrice.val() == "") {
					alert("금액 범위를 기입해야합니다.");
					return false;
				} else if (beginPrice.val() != "" && endPrice.val() != "" && beginPrice.val() > endPrice.val()) {
					alert("금액 범위가 잘못되었습니다.");
					return false;
				}
			} else if (op == "1") {
				if ($("input[name='searchKeyword']").val() == "") {
					alert("키워드를 기입해야합니다.");
					return false;
				}
			} else {
				alert("검색 분야를 기입해야합니다.");
				return false;
			}
			
			if (op == "1") {
				beginPrice.val("");
				endPrice.val("");
				$("input[name='searchKeyword']").val($("input[name='searchKeyword']").val());
			} else if (op == "2") {
				$("input[name='searchKeyword']").val(beginPrice.val()+","+endPrice.val());
			}
		}
		
		$("input[name='currentPage']").val(currentPage);
		
		$("form").attr("method", "post").attr("action", "/product/listProduct").submit();
	}
	
	function fncPriceRange() {
		let op = $("select[name='searchCondition'] option:selected").val();
		
		if (op == "2") {
			$("td.tdPrice").css("display", "");
			$("input[name='searchKeyword']").css("display", "none");
		} else if (op == "0" || op == "1") {
			$("td.tdPrice").css("display", "none");
			$("input[name='searchKeyword']").css("display", "");
		}
	}
	
	function fncPriceOrder(currentPage) {
		let op = $("select[name='orderCondition'] option:selected").val();
		
		if (op == "1" || op == "2") {
			$("input[name='currentPage']").val(currentPage);
			
			$("input[name='searchKeyword']").val("${search.searchKeyword}");
			$("select[name='searchCondition']").val("${search.searchCondition}");
			$("input[name='beginPrice']").val("${beginPrice}");
			$("input[name='endPrice']").val("${endPrice}");
			$("form").attr("method", "post").attr("action", "/product/listProduct").submit();
		}
	}
	
	$(function() {
		if ($("select[name='searchCondition']").val() == "2") {
			$("td.tdPrice").css("display", "");
			$("input[name='searchKeyword']").css("display", "none");
		} else if ($("select[name='searchCondition']").val() == "1") {
			$("td.tdPrice").css("display", "none");
			$("input[name='searchKeyword']").css("display", "");
		}
		
		let list = {};
		$.ajax( 
				{
					url : "/product/json/getProdNameList",
					method : "GET",
					dataType : "json" ,
					headers : {
						"Accept" : "application/json",
						"Content-Type" : "application/json"
					},
					success : function(JSONData , status) {

						//Debug...
						//alert(status);
						//Debug...
						//alert("JSONData : \n"+JSONData);
						list = JSONData;
						$("input[name='searchKeyword']").autocomplete({
						      source: list
					    });
					},
					error : function(status) {

						//Debug...
						alert("error");
					}
			});
		
		
		$("select[name='searchCondition']").on("click", function () {
			fncPriceRange();
		})
		
		$(".ct_btn01:contains('검색')").on("click", function () {
			fncGetProductList('1', 1);
		})
		
		$("select[name='orderCondition']").on("change", function () {
			fncPriceOrder('1');
		})
		
		$(".ct_list_pop td:nth-child(3)").on("click", function () {
			let j = Math.floor($(this).parent().index()/2)-1;
			let prodNo = $(".productObject").eq(2*j).val();
			self.location = "/product/getProduct?prodNo="+prodNo+"&menu=${ menu }";
		})
		
		$(".ct_list_pop td:nth-child(9) input[type='button']").on("click", function () {
			let j = Math.floor($(this).parent().parent().index()/2)-1;
			let prodNo = $(".productObject").eq(2*j).val();
			let proTranCode = $(".productObject").eq(2*j+1).val();
			//alert($(".ct_list_pop td:nth-child(9)").eq(j).text());
			let url = "/purchase/json/updateTranCodeByProd?prodNo="+prodNo+"&tranCode="+proTranCode+"&currentPage=${resultPage.currentPage}";
			
			$.ajax( 
					{
						url : url,
						method : "GET" ,
						dataType : "json" ,
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						success : function(JSONData , status) {

							//Debug...
							//alert(status);
							//Debug...
							//alert("JSONData : \n"+JSONData);
							
							$(".ct_list_pop td:nth-child(9)").eq(j).text($(".ct_list_pop td:nth-child(9)").eq(j).text().trim());
						},
						error : function(status) {

							//Debug...
							alert("error");
						}
				});
			
			//self.location = "/purchase/updateTranCodeByProd?prodNo="+prodNo+"&tranCode=${list.get(i).proTranCode }&currentPage=${resultPage.currentPage}";
		})
		
		function loadMoreContent() {
		  // Ajax 요청을 보내서 추가 콘텐츠를 가져옴
		  $.ajax({
			    url: '/product/json/listProduct',
			    method: 'POST',
			    data: { "search":{"currentPage":"${resultPage.currentPage+1}"},
			    		"menu":"${menu}", 
			    		"beginPrice":"", 
			    		"endPrice":""}, 
			    success: function(response) {
			      // 서버에서 받은 데이터를 화면에 추가
			      $('table').eq(1).append(response);
			      nextPage++; // 다음 페이지를 로드하기 위한 페이지 번호 업데이트
		    	}
	 		 });
		}
		$(window).scroll(function() {
			  if ($(window).scrollTop() + $(window).height() >= $('table').eq(1).height()) {
			    // 스크롤이 페이지 하단에 도달하면 추가 콘텐츠를 로드
			    loadMoreContent();
			  }
		});
		
	});
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">
<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
<form name="detailForm" action="/product/listProduct?menu=${!empty menu ? menu : ''}" method="post">
////////////////////////////////////////////////////////////////////////////////////////////////// -->
<form>
<input type="hidden" name="menu" value="${!empty menu ? menu : ''}">
<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
						${ title }
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
			<select name="searchCondition" class="ct_input_g" onClick="javascript:fncPriceRange();"  style="width:80px">
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<option value="0" selected>검색</option>
				<option value="1" 
					${!empty search.searchCondition && search.searchCondition.equals("1") ? "selected" : ""}>
						상품명
				</option>
				<option value="2" 
					${!empty search.searchCondition && search.searchCondition.equals("2") ? "selected" : ""}>
						상품가격
				</option>
			</select>
			<input type="text" name="searchKeyword" 
							value="${!empty search.searchCondition && search.searchCondition.equals('1') ? search.searchKeyword : ''}" 
							class="ct_input_g" style="width:200px; height:19px" />
		</td>
		
		<td class="tdPrice" align="right" width="400" style="display:none">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="80"><strong> &nbsp금액별 검색 </strong></td>
					<td width="150" class="ct_write01">
						<input type="number" name="beginPrice" class="ct_input_g" 
										style="width: 100px; height: 19px" maxLength="20" value="${ !empty beginPrice ? beginPrice : ''}"/> 원
					</td>
					<td width="20"><strong> ~ </strong></td>
					<td width="150" class="ct_write01">
						<input type="number" name="endPrice" class="ct_input_g" 
										style="width: 100px; height: 19px;" maxLength="20" value="${ !empty endPrice ? endPrice : ''}"/> 원
					</td>
					<tr>
			</table>
		</td>
		
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
						<a href="javascript:fncGetProductList('1', 1);">검색</a>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
		
		<td align="right" width="150">
			<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
			<select name="orderCondition" class="ct_input_g" style="width:100px" onChange="javascript:fncPriceOrder('1');">
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
			<select name="orderCondition" class="ct_input_g" style="width:100px">
				<option value="0" selected>정렬</option>
				<option value="1" 
					${!empty search.orderCondition && search.orderCondition.equals("1") ? "selected" : ""}>
						가격낮은순
				</option>
				<option value="2" 
					${!empty search.orderCondition && search.orderCondition.equals("2") ? "selected" : ""}>
						가격높은순
				</option>
			</select>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >
			전체  ${ resultPage.totalCount } 건수,	현재 ${ resultPage.currentPage } 페이지
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<c:set var="i" value="0"></c:set>
	<c:forEach var="product" items="${ list }">
		<c:set var="i" value="${i+1}"/>
		<tr class="ct_list_pop">
			<td align="center">${ i }</td>
			<td></td>
			<td align="left">
			<input class="productObject" style="display: none;" value="${product.prodNo}"/>
			<input class="productObject" style="display: none;" value="${product.proTranCode}"/>
				<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
				<a href="/product/getProduct?prodNo=${ product.prodNo }&menu=${ menu }">${ product.prodName }</a>
				////////////////////////////////////////////////////////////////////////////////////////////////// -->
				${ product.prodName }
			</td>
			
			<td></td>
			<td align="left">${ product.price }</td>
			<td></td>
			<td align="left">${ product.regDate }</td>
			<td></td>
			
			<td align="left">
			<c:choose>
				<c:when test="${(empty user) || !empty user && !empty user.role && user.role.equals('user') }">
					${ empty product.proTranCode ? "판매중" : "재고 없음" }
					<%-- 재고 없음, 판매중
					구매에 물품 아이디가 없으면 판매중, 있으면 재고 없음 --%>			
				</c:when>
				<c:when test="${ !empty user.role && user.role.equals('admin') }">
					<%-- manage, search 상관없음 --%>
					<c:choose>
						<c:when test="${ empty product.proTranCode }">
							판매중
						</c:when>
						<c:when test="${ product.proTranCode.equals('2') }">
							판매완료
						</c:when>
						<c:when test="${ product.proTranCode.equals('3') }">
							배송중
						</c:when>
						<c:when test="${ product.proTranCode.equals('4') }">
							배송완료
						</c:when>
					</c:choose>
					<c:if test="${ menu.equals('manage') &&  !empty product.proTranCode && product.proTranCode.equals('2') }">
						<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
						<a href="/purchase/updateTranCodeByProd?prodNo=${ product.prodNo }&tranCode=${product.proTranCode }&currentPage=${resultPage.currentPage}">배송하기</a>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						<input type="button" value="배송하기"/>
					</c:if>
					<%-- <a href="/purchase/updateTranCodeByProd?prodNo=10001&tranCode=2">배송하기</a>
					관리자에게만 보이는 것, 상품 관리에는 있음, 상품 검색에는 없음 
					배송하기 누르면 배송중으로 변경, 상품관리 페이지로 다시 리로드
					배송하기 버튼이 있는 구매 완료일때 tranCode 2로 넘겨줌--%>
				</c:when>
			</c:choose>
			</td>
		</tr>
		<tr>
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>	
	</c:forEach>
</table>
<!-- 
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
			<input type="hidden" name="currentPage" value=""/>
			<jsp:include page="../common/pageNavigator.jsp">	
				<jsp:param name="type" value="Product"/>
			</jsp:include>
		</td>
	</tr>
</table>
 -->
<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>
