package backend.controllers;

import backend.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/update-user-profile")
public class UpdateUserProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String sessionUsername = session != null && session.getAttribute("username") != null
                ? session.getAttribute("username").toString().trim()
                : "";

        String username = request.getParameter("username");
        String about = request.getParameter("about");
        String profilePic = request.getParameter("profilePic");

        if (username != null) {
            username = username.trim();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (sessionUsername.isEmpty() || username == null || username.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        if (!sessionUsername.equals(username)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\":\"Access denied\"}");
            return;
        }

        if (profilePic != null && profilePic.length() > 2_000_000) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Profile image is too large\"}");
            return;
        }

        try {
            boolean updated = userService.updateUserProfile(username, about, profilePic);
            if (!updated) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"User not found\"}");
                return;
            }

            response.getWriter().write("{\"success\":true}");
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
