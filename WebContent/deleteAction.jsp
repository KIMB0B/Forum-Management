<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="forum.ForumDAO"%>
<%@ page import="forum.Forum"%>
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
		String name = request.getParameter("name"); // name파라미터로 받아온 게시판 이름을 name에 넣어준다.
	
		/* userID이름의 세션이 null이 아니면 userID에 넣어주고 null이면 로그인 하도록 함. */
		String userID = null;
		if (session.getAttribute("userID") != null) { 
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 
		
		/* 게시판글ID값으로 받은 파라미터값을 변수 ID에 넣어주고 null이면 게시판forum.jsp로 돌아감 */
		int ID = 0;
		if(request.getParameter("ID") != null){ // 게시판글ID값이 파라미터
			ID = Integer.parseInt(request.getParameter("ID"));
		}
		if(ID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글 입니다')");
			script.println("location.href='forum.jsp?name=" + name + "'");
			script.println("</script>");
		}
		
		/* 글 작성자의 userID와 현재 userID가 같지 않으면 권한이 없으므로 forum.jsp로 돌아가고 아니면 삭제 실행 */
		Forum forum = new ForumDAO().getForum(ID, name);
		if(!userID.equals(forum.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href='forum.jsp?name=" + name + "'");
			script.println("</script>");			
		}
		else{
			ForumDAO forumDAO = new ForumDAO();
			int result = forumDAO.delete(ID, name);
			if (result == -1) { // 데이터베이스 오류로 인한 실패
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 삭제에 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else { // 삭제 성공
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 삭제에 성공했습니다')");
				if(name.equals("notice")) { // 공지사항일경우 삭제 manageRoom에서 하기 때문에 manageRoom으로 보냄
					script.println("location.href='manageRoom.jsp?list=3'");
				} else {
					script.println("location.href='forum.jsp?name=" + name + "'");
				}
				script.println("</script>");
			}
		}
	%>
</body>
</html>