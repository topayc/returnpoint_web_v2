package com.returnp_web.utils;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


public class SessionManager
{
	protected HttpSession session;
	protected final Log logger = LogFactory.getLog(getClass());
	
	public SessionManager(HttpServletRequest request, HttpServletResponse response)
	{
		session = request.getSession(false);
	}
	
	private int memberNo;
	private String memberName;
	private String memberEmail;
	private String memberType;
	
	public int getmemberNo(){
		return (int) session.getAttribute("memberNo");
	}
	public void setmemberNo(int memberNo){
		session.setAttribute("memberNo", memberNo);
	}

	public String getmemberName(){
		return (String)session.getAttribute("memberName");
	}
	public void setmemberName(String memberName){
		session.setAttribute("memberName", memberName);
	}
	
	public String getmemberEmail(){
		return (String)session.getAttribute("memberEmail");
	}
	public void setmemberEmail(String memberEmail){
		session.setAttribute("memberEmail", memberEmail);
	}
	
	public String getmemberType(){
		return (String)session.getAttribute("memberType");
	}
	public void setmemberType(String memberType){
		session.setAttribute("memberType", memberType);
	}
	
	public void killSession(){
		try{
			Enumeration keys = session.getAttributeNames();
			while (keys.hasMoreElements()){
				session.removeAttribute(keys.nextElement().toString());
			}
		}
		catch(Exception e) {}
	}
	
}