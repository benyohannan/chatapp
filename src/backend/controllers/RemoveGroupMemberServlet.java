package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/remove-group-member")
public class RemoveGroupMemberServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String roomName = request.getParameter("roomName");
        String creator = request.getParameter("creator");
        String username = request.getParameter("username");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Document room = groupRoomService.removeMember(roomName, creator, username);
            List<String> members = room.getList("members", String.class);

            response.getWriter().write("{"
                + "\"success\":true,"
                + "\"roomName\":\"" + escapeJson(room.getString("roomName")) + "\","
                + "\"removedUser\":\"" + escapeJson(username) + "\","
                + "\"members\":" + listToJson(members)
                + "}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String listToJson(List<String> list) {
        if (list == null || list.isEmpty()) {
            return "[]";
        }

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append("\"").append(escapeJson(list.get(i))).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r");
    }
}
