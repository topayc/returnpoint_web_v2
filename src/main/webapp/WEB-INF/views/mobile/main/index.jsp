<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.returnp_web.utils.SessionManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="java.net.URL" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>ReturnP</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<!-- sns url 링크시 표시되는 이미지와 텍스트내용들 테스트입니다.  -->
<meta property="og:url" content="http://returnp.com">
<meta property="og:title" content="ReturnP">
<meta property="og:type" content="website">
<meta property="og:image" content="/resources/images/sns_url_link_img.png">
  
<!-- css   -->
<!-- font -->
<link rel="stylesheet" href="/resources/css/m_common.css">
<!-- js -->
<script type="text/javascript" src="/resources/js/lib/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/bootstrap.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/jquery.cookie.js"></script>
<script type="text/javascript" src="/resources/js/lib/m_common.js"></script>

<!-- 가맹점롤링 --><script src="https://code.jquery.com/jquery-2.2.0.min.js" type="text/javascript"></script>
<!-- 가맹점롤링 --><script type="text/javascript" src="/resources/js/lib/m_slick.js"></script>

<script type="text/javascript">

// 가맹점롤링 시작
$(document).on('ready', function() {
    $(".center").slick({
      infinite: true,
      centerMode: true,
      arrows: false,
      slidesToShow: 4,
      slidesToScroll: 3,
      autoplay:true
    });

    var memberTotal = '${model.memberTotal}';

    if(memberTotal!=""){
       $(".total").text(comma(memberTotal) + " 명");
    }
    
    if (appInfo && appInfo['access'] && appInfo['access'] == "APP") {
        var p = getParams();
        var mbrE = (p["mbrE"]);
        var userAT = (p["userAT"]);
        if (typeof mbrE != "undefined" && typeof userAT != "undefined") {
           bridge.setDeviceSession(mbrE, mbrE, userAT, function(result) {
        	   bridge.getSessionValue('PREF_ALL_SESSION', function(result){
              });
           });
        }
     }
  });
// 가맹점롤링 끝

//콤마찍기
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
$(document).ready(function(){
   var pageContextlocale = '${pageContext.response.locale}';
   if(pageContextlocale == "ko"){
         $("#sel1").val("ko");
   }else{
       $("#sel1").val("ch");
   }
    //탈퇴완료 후 모달 호출
   if(location.href.match('form=out')){
       location.href = '/mypage/m_memberout.do';
    }
   if (appInfo && appInfo['access'] && appInfo['access'] == "APP") {
      var p = getParams();
      var mbrE = (p["mbrE"]);
      var userAT = (p["userAT"]);
      if (typeof mbrE != "undefined" && typeof userAT != "undefined") {
         bridge.setDeviceSession(mbrE, mbrE, userAT, function(result) {
            bridge.getSessionValue('PREF_ALL_SESSION', function(result){
            });
         });
      }
   }
   var p = getParams();
   var alertView = (p["alertView"]);
   var Message  = (p["Message"]);
   var message = "";
   var title = "확인";
   if(Message =="1"){
      message = "잘못된 경로입니다.";
   }else if(Message =="2"){
      message = "이메일 인증이 완료된 고객입니다.";
   }else if(Message =="3"){
      message = "이메일 인증완료되었습니다.";
   }else if(Message =="4"){
      message = "미인증 고객입니다. 이메일인증완료후 사용해주세요.";
   }else if(Message =="5"){
      message = "가입하신 이메일로 발송이 완료되었습니다.";
   }
   if(alertView =="t"){
      var alertMessageHtml = "";
      var alertTitleHtml = "";
      document.getElementById('alertView').style.display='flex';
      alertMessageHtml += "<p>"+message+"</p>";
      $('#alertMassage').html(alertMessageHtml);
      alertTitleHtml += "<strong><i class='fas fa-info-circle'></i>"+title+"</strong>";
      $('#alertTitle').html(alertTitleHtml);
      $('#alert_ok').show();
      $('#alert_cancel').hide();
   }

   $("#alertView").hide();
});

function searchMap(){

   var searchText = $("#text_address").val();
   if(searchText == "" || searchText.length < 3 ){
      alertOpen("확인", "찾고자하는 위치정보를 입력하시거나 2글자 이상 입력해 주세요.", true, false);
      return;
   }
   location.href = '/map/rpmap.do?search=' + searchText;;
}
</script>
</head>
<!-- header end -->
<!-- body begin -->
<body class="index">
   <!-- 0921 이벤트 노티 -->
   <div class="alert_wrap event" id="eventAlert" name="eventAlert" style = "display:none">
     <div class="alert alert-info">
       <button type="button" class="close" id="alert_cancel" name="alertClose"  onclick='javascript:alertClose("event");'>&times;</button>
       <c:choose>
         <c:when
            test="${(sessionScope.memberEmail == null) || (sessionScope.memberEmail == '')}">
            <a href="/member/join.do" class="eventlink">회원가입<br />바로가기</a>
            <!-- 로그인 후 -->
         </c:when>
         <c:otherwise>
            <a href="/mypage/m_fullmember.do" class="eventlink">정회원<br />신청하기</a>
         </c:otherwise>
      </c:choose>
     </div>
   </div>  
   <!-- 0831 서버점검 노티 -->
   <c:if test="${SERVER_MANAGE.status.webServerStatus == '2' }">
   <div class="alert_wrap noti" id="alertView" name="alertView" ><!--  style 부분에 display:none;을 빼주심 활성화되요 -->
     <div class="alert alert-info">
       <div class="alert_body">
          <i class="fas fa-exclamation-triangle"></i>
           <div class="error_desk">
               <h2>Checking Server</h2>
               <h4>서버 임시 점검중입니다.</h4>
           </div>
       </div>
     </div>
   </div>
   </c:if>
   <!-- nav -->
   <jsp:include page="../common/topper.jsp" />
   <!-- nav -->
   <a href="/main/index.do"><h4>RETRUN<span>P</span></h4></a>
   </header>
   <!-- main begin -->
   <section class="nobtn">
     <ul class="nav nav-tabs">
       <li class="main_rpoint active"><a data-toggle="tab" href="#main_rpoint"><span>R</span>-PAY</a></li>
       <li class="main_gpoint"><a data-toggle="tab" href="#main_gpoint"><span>R</span>-POINT</a></li>
     </ul>
     <div class="tab-content">
       <div id="main_rpoint" class="tab-pane fade in active">
         <h6>현재 ${sessionScope.memberName}님의 총 RPay입니다.</h6>
         <p><fmt:formatNumber value="${model.myRedPointSumInfo.redPointAmountSum}" pattern="###,###,###,###"/>P</p>
         <ul>
            <li><a href=""><i class="fas fa-qrcode"></i> 구매하기</a></li>
            <li><a href="/mypage/point_gift.do"><i class="fas fa-gift"></i> 선물하기</a></li>
            <li><a href="/mypage/newpoint.do"><i class="fas fa-sync-alt"></i> 전환내역</a></li>
         </ul>
       </div>
       <div id="main_gpoint" class="tab-pane fade">
         <h6>현재 ${sessionScope.memberName}님의 총 RPoint입니다.</h6>
         <p><fmt:formatNumber value="${model.myGreenPointSumInfo.greenPointAmountSum}" pattern="###,###,###,###"/>P</p>
         <ul>
            <li><a onclick="startQRScan()"><i class="fas fa-qrcode"></i> 적립하기</a></li>
            <li><a href="/mypage/point_gift.do"><i class="fas fa-gift"></i> 선물하기</a></li>
            <li><a href="/mypage/newpoint.do"><i class="fas fa-list-ul"></i> 적립내역</a></li>
         </ul>
       </div>
     </div>
     <div class="center store">
       <div><img src="/resources/images/m_store01.jpg" /></div>
       <div><img src="/resources/images/m_store02.jpg" /></div>
       <div><img src="/resources/images/m_store03.jpg" /></div>
       <div><img src="/resources/images/m_store04.jpg" /></div>
       <div><img src="/resources/images/m_store05.jpg" /></div>
       <div><img src="/resources/images/m_store06.jpg" /></div>
       <div><img src="/resources/images/m_store07.jpg" /></div>
       <div><img src="/resources/images/m_store08.jpg" /></div>
     </div>
     <div class="search">
        <p class="searchbtn"><a href="/map/rpmap.do"><i class="fas fa-map-marker-alt"></i> 내주변에 가맹점 찾기</a></p>
      <input id="text_address" type="text" class="form-control" placeholder="ex)강남역, 시청역, 김포 ...">
      <i class="fas fa-search" onclick="searchMap()"></i>
      </div>
     <ul class="banner">
        <li><a href=""><img src="/resources/images/m_banner01.jpg" /></a></li>
        <li><a href=""><img src="/resources/images/m_banner02.jpg" /></a></li>
        <li><a href=""><img src="/resources/images/m_banner03.jpg" /></a></li>
     </ul>
     <div class="footinfo">
        <a href="/company/service_member.do">리턴포인트란</a><small>/</small>
        <a href="/board/qna_node.do">제휴문의</a><small>/</small>
        <a href="/board/faq.do">FAQ</a>
        <p>TOTAL<br /><span class="total">${model.memberTotal}명</span></p>
     </div>
   </section>
</div>
</body>
<!-- body end -->
</html>