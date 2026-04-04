<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    HttpSession session = request.getSession(false);
    if(session == null || session.getAttribute("username") == null){
        response.sendRedirect("auth.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - ChatApp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Welcome, <%= username %>!</h2>
    <p>This is your dashboard.</p>
    <form action="logout" method="post">
        <button type="submit" class="btn btn-danger">Logout</button>
    </form>
</div>
</body>
</html>