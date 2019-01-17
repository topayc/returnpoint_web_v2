package com.returnp_web.interceptor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.LocaleEditor;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.mvc.WebContentInterceptor;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.returnp_web.svc.FrontMainService;
import com.returnp_web.utils.RPMap;

import org.springframework.web.method.HandlerMethod;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;

/**
 * The Class FrontInterceptor.
 */
@Component
public class FrontInterceptor extends HandlerInterceptorAdapter {
	
	/** The Constant logger. */
	private static final Logger logger = LoggerFactory.getLogger(FrontInterceptor.class);
	//private String paramName;
	
	/** The fcs. */
	@Autowired
	private FrontMainService fms;
	
	@Override
	public boolean preHandle(HttpServletRequest request, 
                    		 HttpServletResponse response,
                    		 Object handler) throws ServletException  {
		
		String uri = request.getRequestURI();
		String url = request.getRequestURL().toString();
		String action = url.substring(url.indexOf(".") + 1, url.length());
		
		if (logger.isDebugEnabled()){
			logger.debug("uri ==>" + uri);
			logger.debug("url ==>" + request.getRequestURL().toString());
			logger.debug("action ==>" + action);
		}
		
		Enumeration params = request.getParameterNames(); 
		/*System.out.println("----------------------------"); 
		while (params.hasMoreElements()){
			String name = (String)params.nextElement();
			System.out.println(name + " : " +request.getParameter(name)); 
		}
		System.out.println("----------------------------");*/
		
		try {
			String newLocale = request.getParameter("lang");
			if(newLocale != null){
				LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
				if(localeResolver == null){
					throw new IllegalStateException("No LocaleResolver found: not in a DispatcherServlet request?");
				}
				LocaleEditor localeEditor = new LocaleEditor();
				localeEditor.setAsText(newLocale);
				localeResolver.setLocale(request, response, (Locale) localeEditor.getValue());
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}


	@Override
	public void postHandle(HttpServletRequest request, 
                           HttpServletResponse response,
                           Object handler,
                           ModelAndView mv) throws Exception {
		HttpSession session = request.getSession(false);
		RPMap dbparams = new RPMap();
		//if(session != null) {
			String attrName ="org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE";
			Object localeValue = session.getAttribute(attrName);
			if(localeValue == null) {
				dbparams.put("langLocale", "ko");
			}else {
				dbparams.put("langLocale", localeValue.toString());
			}
		//}
		if (mv == null) return;	
		mv.addObject("SERVER_MANAGE", fms.getServerManageStatus());
		mv.addObject("FOOTER", fms.getFooter(dbparams));
	}


	@Override
	public void afterCompletion(HttpServletRequest req, 
                                HttpServletResponse res,
                                Object handler,
                                Exception ex) throws Exception {

		
	}
}
