<%@ page contentType="text/html; charset=EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>���� �����ȸ</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<!-- CDN(Content Delivery Network) ȣ��Ʈ ��� -->
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="../javascript/calendar.js">
</script>

<script type="text/javascript">
	function fncGetPurchaseList(currentPage) {
		//if (document.detailForm.beginDate.value == "" && document.detailForm.endDate.value != "") {
			//alert("�Ⱓ�� ��ȸ�� ���� ��¥�� �����ؾ��մϴ�.");
			//return false;
		//}
		//document.getElementById("currentPage").value = currentPage;
		//document.detailForm.submit();
		
		if ($("input[name='beginDate']").val() == "" && $("input[name='beginDate']").val() != "") {
			alert("�Ⱓ�� ��ȸ�� ���� ��¥�� �����ؾ��մϴ�.");
			return false;
		}
		
		$("input[name='currentPage']").val(currentPage);
		
		$("form").attr("method", "post").attr("action", "/purchase/listPurchase").submit();
	}
	
	$(function() {
		$( ".ct_btn01:contains('��ȸ')" ).on("click" , function() {
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

<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
<form name="detailForm" action="/purchase/listPurchase" method="post">
////////////////////////////////////////////////////////////////////////////////////////////////// -->
<form>
<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">���� �����ȸ</td>
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
					<td><strong>�Ⱓ�� ��ȸ </strong></td>
					<td width="150" class="ct_write01">
						<input 	type="text" readonly="readonly" name="beginDate" class="ct_input_g" 
										style="width: 100px; height: 19px" maxLength="20" value="${ !empty beginDate ? beginDate : ''}"/>
						<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
						<img 	src="../images/ct_icon_date.gif" width="15" height="15"	
									onclick="show_calendar('document.detailForm.beginDate', document.detailForm.beginDate.value)"/>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						&nbsp;<img src="../images/ct_icon_date.gif" width="15" height="15" />
					</td>
					<td width="20"><strong> ~ </strong></td>
					<td width="150" class="ct_write01">
						<input 	type="text" readonly="readonly" name="endDate" class="ct_input_g" 
										style="width: 100px; height: 19px;" maxLength="20" value="${ !empty endDate ? endDate : ''}"/>
						<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
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
						<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
						<a href="javascript:fncGetPurchaseList('1');">��ȸ</a>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
						��ȸ
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
			��ü  ${ resultPage.totalCount } �Ǽ�,	���� ${ resultPage.currentPage } ������
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ��</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="300">��������</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">����ּ�</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����Ȳ</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">��������</td>
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
			<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
			<a href="/purchase/getProduct?menu=search&prodNo=${ purchase.purchaseProd.prodNo }">${ purchase.purchaseProd.prodName }</a>
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
			${ purchase.purchaseProd.prodName }
		</td>
		<td></td>
		<td align="left">
			${ purchase.orderDate }
			<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
			<a href="/purchase/getPurchase?tranNo=${ purchase.tranNo }" style="margin:30px">���Ż���ȸ</a>
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
			���Ż���ȸ
		</td>
		<td></td>
		<td align="left">${ purchase.divyAddr }</td>
		<td></td>
		<td align="left">
			����
			<c:choose>
				<c:when test="${ !empty purchase.tranCode && purchase.tranCode.equals('2') }">
					���ſϷ�
				</c:when>
				<c:when test="${ !empty purchase.tranCode && purchase.tranCode.equals('3') }">
					�����
				</c:when>
				<c:when test="${ !empty purchase.tranCode && purchase.tranCode.equals('4') }">
					��ۿϷ�
				</c:when>
			</c:choose>
			���� �Դϴ�.		
		</td>
		<td></td>
		<td align="left">
			<%--����� ���¸� ����, ����ڰ� ��ۿϷ�Ǹ� �����Բ�
			���� �����ϸ� ���������� �ƹ��͵� ����, ������ ����� ��� ��ۿϷ�� �ٲ� --%>
			<c:if test="${ !empty purchase.tranCode && purchase.tranCode.equals('3') }">
				<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
				<a href="/purchase/updateTranCode?tranNo=${ purchase.tranNo }&tranCode=${ purchase.tranCode }&currentPage=${resultPage.currentPage}">���ǵ���</a>
				////////////////////////////////////////////////////////////////////////////////////////////////// -->
				���ǵ���
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

<!--  ������ Navigator �� -->
</form>

</div>

</body>
</html>