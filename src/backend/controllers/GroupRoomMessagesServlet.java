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
import java.util.List;

@WebServlet("/group-room-messages")
public class GroupRoomMessagesServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomName = request.getParameter("roomName");
        String username = request.getParameter("username");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (roomName == null || roomName.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"roomName is required\"}");
            return;
        }

        try {
            Document room = groupRoomService.findRoomByName(roomName);
            if (room == null || !groupRoomService.isRoomMember(room, username)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Access denied\"}");
                return;
            }

            List<Document> messages = groupRoomService.getMessagesForRoom(roomName);
            StringBuilder json = new StringBuilder();
            json.append("{")
                .append("\"roomName\":\"").append(escapeJson(room.getString("roomName"))).append("\",")
                .append("\"messages\":[");

            boolean first = true;
            for (Document msg : messages) {
                if (!first) {
                    json.append(",");
                }
                String id = msg.getObjectId("_id") != null ? msg.getObjectId("_id").toHexString() : "";
                json.append("{")
                    .append("\"id\":\"").append(escapeJson(id)).append("\",")
                    .append("\"sender\":\"").append(escapeJson(msg.getString("sender"))).append("\",")
                    .append("\"message\":\"").append(escapeJson(msg.getString("message"))).append("\",")
                    .append("\"timestamp\":\"").append(escapeJson(msg.getString("timestamp"))).append("\",")
                    .append("\"clientMessageId\":\"").append(escapeJson(msg.getString("clientMessageId"))).append("\"")
                    .append("}");
                first = false;
            }

            json.append("]}");
            PrintWriter out = response.getWriter();
            out.write(json.toString());
            out.flush();
        } catch (Exception e) {
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
