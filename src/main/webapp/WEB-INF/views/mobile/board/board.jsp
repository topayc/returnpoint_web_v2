<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.returnp_web.utils.SessionManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="f" uri="/WEB-INF/tld/f.tld" %>
<!DOCTYPE html>
<html lang="en"> 
<head>
<title>ReturnP</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="format-detection" content="telephone=no"/>
<!-- css   -->
<!-- font -->
<link rel="stylesheet" href="/resources/css/m_common.css">
<!-- js -->
<script type="text/javascript" src="/resources/js/lib/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/bootstrap.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/m_common.js"></script>
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
<body class="p_board">	
	<!-- nav -->
	<jsp:include page="../common/topper.jsp" />
	<!-- nav -->
		<h4>Customer Center</h4>
	</header> 
	<!-- content begin -->
	<section>
		<div class="listS01">
			<div class="list_title"><i class="fas fa-pencil-alt"></i> 게시판 </div>		
			<a href="/board/faq.do"><div class="list_li">자주묻는질문<span><i class="fas fa-chevron-right"></i></span></div></a>
			<a href="/board/notice.do"><div class="list_li">공지사항<span><i class="fas fa-chevron-right"></i></span></div></a>			 
			<a href="/board/qna.do"><div class="list_li">일반상담<span><i class="fas fa-chevron-right"></i></span></div></a>	
			<a href="/board/qna_node.do"><div class="list_li">제휴상담<span><i class="fas fa-chevron-right"></i></span></div></a>		
			<div class="list_title"><i class="fas fa-user-shield"></i> 약관 및 정책 </div>		
			<a href="/company/m_termsofuse.do"><div class="list_li">이용약관<span><i class="fas fa-chevron-right"></i></span></div></a>
			<a href="/company/m_privacypolicy.do"><div class="list_li">개인정보취급방침<span><i class="fas fa-chevron-right"></i></span></div></a> 
 
			<div class="list_title"><i class="fas fa-building"></i> ReturnP </div>			
			<a href="/company/company_identity.do"><div class="list_li">회사소개<span><i class="fas fa-chevron-right"></i></span></div></a> 		
			<a href="/company/service_member.do"><div class="list_li">서비스안내<span><i class="fas fa-chevron-right"></i></span></div></a> 	
			<div class="list_li">상호 : (주) 탑해피월드</div> 		
			<div class="list_li">전화번호 : 02-585-2593</div>		
			<div class="list_li">팩스 : 02-585-2590</div>
			<div class="list_li">주소 : 서울특별시 서초구 사임당로 32 재우빌딩1층</div> 		
			<div class="list_li">사업자번호 : 754-86-01056</div> 		
		</div>
	</section>
	<!-- content end -->
</div>
</body>
<!-- body end -->
</html>