<%@ page contentType="text/html; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>회원 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
 <link rel="stylesheet" href="/resources/demos/style.css">
 <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
 <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>

<script type="text/javascript">
//=====기존Code 주석 처리 후  jQuery 변경 ======//
// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
function fncGetUserList(currentPage) {
	//document.getElementById("currentPage").value = currentPage;
	$("input[name='currentPage']").val(currentPage)
   	//document.detailForm.submit();
	$("form").attr("method" , "POST").attr("action" , "/user/listUser").submit();
}
//===========================================//
//==> 추가된부분 : "검색" ,  userId link  Event 연결 및 처리
 $(function() {
	 let idList = {};
	 let nameList = {};
	 //let currPage = 1;
	 
	 $.ajax( 
				{
					url : "/user/json/getUserAutocompleteList/user_id",
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
						
						idList = JSONData;
						$("input[name='searchKeyword']").autocomplete({
						      source: idList
					    });
						$.ajax( 
								{
									url : "/user/json/getUserAutocompleteList/user_name",
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
										
										nameList = JSONData;
									},
									error : function(status) {

										//Debug...
										alert("error");
									}
							});
					},
					error : function(status) {

						//Debug...
						alert("error");
					}
			});
	 
	 
	//==> 검색 Event 연결처리부분
	//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
	//==> 1 과 3 방법 조합 : $("tagName.className:filter함수") 사용함. 
	 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
		//Debug..
		//alert(  $( "td.ct_btn01:contains('검색')" ).html() );
		fncGetUserList(1);
	  });
	
	
	//==> userId LINK Event 연결처리
	//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
	//==> 3 과 1 방법 조합 : $(".className tagName:filter함수") 사용함.
	$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			//Debug..
			//alert(  $( this ).text().trim() );
			//////////////////////////// 추가 , 변경된 부분 ///////////////////////////////////
					//self.location ="/user/getUser?userId="+$(this).text().trim();
					////////////////////////////////////////////////////////////////////////////////////////////
					var userId = $(this).text().trim();
					$.ajax( 
							{
								url : "/user/json/getUser/"+userId ,
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
									
									var displayValue = "<h3>"
																+"아이디 : "+JSONData.userId+"<br/>"
																+"이  름 : "+JSONData.userName+"<br/>"
																+"이메일 : "+JSONData.email+"<br/>"
																+"ROLE : "+JSONData.role+"<br/>"
																+"등록일 : "+JSONData.regDateString+"<br/>"
																+"</h3>";
									//Debug...									
									//alert(displayValue);
									$("h3").remove();
									$( "td[name='"+userId+"']" ).html(displayValue);
								}
						});
						////////////////////////////////////////////////////////////////////////////////////////////
	});
	
	//==> UI 수정 추가부분  :  userId LINK Event End User 에게 보일수 있도록 
	$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
	$("h7").css("color" , "red");
	
	
	//==> 아래와 같이 정의한 이유는 ??
	//==> 아래의 주석을 하나씩 풀어 가며 이해하세요.					
	$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
	
	$( "select[name='searchCondition']" ).on("change" , function() {
		if ($(this).val() == "0") {
			$("input[name='searchKeyword']").autocomplete({
			      source: idList
		    });
		} else if ($(this).val() == "1") {
			$("input[name='searchKeyword']").autocomplete({
			      source: nameList
		    });
		}
	});
	
	function loadMoreContent() {
		  // Ajax 요청을 보내서 추가 콘텐츠를 가져옴
		  let currPage = ${resultPage.currentPage};
		  //alert(currPage);
		  $.ajax({
			    url: '/user/json/listUser',
			    method: 'POST',
			    dataType : "json" ,
			    headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				data : JSON.stringify( {currentPage:currPage}),
			    success: function(data) {
			      // 서버에서 받은 데이터를 화면에 추가
			      //alert(response);
			      
			      //alert(data.userId);
			     let value = "<tr class='ct_list_pop'>"
			     +"<td align='center'>${i}</td>"
				 +"<td></td>"
				 +"<td align='left'>"
				 +"${user.userId}"		
				 +"</td>"
				 +"<td></td>"
				 +"<td align='left'>${ user.userName }</td>"
				 +"<td></td>"
				 +"<td align='left'>${ user.email }</td>"
				 +"</tr>"
				 +"<tr>"
				 +"<td name='${user.userId}' colspan='11' bgcolor='D6D7D6' height='1'></td>"
				 +"</tr>";
				 
			      $('table').eq(4).append(value);
			      console.log(currPage);
			      //console.log(value);
			      //console(value);
			      currPage++;
			      //${resultPage.currentPage} = currPage;
		    	}, 
		    	error:function() {
		    		alert("error");
		    	}
	 		 });
		}
		$(window).scroll(function() {
			//currPage= ${resultPage.currentPage}+1;
			  //if ($(window).scrollTop() + $(window).height() >= $('table').eq(4).height()) {
			  if ($(window).scrollTop() == $(document).height() - $(window).height()) {
			    // 스크롤이 페이지 하단에 도달하면 추가 콘텐츠를 로드
			   // if (resultPage.currentPage <= resultPage.maxPage) {
			    	//loadMoreContent();
			   // }
			  }
		});

});	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37">
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">회원 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<option value="0" 
					${!empty search.searchCondition && search.searchCondition.equals("0") ? "selected" : ""}>회원ID
				</option>
				<option value="1" 
					${!empty search.searchCondition && search.searchCondition.equals("1") ? "selected" : ""}> 회원명
				</option>
			</select>
		<input 	type="text" name="searchKeyword"  value="${search.searchKeyword}" 
							class="ct_input_g" style="width:200px; height:19px" >
		</td>
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
							<a href="javascript:fncGetUserList('1');">검색</a>
							////////////////////////////////////////////////////////////////////////////////////////////////// -->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
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
		<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
		<td class="ct_list_b" width="150">회원ID</td>
		////////////////////////////////////////////////////////////////////////////////////////////////// -->
		<td class="ct_list_b" width="150">
			회원ID<br>
			<h7 >(id click:상세정보)</h7>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">이메일</td>		
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<c:set var="i" value="0"/>
	<c:forEach var="user" items="${list}">
		<c:set var="i" value="${i+1}"/>
		<tr class="ct_list_pop">
			<td align="center">${i}</td>
			<td></td>
			<td align="left">
				<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
				<a href="/user/getUser?userId=${user.userId}">${user.userId}</a>
				////////////////////////////////////////////////////////////////////////////////////////////////// -->
				${user.userId}
			</td>
			<td></td>
			<td align="left">${ user.userName }</td>
			<td></td>
			<td align="left">${ user.email }
			</td>		
		</tr>
		<tr>
			<!-- //////////////////////////// 추가 , 변경된 부분 /////////////////////////////
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
			////////////////////////////////////////////////////////////////////////////////////////////  -->
			<td name="${user.userId}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>

<!-- 
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
			<input type="hidden" name="currentPage" value=""/>
			<jsp:include page="../common/pageNavigator.jsp">
				<jsp:param name="type" value="User"/>
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