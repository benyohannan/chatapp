package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

@WebServlet("/send-group-message")
public class SendGroupMessageServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomName = request.getParameter("roomName");
        String sender = request.getParameter("sender");
        String message = request.getParameter("message");
        String clientMessageId = request.getParameter("clientMessageId");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (roomName == null || sender == null || message == null || roomName.trim().isEmpty() || sender.trim().isEmpty() || message.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"roomName, sender and message are required\"}");
            return;
        }

        try {
            Document room = groupRoomService.findRoomByName(roomName);
            if (room == null || !groupRoomService.isRoomMember(room, sender)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Access denied\"}");
                return;
            }

            boolean adminOnlyMode = groupRoomService.isAdminOnlyMode(room);
            boolean isCreator = groupRoomService.isCreator(room, sender);
            if (adminOnlyMode && !isCreator) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Only room admin can send messages right now\"}");
                return;
            }

            String savedId = groupRoomService.saveRoomMessage(roomName, sender.trim(), message.trim(), clientMessageId);
            String now = LocalDateTime.now().toString();

            StringBuilder json = new StringBuilder();
            json.append("{")
                .append("\"success\":true,")
                .append("\"roomName\":\"").append(escapeJson(roomName.trim())).append("\",")
                .append("\"messageId\":\"").append(escapeJson(savedId)).append("\",")
                .append("\"clientMessageId\":\"").append(escapeJson(clientMessageId)).append("\",")
                .append("\"sender\":\"").append(escapeJson(sender.trim())).append("\",")
                .append("\"message\":\"").append(escapeJson(message.trim())).append("\",")
                .append("\"timestamp\":\"").append(escapeJson(now)).append("\"")
                .append("}");

            PrintWriter out = response.getWriter();
            out.write(json.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}