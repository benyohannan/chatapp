package backend.controllers;

import backend.database.MongoConnection;
import backend.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate inputs
        if (username == null || password == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username and password are required.");
            return;
        }

        // Authenticate user
        try {
            MongoConnection connection = new MongoConnection();
            User user = connection.findUserByUsername(username);

            if (user != null && user.getPassword().equals(password)) {
                response.sendRedirect("frontend/basic.jsp");
            } else {
                response.sendRedirect("auth.jsp?error=invalid_credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Login failed.");
        }
    }
}