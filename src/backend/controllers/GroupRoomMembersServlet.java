package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/group-room-members")
public class GroupRoomMembersServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String roomName = request.getParameter("roomName");
        String username = request.getParameter("username");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Document room = groupRoomService.findRoomByName(roomName);
            if (room == null || !groupRoomService.isRoomMember(room, username)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Access denied\"}");
                return;
            }

            List<String> members = room.getList("members", String.class);
            if (members == null) {
                members = new ArrayList<>();
            }

            String creator = room.getString("creator") == null ? "" : room.getString("creator");
            boolean isCreator = groupRoomService.isCreator(room, username);
            boolean adminOnlyMode = groupRoomService.isAdminOnlyMode(room);

            response.getWriter().write("{"
                + "\"success\":true,"
                + "\"roomName\":\"" + escapeJson(room.getString("roomName")) + "\","
                + "\"creator\":\"" + escapeJson(creator) + "\","
                + "\"isCreator\":" + isCreator + ","
                + "\"adminOnlyMode\":" + adminOnlyMode + ","
                + "\"members\":" + listToJson(members)
                + "}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
