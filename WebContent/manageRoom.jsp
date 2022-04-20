<%@page import="java.util.ArrayList"%>
<%@page import="user.UserDAO"%>
<%@page import="forum.ForumDAO"%>
<%@page import="forum.Forum"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
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
	<%
		request.setCharacterEncoding("UTF-8");
	
		UserDAO userDAO = new UserDAO();
		ForumDAO forumDAO = new ForumDAO();
		
		/* userBanned파라미터가 null이 아니면 그 값을 integer형으로 바꿔 bannum에 입력, 아니면 0으로 userUpdate에 넣음 */
		int bannum = 0;
		if(request.getParameter("userBanned") != null){
			bannum = Integer.parseInt(request.getParameter("userBanned"));
		}
		userDAO.userUpdate(request.getParameter("userID"), request.getParameter("userPassword"), request.getParameter("userName"), request.getParameter("userGender"), request.getParameter("userEmail"), bannum);
		
		/* 게시판 추가될 이름 파라미터 nforumName을 makeForum()에 넣음 */
		forumDAO.makeForum(request.getParameter("nforumName"));
		/* 게시판 수정되기전 이름 파라미터 forumoldName, 수정후 이름 forumnewName을 renameForum()에 넣음 */
		forumDAO.renameForum(request.getParameter("forumoldName"), request.getParameter("forumnewName"));
		/* 게시판 삭제될 이름 파라미터 dforumName을 deleteForum()에 넣음 */
		forumDAO.deleteForum(request.getParameter("dforumName"));
		
		int count = userDAO.count();          // 총 유져수
		String[][] user = userDAO.sltUser();  // 유져 정보담은 2차원 배열
		
		int fCount = forumDAO.count();        // 총 일반게시판의 수
		String[] forum = forumDAO.sltForum(); // 일반 게시판 이름을 담은 1차원 배열
		
		/* 공지사항탭에서 사용될 공지사항 페이지 */
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	
	<jsp:include page="/header.jsp" flush="false" />
	
	<%
	/* Manage Room 버튼을 누르지 않고 왔을 시 뒤로 돌아가게 만듬 */
	if(!session.getAttribute("isAdmin").equals("YesI'mAdmin")){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('운영자 로그인 후 들어와 주시기 바랍니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
	
	int list = Integer.parseInt(request.getParameter("list")); // list파라미터는 manageRoom의 3개의 탭을 구분지어줌
	
	%><!---------------------------------- 게시판 관리 탭 --------------------------><%
	if(list == 1){ %>
		<h3> Manage <span class="label label-default">User</span></h3><br>
		<ul class="nav nav-tabs nav-justified">
			<li role="presentation" class="active"><a href="manageRoom.jsp?list=1" style="background-color: #eeeeee;">회원 관리</a></li>
		  	<li role="presentation"><a href="manageRoom.jsp?list=2">게시판 관리</a></li>
		  	<li role="presentation"><a href="manageRoom.jsp?list=3">공지 추가</a></li>
		</ul>
		<table class="table">
			<thead>
				<tr>
					<th style="background-color: #eeeeee; text-align: center;">ID</th>
					<th style="background-color: #eeeeee; text-align: center;">Password</th>
					<th style="background-color: #eeeeee; text-align: center;">이름</th>
					<th style="background-color: #eeeeee; text-align: center;">성별</th>
					<th style="background-color: #eeeeee; text-align: center;">이메일</th>
					<th style="background-color: #eeeeee; text-align: center;">밴</th>
					<th style="background-color: #eeeeee; text-align: center;"> </th>
				</tr>
			<tbody>
			<%
				for(int i=0; i<count; i++){ // 사용자수만큼 반복하여 모든 사용자의 정보를 form의 text로 출력하면서 수정버튼으로 수정할 수 있도록 함
					int ban = Integer.parseInt(user[i][5]);
					%><tr><form method="POST" style="margin:0;">
					<!-- userID값이 전송되어야하니 hidden으로 숨기고 userID는 수정되면 안되니 input으로가 아닌 그냥 출력 -->
					<input type="hidden" class="form-control" name="userID" value="<%=user[i][0] %>">
					<th><div class="form-control"><%=user[i][0] %></div></th>
					<th><input type="text" class="form-control" name="userPassword" value="<%=user[i][1] %>"></th>
					<th><input type="text" class="form-control" name="userName" value="<%=user[i][2] %>"></th>
					<th><input type="text" class="form-control" name="userGender" value="<%=user[i][3] %>"></th>
					<th><input type="text" class="form-control" name="userEmail" value="<%=user[i][4] %>"></th>
					<!-- userBanned값이 0이 아니면 밴이니 0이 아닐때 checked로 체크되어있게 만듦  -->
					<!-- 체크되어있는 상태로 submit이 되면 i의 값이 userBanned값이 되니  -->
					<!-- 제일 위에있는 admin은 i가 0이므로 체크가 되어도 밴이 안되지만 나머지 사용자는 체크가 되면 0이상의 값이 들어가므로 밴이됨 -->
					<th><input type="checkbox" class="checkbox" name="userBanned" value="<%=i %>" <%if(ban != 0){out.print("checked");} %>></th>
					<th><input type="submit" class="btn btn-warning" value="수정"></th></form></tr>
				<%}
			%>
			</tbody>
		</table>
		
	<!---------------------------------- 게시판 관리 탭 -------------------------->
	<%}else if(list == 2){%>
		<h3> Manage <span class="label label-default">Forum</span></h3><br>
		<ul class="nav nav-tabs nav-justified">
			<li role="presentation"><a href="manageRoom.jsp?list=1">회원 관리</a></li>
		  	<li role="presentation" class="active"><a href="manageRoom.jsp?list=2" style="background-color: #eeeeee;">게시판 관리</a></li>
		  	<li role="presentation"><a href="manageRoom.jsp?list=3">공지 추가</a></li>
		</ul>
		
		<table class="table">
			<thead>
				<tr>
					<th style="background-color: #eeeeee; text-align: center;">게시판 이름</th>
					<th style="background-color: #eeeeee; text-align: center;"></th>
					<th style="background-color: #eeeeee; text-align: center;"></th>
					<th style="background-color: #eeeeee; text-align: center;"> </th>
					<th style="background-color: #eeeeee; text-align: center;"> </th>
				</tr>
			<tbody>
				<%
				for(int i=0; i<fCount; i++){ // 게시판수만큼 반복하여 모든 게시판 이름을 form의 text로 출력하면서 수정버튼으로 수정할 수 있도록 함 %>
				<tr>
					<!-- 수정 -->
					<form method="POST">
						<!-- hidden타입으로 하나 더 만들어 이전 게시판이름과 수정될 게시판이름으로 나눔 -->
						<input type="hidden" class="form-control" name="forumoldName" value="<%=forum[i]%>">
						<th><input type="text" class="form-control" name="forumnewName" value="<%=forum[i]%>"></th>
						<th></th>
						<th></th>
						<th style="float:right"><input type="submit" class="btn btn-warning" value="수정"></th>
					</form>
					<!-- 삭제 -->
					<form method="POST">
						<input type="hidden" name="dforumName" value="<%=forum[i]%>">
						<th style="float:right"><input type="submit" class="btn btn-danger" value="삭제" onclick="return confirm('정말로 삭제하시겠습니까?')"></th>
					</form>
				</tr>
				<%}%>
				<tr>
					<!-- 추가 -->
					<form method="POST">
						<th><h4 class="text-right"><strong>게시판 추가</strong></h4></th>
						<th><input type="text" class="form-control" name="nforumName" value="" placeholder="추가할 게시판 이름"></th>
						<th><input type="submit" class="btn btn-success" value="추가"></th>
					</form>
				</tr>
			</tbody>
		</table>
		
	<!---------------------------------- 공지사항 관리 탭 -------------------------->
	<%}else if(list == 3){ %>
		<h3> Manage <span class="label label-default">Notice</span></h3><br>
		<ul class="nav nav-tabs nav-justified">
			<li role="presentation"><a href="manageRoom.jsp?list=1">회원 관리</a></li>
		  	<li role="presentation"><a href="manageRoom.jsp?list=2">게시판 관리</a></li>
		  	<li role="presentation" class="active"><a href="manageRoom.jsp?list=3" style="background-color: #eeeeee;">공지 추가</a></li>
		</ul>
		<h1 class="text-center">공지</h1>
		<div class="container">
			<div class="row">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th style="background-color: #eeeeee; text-align: center;">번호</th>
							<th style="background-color: #eeeeee; text-align: center;">제목</th>
							<th style="background-color: #eeeeee; text-align: center;">작성자</th>
							<th style="background-color: #eeeeee; text-align: center;">작성일</th>
						</tr>
					</thead>
					<tbody>
						<%
							/* notice게시판 list를 불러와 nlist에 넣고 전체 글목록 출력 */
							ArrayList<Forum> nlist = forumDAO.getList(pageNumber, "notice");
							for (int i = 0; i < nlist.size(); i++) {
						%>
						<tr>
							<td><%=nlist.get(i).getID()%></td>
							<td><a href="view.jsp?ID=<%=nlist.get(i).getID()%>&name=notice"><%=nlist.get(i).getTitle()%></a></td>
							<td><%=nlist.get(i).getUserID()%></td>
							<td><%=nlist.get(i).getDate().substring(0, 11) + nlist.get(i).getDate().substring(11, 13) + "시"
							+ nlist.get(i).getDate().substring(14, 16) + "분"%></td>
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
				
				<!-- 페이지 다음/이전 버튼 -->
				<%if (pageNumber != 1) {%>
					<a href="manageRoom.jsp?list=3&pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arrow-left">이전</a>
				<%}
				if (forumDAO.nextPage(pageNumber + 1, "notice")) {%>
					<a href="manageRoom.jsp?list=3&pageNumber=<%=pageNumber + 1%>" class="btn btn-success pull-right">다음</a>
				<%}%>
				
				<!-- 글쓰기 버튼 -->
				<%if (session.getAttribute("userID") != null) {%>
					<br><br>
					<a href="write.jsp?name=notice" class="btn btn-primary btn-lg" style="width:100%;">글쓰기</a>
				<%} else {%>
					<br><br>
					<button class="btn btn-primary btn-lg" style="width:100%;"
						onclick="if(confirm('로그인 하세요'))location.href='login.jsp';"
						type="button">글쓰기</button>
				<%}%>
			</div>
		</div>
	<%} %>
	
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"
		type="text/javascript"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js" type="text/javascript"></script>
</body>
</html>