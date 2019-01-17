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

function addlist(faqcount){
	var content = "";
	var faqcount = faqcount;
	var morecount = $('#morecount').val();
	if(morecount =="" || morecount ==null){
		morecount = "1";
	}
	var p = getParams();
	var CODE = (p["code"]);
	$.ajax({
		method : "POST",
		url    : "/board/faqMoreAct.do",
		dataType: "json",
		data   : {
			faqcount		: faqcount,
			morecount		: morecount,
			CODE			: CODE
		},
        success : function(data){
        	if(data.json_arr.length == 0){
        		alert("더보기가 없습니다");
        	}
        	
            for(i=0; i<data.json_arr.length; i++) {
            	content += "<div data-toggle='collapse' data-target='#faq_"+data.json_arr[i].faqMoreList[i].ROWNUM+"' class='list_li collapsed ellp'>"+data.json_arr[i].faqMoreList[i].boardNo+"<strong>Q</strong>"
            	content += "<span>"+data.json_arr[i].faqMoreList[i].boardTitle+"</span>"
            	content += "</div>"
            	content +="<div id='faq_"+data.json_arr[i].faqMoreList[i].ROWNUM+ "' class='list_toggle collapse'>"
            	content +="<p><strong>A</strong>"+data.json_arr[i].faqMoreList[i].boardContent+"</p>"
            	content +="</div>"; 
            }
            $('#morecount').val(data.morecount);
            //$('#addlist').remove();//remove btn
            $(content).appendTo("#table"); 
        },
        error: function (request, status, error) {
			alert("더보기가 없습니다");
			return false;
		}
		
    });


}
</script>
</head>
<!-- header end -->
<!-- body begin -->
<body class="p_faq">	
	<!-- nav -->
	<jsp:include page="/WEB-INF/views/common/topper.jsp" />
	<!-- nav -->
		<h4 class="pc">Customer Center</h4>
		<h4 class="mobile">FAQ</h4>
	</header> 
	<!-- content begin -->
	<ul class="submenu pc">
		<li class="active"><a href="./faq.do">자주묻는질문</a></li>
		<li><a href="./notice.do">공지사항</a></li>
		<!-- <li><a href="./qna.do">일반상담</a></li>
		<li><a href="./qna_node.do">제휴상담</a></li> -->
	</ul>
	<section>
		<div class="listS01">			
			<div class="list_title"><i class="fas fa-pencil-alt"></i> 자주묻는 질문들을 모았습니다. </div>			
			<ul><li class="active"><a href="/board/faq.do?code=1">일반회원</a></li>
				<li><a href="/board/faq.do?code=2">회원정보</a></li>
				<li><a href="/board/faq.do?code=3">포인트</a></li>
				<li><a href="/board/faq.do?code=4">기타</a></li>
			</ul>
	<div id="table">
		<c:choose>
			<c:when test="${! empty model.faqList}">
		<c:forEach var="list" items="${model.faqList}" varStatus="loop">

		<div data-toggle="collapse" data-target="#faq_${list.ROWNUM}" class="list_li collapsed ellp">
			${list.ROWNUM}<strong>Q</strong>
			<span>${list.boardTitle}</span>
		</div>
		<div id="faq_${list.boardNo}" class="list_toggle collapse">
			<p><strong>A</strong>${f:decQuote(list.boardContent)}</p>
		</div> 	
		<c:set var="faqcount" value="${loop.count}"/>
		</c:forEach>
			</c:when>
			<c:otherwise>
				<div class="list_li collapsed ellp">
				<span>등록된 FAQ가 없습니다.</span>
				</div>
			</c:otherwise>
		</c:choose>	
	</div>
		</div>
		<input type="hidden" id="morecount" name="morecount"/>
		<input type="hidden" id="faqTotalCnt" name="faqTotalCnt" value="${model.faqTotalCnt.CNT}"/>
		<c:if test="${faqcount eq 10}">
			<button type="submit" class="btn btn-basic" id="addlist" onclick="addlist('${faqcount}');">더보기</button>
		</c:if>
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