package backend.controllers;

import backend.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/get-user-profile")
public class GetUserProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        if (username != null) {
            username = username.trim();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (username == null || username.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"username is required\"}");
            return;
        }

        try {
            String about = userService.getUserAbout(username);
            String profilePic = userService.getUserProfilePic(username);

            StringBuilder json = new StringBuilder();
            json.append("{")
                .append("\"username\":\"").append(escapeJson(username)).append("\",")
                .append("\"about\":\"").append(escapeJson(about)).append("\",")
                .append("\"profilePic\":\"").append(escapeJson(profilePic)).append("\"")
                .append("}");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
