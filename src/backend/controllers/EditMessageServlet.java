package backend.controllers;

import backend.services.ConversationService;
import org.bson.Document;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/edit-message")
public class EditMessageServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String currentUser = request.getParameter("currentUser");
        String otherUser = request.getParameter("otherUser");
        String messageId = request.getParameter("messageId");
        String message = request.getParameter("message");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (isBlank(currentUser) || isBlank(otherUser) || isBlank(messageId) || isBlank(message)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"currentUser, otherUser, messageId and message are required\"}");
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
            Document updatedMessage = conversationService.updateMessage(
                conversationId,
                messageId.trim(),
                currentUser.trim(),
                message.trim()
            );

            if (updatedMessage == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Unable to edit message\"}");
                return;
            }

            String timestamp = updatedMessage.getString("timestamp");
            ChatWebSocketEndpoint.sendEditEvent(
                currentUser.trim(),
                otherUser.trim(),
                messageId.trim(),
                message.trim(),
                timestamp
            );

            response.getWriter().write("{"
                + "\"success\":true,"
                + "\"messageId\":\"" + escapeJson(messageId.trim()) + "\","
                + "\"message\":\"" + escapeJson(message.trim()) + "\""
                + "}");
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
