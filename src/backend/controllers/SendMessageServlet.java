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
import java.time.LocalDateTime;

@WebServlet("/send-message")
public class SendMessageServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sender = request.getParameter("sender");
        String receiver = request.getParameter("receiver");
        String message = request.getParameter("message");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (isBlank(sender) || isBlank(receiver) || isBlank(message)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"sender, receiver and message are required\"}");
            return;
        }

        try {
            Document conversation = conversationService.createOrGetConversation(sender.trim(), receiver.trim());
            String conversationId = conversation.getObjectId("_id").toHexString();
            String now = LocalDateTime.now().toString();

            conversationService.saveMessage(conversationId, sender.trim(), receiver.trim(), message.trim());

            StringBuilder json = new StringBuilder();
            json.append("{")
                .append("\"success\":true,")
                .append("\"conversationId\":\"").append(escapeJson(conversationId)).append("\",")
                .append("\"sender\":\"").append(escapeJson(sender.trim())).append("\",")
                .append("\"receiver\":\"").append(escapeJson(receiver.trim())).append("\",")
                .append("\"message\":\"").append(escapeJson(message.trim())).append("\",")
                .append("\"timestamp\":\"").append(escapeJson(now)).append("\"")
                .append("}");

            PrintWriter out = response.getWriter();
            out.write(json.toString());
            out.flush();
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
