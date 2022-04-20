<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		session.invalidate(); // 세션을 전부 뺏어서 비회원 상태로 전환
	%>
	<script>
		location.href = 'index.jsp';
	</script>
</body>
</body>
</html>