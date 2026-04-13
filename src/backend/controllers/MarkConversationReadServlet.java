package backend.controllers;

import backend.services.ConversationService;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/mark-conversation-read")
public class MarkConversationReadServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentUser = request.getParameter("currentUser");
        String otherUser = request.getParameter("otherUser");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

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

            long updated = conversationService.markConversationAsRead(conversationId, currentUser.trim());
            response.getWriter().write("{\"success\":true,\"updated\":" + updated + "}");
        } catch (Exception e) {
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
