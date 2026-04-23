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

    private static final int MIN_USERNAME_LENGTH = 3;
    private static final int MIN_PASSWORD_LENGTH = 6;

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

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=missing_login_fields");
            return;
        }

        if (username.length() < MIN_USERNAME_LENGTH) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_login_username");
            return;
        }

        if (password.length() < MIN_PASSWORD_LENGTH) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_login_password");
            return;
        }

        try {
            MongoConnection connection = new MongoConnection();
            String identifier = username.trim();
            User user = connection.findUserByUsernameOrEmail(identifier);

            if (user != null && user.getPassword().equals(password)) {
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);
                String resolvedUsername = user.getUsername() != null && !user.getUsername().isBlank()
                    ? user.getUsername()
                    : identifier;
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
