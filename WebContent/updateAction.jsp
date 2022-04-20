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
		String name = request.getParameter("name");	// 게시판 이름값을 갖고있는 파라미터를 변수 name에 넣음
		
		/* userID에 세션값 userID를 넣고 null이면 null을 넣음*/
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		/* 로그인 하지 않은 경우 */
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 

		/* 변수 ID에 파라미터 ID값을 넣고 없으면 0을 넣은 후 ID값이 0이면 forum.jsp로 돌려보냄 */
		int ID = 0;
		if (request.getParameter("ID") != null) {
			ID = Integer.parseInt(request.getParameter("ID"));
		}
		if (ID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글 입니다.')");
			script.println("location.href = 'forum.jsp?name=" + name +"'");
			script.println("</script>");
		}
		
		Forum forum = new ForumDAO().getForum(ID, name);
		if (!userID.equals(forum.getUserID())) { // 본인의 글만 수정할 수 있으므로 userID값과 이 글의 userID값이 같지 않으면 forum.jsp로 돌려보냄
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'forum.jsp?name=" + name +"'");
			script.println("</script>");				
		} else {
			if (request.getParameter("Title") == null || request.getParameter("Content") == null || request.getParameter("Title").equals("") || request.getParameter("Content").equals("") ) {
			// 입력 안한 곳이 있을 경우
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				ForumDAO forumDAO = new ForumDAO();
				int result = forumDAO.update(ID, request.getParameter("Title"), request.getParameter("Content"), name);
				if (result == -1) { // 데이터베이스 오류일 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글수정에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				} else { // 글쓰기 완료할경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					if(name.equals("notice")) { // 공지사항일경우 수정은 manageRoom에서 하기 때문에 manageRoom으로 보냄
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