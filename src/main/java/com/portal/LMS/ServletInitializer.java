package com.portal.LMS;

import javax.servlet.http.HttpServlet;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import com.portal.LMS.controller.VerifyAdminUsername;
import com.portal.LMS.controller.VerifyStudentUsername;

@Configuration
@ComponentScan
public class ServletInitializer extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(LmsApplication.class);
	}
	
	@Bean	
	   public ServletRegistrationBean<HttpServlet> verifyAdminUsernameServlet() {
		   ServletRegistrationBean<HttpServlet> servRegBean = new ServletRegistrationBean<>();
		   servRegBean.setServlet(new VerifyAdminUsername());
		   servRegBean.addUrlMappings("/VerifyAdminUsername");
		   servRegBean.setLoadOnStartup(1);
		   return servRegBean;
	   }
	
	@Bean	
	   public ServletRegistrationBean<HttpServlet> verifyStudentUsernameServlet() {
		   ServletRegistrationBean<HttpServlet> servRegBean = new ServletRegistrationBean<>();
		   servRegBean.setServlet(new VerifyStudentUsername());
		   servRegBean.addUrlMappings("/VerifyStudentUsername");
		   servRegBean.setLoadOnStartup(1);
		   return servRegBean;
	   }

}
