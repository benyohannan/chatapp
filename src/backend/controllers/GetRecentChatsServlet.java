package backend.controllers;

import backend.services.ConversationService;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/get-recent-chats")
public class GetRecentChatsServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");

        if (username == null || username.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Username is required\"}");
            return;
        }

        try {
            // Fetch recent conversations
            List<Document> conversations = conversationService.getRecentConversations(username);

            // Format the response as JSON
            StringBuilder jsonResponse = new StringBuilder("[");
            boolean first = true;

            for (Document conversation : conversations) {
                @SuppressWarnings("unchecked")
                List<String> participants = (List<String>) conversation.get("participants");
                String otherParticipant = conversationService.getOtherParticipant(participants, username);

                if (otherParticipant != null) {
                    if (!first) jsonResponse.append(",");
                    
                    String conversationId = conversation.getObjectId("_id") != null ? 
                        conversation.getObjectId("_id").toString() : "";
                    String lastMessage = conversation.getString("lastMessage") != null ? 
                        conversation.getString("lastMessage") : "";
                    String lastMessageTime = conversation.getString("lastMessageTime") != null ? 
                        conversation.getString("lastMessageTime") : "";
                    boolean isGroupChat = conversation.getBoolean("isGroupChat", false);

                    jsonResponse.append("{")
                        .append("\"conversationId\":\"").append(escapeJson(conversationId)).append("\",")
                        .append("\"username\":\"").append(escapeJson(otherParticipant)).append("\",")
                        .append("\"lastMessage\":\"").append(escapeJson(lastMessage)).append("\",")
                        .append("\"lastMessageTime\":\"").append(escapeJson(lastMessageTime)).append("\",")
                        .append("\"isGroupChat\":").append(isGroupChat)
                        .append("}");
                    
                    first = false;
                }
            }

            jsonResponse.append("]");

            // Return JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            out.write(jsonResponse.toString());
            out.flush();

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // Helper method to escape special characters for JSON
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}
