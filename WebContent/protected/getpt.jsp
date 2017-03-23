<%-- 
Copyright (c) 2008, Martin W. Kirst
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met: 

* Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

* Neither the name of the Martin W. Kirst nor the names of its 
  contributors may be used to endorse or promote products derived from 
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER 
OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="org.jasig.cas.client.util.AbstractCasFilter"%>
<%@page import="org.jasig.cas.client.validation.Assertion"%>
<%@page import="org.jasig.cas.client.util.AssertionHolder"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Request proxy tickets</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/main.css">
</head>
<body>
<jsp:include page="/include_header.jsp" />
<%-- ====================================================================== --%>
<h3>Get PGT from Session, Method 1</h3>
<%
	Assertion assertion1 = (Assertion) session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION);
%>
<dl>
	<dt>Principal:</dt>
	<dd><%= assertion1.getPrincipal().getName() %></dd>	
	<dt>Valid from:</dt>
	<dd><%= assertion1.getValidFromDate() %></dd>
	<dt>Valid until:</dt>
	<dd><%= assertion1.getValidUntilDate() %></dd>
	<dt>Attributes:</dt>
	<dd>
		<dl>
		<% 
			Iterator it1 = assertion1.getAttributes().entrySet().iterator();
			while (it1.hasNext()) {
				Map.Entry entry = (Map.Entry) it1.next();
				out.println("<dt>"+entry.getKey()+"</dt>");
				out.println("<dd>"+entry.getValue()+"</dd>");
			}
		%>
		</dl>
	</dd>
</dl>
<%-- ====================================================================== --%>
<h3>Get PGT from Session, Method 2</h3>
<%
	Assertion assertion2 = AssertionHolder.getAssertion();
%>
<dl>
	<dt>Principal:</dt>
	<dd><%= assertion2.getPrincipal().getName() %></dd>	
	<dt>Valid from:</dt>
	<dd><%= assertion2.getValidFromDate() %></dd>
	<dt>Valid until:</dt>
	<dd><%= assertion2.getValidUntilDate() %></dd>
	<dt>Attributes:</dt>
	<dd>
		<dl>
		<% 
			Iterator it2 = assertion2.getAttributes().entrySet().iterator();
			while (it2.hasNext()) {
				Map.Entry entry = (Map.Entry) it2.next();
				out.println("<dt>"+entry.getKey()+"</dt>");
				out.println("<dd>"+entry.getValue()+"</dd>");
			}
		%>
		</dl>
	</dd>
</dl>

<%-- ====================================================================== --%>
<h3>Fetch new proxy ticket from CAS server</h3>
<%
	String targetService = "http://otherserver/legacy/service";
	String result1 = assertion1.getPrincipal().getProxyTicketFor(targetService);
	String result2 = assertion2.getPrincipal().getProxyTicketFor(targetService);
%>
<dl>
	<dt>Valid for service:</dt>
	<dd><%= targetService %></dd>
	
	<dt>PT (from assertion 1):</dt>
	<dd><%= result1 %></dd>
	
	<dt>PT (from assertion 2):</dt>
	<dd><%= result2 %></dd>

</dl>

<h5>Hints:</h5>
<ol>
	<li>Catching a Proxy ticket twice, results in two calls. So these are two different but valid PTs with the same meaning.</li>
	<li>So you can fire up this service now, with the given proxy ticket.</li>
</ol>

<h3>Where you want to go from here?</h3>
<dl>
	<dt>Nowhere, just give me a</dt>
	<dd><a href="<%= request.getContextPath() %>/protected/getpt.jsp">new ticket</a></dd>

	<dt>You can jump back in public area</dt>
	<dd><a href="<%= request.getContextPath() %>">public area</a></dd>
	
	<dt>You can jump back in protected area</dt>
	<dd><a href="<%= request.getContextPath() %>/protected/">protected area</a></dd>
</dl>
<jsp:include page="/include_footer.jsp" />
</body>
</html>