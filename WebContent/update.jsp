<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="forum.Forum"%>
<%@ page import="forum.ForumDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<jsp:include page="/header.jsp" flush="false"/>
	<%
		String name = request.getParameter("name"); // 게시판 이름값을 갖고있는 파라미터를 변수 name에 넣음
	
		/* userID에 세션값 userID를 넣고 null이면 null을 넣음*/
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		} 

		/* 로그인 하지 않은 경우 */
		if(userID == null) {
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
		
		/* 본인의 글만 수정할 수 있으므로 userID값과 이 글의 userID값이 같지 않으면 forum.jsp로 돌려보냄 */
		Forum forum = new ForumDAO().getForum(ID, name);
		if (!userID.equals(forum.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'forum.jsp?name=" + name +"'");
			script.println("</script>");				
		}
	%>

	<!----------------- 글 수정 폼 ------------------> 
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?ID=<%= ID %>&name=<%= name%>">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">글 수정 </th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" class="form-control" placeholder="글 제목" name="Title" maxlength="50" value="<%= forum.getTitle() %>" ></td>
						</tr>
						<tr>
							<td><textarea class="form-control" placeholder="글 내용" name="Content" maxlength="2048" style="height: 350px;" ><%= forum.getContent() %></textarea></td>
						</tr>
					</tbody>
				</table>	
				<button type="submit" class="btn btn-primary pull-right" >글수정</button>
			</form>
		</div>
	</div>
	
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>