<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.returnp_web.utils.SessionManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<!DOCTYPE html>
<html lang="en"> 
<head> 
<title>ReturnP</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge"><!-- 0710 ie가 edge로 맞춰지는 메타 추가 -->
<meta name="format-detection" content="telephone=no"/><!-- 0710 edge상에서 전화번호 자동인식으로 인한 메타 추가 -->
<!-- css   -->
<!-- font -->
<link rel="stylesheet" href="/resources/css/common.css">
<!-- js -->
<script src="/resources/js/lib/jquery.min.js"></script>
<script src="/resources/js/lib/bootstrap.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/common.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var pageContextlocale = '${pageContext.response.locale}';
	if(pageContextlocale == "ko"){
	      $("#sel1").val("ko");
	}else{
		 $("#sel1").val("ch");
	}  	
});
</script>
</head>
<!-- header end -->
<!-- body begin -->
<body class="p_qna">	
	<!-- nav -->
	<jsp:include page="/WEB-INF/views/common/topper.jsp" />
	<!-- nav -->
		<h4 class="pc">Customer Center</h4>
		<h4 class="mobile">Q & A</h4>
	</header> 
	<!-- content begin -->
	<ul class="submenu pc">
		<li><a href="./faq.do">자주묻는질문</a></li>
		<li><a href="./notice.do">공지사항</a></li>
		<li class="active"><a href="./qna.do">일반상담</a></li>
		<li><a href="./qna_node.do">제휴상담</a></li>
	</ul>
	<section>
		<div class="listS01">			
			<div class="list_title"><i class="fas fa-pencil-alt"></i> ReturnP 일반상담게시판입니다. </div><br />		
			<form name="Frm">
				<div class="form-group">
				  <div class="dropdown">
				    <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">문의 유형
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				      <li><a href="#">회원가입문의</a></li>      
				      <li><a href="#">결제문의</a></li>
				      <li><a href="#">입금확인문의</a></li>
				      <li><a href="#">서비스문의</a></li>
				      <li><a href="#">기타문의</a></li>
				    </ul>
				  </div>  
				</div>
				<div class="form-group">
					<label for="name">이름</label> 
					<input type="text"	class="form-control" name="name" maxlength="50">
				</div>
				<div class="form-group">
					<label for="subject">제목</label> 
					<input type="text"	class="form-control" name="subject" maxlength="50">
				</div>
				<div class="form-group">
					<label for="contents">내용</label> 
					<textarea rows="10" cols="50"  name="content" class="form-control"></textarea>
				</div>
				<button type="submit" class="btn btn-submit" onclick="memberJoinSubmit();" onsubmit="return false;"><spring:message code="label.joinDesc15" /></button>
			</form> 
		</div>
		<button type="submit" class="btn btn-submit" >글쓰기</button>  
	</section>
	<!-- content end -->
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	<!-- footer -->	
</div>
	<!-- privacy policy modal -->
	<jsp:include page="../company/m_privacypolicy.jsp" flush="false" />
	<!-- privacy policy modal end -->
	<!-- terms of ues modal -->
	<jsp:include page="../company/m_termsofuse.jsp" flush="false" />
	<!-- terms of ues modal end -->
</body>
<!-- body end -->
</html>