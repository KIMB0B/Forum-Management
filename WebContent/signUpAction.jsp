<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%request.setCharacterEncoding("UTF-8");%>

<!-- 한명의 회원정보를 담는 user클래스 자바 빈즈-->
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<jsp:setProperty name="user" property="userBanned" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
<%
	/* userID에 세션값 userID를 넣고 null이면 null을 넣음 */
	String userID = null;
	if(session.getAttribute("userID") != null ){
		userID = (String) session.getAttribute("userID");
	}
	
	/* 이미 로그인한 회원은 접속할 수 없도록 함 */
	if(userID != null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인 되어있습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");	
	}

	if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null || user.getUserGender() == null || user.getUserEmail() == null) {
	// 입력이 안된 항목이 있을 때
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} 
	else {
		UserDAO userDAO = new UserDAO();
		int result = userDAO.join(user);
		if (result == -1) { // 아이디 중복일시
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디 입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else { // 가입 성공했을시
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('회원가입이 완료되었습니다.')");
			script.println("location.href = 'index.jsp'");
			script.println("</script>");
		}
	}
%>
</body>
</html>