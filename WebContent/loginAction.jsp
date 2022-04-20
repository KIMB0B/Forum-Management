<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>

<!-- 한명의 회원정보를 담는 user클래스 자바 빈즈-->
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" /> 

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword()); // result변수에 login()결과 입력

		//로그인 성공
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'index.jsp'");
			script.println("</script>");
			session.setAttribute("userID", user.getUserID()); // 로그인 성공 시 userID세션을 userID값으로 설정
		}
		
		//비밀번호 불일치
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		//아이디 없음
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디 입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		// 데이터베이스 오류
		else if(result == -2){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('DB오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}		
		// 사용자 밴
		else if(result == -3){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('밴 당하셨습니다...')");
			script.println("history.back()");
			script.println("</script>");
		}	
	%>
</body>
</body>
</html>