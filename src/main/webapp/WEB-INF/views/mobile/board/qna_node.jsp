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
<body class="p_qna">	
	<!-- nav -->
	<jsp:include page="../common/topper.jsp" />
	<!-- nav -->
		<h4>제휴상담 Q & A</h4>
	</header> 
	<!-- content begin -->
	<section>
		<div class="listS01">			
			<div class="list_title"><i class="fas fa-pencil-alt"></i> ReturnP 등급신청상담게시판입니다. </div>			

		<c:choose>
			<c:when test="${! empty model.qnaNodeList}">	
			<c:forEach var="list" items="${model.qnaNodeList}" varStatus="loop">
			<div data-toggle="collapse" data-target="#faq_${list.boardNo}" class="list_li collapsed ellp">
				<small class="date"><i class="fas fa-calendar-alt"></i> ${list.createTime2}</small><small>${list.boardWriterName}</small><small>${list.boardName}</small>
				<span>${list.boardTitle}</span>
			</div>
			<div id="faq_${list.boardNo}" class="list_toggle collapse">
				<p>${f:decQuote(list.answerContent)}</p>
			</div> 	 	
			<c:set var="qnacount" value="${loop.count}"/>
			</c:forEach>	
			</c:when>
			<c:otherwise>
			<div data-toggle="collapse" data-target="#faq1" class="list_li collapsed ellp">
				<span class="ellp">게시글이 존재하지 않습니다.</span>
			</div>
			</c:otherwise>
			</c:choose>
		</div>
		<button type="submit" class="btn btn-submit" onclick="location='./qna_node_w.do'">글쓰기</button>  
	</section>
	<!-- content end -->
</div>
</body>
<!-- body end -->
</html>