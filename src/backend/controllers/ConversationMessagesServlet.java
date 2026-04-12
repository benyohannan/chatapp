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
import java.util.List;

@WebServlet("/conversation-messages")
public class ConversationMessagesServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentUser = request.getParameter("currentUser");
        String otherUser = request.getParameter("otherUser");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (isBlank(currentUser) || isBlank(otherUser)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"currentUser and otherUser are required\"}");
            return;
        }

        try {
            Document conversation = conversationService.createOrGetConversation(currentUser.trim(), otherUser.trim());
            String conversationId = conversationService.extractConversationId(conversation);
            if (conversationId == null || conversationId.isBlank()) {
                throw new IllegalStateException("Conversation id could not be resolved");
            }
            List<Document> messages = conversationService.getConversationMessages(conversationId);

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"conversationId\":\"").append(escapeJson(conversationId)).append("\",");
            json.append("\"messages\":[");

            boolean first = true;
            for (Document msg : messages) {
                if (!first) {
                    json.append(",");
                }

                String id = msg.getObjectId("_id") != null ? msg.getObjectId("_id").toHexString() : "";
                String sender = msg.getString("sender") != null ? msg.getString("sender") : "";
                String receiver = msg.getString("receiver") != null ? msg.getString("receiver") : "";
                String message = msg.getString("message") != null ? msg.getString("message") : "";
                String clientMessageId = msg.getString("clientMessageId") != null ? msg.getString("clientMessageId") : "";
                String timestamp = msg.getString("timestamp") != null ? msg.getString("timestamp") : "";

                json.append("{")
                    .append("\"id\":\"").append(escapeJson(id)).append("\",")
                    .append("\"sender\":\"").append(escapeJson(sender)).append("\",")
                    .append("\"receiver\":\"").append(escapeJson(receiver)).append("\",")
                    .append("\"message\":\"").append(escapeJson(message)).append("\",")
                    .append("\"clientMessageId\":\"").append(escapeJson(clientMessageId)).append("\",")
                    .append("\"timestamp\":\"").append(escapeJson(timestamp)).append("\"")
                    .append("}");

                first = false;
            }

            json.append("]}");

            PrintWriter out = response.getWriter();
            out.write(json.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getClass().getSimpleName() + ": " + e.getMessage()) + "\"}");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
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
