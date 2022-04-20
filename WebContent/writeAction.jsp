<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="forum.ForumDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		String Title = request.getParameter("Title");
		String Content = request.getParameter("Content");
		
		/* userID에 세션값 userID를 넣고 null이면 null을 넣음*/
		String userID = null;
		if (session.getAttribute("userID") != null) { 
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) { // 로그인 하지 않은 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 
		else {
			if (Title.equals("") || Content.equals("")) { // 입력 안한 곳이 있을 경우
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				String name = request.getParameter("name"); // 게시판 이름값을 갖고있는 파라미터를 변수 name에 넣음
				ForumDAO forumDAO = new ForumDAO();
				int result = forumDAO.write(Title, userID, Content, name);
				if (result == -1) { // 데이터베이스 오류일 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				} else { // 글쓰기 완료할경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('작성이 완료되었습니다.')");
					if(name.equals("notice")) { // 공지사항일경우 작성은 manageRoom에서 하기 때문에 manageRoom으로 보냄
						script.println("location.href='manageRoom.jsp?list=3'");
					} else {
						script.println("location.href='forum.jsp?name=" + name + "'");
					}
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>