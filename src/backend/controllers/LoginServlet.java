package backend.controllers;

import backend.database.MongoConnection;
import backend.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null) {
            username = username.trim();
        }
        if (password != null) {
            password = password.trim();
        }

        // Validate inputs
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username and password are required.");
            return;
        }

        // Authenticate user
        try {
            MongoConnection connection = new MongoConnection();
            User user = connection.findUserByUsernameOrEmail(username);

            if (user != null && user.getPassword().equals(password)) {
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);
                String resolvedUsername = user.getUsername() != null && !user.getUsername().isBlank()
                    ? user.getUsername()
                    : username;
                session.setAttribute("username", resolvedUsername);
                session.setAttribute("userId", resolvedUsername);

                request.getRequestDispatcher("/frontend/basic.jsp").forward(request, response);
                return;
            } else {
                String errorUrl = response.encodeRedirectURL(request.getContextPath() + "/auth.jsp?error=invalid_credentials");
                response.sendRedirect(errorUrl);
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errorUrl = response.encodeRedirectURL(request.getContextPath() + "/auth.jsp?error=server");
            response.sendRedirect(errorUrl);
        }
    }
}