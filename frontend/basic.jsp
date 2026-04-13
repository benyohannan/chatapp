<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    jakarta.servlet.http.HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/auth.jsp"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<%@ include file="includes/header.jsp" %>
<body class="light-mode">
    <div class="RainChatify-container">
 
    
        <%@ include file="includes/sidebar.jsp" %>
        <%@ include file="includes/chatlist.jsp" %>
        <%@ include file="includes/mainChat.jsp" %>
       
    </div>
    <%@ include file="includes/modals.jsp" %>
    <%@ include file="includes/groupchat.jsp" %>
</body>
</html>