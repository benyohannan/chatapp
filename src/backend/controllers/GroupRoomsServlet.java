package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
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
                if (!first) json.append(",");
               String admin = room.getString("creator");
                if (admin == null) admin = "";
                boolean isAdmin = username != null && username.equals(admin);

                List<String> pending = room.getList("pendingRequests", String.class);
                boolean isPending = pending != null && pending.contains(username);
                String roomId = groupRoomService.extractRoomId(room);
                String roomName = room.getString("roomName") != null ? room.getString("roomName") : "";

                List<String> members = room.getList("members", String.class);
                String lastMessage = room.getString("lastMessage") != null ? room.getString("lastMessage") : "";

                boolean isMember = members != null && members.contains(username);

                json.append("{")
                .append("\"roomId\":\"").append(roomId).append("\",")
                .append("\"roomName\":\"").append(escapeJson(roomName)).append("\",")
                .append("\"members\":").append(convertListToJsonArray(members)).append(",")
                .append("\"lastMessage\":\"").append(escapeJson(lastMessage)).append("\",")
                .append("\"isMember\":").append(isMember).append(",")
                .append("\"admin\":\"").append(escapeJson(admin)).append("\",")
                .append("\"isAdmin\":").append(isAdmin).append(",")
                .append("\"isPending\":").append(isPending)
                .append("}");

                first = false;
            }

            json.append("]");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // ✅ OUTSIDE doGet (correct place)
    private String convertListToJsonArray(List<String> list) {
        if (list == null || list.isEmpty()) return "[]";

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append("\"").append(escapeJson(list.get(i))).append("\"");
            if (i < list.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    // ✅ OUTSIDE doGet (correct place)
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}