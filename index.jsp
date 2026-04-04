<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("auth.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<%@ include file="frontend/includes/header.jsp" %>

<body class="light-mode">
    <div class="RainChatify-container">
    
        <%@ include file="frontend/includes/sidebar.jsp" %>
        <%@ include file="frontend/includes/chatlist.jsp" %>
        <%@ include file="frontend/includes/mainChat.jsp" %>
       
    </div>

    <%@ include file="frontend/includes/modals.jsp" %>
</body>
</html>