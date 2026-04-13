package backend.controllers;

import backend.services.ConversationService;
import org.bson.Document;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/delete-message")
public class DeleteMessageServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String currentUser = request.getParameter("currentUser");
        String otherUser = request.getParameter("otherUser");
        String messageId = request.getParameter("messageId");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (isBlank(currentUser) || isBlank(otherUser) || isBlank(messageId)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"currentUser, otherUser and messageId are required\"}");
            return;
        }

        try {
            Document conversation = conversationService.findConversation(currentUser.trim(), otherUser.trim());
            if (conversation == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Conversation not found\"}");
                return;
            }

            String conversationId = conversationService.extractConversationId(conversation);
            Document deletedMessage = conversationService.deleteMessageDocument(conversationId, messageId.trim(), currentUser.trim());
            if (deletedMessage == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Unable to delete message\"}");
                return;
            }

            ChatWebSocketEndpoint.sendDeleteEvent(
                currentUser.trim(),
                otherUser.trim(),
                messageId.trim()
            );

            response.getWriter().write("{\"success\":true,\"messageId\":\"" + escapeJson(messageId.trim()) + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
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
