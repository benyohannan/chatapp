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

        // Create user object
        User user = new User(firstName, lastName, username, email, password);

        // Save user to database
        try {
            MongoConnection connection = new MongoConnection();
            connection.saveUser(user);

            HttpSession session = request.getSession(true);
            session.setAttribute("username", username.trim());
            session.setAttribute("userId", username.trim());

            request.getRequestDispatcher("/frontend/basic.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration failed.");
        }
    }
}