package backend.controllers;

import backend.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/search-users")
public class SearchUsersServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        String currentUser = request.getParameter("currentUser");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        List<String> usernames = userService.searchUsersByUsername(query, currentUser, 8);

        StringBuilder json = new StringBuilder("[");
        boolean first = true;

        for (String username : usernames) {
            if (!first) {
                json.append(",");
            }
            json.append("{\"username\":\"").append(escapeJson(username)).append("\"}");
            first = false;
        }

        json.append("]");

        PrintWriter out = response.getWriter();
        out.write(json.toString());
        out.flush();
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
