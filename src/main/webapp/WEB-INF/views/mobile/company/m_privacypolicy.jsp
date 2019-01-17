<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
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
<body class="p_terms">	
	<!-- nav -->
	<jsp:include page="../common/topper.jsp" />
	<!-- nav -->
		<h4>개인정보 수집 및 이용에 대한 안내</h4>
	</header> 	
	<section>	
		<div class="m_txtarea">
<h5>가. 개인정보의 수집 및 이용목적</h5> 

RETURNP는 회원제 서비스(게시판, 포인트환전, 컨텐츠서비스, 쇼핑몰) 등을 통하여 이용자들에게 맞춤 식 서비스를 비롯한, 보다 더 향상된 양질의 서비스를 제공하기 위하여 이용자 개인의 정보를 본인 및 제휴기관으로부터 아래와 같이 수집하고 있습니다.
<br /><br />
- 수집 방법 : 본인, RETURNP와 포인트 교환 계약을 체결한 제휴업체(단, 이용자가 해당 제휴업체 회원으로 등록된 경우에 한함)<br />
※ RETURNP와 포인트 교환 계약을 체결한 제휴업체 : ㈜KB국민카드, 비씨카드㈜, ㈜우리카드, KEB외환은행, 신한카드㈜, ㈜케이티, 현대오일뱅크, 동양증권, GS칼텍스㈜, E1, (주)이마트, CJ CGV, ㈜이베이코리아, SK플래닛㈜, NH농협은행 등
<br /><br />
 RETURNP는 이용자의 사전 동의 없이는 이용자의 개인정보를 함부로 공개하지 않으며, 수집된 정보는 아래와 같이 이용하고 있습니다.<br /> 
<br /><br />
 [서비스 제공에 대한 계약 이행 및 서비스 제공에 따른 정산]<br />
- RETURNP 포인트 거래를 위한 본인 확인과 포인트 환전, 게시판, 컨텐츠 제공, 물품 배송, 요금 결제 서비스, 요금 정산
<br /><br />
[회원 관리]<br />
- 회원제 서비스 이용에 따른 본인 확인, 개인 식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 가입 및 재 가입 시 과거 거래 내용 연계, 만 19세 미만 미성년자의 가입 제한, 분쟁 조정을 위한 기록 보전, 불만 처리 등 민원 처리, 고지사항 전달
<br /><br />
[마케팅 및 홍보에 활용]<br />
- 신규 서비스 개발 및 특화, 인구 통계학 정 특성에 따른 서비스 제공 및 광고 게재, 회원의 서비스 이용에 대한 통계, RETURNP 서비스와 관련된 뉴스, 이벤트, 업데이트의 전화, 이메일 등을 통한 광고성 정보 전달<br />
<br /><br />
[신규 서비스를 개발]<br />
- RETURNP는 신규 서비스 개발이나 컨텐츠의 확충 시에 기존 이용자들이 RETURNP에 제공한 개인정보를 바탕으로 개발해야 할 서비스의 우선 순위를 보다 더 효율적으로 정하고, RETURNP 이용자들이 필요로 하는 컨텐츠를 합리적으로 선택하여 제공 할 수 있습니다. 
<br /><br />
<h5>나. 수집하는 개인정보의 항목 </h5>

RETURNP에서는 이용자들이 회원제 서비스 제공 및 포인트 거래, 경품 제공, 본인확인, 고객 지원 등을 위해 개인정보를 아래와 같이 수집하고 있습니다. <br /><br />

- 이름, CI(연계정보), 이 메일,주소(거주지), 연락처, 휴대폰 번호, 카드번호, 유효기간, 잔여포인트 및 서비스 이용 과정이나 사업처리 과정에서 아래와 같은 정보들이 생성되어 수집될 수 있습니다. <br />
- 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보, 결제 기록, 상품 구매 기록, 포인트 거래 기록 <br /><br />
<h5>다. 개인정보의 보유 및 이용기간 </h5>

1) RETURNP는 원칙적으로 개인정보 수집 및 이용목적이 달성 된 후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다. <br /><br />
 [ 관련 법령에 따른 정보보유 사유 ] <br />
- RETURNP 거래 내역은 전자상거래 등에서의 소비자보호에 관한 법률 제6조에 관한 법률 등 관계 법령의 규정에 의하여 일정기간 보유됩니다. <br />
이때 거래 정보는 별도 회원구분인자와 함께 따로 보관되어지며, 이 경우 RETURNP는 보관하는 정보를 그 보관의 목적으로만 이용하며, 보존기간은 아래와 같습니다. <br /><br />

 * 포인트 거래 및 상품 구매 등에 관한 거래내역 <br />
 보존 이유 : 소비자보호에 관한 법률 제6조에 관한 법/ 전자상거래 등에서의 소비자보호에 관한 법률 시행령 제6조 <br />
 보존 기간 : 대금결제 및 재화 등의 공급에 관한 기록 : 5년 <br /><br />

* 포인트 조회에 관한 내역<br />
 보존 이유 : 고객 응대<br />
 보존 기간 : 30분(최대 1일)<br /><br />
2)수집된 개인정보의 보유/이용기간은 서비스이용계약체결(회원가입)시부터 서비스이용계약해지(탈퇴신청, 직권탈퇴 포함)입니다. <br /><br />

<h5>라. 위 사항에 대하여 동의하시는 경우</h5>

「개인정보 보호법」 제19조에 의하여 제휴업체가 고객님의 정보를 RETURNP에 제공함에 동의한 것과 동일한 효력이 있음을 안내드립니다. 
          
		</div>
	</section>	
</div>
</body>
<!-- body end -->
</html>
