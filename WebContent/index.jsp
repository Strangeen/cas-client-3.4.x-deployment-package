<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>公共访问页面</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/main.css">
</head>
<body>
	<jsp:include page="/include_header.jsp" />
	<h2>公共访问页面</h2>
	
	<p>
	cas client用于部署在应用中，与cas server交互实现单点登录功能，每个需要实现单点登录的应用均需要部署cas client。<br><br>
	出于达到对后期快速开发的目的，我在研究cas server的同时，也基于cas官方提供的client模板<br>
	client_sample_mywebapp对cas client进行配置和封装出一套部署包，<br>
	该套部署包需要与<a href="https://github.com/Strangeen/cas-server-4.2.x-deployment-package">cas server部署包</a>同时使用
	</p>
	
	<p>
		<a href="<%= request.getContextPath() %>/protected/">登陆访问</a>
	</p>
	<jsp:include page="/include_footer.jsp" />
</body>
</html>