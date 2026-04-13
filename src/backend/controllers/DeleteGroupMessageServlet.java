package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/delete-group-message")
public class DeleteGroupMessageServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String roomName = request.getParameter("roomName");
        String username = request.getParameter("username");
        String messageId = request.getParameter("messageId");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (isBlank(roomName) || isBlank(username) || isBlank(messageId)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"roomName, username and messageId are required\"}");
            return;
        }

        try {
            Document room = groupRoomService.findRoomByName(roomName.trim());
            if (room == null || !groupRoomService.isRoomMember(room, username.trim())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Access denied\"}");
                return;
            }

            boolean deleted = groupRoomService.deleteRoomMessage(roomName.trim(), messageId.trim(), username.trim());
            if (!deleted) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Unable to delete message\"}");
                return;
            }

            response.getWriter().write("{\"success\":true}");
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
