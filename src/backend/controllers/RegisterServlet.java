package backend.controllers;

import backend.database.MongoConnection;
import backend.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate inputs
        if (firstName == null || lastName == null || username == null || email == null || password == null ||
            firstName.isEmpty() || lastName.isEmpty() || username.isEmpty() || email.isEmpty() || password.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required.");
            return;
        }

        // Check if username or email already exists
        try {
            MongoConnection connection = new MongoConnection();
            if (connection.findUserByUsername(username) != null) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Username already exists.");
                return;
            }
            if (connection.findUserByEmail(email) != null) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Email already exists.");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error checking user existence.");
            return;
        }

        // Create user object
        User user = new User(firstName, lastName, username, email, password);

        // Save user to database
        try {
            MongoConnection connection = new MongoConnection();
            connection.saveUser(user);
            response.sendRedirect("frontend/basic.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration failed.");
        }
    }
}