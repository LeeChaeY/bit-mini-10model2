<%@ page contentType="text/html; charset=EUC-KR"%>

<html>
<head>
<title>��ǰ ���� ��ȸ</title>

<!-- CDN(Content Delivery Network) ȣ��Ʈ ��� -->
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>

<script type="text/javascript">
$(function() {
	
	$( "td.ct_btn01:contains('Ȯ��')" ).on("click" , function() {
		 	self.location = "/product/listProduct?menu=manage";
	});
	 
	$( "td.ct_btn01:contains('�߰����')" ).on("click" , function() {
		 self.location = "/product/addProduct";
	});
	 
});
</script>

</head>

<body>

<!-- ////////////////// jQuery Event ó���� ����� ///////////////////////// 
<form name="updatePurchase" action="/purchase/updatePurchase" method="post">
////////////////////////////////////////////////////////////////////////////////////////////////// -->
<form>

	������ ���� ���Ű� �Ǿ����ϴ�.
	
	<table border=1>
		<tr>
			<td>��ǰ��ȣ</td>
			<td>${ purchase.purchaseProd.prodNo }</td>
			<td></td>
		</tr>
		<tr>
			<td>�����ھ��̵�</td>
			<td>${ purchase.buyer.userId }</td>
			<td></td>
		</tr>
		<tr>
			<td>���Ź��</td>
			<td>${ purchase.paymentOption }</td>
			<td></td>
		</tr>
		<tr>
			<td>�������̸�</td>
			<td>${ purchase.receiverName }</td>
			<td></td>
		</tr>
		<tr>
			<td>�����ڿ���ó</td>
			<td>${ purchase.receiverPhone }</td>
			<td></td>
		</tr>
		<tr>
			<td>�������ּ�</td>
			<td>${ purchase.divyAddr }</td>
			<td></td>
		</tr>
			<tr>
			<td>���ſ�û����</td>
			<td>${ purchase.divyRequest }</td>
			<td></td>
		</tr>
		<tr>
			<td>����������</td>
			<td>${ purchase.divyDate }</td>
			<td></td>
		</tr>
	</table>
</form>

</body>
</html>