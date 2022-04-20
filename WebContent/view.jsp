<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		String name = request.getParameter("name"); // name파라미터로 받아온 게시판 이름을 name에 넣어준다.
	
		/* userID에 세션값 userID를 넣고 null이면 null을 넣음*/
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
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
			script.println("location.href = 'forum.jsp?name=" + name + "'");
			script.println("</script>");
		}
		
		Forum forum = new ForumDAO().getForum(ID, name); // forum에 현재 게시판과 글ID에 맞는 글 내용을 입력
	%>

	<!------------------------- 게시판 글 view 폼 ---------------------------------->
	<div class="container">
		<div class="row">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeee; text-align: center;">글 보기 </th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;"> 글 제목 </td>
							<td colspan="2"><%= forum.getTitle() %></td>
						</tr>
						<tr>
							<td>작성자</td>	
							<td colspan="2"><%= forum.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일</td>	
							<td colspan="2"><%= forum.getDate().substring(0, 11) + forum.getDate().substring(11, 13) + "시"
							+ forum.getDate().substring(14, 16) + "분"%></td>
						</tr>
						<tr>
							<td>내용</td>	
							<td colspan="2" style="min-height: 200px; text-align: left;"><%= forum.getContent() %></td>
						</tr>
					</tbody>
				</table>	
				
				<!-- 목록 버튼 -->
				<a href = "forum.jsp?name=<%=name %>" class="btn btn-primary">목록</a>
				
				<!-- 수정/삭제 버튼(글 작성자 본일일때만 나오게 설정) -->
				<%if(userID != null && userID.equals(forum.getUserID())){%>
					<a href="update.jsp?ID=<%= ID %>&name=<%=name %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?ID=<%=ID %>&name=<%=name %>" class="btn btn-primary">삭제</a>
				<%}%>
		</div>
	</div>
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>