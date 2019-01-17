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
		<h4>ReturnP 이용약관</h4>
	</header> 	
	<section>	
		<div class="m_txtarea">
		<h5>제1조 (목적) </h5>

이 약관은 (주)RETURNP(전자거래 사업자)가 운영하는 www.returnp.com(이하 "사이트"라 한다)에서 제공하는 인터넷 관련 서비스(이하 "서비스"라 한다)를 이용함에 있어 사이트와 이용자의 권리·의무 및 책임사항을 규정함을 목적으로합니다. 
<br /><br />
※ PC통신 등을 이용하는 전자거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다. <br /><br />

<h5>제2조 (정의) </h5>

① "사이트"는 (주)RETURNP가 재화 또는 용역을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 또는 용역을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이트를 운영하는 사업자의 의미로도 사용합니다.
<br />
② "이용자"란 "사이트"에 접속하여 이 약관에 따라 "사이트"가 제공하는 서비스를 받는 회원및 비회원을 말합니다.
<br />
③ '회원'이라 함은 "사이트"에 개인정보를 제공하여 회원등록을 한 자로서, "사이트"의 정보를 지속적으로 제공받으며, "사이트"가 제공하는 서비스(쇼핑몰, 커뮤니케이션 서비스, 교육서비스, 콜센터를 통한 보험, 신용카드 등의 TM마케팅 서비스등, 회사의 모든 서비스를 포함합니다.) 를 계속적으로 이용할 수 있는 자를 말합니다.
<br />
④ '비회원'이라 함은 회원에 가입하지 않고 "사이트"가 제공하는 서비스를 이용하는 자를 말합니다.
<br />
⑤ 프리미엄 회원이라 함은 RETURNP 사이트 내에서 '본인확인'을 통해 '포인트거래'등 RETURNP가 제공하는 모든 서비스를 이용할 수 있는 자를 말합니다. <br /><br />

<h5>제3조 (약관의 명시와 개정) </h5>

① "사이트"는 이 약관의 내용과 상호, 영업소 소재지, 대표자의 성명, 사업자등록번호 등을 이용자가 알 수 있도록 사이트의 초기 서비스화면(전면)에 게시합니다.
<br />
② "사이트"는 약관의 규제등에 관한 법률, 전자거래 기본법, 전자서명법, 정보통신망 이용촉진등에 관한 법률, 방문판매 등에 관한 법률, 소비자 보호법 등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
<br />
③ "사이트"가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행 약관과 함께 사이트의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 그 기간 안에 회원의 전자메일 또는 서면에 의한 이의제기가 없으면 이를 승인한 것으로봅니다.
<br />
④ 제3 항의 방법으로 변경고지된 약관은 기존의 회원에게도 유효하게 효력을 발생합니다.
<br />
⑤ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 정부가 제정한 전자거래소비자보호지침 및 관계법령 또는 상관례에 따릅니다. 
<br /><br />
<h5>제4조 (서비스의 제공 및 변경)</h5> 

① "사이트"는 다음과 같은 업무를 수행합니다.
- 재화 또는 용역에 대한 정보 제공 및 구매계약의 체결
- 구매계약이 체결된 재화 또는 용역의 배송
- 기타 "사이트"가 정하는 업무
<br />
② "사이트"는 재화의 품절 또는 기술적 사양의 변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 재화·용역의 내용을 변경할 수 있습니다.<br />
이 경우에는 변경된 재화·용역의 내용 및 제공일자를 명시하여 현재의 재화·용역의 내용을 게시한 곳에 그 제공일자 이전 7일부터 공지합니다.
<br />
③ "사이트"가 제공하기로 이용자와 계약을 체결한 서비스의 내용을 재화의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 "사이트"는 이로 인하여 이용자가 입은 손해를 배상합니다. 단, "사이트"에 고의 또는 과실이 없는 경우에는 그러하지 아니합니다 
<br /><br />
<h5>제5조 (서비스의 중단) </h5>

① "사이트"는 컴퓨터 등 정보통신설비의 보수점검·교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.
<br />
② 제1항에 의한 서비스 중단의 경우에는 "사이트"는 제8조에 정한 방법으로 이용자에게 통지합니다.
<br />
③ "사이트"는 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단 "사이트"에 고의 또는 과실이 없는 경우에는 그러하지 아니합니다. <br /><br />

<h5>제6조 (회원가입) </h5>

① 이용자는 "사이트"가 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.
<br />
② 일반회원 및 프리미엄회원은 만19세 이상의 분들에 한해 가입을 받고 있습니다.
<br />
③ "사이트"는 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.<br />
- 가입신청자가 이 약관 제7조 제3항에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 다만 제7조 제3항에 의한 회원자격 상실 후 3년이 경과한 자로서 "사이트"의 회원 재가입 승낙을 얻은 경우에는 예외로 한다.<br />
- 등록 내용에 허위, 기재누락, 오기가 있는 경우<br />
- 기타 회원으로 등록하는 것이 "사이트"의 기술상 현저히 지장이 있다고 판단되는 경우<br />

④ 회원가입계약의 성립시기는 "사이트"의 승낙이 회원에게 도달한 시점으로 합니다.<br />

⑤ 회원은 제15조 제1항에 의한 등록사항에 변경이 있는 경우, 즉시 전자우편 기타방법으로 "사이트"에 대하여 그 변경사항을 알려야 합니다.<br />

⑥ 회원이 최초로 "사이트"의 회원으로 가입시에 "사이트"는 회원의 편의 및 다양한 서비스(쇼핑몰 서비스, 커뮤니케이션 서비스, 교육 서비스, 보험, 신용카드 등의 TM마케팅 서비스 등)를 제공하기 위해 회원의 동의가 있을 경우, 해당 서비스별로 선택적인 자동 가입 조치를 할 수 있습니다.
<br />
⑦ "사이트"는 회원에게 서비스의 이용 및 각종행사, 생활편의 정보추천 등의 다양한 서비스를 전자우편이나 무선단문메세지(SMS), 서신우편, 기타의 방법으로 제공 할 수 있습니다. 
<br /><br />
<h5>제7조 (회원 탈퇴 및 자격 상실) </h5>

① 회원은 "사이트"에 언제든지 탈퇴를 요청할 수 있으며 "사이트"는 즉시 회원탈퇴를 처리합니다.
<br />
② 회원이 다음 각 호의 사유에 해당하는 경우, "사이트"는 회원자격을 제한 및 정지시킬 수 있습니다.
<br />- 가입 신청 시에 허위 내용을 등록한 경우
<br />-"사이트"를 이용하여 구입한 재화·용역 등의 대금, 기타 "사이트" 이용에 관련하여 회원이 부담하는 채무를 지급하지 않는 경우
<br />- 다른 사람의 "사이트" 이용을 방해하거나 그 정보를 도용하는 등 전자거래질서를 위협하는 경우
<br />-"사이트"를 이용하여 법령과 이 약관이 금지하거나 공서 양속에 반하는 행위를 하는 경우
<br />
<br />③ "사이트"가 회원 자격을 제한·정지시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 "사이트"는 회원자격을 상실시킬 수 있습니다.

<br />④ "사이트"가 회원자격을 상실시키는 경우에는 회원등록을 말소합니다. 이 경우 회원에게 이를 통지하고, 회원등록 말소 전에 소명할 기회를 부여합니다. 
<br /><br />
<h5>제8조 (회원에 대한 통지) </h5>

① "사이트"가 회원에 대한 통지를 하는 경우, 회원이 "사이트"에 제출한 전자우편 주소로 할 수 있습니다.
<br />
② "사이트"는 불특정다수 회원에 대한 통지의 경우 1주일이상 "사이트" 게시판에 게시함으로써 개별 통지에 갈음할 수 있습니다. 
<br /><br />
<h5>제9조 (구매신청) </h5>

"사이트"이용자는 "사이트"상에서 이하의 방법에 의하여 구매를 신청합니다.<br />
- 성명, 주소, 전화번호 입력<br />
- 재화 또는 용역의 선택<br />
- 결제방법의 선택<br />
- 이 약관에 동의한다는 표시(예, 마우스 클릭) <br /><br />

<h5>제10조 (계약의 성립) </h5>

① "사이트"는 제9조와 같은 구매신청에 대하여 다음 각 호에 해당하지 않는 한 승낙합니다.
<br />- 신청 내용에 허위, 기재누락, 오기가 있는 경우
<br />- 미성년자가 담배, 주류등 청소년보호법에서 금지하는 재화 및 용역을 구매하는 경우
<br />- 기타 구매신청에 승낙하는 것이 "사이트" 기술상 현저히 지장이 있다고 판단하는 경우

<br />② "사이트"의 승낙이 제12조 제1항의 수신확인통지형태로 이용자에게 도달한 시점에 계약이 성립한 것으로 봅니다. <br /><br />

<h5>제11조 (지급방법) </h5>

"사이트"에서 구매한 재화 또는 용역에 대한 대금지급방법은 다음 각 호의 하나로 할 수 있습니다.
<br />- 계좌이체
<br />- 신용카드결제
<br />- 온라인무통장입금
<br />- 전자화폐에 의한 결제
<br />- 수령시 대금지급 등 <br /><br />

<h5>제12조 (수신확인통지,구매신청 변경 및 취소) </h5>

"사이트"에서 구매한 재화 또는 용역에 대한 대금지급방법은 다음 각 호의 하나로 할 수 있습니다.

<br />① "사이트"는 이용자의 구매신청이 있는 경우 이용자에게 수신확인통지를 합니다.

<br />② 수신확인통지를 받은 이용자는 의사표시의 불일치 등이 있는 경우에는 수신확인통지를 받은 후 즉시 구매신청 변경 및 취소를 요청할 수 있습니다.

<br />③ "사이트"는 배송전 이용자의 구매신청 변경 및 취소 요청이 있는 때에는 지체없이 그 요청에 따라 처리합니다. <br /><br />

<h5>제13조 (배송) </h5>

"사이트"는 이용자가 구매한 재화에 대해 배송수단, 수단별 배송비용 부담자, 수단별 배송기간 등을 명시합니다. <br />
만약 "사이트"의 고의·과실로 약정 배송기간을 초과한 경우에는 그로 인한 이용자의 손해를 배상합니다. <br /><br />

<h5>제14조 (환급,반품 및 교환) </h5>

① "사이트"는 이용자가 구매 신청한 재화 또는 용역이 품절 등의 사유로 재화의 인도 또는 용역의 제공을 할 수 없을 때에는 지체없이 그 사유를 이용자에게 통지하고, 사전에 재화 또는 용역의 대금을 받은 경우에는 대금을 받은 날부터 3일 이내에, 그렇지 않은 경우에는 그 사유발생일로부터 3일 이내에 계약해제 및 환급절차를 취합니다. 
<br />
② 다음 각 호의 경우에는 "사이트"는 배송된 재화일지라도 재화를 반품받은 다음 영업일 이내에 이용자의 요구에 따라 즉시 환급, 반품 및 교환 조치를 합니다. 다만 그 요구기한은 배송된 날로부터 20일 이내로 합니다. <br />
- 배송된 재화가 주문내용과 상이하거나 "사이트"가 제공한 정보와 상이할 경우 <br />
- 배송된 재화가 파손, 손상되었거나 오염되었을 경우 <br />
- 재화가 광고에 표시된 배송기간보다 늦게 배송된 경우 <br />
- 방문판매 등에 관한 법률 제18조에 의하여 광고에 표시하여야 할 사항을 표시하지 아니한 상태에서 이용자의 청약이 이루어진 경우 <br /><br />

<h5>제15조 (개인정보보호) </h5>

① "사이트"는 이용자의 정보수집시 구매계약 이행에 필요한 최소한의 정보를 수집합니다.<br />
 [ 다음 사항을 필수사항으로 하며 그 외 사항은 선택사항으로 합니다.]<br />
- 성명<br />
- CI 연계정보 (프리미엄 이상 회원인 경우)<br />
- E-mail주소<br />
- 주소<br />
- 휴대폰 번호<br />
- 희망ID (회원의 경우)<br />
- 비밀번호 (회원의 경우)<br />
- 생년월일<br />
- 성별<br />

② "사이트"가 이용자의 개인식별이 가능한 개인정보를 수집하는 때에는 반드시 당해 이용자의 동의를 받습니다.<br />

③ 제공된 개인정보는 당해 이용자의 동의없이 목적 외의 이용이나 제3자에게 제공할 수 없으며, 이에 대한 모든 책임은 "사이트"가 집니다. 다만, 다음의 경우에는 예외로 합니다.<br />
- 배송업무상 배송업체에게 배송에 필요한 최소한의 이용자의 정보 (성명, 주소, 전화번호)를 알려주는 경우<br />
- 통계작성, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우<br />

④ "사이트"가 제2항과 제3항에 의해 이용자의 동의를 받아야 하는 경우에는 개인정보관리 책임자의 신원(소속, 성명 및 전화번호 기타 연락처), 정보의 수집목적 및 이용목적, 제3자에 대한 정보제공 관련사항(제공받는자, 제공목적 및 제공할 정보의 내용)등 정보통신망 이용촉진 등에 관한법률 제16조 제3항이 규정한 사항을 미리 명시하거나 고지해야 하며 이용자는 언제든지 이 동의를 철회할 수 있습니다.
<br />
⑤ 이용자는 언제든지 "사이트"가 가지고 있는 자신의 개인정보에 대해 열람 및 오류정정을 요구할 수 있으며 "사이트"는 이에 대해 지체없이 필요한 조치를 취할 의무를 집니다. 이용자가 오류의 정정을 요구한 경우에는 "사이트"는 그 오류를 정정할 때까지 당해 개인정보를 이용하지 않습니다.
<br />
⑥ "사이트"는 개인정보 보호를 위하여 관리자를 한정하여 그 수를 최소화하며 신용카드, 은행계좌 등을 포함한 이용자의 개인정보의 분실, 도난, 유출, 변조 등으로 인한 이용자의 손해에 대하여 모든 책임을 집니다.<br />

⑦ "사이트" 또는 그로부터 개인정보를 제공받은 제3자는 개인정보의 수집목적 또는 제공받은 목적을 달성한 때에는 당해 개인정보를 지체없이 파기합니다. <br /><br />

<h5>제16조 ("사이트"의 의무) </h5>

① "사이트"는 법령과 이 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 이 약관이 정하는 바에 따라 지속적이고, 안정적으로 재화·용역을 제공하는 데 최선을 다하여야 합니다.<br />

② "사이트"는 이용자가 안전하게 인터넷 서비스를 이용할 수 있도록 이용자의 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다.<br />

③ "사이트"가 상품이나 용역에 대하여 「표시·광고의 공정화에 관한 법률」제3조 소정의 부당한 표시·광고행위를 함으로써 이용자가 손해를 입은 때에는 이를 배상할 책임을 집니다.<br />

④ "사이트는 이용자가 원하지 않는 영리목적의 광고성 전자우편을 발송하지 않습니다. <br /><br />

<h5>제17조 (회원의 아이디 및 비밀번호에 대한 의무) </h5>

① 제15조의 경우를 제외한 ID와 비밀번호에 관한 관리책임은 회원에게 있습니다.<br />

② 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안됩니다.<br />

③ 회원이 자신의 ID 및 비밀번호를 도난당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로 "사이트"에 통보하고 "사이트"의 안내가 있는 경우에는 그에 따라야 합니다.<br />

④ "사이트는 이용자가 원하지 않는 영리목적의 광고성 전자우편을 발송하지 않습니다. <br /><br />

<h5>제18조 (이용자의 의무) </h5>

이용자는 다음 행위를 하여서는 안됩니다.<br /><br />

- 신청 또는 변경시 허위내용의 등록<br />
- "사이트"에 게시된 정보의 변경<br />
- "사이트"가 정한 정보 이외의 정보(컴퓨터 프로그램 등)의 송신 또는 게시<br />
- "사이트" 기타 제3자의 저작권 등 지적재산권에 대한 침해<br />
- "사이트" 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위<br />
- 외설 또는 폭력적인 메시지·화상·음성 기타 공서양속에 반하는 정보를 사이트에 공개 또는 게시하는 행위 <br /><br />

<h5>제19조 (개인정보파기제도) </h5>

정보통신망 이용촉진 및 정보보호 등에 관한 법률 제29조 및 동법 시행령 제16조 1항(개인정보의 파기)에 의거하여 개인정보 파기의무가 강화 됨에 따라 아래와 같이 개인정보파기제도를 운영 합니다.<br /><br />

대상: 1년이상 "사이트" 미 로그인 회원 중 포인트 거래가 없는 회원<br />
 통지: 개인정보 파기 예정일로부터 30일 이전까지 해당 사실을 전자메일, 서면, SMS 중 하나의 방법으로 "회원"에게 사전 통지 <br /><br />

<h5>제20조 (연결"사이트"와 피연결 "사이트"간의 관계 ) </h5>

① 상위 "사이트"와 하위 "사이트"가 하이퍼 링크(예: 하이퍼 링크의 대상에는 문자, 그림 및 동화상 등이 포함됨)방식 등으로 연결된 경우, 전자를 연결 "사이트"(웹 사이트)이라고 하고 후자를 피연결 "사이트"(웹 사이트)이라고 합니다.
<br />
② 연결 "사이트"는 피연결 "사이트"가 독자적으로 제공하는 재화·용역에 의하여 이용자와 행하는 거래에 대해서 보증책임을 지지 않는다는 뜻을 연결 "사이트"의 웹사이트에서 명시한 경우에는 그 거래에 대한 보증책임을 지지 않습니다. 
<br /><br />
<h5>제21조 (저작권의 귀속 및 이용제한) </h5>

① "사이트"가 작성한 저작물에 대한 저작권 기타 지적재산권은 "사이트"에 귀속합니다.<br />

② 이용자는 "사이트"를 이용함으로써 얻은 정보를 "사이트"의 사전 승낙없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다. <br /><br />

<h5>제22조 (분쟁해결) </h5>

① "사이트"는 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구를 설치·운영합니다.<br />

② "사이트"는 이용자로부터 제출되는 불만사항 및 의견은 우선적으로 그 사항을 처리합니다. 다만, 신속한 처리가 곤란한 경우에는 이용자에게 그 사유와 처리일정을 즉시 통보해 드립니다.<br />

③ "사이트"와 이용자간에 발생한 분쟁은 전자거래 기본법 제28조 및 동 시행령 제15조에 의하여 설치된 전자거래분쟁조정위원회의 조정에 따를 수 있습니다. <br /><br />

<h5>제23조(재판권 및 준거법) </h5>

① "사이트"와 이용자간에 발생한 전자거래 분쟁에 관한 소송은 민사 소송법상의 관할법원에 제기합니다.<br />

② "사이트"와 이용자간에 제기된 전자거래 소송에는 한국법을 적용 합니다. <br />
		
		</div>
	</section>	
</div>
</body>
<!-- body end -->
</html>