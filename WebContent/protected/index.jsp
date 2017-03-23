<%@page import="java.net.URLEncoder"%>
<%@page import="org.jasig.cas.client.util.AssertionHolder"%>
<%@page import="org.jasig.cas.client.validation.Assertion"%>
<%@page import="java.util.Map"%>
<%@page import="org.jasig.cas.client.authentication.AttributePrincipal"%>
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
<title>登录访问页面</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/main.css">
</head>
<body>
<jsp:include page="/include_header.jsp" />
<h2>登陆访问页面</h2>

<h3>Attribute获取</h3>
<p>
	用户名：<br>
	<%= request.getRemoteUser()== null ? "null" : request.getRemoteUser() %>
</p>
<p>
	其他信息：
	<br><br>1. request获取：<br>
	<%
	AttributePrincipal principal = (AttributePrincipal) request.getUserPrincipal();
	Map attributes = principal.getAttributes();
	%>
	<%= attributes %>
	
	<br><br>2. session获取：<br>
	<%=((Assertion)session.getAttribute("_const_cas_assertion_")).getPrincipal().getAttributes()%>
	
	<br><br>3. AssertionHolder获取：<br>
	如果设置了AssertionThreadLocalFilter，就可以通过AssertionHolder获取Attribute<br>
	<%=AssertionHolder.getAssertion().getPrincipal().getAttributes() %>
</p>

<p><a href="<%= request.getContextPath() %>">公共访问页面</a></p>
<p><a href="../logout.jsp">退出当前应用</a></p>
<p><a href="http://localhost:8080/cas/logout?service=<%= URLEncoder.encode("http://localhost:8081"+request.getContextPath(),"utf-8") %>">
	退出所有应用</a>（需要使用cas service部署包才能退出后重定向会当前应用，还需要更改service的值为登出后跳转的地址）</p>

<jsp:include page="/include_footer.jsp" />
</body>
</html>