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

@WebServlet("/group-rooms")
public class GroupRoomsServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String query = request.getParameter("query");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            List<Document> rooms;
            if (query != null && !query.trim().isEmpty()) {
                rooms = groupRoomService.searchRooms(query, username);
            } else {
                rooms = groupRoomService.getRoomsForUser(username);
            }

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Document room : rooms) {
                if (!first) {
                    json.append(",");
                }
                String roomId = groupRoomService.extractRoomId(room);
                String roomName = room.getString("roomName") != null ? room.getString("roomName") : "";
                String lastMessage = room.getString("lastMessage") != null ? room.getString("lastMessage") : "";
                String lastMessageTime = room.getString("lastMessageTime") != null ? room.getString("lastMessageTime") : "";
                boolean isMember = groupRoomService.isRoomMember(room, username);
                @SuppressWarnings("unchecked")
                List<String> members = (List<String>) room.get("members");
                json.append("{")
                        .append("\"roomId\":\"").append(escapeJson(roomId)).append("\",")
                        .append("\"roomName\":\"").append(escapeJson(roomName)).append("\",")
                        .append("\"lastMessage\":\"").append(escapeJson(lastMessage)).append("\",")
                        .append("\"lastMessageTime\":\"").append(escapeJson(lastMessageTime)).append("\",")
                    .append("\"isMember\":").append(isMember).append(",")
                        .append("\"members\":[");
                if (members != null) {
                    for (int i = 0; i < members.size(); i++) {
                        if (i > 0) {
                            json.append(",");
                        }
                        json.append("\"").append(escapeJson(members.get(i))).append("\"");
                    }
                }
                json.append("]}");
                first = false;
            }
            json.append("]");

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
