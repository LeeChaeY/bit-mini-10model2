<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.net.URLEncoder" %>

<html>
<head>

<title>��� ��ǰ ����</title>
<script type="text/javascript">

function fncDeleteCookieprodNoo() {
	request.setCharacterEncoding("euc-kr");
	response.setCharacterEncoding("euc-kr");
	String history = null;
	Cookie[] cookies = request.getCookies();
	if (cookies!=null && cookies.length > 0) {
		for (int i = 0; i < cookies.length; i++) {
			Cookie cookie = cookies[i];
			if (cookie.getName().equals("history")) {
				history = cookie.getValue();
			}
		}
		if (history != null) {
			String[] h = history.split(URLEncoder.encode(","));
			for (int i = h.length-1; i >= 0; i--) {
				if (h[i].equals(prodNo)) {
			        c[i].setMaxAge(0); // ��ȿ�ð��� 0���� ����
			        response.addCookie(c[i]); // ���信 �߰��Ͽ� �����Ű��.
	    		}
			}
		}
	}
}

</script>
</head>
<body>
	����� ��� ��ǰ�� �˰� �ִ�
<br>
<br>
<%-- 
	Cookie[] c = request.getCookies(); // ��� ��Ű�� ������ cookies�� ����
	if (c != null) { // ��Ű�� �Ѱ��� ������ ����
		for (int i = 0; i < c.length; i++) {
	        c[i].setMaxAge(0); // ��ȿ�ð��� 0���� ����
	        response.addCookie(c[i]); // ���信 �߰��Ͽ� �����Ű��.
	    }
	}
--%>
<%
	request.setCharacterEncoding("euc-kr");
	response.setCharacterEncoding("euc-kr");
	String history = null;
	Cookie[] cookies = request.getCookies();
	if (cookies!=null && cookies.length > 0) {
		for (int i = 0; i < cookies.length; i++) {
			Cookie cookie = cookies[i];
			System.out.println(cookie.getName());
			if (cookie.getName().equals("history")) {
				System.out.println("ss");
				history = cookie.getValue();
			}
		}
		if (history != null) {
			System.out.println("ss");
			String[] h = history.split(URLEncoder.encode(","));
			for (int i = h.length-1; i >= 0; i--) {
				if (!h[i].equals("null")) {
					%>
						<a href="/product/getProduct?prodNo=<%=h[i]%>&menu=search"	target="rightFrame"><%=h[i]%></a>
						<!--  <button onClick="javascript:fncDeleteCookie('<%= h[i] %>'')" style="margin:5px">����</button>
						-->
						<br>
					<%
				}
			}
		}
	}
%>

</body>
</html>