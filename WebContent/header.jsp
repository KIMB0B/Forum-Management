<!-- 모든 사이트에서 불러올 맨 위 네비게이션바 jsp -->
<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<%
		/* userID이름의 세션이 null이 아니면 변수userID에 넣어주고 null이면 변수userID는 null이 된다. */
		/* userID가 null이 아닌 상황에서 userID와 일치하는 userDAO.sltUser()의 userName Column의 값을 userName변수에 넣는다. */
		String userID = null;
		String userName = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
			UserDAO userDAO = new UserDAO();
			String[][] user = userDAO.sltUser();
			for(int i=0; i<user.length; i++){
				if(userID.equals(user[i][0])){
					userName = user[i][2];
				}
			}
		}
	%>
	
	<!------------------------- 네비게이션  ---------------------------------->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expaned="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">JSP 게시판</a>
		</div>
		<div class="collapse navbar-collapse" id="#bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav navbar-right" style="margin-top:10px;">
				<%if (userID == null) { // 비회원일 경우 로그인창이 나오도록 설정%>
					<form class="form-inline" action="loginAction.jsp">
						<div class="form-group">
							<input type="text" class="form-control" name="userID" placeholder="아이디">
						</div>
						<div class="form-group">
							<input type="password" class="form-control" name="userPassword" placeholder="비밀번호">
						</div>
						<input type="submit" class="btn btn-primary form-control" value="로그인">
						<button type="button" class="btn btn-default" onclick="location.href='signUp.jsp'">회원가입</button>
					</form>
				<%} else { // 회원일 경우 회원의 이름과 로그아웃 버튼이 나오도록 설정%>
					환영합니다. <%=userName%>님!
					<%if (userID.equals("admin")) { // admin일 경우 manageRoom버튼이 나오도록 설정 %>
						<!-- isAdmin세션을 전달해 값을 한번 더 비교함 -->
						<%session.setAttribute("isAdmin", "YesI'mAdmin");%>
						<button type="button" class="btn btn-default" onclick="location.href='manageRoom.jsp?list=1'">Manage Room</button>
					<%}%>
					<button type="button" class="btn btn-default" onclick="location.href='logoutAction.jsp'">로그아웃</button>
				<%}%>
			</ul>
		</div>
	</nav>
</body>
</html>