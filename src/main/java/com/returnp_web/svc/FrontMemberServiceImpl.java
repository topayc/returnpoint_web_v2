package com.returnp_web.svc;

import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map.Entry;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;
import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.returnp_web.dao.FrontMemberDao;
import com.returnp_web.utils.Const;
import com.returnp_web.utils.Converter;
import com.returnp_web.utils.EmailSender;
import com.returnp_web.utils.EmailVO;
import com.returnp_web.utils.RPMap;
import com.returnp_web.utils.ServletRequestInfoUtil;
import com.returnp_web.utils.SessionManager;
import com.returnp_web.utils.Util;
import net.sf.json.JSONObject;
import com.returnp_web.utils.BASE64Util;

/**
 * The Class FrontMemberServiceImpl.
 */
@Service
public class FrontMemberServiceImpl implements FrontMemberService {
	
	private static final Logger logger = LoggerFactory.getLogger(FrontMemberServiceImpl.class);
	
	/** The front member dao. */
	@Autowired
	private FrontMemberDao frontMemberDao;
	
	@Autowired
	private EmailVO email;

	@Autowired
	private EmailSender emailSender;
	
	@Autowired
	private MessageSource messageSource;

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean loginAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{

		//추후 다국어 alert 요청시 아래의 것 활용하세요.(18.07.11)
		String message = messageSource.getMessage("messages.greeting", null, LocaleContextHolder.getLocale());
		
		RPMap dbparams = new RPMap();
		SessionManager sm = new SessionManager(request, response);
		String id = p.getStr("email");
		String pw = p.getStr("pwd");
		Boolean isSaveId = "on".equals(p.getStr("isSave")) ? true : false;
		
		dbparams.put("memberEmail", id);
		if(id == null || id.equals("")){
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일을 입력해 주세요.", "/member/login.do?alertView=t&Message=2", "T"));
			return false;
		}
 
		if(pw == null || pw.equals("")){
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("비밀번호를 입력해 주세요.", "/member/login.do?alertView=t&Message=3", "T"));
			return false;
		}
		dbparams.put("memberPassword", Util.sha(pw));
		
		int memberNo = 0;
		String memberEmail = "";
		String memberPassword = "";
		String memberStatus = "";
		String memberName = "";
		String memberPhone = "";
		int failureCnt = 0;

		HashMap<String,Object>records = frontMemberDao.loginAct(dbparams);
		
		if(records !=null && !records.isEmpty()){
			memberNo = Converter.toInt(records.get("memberNo"));
			memberEmail = Converter.toStr(records.get("memberEmail"));
			memberPassword = Converter.toStr(records.get("memberPassword"));
			memberStatus = Converter.toStr(records.get("memberStatus"));
			memberName = Converter.toStr(records.get("memberName"));
			failureCnt = Converter.toInt(records.get("failureCnt")); // 실패횟수
			memberPhone = Converter.toStr(records.get("memberPhone"));
		} 
		
		if (memberNo <= 0){
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일 또는 비밀번호가 일치하지 않습니다.", "/member/login.do?alertView=t&Message=1", "T"));
			return false;
		}
		
		try{

			if("3".equals(memberStatus)){
				rmap.put(Const.D_SCRIPT, Util.gotoURL("/member/login.do?pop=confirm&memberEmail="+memberEmail+"&memberNo="+memberNo, "T"));
				//rmap.put(Const.D_SCRIPT, Util.jsmsgLink("미인증 고객입니다.", "/member/login.do?pop=confirm", "T"));
				return false;
			}
			
			if("5".equals(memberStatus)){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("사용정지 고객입니다.", "/member/login.do?alertView=t&Message=4", "T"));
				return false;
			}
			
			if("6".equals(memberStatus)){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("탈퇴고객입니다.", "/member/login.do?alertView=t&Message=5", "T"));
				return false;
			}
			
			//인증번호가 있는 경우 인증 시간을 비교한다.
			String lastTime 	= Converter.toStr(records.get("lastTime"));
			String currentTime 	= Converter.toStr(records.get("currentTime"));
			int timeCampare = lastTime.compareTo(currentTime) ; // 인증시간기간 - 현재시간, 0보다 크면 시간초과
			
			if(null != records.get("authNumber") || !"".equals(p.get("authPasswordConfirm"))){
		
				// 현재시간이 인증기간을 지난 경우 인증번호를 재발급 후 나간다.
				if(0 > timeCampare){
					// 이메일주소 암호화
					String encodeEmail = BASE64Util.encodeString(id); // 이메일 암호화
					rmap.put(Const.D_SCRIPT, Util.jsmsgLink("인증시간이 경과되었습니다. 재발급해주세요.", "/member/login.do?form=auth&"+encodeEmail+"&alertView=t&Message=7", "T"));
					return false;
				}
			}
			
			// 인증번호가 없고 실패 5회 이상이거나 4회에서 실패시 오류
			if(null == records.get("authNumber") && (5 <= failureCnt || ( 4 == failureCnt && (!memberPassword.equals(Util.sha(pw))) )) ){
				// 인증번호 6자리 난수 생성
				String authRandomNo = Util.randomNumber();
				dbparams.put("memberNo"	    , memberNo        		);
				dbparams.put("authNumber"	, authRandomNo   		);
				dbparams.put("failureCnt"	, failureCnt + 1		);
				
				//5회 실패 후 미인증시 인증번호 insert
				frontMemberDao.updateLoginAuthNumber(dbparams);
				
				//비밀번호 실패시 비밀번호 실패 테이블에 insert
				frontMemberDao.updateLoginFailure(dbparams);
				
				// 이메일주소 암호화
				String encodeEmail = BASE64Util.encodeString(id); ; // 이메일 암호화
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("로그인 5회이상 실패하였습니다.", "/member/login.do?form=auth&"+encodeEmail+"&alertView=t&Message=8", "T"));
				return true;
			}else{
				// 암호 비교
				if(!memberPassword.equals(Util.sha(pw))){
					dbparams.put("memberNo"	    , memberNo        		);
					dbparams.put("failureCnt"	, failureCnt + 1		);
				
					//비밀번호 실패시 비밀번호 실패 테이블에 insert
					frontMemberDao.updateLoginFailure(dbparams);
					
					if(null != records.get("authNumber")){
						// 이메일주소 암호화
						String encodeEmail = BASE64Util.encodeString(id); ; // 이메일 암호화
						rmap.put(Const.D_SCRIPT, Util.jsmsgLink("비밀번호가 일치하지 않습니다.", "/member/login.do?form=auth&"+encodeEmail+"&alertView=t&Message=6", "T"));
					}else{
						rmap.put(Const.D_SCRIPT, Util.jsmsgLink("비밀번호가 일치하지 않습니다.", "/member/login.do?alertView=t&Message=6", "T"));	
					}
					return false;
				}else{
					// 로그인 성공시 실패횟수 초기화 -> 삭제로 로직 변경
					dbparams.put("memberNo"	    , memberNo        		);
					frontMemberDao.deleteLoginFailure(dbparams);
					
					// 인증기간내에 인증시도한 경우 인증번호 삭제
					if(null != records.get("authNumber") && 0 <= timeCampare){ 

					//인증번호 삭제
					frontMemberDao.loginAuthNumberDelete(dbparams);
					}
				}
			}

			sm.setmemberNo(memberNo);
			sm.setmemberName(memberName);
			sm.setmemberEmail(memberEmail);
			
			HttpSession session = request.getSession(true);
			session.setAttribute("memberNo" , memberNo);
			String userAuthToken = RandomStringUtils.randomAlphanumeric(20)+BASE64Util.encodeString(memberEmail);
			
			Device device = DeviceUtils.getCurrentDevice(request); 
			String deviceType = "";
			if(device.isMobile()){
				dbparams.put("memberNo"	    	, memberNo);
				dbparams.put("memberEmail"	    , memberEmail);
				dbparams.put("userAuthToken"   , userAuthToken);
				dbparams.put("memberPhone"	    , memberPhone);
				frontMemberDao.insertMemberAuthTokenAct(dbparams);
				rmap.put(Const.D_SCRIPT, Util.gotoURL("/main/index.do?mbrE="+memberEmail+"&userAT="+userAuthToken , ""));
			}else {
				rmap.put(Const.D_SCRIPT, Util.gotoURL("/main/index.do" , ""));
			}
			
			//아이디 저장
			if(isSaveId){
				Cookie new_cookie = new Cookie("cookieSaveId",memberEmail);
				new_cookie.setMaxAge(365*24*60*60); //1 year
				response.addCookie(new_cookie);
			}else{
				Cookie new_cookie = new Cookie("cookieSaveId","");
				new_cookie.setMaxAge(0); 
				response.addCookie(new_cookie);
			}
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rmap.put(Const.D_SCRIPT, Util.gotoURL("/main/index.do" , ""));
			return false;
		}		
		return true;
	}
	
	@Override
	public boolean logOut(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		SessionManager sm = new SessionManager(request, response);
		RPMap dbparams = new RPMap();
		dbparams.put("memberNo", sm.getmemberNo());
		try{
			//필요할 경우 접속 로그 추가 할 것
		}catch(Exception e){
			e.printStackTrace();
		}
		frontMemberDao.deleteMemberAuthToken(dbparams);
		sm.killSession();
		rmap.put(Const.D_SCRIPT, Util.gotoURL("/main/index.do" , ""));
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectRecommend(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response ) throws Exception{

		RPMap dbparams = new RPMap();
		
		try{
			dbparams.put("recommend", p.getStr("recommend"));
			int recommonCount = frontMemberDao.selectRecommend(dbparams);

			if(recommonCount == 0){
				String json = Util.printResult(2, String.format("추천인 정보가 존재하지 않습니다."), null);
				rmap.put("json", json);
				return true;
			}else{
				String json = Util.printResult(1, String.format("성공하였습니다. "), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectAuthNumberRequest(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response ) throws Exception{
	
		RPMap dbparams = new RPMap();
		
		try{
			dbparams.put("memberEmail", p.getStr("memberEmail") );
			HashMap<String,Object> userAuthInfo = frontMemberDao.selectUserInfoUseEmail(dbparams);
			
				// 인증번호 6자리 난수 생성
				String memberNo = Converter.toStr(userAuthInfo.get("memberNo"));
				String authRandomNo = Util.randomNumber();
				
				dbparams.put("memberNo"	    , memberNo        		);
				dbparams.put("authNumber"	, authRandomNo   		);
				
				//5회 실패 후 미인증시 인증번호 insert
				frontMemberDao.updateLoginAuthNumber(dbparams);
				
				JSONObject json = new JSONObject();
				JSONObject _json = new JSONObject();
				
				_json.put("code", 1);
				_json.put("msg", "성공했습니다.");
				_json.put("eof", "0");
				_json.put("authNumber", 	authRandomNo);
				
				json.put("result", _json);
				rmap.put("json", json.toString());
				return true;
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
	}	

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectAuthMember(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response ) throws Exception{
	
		RPMap dbparams = new RPMap();
		
		try{
			String decodeEmail = BASE64Util.decodeString(p.getStr("memberEmail")); 
			dbparams.put("memberEmail", decodeEmail );
			HashMap<String,Object> recommonInfo = frontMemberDao.selectAuthMember(dbparams);

			if(recommonInfo == null){
				String json = Util.printResult(0, String.format("로그인 정보가 존재하지 않습니다."), null);
				rmap.put("json", json);
				return true;
			}else{
				JSONObject json = new JSONObject();
				JSONObject _json = new JSONObject();
				
				_json.put("code", 1);
				_json.put("eof", "0");
				_json.put("memberNo", 		recommonInfo.get("memberNo"));
				_json.put("memberEmail", 	recommonInfo.get("memberEmail"));
				_json.put("authNumber", 	recommonInfo.get("authNumber"));
				
				json.put("result", _json);
				rmap.put("json", json.toString());
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}	
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean memberJoinAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{

		RPMap dbparams = new RPMap();

		try{
			// 추천인 memberNo 호출
			dbparams.put("recommenderEmail"	, p.getStr("recommend").trim()			);
			HashMap<String,Object> recommendMyinfo = frontMemberDao.selectRecommendDetail(dbparams);
			
			if(recommendMyinfo != null){
				dbparams.put("recommenderNo"	, Converter.toInt(recommendMyinfo.get("memberNo"))	);
			}
			
			// pw 암호화
			String decodepw = Util.sha(p.getStr("pwd").trim());

			//파라미터 정리
			dbparams.put("email"		, p.getStr("email").trim()				);
			dbparams.put("pwd"			, decodepw						);
			dbparams.put("name"			, p.getStr("name").trim()				);
			dbparams.put("phone"		, p.getStr("phone").trim()				);
			dbparams.put("terms"		, "on".equals(p.getStr("terms").trim()) ? "Y" : "N"	);
			dbparams.put("privacy"		, "on".equals(p.getStr("privacy").trim()) ? "Y" : "N"	);
			dbparams.put("spam"			, "on".equals(p.getStr("spam").trim()) ? "Y" : "N"	);
			dbparams.put("recommend"	, p.getStr("email").trim()				); // 이메일 중복 체크용 파라미터 

			System.out.println("회원가입 파리미터 dbparams::"+dbparams);
			if(p.getStr("email").trim() == null || p.getStr("email").trim().equals("")) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false; 
			}
			
			if(p.getStr("pwd").trim() == null || p.getStr("pwd").trim().equals("")) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false;
			}
			
			if(p.getStr("name").trim() == null || p.getStr("name").trim().equals("")) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false;
			}
			
			if(p.getStr("phone").trim() == null || p.getStr("phone").trim().equals("")) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false;
			}
			
			// 이메일 중복 체크
			int memberEmailDuplicate = frontMemberDao.selectMemberEmailDup(dbparams);
			if(memberEmailDuplicate > 0){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이미 가입한 이메일입니다.", "/member/join.do?alertView=t&Message=2", "T"));
				return false;
			}
			
			frontMemberDao.insertJoinAct(dbparams);
			
			//회원가입후 memberNo갑슬 가져오기 위해 추가
			int memberNo = frontMemberDao.selectMemberNo(dbparams);
			dbparams.put("memberNo"		, memberNo );
			frontMemberDao.insertGreenAct(dbparams);
			frontMemberDao.insertRedAct(dbparams);
			
			Cookie joinCookie = new Cookie("joinCookie","T");
			joinCookie.setMaxAge(7); 
			joinCookie.setPath("/");     
			response.addCookie(joinCookie);
			Date today = new Date();
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
			String mail_date = date.format(today);
		    String mail_name = p.getStr("name").trim().toString();
		    String mail_email = BASE64Util.encodeString(p.getStr("email").trim());
		    
			String[] url=request.getRequestURL().toString().split(request.getRequestURI());
			String mail_sign = "<a href ="+url[0]+"/member/email_sign_act.do?memberEmail='"+mail_email+"' target ='_blank'>";
		    
			/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			email.setSubject("회원가입 완료되었습니다.");
		    email.setReceiver(p.getStr("email").trim());
		    email.setVeloTemplate("mail_emailconfirm.vm");
		    dbparams.put("mail_name", mail_name);
		    dbparams.put("mail_date", mail_date);
		    dbparams.put("mail_sign", mail_sign);
		    email.setEmailMap(dbparams);
		    email.setHtmlYn("Y");  
		    emailSender.sendVelocityEmail(email);   
		    /*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
		    
		    rmap.put(Const.D_SCRIPT, Util.gotoURL("/main/index.do" , ""));
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
	}

	@Override
	public boolean mypageMyinfo(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		SessionManager sm = new SessionManager(request, response);
		dbparams.put("memberNo", sm.getmemberNo());
		try{
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
			
			HashMap<String,Object> membershipRequestPaymentStatus = frontMemberDao.selectMembershipRequestPaymentStatus(dbparams); //정회원 신청여부
			
			if( mypageMyinfo == null ) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false;
			}
			String recoMemberEmail = null;
			if(mypageMyinfo.get("recommenderNo") != null) {
				dbparams.put("recommenderNo", Converter.toInt( mypageMyinfo.get("recommenderNo") ) );
				recoMemberEmail = frontMemberDao.recommenderNo(dbparams);
			}
			if(recoMemberEmail != null) {
				mypageMyinfo.put("recoMemberEmail", recoMemberEmail);
			}
			rmap.put("mypageMyinfo", mypageMyinfo);
			ArrayList<HashMap<String, Object>> selectCompanyBankList = frontMemberDao.selectCompanyBankList(dbparams);
			rmap.put("selectCompanyBankList", selectCompanyBankList);
			rmap.put("membershipRequestPaymentStatus", membershipRequestPaymentStatus);
			
			HashMap<String,Object> memberTypeInfo = frontMemberDao.selectmemberTypeInfo(dbparams); //회원 타입 조회
			rmap.put("memberTypeInfo", memberTypeInfo);
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
		return true;
	}	
	
	@Override
	public boolean myinfoConfirm(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		
		SessionManager sm = new SessionManager(request, response);
		dbparams.put("memberNo", sm.getmemberNo());
		try{
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
			if( mypageMyinfo == null ) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false;
			}
			rmap.put("mypageMyinfo", mypageMyinfo);
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
		return true;
	}	
	
	@Override
	public boolean myinfoConfirmModify(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{

		SessionManager sm = new SessionManager(request, response);
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		int pwd = p.getInt("pwd");
		dbparams.put("memberNo", sm.getmemberNo());

		try{
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);

			String recoMemberEmail = null;
			if(mypageMyinfo.get("recommenderNo") != null) {
				dbparams.put("recommenderNo", Converter.toInt( mypageMyinfo.get("recommenderNo") ) );
				recoMemberEmail = frontMemberDao.recommenderNo(dbparams);
			}
			if(recoMemberEmail != null) {
				mypageMyinfo.put("recoMemberEmail", recoMemberEmail);
			}
			rmap.put("mypageMyinfo", mypageMyinfo);
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
		return true;
	}	
	
	
	@Override
	public boolean myinfoConfirmModifyCheck(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		SessionManager sm = new SessionManager(request, response);
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		int pwd = p.getInt("pwd");
		dbparams.put("memberNo", sm.getmemberNo());
		try{
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
			String decodepw = Util.sha(p.getStr("pwd").trim().toString());
			String memberPass = Converter.toStr(mypageMyinfo.get("memberPassword").toString());
			
			if(!(memberPass.equals(decodepw))) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("비밀번호가 맞지 않습니다.", "/mypage/mypage_myinfo_confirm.do?alertView=t&Message=1", "T"));
				return false;
			}
			
			String recoMemberEmail = null;
			if(mypageMyinfo.get("recommenderNo") != null) {
				dbparams.put("recommenderNo", Converter.toInt( mypageMyinfo.get("recommenderNo") ) );
				recoMemberEmail = frontMemberDao.recommenderNo(dbparams);
			}
			if(recoMemberEmail != null) {
				mypageMyinfo.put("recoMemberEmail", recoMemberEmail);
			}
			rmap.put("mypageMyinfo", mypageMyinfo);
			rmap.put(Const.D_SCRIPT, Util.gotoURL("/mypage/mypage_myinfo_modify.do", "T"));
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	
	@Override
	public boolean memberUpdateAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		SessionManager sm = new SessionManager(request, response);
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		String oriMemberPassword = null;
		int oriRecommenderNo = 0;
		String oriMemberPhone = null;
		String NewMemberPassword = null;
		int NewRecommenderNo = 0;
		String NewMemberPhone = null;
		
		try{
			dbparams.put("memberNo", sm.getmemberNo());
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
			if(mypageMyinfo!= null) {
				oriMemberPassword = Converter.toStr(mypageMyinfo.get("memberPassword").toString());
				if(mypageMyinfo.get("memberPhone") != null) {
					oriRecommenderNo = Converter.toInt(mypageMyinfo.get("recommenderNo"));
				}else {
					oriRecommenderNo = 0;
				}
				oriMemberPhone = Converter.toStr(mypageMyinfo.get("memberPhone"));
			}
			
			dbparams.put("recommenderEmail"	, p.getStr("recommend").trim());
			HashMap<String,Object> recommendMyinfo = frontMemberDao.selectRecommendDetail(dbparams);
			if (recommendMyinfo != null){
				dbparams.put("recommenderNo", Converter.toInt(recommendMyinfo.get("memberNo")));
				if(Converter.toInt(recommendMyinfo.get("memberNo")) != null) {
					NewRecommenderNo = Converter.toInt(recommendMyinfo.get("memberNo"));
				}else{
					NewRecommenderNo = 0;
				}
			}
	
			String decodepw = Util.sha(p.getStr("pwd").trim().toString());
			NewMemberPassword = decodepw;
			NewMemberPhone = p.getStr("phone").trim();
			String mail_password = null;
			String mail_recomm = null;
			if(!oriMemberPassword.equals(NewMemberPassword)){
				mail_password = "<li>비밀번호 : "+p.getStr("pwd").trim()+"</li>";
				 dbparams.put("mail_password", mail_password);
				 dbparams.put("mail_password_text", "비밀번호");
			}else {
				 dbparams.put("mail_password", "");
				 dbparams.put("mail_password_text", "");
			}
			
			if(oriRecommenderNo != NewRecommenderNo){
				mail_recomm = "<li>추천인 : "+p.getStr("recommend").trim()+"</li>";
				dbparams.put("mail_recomm", mail_recomm);
				if(mail_password!=null) {
					dbparams.put("mail_recomm_text", ", 추천인");
				}else {
					dbparams.put("mail_recomm_text", "추천인");
				}
			}else {
				 dbparams.put("mail_recomm", "");
				 dbparams.put("mail_recomm_text", "");
			}
			
			if(!oriMemberPhone.equals(NewMemberPhone)){
				String mail_phone = "<li>핸드폰번호 : "+NewMemberPhone+"</li>";
				dbparams.put("mail_phone", mail_phone);
				if(mail_recomm != null || mail_password != null) {
					dbparams.put("mail_phone_text", ", 핸드폰번호");
				}else {
					dbparams.put("mail_phone_text", "핸드폰번호");
				}
			}else {
				dbparams.put("mail_phone", "");
				dbparams.put("mail_phone_text", "");
			}
			
			dbparams.put("memberPassword"	, decodepw						);
			dbparams.put("memberPhone"		, p.getStr("phone").trim()			);
			dbparams.put("memberNo", sm.getmemberNo());
			frontMemberDao.updateUser(dbparams);
			
			String[] url=request.getRequestURL().toString().split(request.getRequestURI());
			String mail_sign = "<a href ="+url[0]+"/member/login.do target ='_blank'>";
			
			/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
		    email.setSubject("회원님께서 수정하신 정보를 보내드립니다.");
		    email.setReceiver(mypageMyinfo.get("memberEmail").toString());
			email.setHtmlYn("Y");
		    email.setVeloTemplate("mail_infomodify.vm");
			dbparams.put("mail_sign", mail_sign);
		    email.setEmailMap(dbparams);
		    emailSender.sendVelocityEmail(email);     
		    /*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */

			rmap.put(Const.D_SCRIPT, Util.gotoURL("/mypage/newpoint.do", "T"));
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}	
	 return true;
	}
	
	@Override
	public boolean emailSignAct(String emailSignAct, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		SessionManager sm = new SessionManager(request, response);
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		dbparams.put("memberEmail", BASE64Util.decodeString(emailSignAct).toString().trim());
		
		try{
			int emailSignCount = frontMemberDao.selectEmailSignSuccessCount(dbparams);
			if(emailSignCount > 0){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일 인증이 완료된 고객입니다.", "/main/index.do?alertView=t&Message=2", "T"));
				return false;
			}
			frontMemberDao.updateUserMemberStatus(dbparams);
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일 인증완료되었습니다.", "/main/index.do?alertView=t&Message=3", "T"));
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return false;
		}	
	 return true;
	}	
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean findEmailAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		RPMap dbparams = new RPMap();

		String memberName = p.getStr("memberName");
		dbparams.put("memberName", memberName);
		
		String memberPhone = p.getStr("memberPhone");
		dbparams.put("memberPhone", memberPhone);
		
		try{
			HashMap<String,Object> userInfos = frontMemberDao.selectFindUserEmailAct(dbparams);
			if(userInfos !=null && !userInfos.isEmpty()){
			    String memberEmail = Converter.toStr(userInfos.get("memberEmail"));
			    
				String[] url=request.getRequestURL().toString().split(request.getRequestURI());
				String mail_sign = "<a href ="+url[0]+"/member/login.do target ='_blank'>";
			    
				/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			    email.setSubject("가입된 이메일을 보내드립니다.");
			    email.setReceiver(memberEmail);
			    email.setVeloTemplate("mail_findemail.vm");
			    dbparams.put("mail_sign", mail_sign);
			    dbparams.put("mail_email", memberEmail);
			    email.setEmailMap(dbparams);
				email.setHtmlYn("Y");
			    emailSender.sendVelocityEmail(email);
			    /*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			    Cookie emailViewCookie = new Cookie("emailViewCookie","T");
			    emailViewCookie.setMaxAge(6); 
			    emailViewCookie.setPath("/");     
				response.addCookie(emailViewCookie);
			    
			    rmap.put(Const.D_SCRIPT, Util.jsmsgLink("가입하신 이메일로 발송이 완료되었습니다.", "/member/find_email.do?memberEmail="+memberEmail+"&alertView=t&Message=1", "T"));
			}else{
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일이 존재하지 않습니다.", "/member/find_email.do?alertView=t&Message=2", "T"));
				return false;
			}
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
	}	
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean findPwAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{

		RPMap dbparams = new RPMap();
		String memberEmail = p.getStr("email");
		dbparams.put("memberEmail", memberEmail);
		
		try{
			HashMap<String,Object> userInfos = frontMemberDao.selectFindEmailAct(dbparams);
			String memberStatus = "";
			if(userInfos !=null && !userInfos.isEmpty()){
				memberStatus = Converter.toStr(userInfos.get("memberStatus"));
				if("3".equals(memberStatus)){
					rmap.put(Const.D_SCRIPT, Util.jsmsgLink("미인증 고객입니다. 이메일인증완료후 사용해주세요.", "/main/index.do?alertView=t&Message=4", "T"));
					return true;
				}
				
				// 8자리 소문자,숫자 난수
				StringBuffer rendomPw = Util.randomNumberLower();
				// pw 암호화
				String decodePw = Util.sha(rendomPw.toString());
				int memberNo = Converter.toInt(userInfos.get("memberNo"));
				
				dbparams.put("memberNo", memberNo);
				dbparams.put("tempPassword", decodePw);
				
				//임시비밀번호 업데이트
				frontMemberDao.updateTempPw(dbparams);
				memberEmail = Converter.toStr(userInfos.get("memberEmail"));
				String pw = rendomPw.toString();
				String[] url=request.getRequestURL().toString().split(request.getRequestURI());
				String mail_sign = "<a href ="+url[0]+"/member/login.do target ='_blank'>";
				
				/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
				email.setSubject("회원님께서 요청하신 비밀번호를 보내드립니다.");
				email.setReceiver(memberEmail);
				email.setVeloTemplate("mail_findpw.vm");
			    dbparams.put("mail_pw", pw);
			    dbparams.put("mail_sign", mail_sign);
			    dbparams.put("mail_email", memberEmail);
			    email.setEmailMap(dbparams);
				email.setHtmlYn("Y");                         
			    emailSender.sendVelocityEmail(email);
			    /*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			    rmap.put(Const.D_SCRIPT, Util.jsmsgLink("가입하신 이메일로 발송이 완료되었습니다.", "/member/find_pw.do?alertView=t&Message=1", "T"));
			}else{
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일이 존재하지 않습니다.", "/member/find_pw.do?alertView=t&Message=2", "T"));
				return false;
			}
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectMemberValidity(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		RPMap dbparams = new RPMap();
		
		try{
			dbparams.put("memberEmail", p.getStr("email"));
			int memberValidity = frontMemberDao.selectMemberJoinCount(dbparams);
			
			if(memberValidity > 0){
				String json = Util.printResult(2, String.format("중복된 회원정보가 존재합니다."), null);
				rmap.put("json", json);
				return true;
			}else{
				String json = Util.printResult(1, String.format("성공하였습니다."), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectPhoneOverlap(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		RPMap dbparams = new RPMap();
		
		try{
			dbparams.put("memberPhone", p.getStr("memberPhone"));
			int memberValidity = frontMemberDao.selectMemberPhoneOverlapCount(dbparams);
			
			if(memberValidity > 0){
				String json = Util.printResult(2, String.format("중복된 회원정보가 존재합니다."), null);
				rmap.put("json", json);
				return true;
			}else{
				String json = Util.printResult(1, String.format("성공하였습니다."), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean memberEmailConfirmAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		RPMap dbparams = new RPMap();
		String memberEmail = p.getStr("memberEmail"); 
		String memberNo = p.getStr("memberNo"); 
		SessionManager sm = new SessionManager(request, response);
		
		try{
			if(memberEmail != null){
				dbparams.put("memberNo", memberNo);
				dbparams.put("memberEmail", memberEmail);
				HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
				
				
				String createTime = mypageMyinfo.get("createTime2").toString();
				
				/* 변경: 현재시간->가입당시시간
				Date today = new Date();
				SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
				String mail_date = date.format(today);*/
							
				HashMap<String,Object> userInfos = frontMemberDao.selectFindEmailAct(dbparams);
			    String mail_name = userInfos.get("memberName").toString();
			    String mail_email = BASE64Util.encodeString(p.getStr("memberEmail").trim()); 
				String[] url=request.getRequestURL().toString().split(request.getRequestURI());
			    String mail_sign = "<a href ="+url[0]+"/member/email_sign_act.do?memberEmail='"+mail_email+"' target ='_blank'>";
			    String mail_date = createTime;
			    
				/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
				email.setHtmlYn("Y");                           
			    email.setReceiver(memberEmail);
			    email.setSubject("본인 인증하기 이메일입니다.");
			    email.setVeloTemplate("mail_emailconfirm.vm");
			    dbparams.put("mail_name", mail_name);
			    dbparams.put("mail_date", mail_date);
			    dbparams.put("mail_sign", mail_sign);
			    email.setEmailMap(dbparams);
			    emailSender.sendVelocityEmail(email);
			    /*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			    
			    String json = Util.printResult(1, String.format("발송완료 되었습니다."), null);//주석처리해도 될듯, 페이지에서 리로드
				rmap.put("json", json);
			}else{
				String json = Util.printResult(1, String.format("회원정보를 확인해주시길 바랍니다."), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean regularMemberAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{

		RPMap dbparams = new RPMap();
		SessionManager sm = new SessionManager(request, response);
		
		try{
			dbparams.put("memberNo", sm.getmemberNo());
			int memberShipReqCount = frontMemberDao.selectMemberShipReq(dbparams);
			
			if(memberShipReqCount > 0){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이미 정회원 신청을 하셨습니다.", "/mypage/mypage_myinfo.do?alertView=t&Message=1", "T"));
				return false;
			}
			
			String memberName = p.getStr("m_name");
			dbparams.put("BankAccountNo", p.getStr("m_bank"));
			HashMap<String, Object> selectCompanyBankAccount = frontMemberDao.selectCompanyBankAccount(dbparams);
			dbparams.put("bankName", selectCompanyBankAccount.get("bankName"));
			dbparams.put("bankOwnerName", selectCompanyBankAccount.get("bankOwnerName"));
			dbparams.put("bankAccount", selectCompanyBankAccount.get("bankAccount"));
			dbparams.put("memberName", p.getStr("m_name"));
			dbparams.put("BankAccountNo", p.getStr("m_bank"));
			
			HashMap<String, Object> selectPolicyMembershipTransLimit = frontMemberDao.selectPolicyMembershipTransLimit(dbparams);
			dbparams.put("paymentAmount", selectPolicyMembershipTransLimit.get("membershipTransLimit"));
			dbparams.put("companyBankAccountNo", p.getStr("m_bank"));
			frontMemberDao.insertMembershipRequest(dbparams);
			
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
			
			dbparams.put("memberName", mypageMyinfo.get("memberName"));
			dbparams.put("memberEmail", mypageMyinfo.get("memberEmail"));
			dbparams.put("memberNameDepo", memberName);
			
			String[] url=request.getRequestURL().toString().split(request.getRequestURI());
			String mail_sign = "<a href ="+url[0]+"/member/login.do target ='_blank'>";
			
			/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			email.setSubject("정회원 신청 정보를 보내드립니다.");
			email.setReceiver(mypageMyinfo.get("memberEmail").toString());
			email.setVeloTemplate("mail_fullmember.vm");
			dbparams.put("mail_sign", mail_sign);
			email.setEmailMap(dbparams);
			email.setHtmlYn("Y");
			emailSender.sendVelocityEmail(email);  
			/*send email ->계정:gmail, 운영 반영시에 실제사용값으로 수정요청드립니다.(참고파일: root-context.xml) */
			
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("가입하신 이메일로 발송이 완료되었습니다.", "/main/index.do?alertView=t&Message=5", "T"));
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
	}
	
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean memberOutAct(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response ) throws Exception {
		
		SessionManager sm = new SessionManager(request, response);
		RPMap dbparams = new RPMap();

		String pwd = p.getStr("pwd");
		String memberEmail = p.getStr("memberEmail");
		String memberPassword = "";
		int memberNo = 0 ;
		dbparams.put("memberNo", sm.getmemberNo());
		dbparams.put("memberEmail", memberEmail);
		dbparams.put("pwd", pwd);
		
		try{
			HashMap<String,Object> myinfo = frontMemberDao.selectMyinfoCheck(dbparams);
			
			if(myinfo !=null && !myinfo.isEmpty()){
				memberNo = Converter.toInt(myinfo.get("memberNo"));
				memberPassword = Converter.toStr(myinfo.get("memberPassword"));
			} 

			if(memberNo <= 0){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일 또는 비밀번호가 일치하지 않습니다.", "/mypage/mypage_out.do?alertView=t&Message=1", "T"));
				return false;
			}
			
			// 암호 비교
			if(!memberPassword.equals(Util.sha(pwd))){
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("이메일 또는 비밀번호가 일치하지 않습니다.", "/mypage/mypage_out.do?alertView=t&Message=1", "T"));
				return false ;
			}
			
			dbparams.put("memberNo"	        	, myinfo.get("memberNo")              		);
			dbparams.put("memberStatus"			, "6"						); //사용자 자발 탈퇴

			frontMemberDao.memberOutAct(dbparams);
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("탈퇴되었습니다.", "/main/index.do?form=out&", "T"));
			sm.killSession();
		
		}catch(Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return true;
		
	}
	
	@Override
	public boolean myinfoCheck(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		HashMap<String, Object> dbparams = new HashMap<String, Object>();
		
		SessionManager sm = new SessionManager(request, response);
		dbparams.put("memberNo", sm.getmemberNo());
		try{
			HashMap<String,Object> mypageMyinfo = frontMemberDao.selectMypageMyinfo(dbparams);
			if( mypageMyinfo == null ) {
				rmap.put(Const.D_SCRIPT, Util.jsmsgLink("잘못된 경로입니다.", "/main/index.do?alertView=t&Message=1", "T"));
				return false;
			}
			rmap.put("mypageMyinfo", mypageMyinfo);
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectPolicyPointTransLimit(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response ) throws Exception{
		RPMap dbparams = new RPMap();
		try{
			//dbparams.put("pointtranslimit", p.getStr("pointtranslimit"));
			HashMap<String,Object> policy = frontMemberDao.selectPolicyPointTranslimit(dbparams);
			
			JSONArray json_arr = new JSONArray();
			JSONObject obj = new JSONObject();
			obj.put("pointTransLimit", policy.get("pointTransLimit"));
			obj.put("rPointMovingMinLimit", policy.get("rPointMovingMinLimit"));
			obj.put("rPointMovingMaxLimit", policy.get("rPointMovingMaxLimit"));
			obj.put("gPointMovingMinLimit", policy.get("gPointMovingMinLimit"));
			obj.put("gPointMovingMaxLimit", policy.get("gPointMovingMaxLimit"));
			json_arr.add(obj);
			
			JSONObject json = new JSONObject();
			json.put("result", 1);
			json.put("json_arr", json_arr);
			rmap.put(Const.D_JSON, json.toString());
			return true;
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectMemberEmailInfo(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		RPMap dbparams = new RPMap();
		SessionManager sm = new SessionManager(request, response);
		dbparams.put("memberNo", sm.getmemberNo());
		
		try{
			dbparams.put("memberEmail", p.getStr("memberEmail"));
			int memberValidity = frontMemberDao.selectMemberInfo(dbparams);
			
			if(memberValidity == 1){
				String json = Util.printResult(1, String.format("성공하였습니다."), null);
				rmap.put("json", json);
				return true;
			}else{
				String json = Util.printResult(2, String.format("실패하였습니다. 정확한 이메일주소를 입력해주세요."), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectQrSelectMemberPhoneInfo(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		RPMap dbparams = new RPMap();
		SessionManager sm = new SessionManager(request, response);
		
		try{
			dbparams.put("memberPhone", p.getStr("memberPhone"));
			int qrmemberPhone = frontMemberDao.selectqrMemberPhone(dbparams);
			
			if(qrmemberPhone > 0){
				String json = Util.printResult(1, String.format("회원님은 이미 회원가입이 되어 계십니다. 로그인을 해주세요."), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean selectPhoneOverlapModify(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response) throws Exception{
	
		RPMap dbparams = new RPMap();
		SessionManager sm = new SessionManager(request, response);
		try{
			dbparams.put("memberPhone", p.getStr("memberPhone"));
			dbparams.put("memberNo", sm.getmemberNo());
			
			int memberValidity = frontMemberDao.selectMemberPhoneOverlapModfiyCount(dbparams);
			
			if(memberValidity > 0){
				String json = Util.printResult(2, String.format("중복된 회원정보가 존재합니다."), null);
				rmap.put("json", json);
				return true;
			}else{
				String json = Util.printResult(1, String.format("성공하였습니다."), null);
				rmap.put("json", json);
				return true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})
	public boolean updatePaymentStatus(RPMap p, RPMap rmap, HttpServletRequest request, HttpServletResponse response ) throws Exception{
		RPMap dbparams = new RPMap();
		SessionManager sm = new SessionManager(request, response);
		
		try{
			dbparams.put("memberNo", sm.getmemberNo());
			frontMemberDao.updatePaymentStatusRequestCon(dbparams);
			rmap.put(Const.D_SCRIPT, Util.jsmsgLink("성공하였습니다.", "/mypage/mypage_myinfo.do?alertView=t&Message=2", "T"));
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
}