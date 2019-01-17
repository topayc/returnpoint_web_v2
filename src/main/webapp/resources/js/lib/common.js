function changeLang(value){
	if(value =="ko"){
		location.href="/main/index.do?lang=ko";
	}else if(value =="ch"){
		location.href="/main/index.do?lang=ch";
	}
}

function openNav() {
document.getElementById("myNavbar").style.right = "0";
document.getElementById("myNavbarbg").style.display = "block";
}

function closeNav() {
document.getElementById("myNavbar").style.right = "-100%";
document.getElementById("myNavbarbg").style.display = "none";
}

function checkUrlForm(strUrl) {
    var expUrl = /^http[s]?\:\/\//i;
    return expUrl.test(strUrl);
}

function closeAlert(){
	$('#alert_wrap').show();
}
function alertOpen(title, message, okbutt, obcancle, f1, f2){
	
	var alertMessageHtml = "";
	var alertTitleHtml = "";
	document.getElementById('alertView').style.display='flex';	
	
	alertMessageHtml += "<p>"+message+"</p>";
	$('#alertMassage').html(alertMessageHtml);
	
	alertTitleHtml += "<strong><i class='fas fa-info-circle'></i>"+title+"</strong>";
	$('#alertTitle').html(alertTitleHtml);
	
	$('#alert_ok').unbind("click")
	$('#alert_cancel').unbind("click")
	$('#alert_ok').hide();
	$('#alert_cancel').hide();
	
	if (okbutt){ //ok(확인)버튼이 true이면
		$('#alert_ok').show();
		if ((typeof f1 == "function")){
			$('#alert_ok').bind("click", f1); //ok 버튼을 누르면 f1을 바인드
		}
	}else{
		$('#alert_ok').hide();
	}
	
	if (obcancle){ //ok(취소)버튼이 true이면
		$('#alert_cancel').show();
		if ((typeof f2 == "function")){
			$('#alert_ok').bind("click", f2);
		};
	}else{
		$('#alert_cancel').hide();
	}
}

function alertClose(elem){
	if (elem) {
		$('.' + elem ).hide();
	}else {
		document.getElementById('alertView').style.display='none';
	}
} 

function getParams() {
	// 파라미터가 담길 배열
	var param = new Array();
	// 현재 페이지의 url
	var url = decodeURIComponent(location.href);
	// url이 encodeURIComponent 로 인코딩 되었을때는 다시 디코딩 해준다.
	url = decodeURIComponent(url);
	var params;
	// url에서 '?' 문자 이후의 파라미터 문자열까지 자르기
	params = url.substring( url.indexOf('?')+1, url.length );
	// 파라미터 구분자("&") 로 분리
	params = params.split("&");

	// params 배열을 다시 "=" 구분자로 분리하여 param 배열에 key = value 로 담는다.
	var size = params.length;
	var key, value;
	for(var i=0 ; i < size ; i++){
 		key = params[i].split("=")[0];
		value = params[i].split("=")[1];
		param[key] = value;
	}
	return param;
}

var access = (function () {
	var filter = "win16|win32|win64|mac";
	if ( navigator.platform ) {
		if (filter.indexOf( navigator.platform.toLowerCase()) < 0 ) {
			if (window.navigator.userAgent.indexOf("APP_RETURNP_Android") > 0) {
				return  "APP";
			}else {
				return  "MOBILE";
			}
		}else {
			return  "PC";
		}
	}else {
		return  "UNKNOWN";
	}
})();

var host = window.location.protocol + "//" + window.location.host;
var appInfo = {
	//appSchem : "intent://returnp?seq=67#Intent;scheme=rp;action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package=com.returnp.app;end",
	appSchem : "rp://returnp",
	access : access,
	share : {
		title : '리턴포인트.',
		description : '쓴 만큼 100% 돌려주는 ReturnPoint , 언제 어디서나 쉽고 간편하게',
		imageUrl: 'http://www.returnp.com/resources/images/sns_url_link_img.png',
		link : {
			webUrl : {
				home : host,
				des :  host + "/company/service_member.do",
				join : host + "/member/join.do"
			},
			mobileUrl : {
				home : host + "/main/index.do",
				des :  host + "/company/service_member.do",
				join : host + "/member/join.do"
			}
		}
	},
	key : {
		kakao : "3dbc61239fe98c572c6a809e90ded5c4"
	},
	permission : {
		CAMERA : "CAMERA",
		READ_PHONE_STATE : "READ_PHONE_STATE",
		READ_CONTACTS : "READ_CONTACTS",
		ACCESS_FINE_LOCATION : "ACCESS_FINE_LOCATION",
		SEND_SMS : "SEND_SMS"
		
	},
	permissionResult : {
		PERMITTEED : "0",
		NOT_PERMITTEED: "1"
	}
};

alert(access.share.link.mobileUrl.join);

function executeApp() {
	document.location.href = appInfo.appSchem;
}

function executeAppOrGoStore() {
	var openAt = new Date;
	 setTimeout(
	 	function() {
	 		if (new Date - openAt < 1000)
	 			alertOpen(
	 				"알립", 
	 				"해당 기능을 위해서는 앱을 설치해야 합니다. </br>확인을 누르시면 앱 설치 페이지로 이동합니다", 
	 				true, 
	 				true, 
	 				function(){
	 					goPlayStore();
	 				}, 
	 				null);
	 			
	 	}, 500);
	 executeApp();
}

function goPlayStore() {
	// id 뒤에 앱 패키지명
	storeURL = "https://play.google.com/store/apps/details?id=com.returnp.returnpointapp";
	location.replace(storeURL);
}

function goAppStore() {
	// id 뒤에 앱 패키지명
	storeURL = 'http://itunes.apple.com/<country>/app/<app–name>/id<app-ID>?mt=8';
	location.replace(storeURL);
}


/* 안드로이드 브릿지 관련 코드 */
var bridge = (function () {
	var callbackFunc;
	
	function init(){
		callbackFunc = null;
	}
	
	/* 큐알 코드 스캐너 시작*/
	function startQRCodeScan(func){
		callbackFunc = func;
		window.returnpAndroidBridge.scanQRCode();
	}

	/* 디바이스 전화번호 가져오기*/
	function getPhoneNumber(func) {
		callbackFunc = func;
		window.returnpAndroidBridge.getPhoneNumber();
	}

	/* 디바이스 화면 크기 가져오기*/
	function getDeviceSize(func) {
		callbackFunc = func;
		window.returnpAndroidBridge.getDeviceSize();
	}

	/* 디바이스 세션 설정*/
	function setDeviceSession(userName, userEmail , userAuthToken, func) {
		callbackFunc = func;
		var session = [userName, userEmail, userAuthToken].join(":");
		window.returnpAndroidBridge.setDeviceSession(session);
	}
	
	/* 디바이스 세션 모두 삭제*/
	function clearDeviceSession(func) {
		callbackFunc = func;
		window.returnpAndroidBridge.clearUserSession();
	}
	
	/* 해당 키의 세션 밸류 가져오기*/
	function getSessionValue(key, func){
		callbackFunc = func;
		window.returnpAndroidBridge.getSessionValue(key);
	}
	
	/* 해당 키의 세션 밸류 가져오기*/
	function loadUrl(url, func){
		callbackFunc = func;
		window.returnpAndroidBridge.loadUrl(url);
	}
	
	/*  안드로이드 Bridge 호출후 앱에서 호출되는 콜백*/
	function jsBridgeCallback(result) {
		if (callbackFunc) callbackFunc(result)
	}
	
	function toast(messge){
		window.returnpAndroidBridge.toast(messge);
	}
	
	function getSesssionAndDeviceInfo(func){
		callbackFunc = func;
		window.returnpAndroidBridge.getSesssionAndDeviceInfo();
	}
	
	function checkPermission(permission, func){
		callbackFunc = func;
		window.returnpAndroidBridge.checkPermission(permission);
	}

	function requestPermission(pemission, func){
		callbackFunc = func;
		window.returnpAndroidBridge.requestPermission(pemission);
	}
	
	function getDeviceContacts(func){
		callbackFunc = func;
		window.returnpAndroidBridge.getDeviceContacts();
	}
	
	function getMyLocation(func){
		callbackFunc = func;
		window.returnpAndroidBridge.getMyLocation();
	}

	function sendSMS(smsData, func){
		callbackFunc = func;
		window.returnpAndroidBridge.sendSMS(smsData);
	}
	/*
	 * 안드로이드, IOS 여부에 따라 모듈 함수 세팅
	 * ( 이부분은 차후 진행, 일단 안드로이드만 제공)
	 * */
	var exportFunc = {
		startQRCodeScan : startQRCodeScan,
		getPhoneNumber : getPhoneNumber,
		getDeviceSize : getDeviceSize,
		jsBridgeCallback : jsBridgeCallback,
		setDeviceSession : setDeviceSession,
		clearDeviceSession : clearDeviceSession,
		getSessionValue : getSessionValue,
		getSesssionAndDeviceInfo : getSesssionAndDeviceInfo,
		loadUrl : loadUrl,
		toast : toast,
		checkPermission : checkPermission,
		requestPermission : requestPermission,
		getDeviceContacts : getDeviceContacts,
		getMyLocation : getMyLocation,
		sendSMS : sendSMS
	}
	return exportFunc;
})();

function unsupportedService(){
	alertOpen("알림", "해당 기능은 곧 지원 예정입니다", true, false, null, null);
	return;
	//bridge.toast("아직 지원되지 않는 기능입니다. 곧 추가될 예정입니다.");
}

function startPointBack(){
	//$("#progress_loading").show();
	var param = {};
	$('.returnp_qr').each(function(){
		param[$(this).attr("id")]  = $(this).val().trim().replace(",","");
	});
	function execPointback(){
		bridge.getSesssionAndDeviceInfo(function(info){
			info = JSON.parse(info);
			param["memberEmail"] = info.user_email;
			param["memberName"] = info.user_name;
			param["phoneNumber"] = info.phoneNumber;
			param["phoneNumberCountry"]  = info.phoneNumberCountry;
			param["key"]  = "AIzaSyB-bv2uR929DOUO8vqMTkjLI_E6QCDofb8";
			for (key in param){
				if (param.hasOwnProperty(key)) {
					param[key] = encodeURIComponent(param[key]);
				}
			}
			
			/*실제 운영 포인트 백 서버 */
			var  pointBackUrl = window.location.protocol + "//" + window.location.host + "/qr/qrAcc.do";
			//ert(JSON.stringify(param));
			$.ajax({
	           	type: "POST",
	               url: pointBackUrl,
	               data: param,
	               success: function (result) {
	            	   if (result && typeof result !="undefined") {
	            		  $("#progress_loading").hide();
	            		   /* result obj 설명
	               		  * resultCode : 성공 실패 값(100 이 아니면 실패)
	               		  * message : 메시지
	               		  * url : 이동할 URL 
	               		  */ 
	            		 var alertText = "";
	            		 if (result.resultCode  == "100") {
	            			 alertText = result.message
	            		 }else {
	            			 alertText = result.resultCode + " : " + result.message
	            		 }
	            		 
	            		 alertOpen("확인", 
	            			alertText, 
	            			true, 
	            			false, 
	            			function(){
	            			 if (result.resultCode == "100") {
	            				 document.location.href = window.location.protocol + "//" + window.location.host + "/mypage/newpoint.do";
	            			 }
	            		 	}, 
	            			null);
	               	 }else{
	               		alertOpen("알림", "네트워트 장애 발생. 다시 시도해주세요.", true, false, null, null);
	               	 }
	               },
	               error : function(request, status, error){
	            	   $("#progress_loading").hide();
	            	   alertOpen("알림 ", "네트워트 장애 발생. 다시 시도해주세요", true, false, null, null);
	               },
	               dataType: 'json'
	           });
			//var qrInfoUrl = window.location.protocol + "//pb.retunp.com + "/qr/qrinfo.do?data=" + url;
		});	
	}
	
	bridge.checkPermission(appInfo.permission.READ_PHONE_STATE, function(result){
		result = JSON.parse(result);
		if (result.permission == appInfo.permissionResult.PERMITTEED) {
			execPointback();
		}else {
			bridge.requestPermission(appInfo.permission.READ_PHONE_STATE, function(result){
				result = JSON.parse(result);
				if (result.permission == appInfo.permissionResult.PERMITTEED) {
					execPointback();
				}else {
					 alertOpen("확인", result.permissionName + " 권한을 허용하셔야 적립이 가능합니다", true, false, null, null);
				}
			});
		}
	});
}

function startQRScan(){
	if (appInfo.access != "APP")  {
		executeAppOrGoStore();
		return;
	}
	bridge.startQRCodeScan(function(url){
		if (!url || url == 'null' || url == '') {
			return;
		}else {
		 
			if (checkUrlForm(url)) {
				/* 구매후 포인트 적립 요청 QR */
				if (url.indexOf("PB.RETURNP.COM") > 0) {
					/*QR code Base64 인코딩 전송*/
					var qrInfoUrl = window.location.protocol + "//" + window.location.host + "/qr/qrinfo.do?qr_data=" + btoa(unescape(encodeURIComponent(url)));
					//alert(qrInfoUrl)
					webview_redirect(qrInfoUrl);
					return;
				}else if (url.indexOf("www.returnp.com/member/join.do") > 0) {
					webview_redirect(url);
					return;
				}else {
					//alert("유효하지 않는 QR Code 입니다");
					alertOpen("확인", "유효하지 않는 QR Code 입니다.", true, false, null, null);
				}
			}else {
				bridge.getPhoneNumber(function(phone){
					console.log(phone);
					phone = JSON.parse(phone);
					var phoneNumber = phone.phoneNumber;
					var phoneNumberCountry = phone.phoneNumberCountry;
					var qrInfoUrl = window.location.protocol + "//" + window.location.host + "/qr/qrinfo.do?data=" + url;
					webview_redirect(qrInfoUrl);
				});	
			}
		}
	});
}

function webview_redirect(uri) {
    if(navigator.userAgent.match(/Android/i)){ 
        document.location=uri;
    }else if(navigator.userAgent.match(/iPhone|iPod/i)){
        window.location.replace(uri);
    }else if(navigator.userAgent.match(/iPad/i)){
        window.location.replace(uri);
    }else{
        window.location.href=uri;
    }
}


/*var uAgent = navigator.userAgent.toLowerCase();
//아래는 모바일 장치들의 모바일 페이지 접속을위한 스크립트
var mobilePhones = new Array('iphone', 'ipod', 'ipad', 'android', 'blackberry', 'windows ce','nokia', 'webos', 'opera mini', 'sonyericsson', 'opera mobi', 'iemobile');
for(var i = 0; i < mobilePhones.length; i++){
	if(uAgent.indexOf(mobilePhones[i]) != -1){
		location.href="/main/index.do";
	}
};*/

/*앱인 경우 브릿지 로드*/
//if (appInfo.access == "APP")  {
	//document.write('<script type="text/javascript" src="/resources/js/lib/android_bridge.js"></script>');
//}

