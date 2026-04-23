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
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-z][A-Za-z '-]{1,29}$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_]{3,20}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = trim(request.getParameter("firstName"));
        String lastName = trim(request.getParameter("lastName"));
        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");

        if (isBlank(firstName) || isBlank(lastName) || isBlank(username) || isBlank(email) || isBlank(password)) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=missing_register_fields");
            return;
        }

        if (!NAME_PATTERN.matcher(firstName).matches()) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_first_name");
            return;
        }

        if (!NAME_PATTERN.matcher(lastName).matches()) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_last_name");
            return;
        }

        if (!USERNAME_PATTERN.matcher(username).matches()) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_username");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_email");
            return;
        }

        if (password.length() < 6) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=weak_password");
            return;
        }

        MongoConnection connection = new MongoConnection();
        if (connection.findUserByUsername(username) != null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=username_taken");
            return;
        }

        if (connection.findUserByEmail(email) != null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=email_taken");
            return;
        }

        User user = new User(firstName, lastName, username, email, password);

        try {
            connection.saveUser(user);

            HttpSession session = request.getSession(true);
            session.setAttribute("username", username);
            session.setAttribute("userId", username);

            request.getRequestDispatcher("/frontend/basic.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration failed.");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
