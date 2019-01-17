<%@page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
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
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<!-- css   -->
<!-- font -->
<link rel="stylesheet" href="/resources/css/m_common.css">
<!-- js -->
<script src="/resources/js/lib/jquery.min.js"></script>
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
<script type="text/javascript">
//red point gift 페이지로 이동
function resetRpointvalue(){
   location.replace("/company/m_rpoint_gift.do");
}

//green point reset
function resetGpointvalue(postfixId){
   if(postfixId == "1"){ //회원
      location.replace("/company/m_gpoint_gift.do");
   }else if(postfixId == "2"){ //정회원
      location.replace("/company/m_gpoint_gift1.do");
   }else if(postfixId == "3"){ //지사
      location.replace("/company/m_gpoint_gift5.do");
   }else if(postfixId == "4"){ //대리점
      location.replace("/company/m_gpoint_gift4.do");
   }else if(postfixId == "5"){ //협력업체
      location.replace("/company/m_gpoint_gift3.do");
   }else if(postfixId == "6"){ //영업관리자
      location.replace("/company/m_gpoint_gift2.do");
   }else if(postfixId == "7"){ //총판
      location.replace("/company/m_gpoint_gift6.do");
   }
}
</script>
</head>
<!-- header end -->
<!-- body begin -->
<body class="p_point">  
   <!-- nav -->
   <jsp:include page="../common/topper.jsp" />
   <!-- nav -->
		<h4>RPay List</h4>
	</header> 
	<!-- content begin -->   
	<section style="padding-top: 50px;">
		<div class="rp_total">
	      <p><fmt:formatNumber value="${model.myRedPointSumInfo.redPointAmountSum}" pattern="###,###,###,###"/>P</p>
	      <h6>Total RPay</h6>
	    </div>
		<div class="tab-content">
			<ul class="tabtitle">
				<li><a href="/mypage/newpay.do">RPay 전환내역</a></li>
				<li class="active"><a href="/mypage/pay_gift.do">RPay 선물하기</a></li>
			</ul>  
          <div id="Rpoint" class="tab-pane fade in active">               
            <div class="listbox rplist">
               <div class="listpoint"><small>P</small><span><fmt:formatNumber value="${model.myRedPointSumInfo.redPointAmountSum}" pattern="###,###,###,###"/></span></div>
               <a type="button"  class="listbtn" onclick="resetRpointvalue();"><i class="fas fa-gift"></i><spring:message code="label.pointGift"/></a>
            </div>
          </div>
      </div>
      <input type="hidden" id="rPointMovingMinLimit" name="rPointMovingMinLimit"/>
      <input type="hidden" id="rPointMovingMaxLimit" name="rPointMovingMaxLimit"/>
      <input type="hidden" id="gPointMovingMinLimit" name="gPointMovingMinLimit"/>
      <input type="hidden" id="gPointMovingMaxLimit" name="gPointMovingMaxLimit"/>
   </section>
   <!-- content end -->
</div>  
</body>
<!-- body end -->
</html>