package backend.controllers;

import backend.services.UserService;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/recent-chats")
public class RecentChatsServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");

        if (username == null || username.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Username is required");
            return;
        }

        List<Document> recentChats = userService.getRecentChats(username);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        
        // Convert to JSON manually
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        for (Document doc : recentChats) {
            if (!first) json.append(",");
            json.append(doc.toJson());
            first = false;
        }
        json.append("]");
        
        out.write(json.toString());
        out.flush();
    }
}