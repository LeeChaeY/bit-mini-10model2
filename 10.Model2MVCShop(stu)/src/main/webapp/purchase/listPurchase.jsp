<%@ page contentType="text/html; charset=EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<!-- CDN(Content Delivery Network) 호스트 사용 -->
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="../javascript/calendar.js">
</script>

<script type="text/javascript">
	function fncGetPurchaseList(currentPage) {
		//if (document.detailForm.beginDate.value == "" && document.detailForm.endDate.value != "") {
			//alert("기간별 조회는 시작 날짜를 기입해야합니다.");
			//return false;
		//}
		//document.getElementById("currentPage").value = currentPage;
		//document.detailForm.submit();
		
		if ($("input[name='beginDate']").val() == "" && $("input[name='beginDate']").val() != "") {
			alert("기간별 조회는 시작 날짜를 기입해야합니다.");
			return false;
		}
		
		$("input[name='currentPage']").val(currentPage);
		
		$("form").attr("method", "post").attr("action", "/purchase/listPurchase").submit();
	}
	
	$(function() {
		$( ".ct_btn01:contains('조회')" ).on("click" , function() {
			fncGetPurchaseList('1');
		});
		
		$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			let j = Math.floor($(this).parent().index()/2)-1;
			let prodNo = $(".purchaseObject").eq(3*j+1).val();
			self.location = "/product/getProduct?menu=search&prodNo="+prodNo+"";
		});

		$( ".ct_list_pop td:nth-child(5)" ).on("click" , function() {
			let j = Math.floor($(this).parent().index()/2)-1;
			let tranNo = $(".purchaseObject").eq(3*j).val();
			self.location = "/purchase/getPurchase?tranNo="+tranNo+"";
		});
		
		$( ".ct_list_pop td:nth-child(11)" ).on("click" , function() {
			let j = Math.floor($(this).parent().index()/2)-1;
			let tranNo = $(".purchaseObject").eq(3*j).val();
			let tranCode = $(".purchaseObject").eq(3*j+2).val();
			//self.location = "/purchase/updateTranCode?tranNo="+tranNo+"&tranCode="+tranCode+"&currentPage=${resultPage.currentPage}";
			
			let url = "/purchase/json/updateTranCode?tranNo="+tranNo+"&tranCode="+tranCode+"&currentPage=${resultPage.currentPage}";
			
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
							
							$(".ct_list_pop td:nth-child(11)").eq(j).text("");
						},
						error : function(status) {

							//Debug...
							alert("error");
						}
				});
		});

		$( "img[src='../images/ct_icon_date.gif']" ).on("click" , function() {
			alert();
			if ($(this).parent() == $("td.ct_write01").eq(0)) {
				show_calendar('document.forms[0].beginDate', $("td[name='beginDate']").val());
			} else if ($(this).parent() == $("td.ct_write01").eq(1)) {
				show_calendar('document.forms[0].endDate', $("td[name='endDate']").val());
			}
		});
	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
<form name="detailForm" action="/purchase/listPurchase" method="post">
////////////////////////////////////////////////////////////////////////////////////////////////// -->
<form>
<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right" width="450">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><strong>기간별 조회 </strong></td>
					<td width="150" class="ct_write01">
						<input 	type="text" readonly="readonly" name="beginDate" class="ct_input_g" 
										style="width: 100px; height: 19px" maxLength="20" value="${ !empty beginDate ? beginDate : ''}"/>
						<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
						<img 	src="../images/ct_icon_date.gif" width="15" height="15"	
									onclick="show_calendar('document.detailForm.beginDate', document.detailForm.beginDate.value)"/>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						&nbsp;<img src="../images/ct_icon_date.gif" width="15" height="15" />
					</td>
					<td width="20"><strong> ~ </strong></td>
					<td width="150" class="ct_write01">
						<input 	type="text" readonly="readonly" name="endDate" class="ct_input_g" 
										style="width: 100px; height: 19px;" maxLength="20" value="${ !empty endDate ? endDate : ''}"/>
						<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
						<img 	src="../images/ct_icon_date.gif" width="15" height="15"	
									onclick="show_calendar('document.detailForm.endDate', document.detailForm.endDate.value)"/>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						&nbsp;<img src="../images/ct_icon_date.gif" width="15" height="15" />
					</td>
					<tr>
			</table>
		</td>
		
		<td align="right" width="10">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
						<a href="javascript:fncGetPurchaseList('1');">조회</a>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						조회
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">
			전체  ${ resultPage.totalCount } 건수,	현재 ${ resultPage.currentPage } 페이지
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="300">구매일자</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송주소</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<c:set var="i" value="0"/>
	<c:forEach var="purchase" items="${ list }">
	<c:set var="i" value="${i+1}"/>
	<tr class="ct_list_pop">
		<td align="center">
			${ i }
		</td>
		<td></td>
		<td align="left">
		<input class="purchaseObject" style="display: none;" value="${purchase.tranNo}"/>
		<input class="purchaseObject" style="display: none;" value="${purchase.purchaseProd.prodNo}"/>
		<input class="purchaseObject" style="display: none;" value="${purchase.tranCode}"/>
			<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
			<a href="/purchase/getProduct?menu=search&prodNo=${ purchase.purchaseProd.prodNo }">${ purchase.purchaseProd.prodName }</a>
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
			${ purchase.purchaseProd.prodName }
		</td>
		<td></td>
		<td align="left">
			${ purchase.orderDate }
			<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
			<a href="/purchase/getPurchase?tranNo=${ purchase.tranNo }" style="margin:30px">구매상세조회</a>
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
			구매상세조회
		</td>
		<td></td>
		<td align="left">${ purchase.divyAddr }</td>
		<td></td>
		<td align="left">
			현재
			<c:choose>
				<c:when test="${ !empty purchase.tranCode && purchase.tranCode.equals('2') }">
					구매완료
				</c:when>
				<c:when test="${ !empty purchase.tranCode && purchase.tranCode.equals('3') }">
					배송중
				</c:when>
				<c:when test="${ !empty purchase.tranCode && purchase.tranCode.equals('4') }">
					배송완료
				</c:when>
			</c:choose>
			상태 입니다.		
		</td>
		<td></td>
		<td align="left">
			<%--배송중 상태면 보임, 사용자가 배송완료되면 누르게끔
			물건 도착하면 정보수정에 아무것도 없음, 관리자 사용자 모두 배송완료로 바뀜 --%>
			<c:if test="${ !empty purchase.tranCode && purchase.tranCode.equals('3') }">
				<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
				<a href="/purchase/updateTranCode?tranNo=${ purchase.tranNo }&tranCode=${ purchase.tranCode }&currentPage=${resultPage.currentPage}">물건도착</a>
				////////////////////////////////////////////////////////////////////////////////////////////////// -->
				물건도착
			</c:if>
		</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	</c:forEach>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr>
		<td align="center">
			<input type="hidden" name="currentPage" value=""/>
			<jsp:include page="../common/pageNavigator.jsp">
				<jsp:param name="type" value="Purchase"/>
			</jsp:include>	
		</td>
	</tr>
</table>

<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>