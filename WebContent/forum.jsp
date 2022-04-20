<%@page import="javax.security.auth.callback.ConfirmationCallback"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="forum.ForumDAO"%>
<%@ page import="forum.Forum"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>jsp 게시판 웹사이트</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		String name = request.getParameter("name"); // name파라미터로 받아온 게시판 이름을 name에 넣어준다.
	
		/* userID이름의 세션이 null이 아니면 변수userID에 넣어주고 null이면 변수userID는 null이 된다. */
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		/* pageNumber파라미터값을 받았다면 변수 pageNumber에 넣어주고 아니라면 pageNumber는 1이 된다. */
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	
	<jsp:include page="/header.jsp" flush="false"/>
	
	<!--------------------------- 게시판 --------------------------->
	<h1 class="text-center"><%=name %></h1>
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
						ForumDAO forumDAO = new ForumDAO();
						ArrayList<Forum> list = forumDAO.getList(pageNumber, name);
						/* 현재 페이지의 게시판 글목록인 list의 크기만큼 반복해서 모든 글들 목록 출력 */
						for (int i = 0; i < list.size(); i++) {%>
							<tr>
								<td><%=list.get(i).getID()%></td>
								<td><a href="view.jsp?ID=<%=list.get(i).getID()%>&name=<%=name%>"><%=list.get(i).getTitle()%></a></td>
								<td><%=list.get(i).getUserID()%></td>
								<td><%=list.get(i).getDate().substring(0, 11) + list.get(i).getDate().substring(11, 13) + "시"
								+ list.get(i).getDate().substring(14, 16) + "분"%></td>
							</tr>
					<%}%>
				</tbody>
			</table>
			
			<!-- 페이지 다음/이전 버튼 -->
			<%if (pageNumber != 1) {%>
				<a href="forum.jsp?name=<%=name %>&pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arrow-left">이전</a>
			<%}
			if (forumDAO.nextPage(pageNumber + 1, name)) {%>
				<a href="forum.jsp?name=<%=name %>&pageNumber=<%=pageNumber + 1%>" class="btn btn-success pull-right">다음</a>
			<%}%>
			
			<!-- 글쓰기 버튼 -->
			<%
				if (!name.equals("notice")) { // 공지는 manageRoom에서만 작성 가능하므로 name이 notice인 forum.jsp는 글쓰기버튼이 없도록 설정
					if (session.getAttribute("userID") != null) {%>
						<br><br>
						<a href="write.jsp?name=<%=name %>" class="btn btn-primary btn-lg" style="width:100%;">글쓰기</a>
						
					<%} else { // userID세션값이 null인 비회원들에게 로그인 후 글쓰기를 하도록 login.jsp로 넘어가는 글쓰기 버튼 설정 %>
						<br><br>
						<button class="btn btn-primary btn-lg" style="width:100%;"
							onclick="if(confirm('로그인 하세요'))location.href='login.jsp';"
							type="button">글쓰기</button>
					<%}
				}
			%>
		</div>
	</div>
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>