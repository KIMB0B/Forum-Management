<%@page import="user.UserDAO"%>
<%@page import="forum.ForumDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<jsp:include page="/header.jsp" flush="false"/>
	
	<%
		request.setCharacterEncoding("UTF-8");
		ForumDAO forumDAO = new ForumDAO();
		String[] forum = forumDAO.sltForum();
		int fCount = forumDAO.count();
	%>
	
	<!-- 공지사항과 게시판의 개수 fCount만큼 반복하여 게시판 이름을 갖고, 그 게시판forum.jsp로 갈 수 있는 ul -->
	<ul class="nav navbar-nav">
		<li><a href="forum.jsp?name=notice">공지사항</a></li>
		<%for(int i=0; i<fCount; i++){ %>
			<li><a href="forum.jsp?name=<%=forum[i]%>"><%=forum[i] %></a></li>
		<%} %>
	</ul>
	
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js" type="text/javascript"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js" type="text/javascript"></script>
</body>
</html>