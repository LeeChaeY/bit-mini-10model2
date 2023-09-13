<%@ page contentType="text/html; charset=EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<!-- CDN(Content Delivery Network) 호스트 사용 -->
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
		
		//==> 추가된부분 : "수정" "확인"  Event 연결 및 처리
		 $(function() {
			$( "td.ct_btn01:contains('확인')" ).on("click" , function() {
				self.location = "/product/listProduct?menu=manage";
			});
			
			$( "td.ct_btn01:contains('구매')" ).on("click" , function() {
				if (${user == null}) {
					alert('로그인을 해주세요.');
					self.location = "/user/login";
				} else {
					self.location = "/purchase/addPurchase?prodNo=${ product.prodNo }";
				}
			});
			 
			$( "td.ct_btn01:contains('이전')" ).on("click" , function() {
				history.go(-1);
			});
		});
		
</script>

<title>상품상세조회</title>
</head>

<body bgcolor="#ffffff" text="#000000">

<form name="detailForm" method="post">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"	width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">상품상세조회</td>
					<td width="20%" align="right">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif"  width="12" height="37"/>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 13px;">
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			상품번호 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="105">${ product.prodNo }</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			상품명 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">${ product.prodName }</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			상품이미지 <img 	src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">
			<table>
			<tr>
			<c:forEach var="image" items="${ product.imgList }">
				<td>
					<img width="300px" height="300px" src="/images/uploadFiles/${image.fileName}">
					<input type="hidden" name="imgId" value="${ image.imgId }">
				</td>
			</c:forEach>
			</tr>
			</table>
			
		</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			상품상세정보 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">${ product.prodDetail }</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">제조일자</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">${ product.manuDate }</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">가격</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">${ product.price }</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">등록일자</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">${ product.regDate }</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td width="53%"></td>
		<td align="right">

		<table border="0" cellspacing="0" cellpadding="0">
			<tr>			
					<c:choose>
						<c:when test="${ !empty menu && menu.equals('manage') }">
							<td width="17" height="23">
								<img src="/images/ct_btnbg01.gif" width="17" height="23"/>
							</td>
							<td background="/images/ct_btnbg02.gif" class="ct_btn01"	style="padding-top: 3px;">
								<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
								<a href="/product/listProduct?menu=manage">확인</a>
								////////////////////////////////////////////////////////////////////////////////////////////////// -->
								확인
							</td>
							<td width="14" height="23">
								<img src="/images/ct_btnbg03.gif" width="14" height="23">
							</td>
						</c:when>
						<c:when test="${empty user || !empty user && user.role.equals('user') && empty product.proTranCode}">
							<td width="17" height="23">
								<img src="/images/ct_btnbg01.gif" width="17" height="23"/>
							</td>
							<td background="/images/ct_btnbg02.gif" class="ct_btn01"	style="padding-top: 3px;">
								<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
								<a href="/purchase/addPurchase?prodNo=${ product.prodNo }">구매</a>  <a href="/user/login" onClick="alert('로그인을 해주세요.');">구매</a>
								////////////////////////////////////////////////////////////////////////////////////////////////// -->
								구매
							</td>
							<td width="14" height="23">
								<img src="/images/ct_btnbg03.gif" width="14" height="23">
							</td>
						</c:when>
					</c:choose>
				
				<td width="30"></td>
				<td width="17" height="23">
					<img src="/images/ct_btnbg01.gif" width="17" height="23"/>
				</td>
				<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top: 3px;">
					<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
					<a href="javascript:history.go(-1)">이전</a>  
					////////////////////////////////////////////////////////////////////////////////////////////////// -->
					이전
				</td>
				<td width="14" height="23">
					<img src="/images/ct_btnbg03.gif" width="14" height="23">
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td align="center">
			<h3>
				<c:choose>
					<c:when test="${ empty product.proTranCode }">
						해당 상품은 판매중입니다.
					</c:when>
					<c:when test="${ !empty user && user.role.equals('admin') && menu.equals('manage') && !empty product.proTranCode }">
						해당 상품은 판매 완료되었습니다. 수정이 불가능합니다.
					</c:when>
					<c:when test="${ !empty user && user.role.equals('admin') && !empty product.proTranCode && product.proTranCode.equals('2') }">
						해당 상품은 판매 완료되었습니다.
					</c:when>
					<c:when test="${!empty user && user.role.equals('admin') && !empty product.proTranCode && product.proTranCode.equals('3') }">
						해당 상품은 배송중입니다.
					</c:when>
					<c:when test="${ !empty user && user.role.equals('admin') && !empty product.proTranCode && product.proTranCode.equals('4') }">
						해당 상품은 배송 완료되었습니다.
					</c:when>
					<c:when test="${ !empty product.proTranCode }">
						해당 상품은 품절되었습니다.
					</c:when>
				</c:choose>
			</h3>
		</td>
	</tr>
</table>
</form>

</body>
</html>