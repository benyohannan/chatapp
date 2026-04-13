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

@WebServlet("/join-group-room")
public class JoinGroupRoomServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String roomName = request.getParameter("roomName");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Document room = groupRoomService.joinRoom(username, roomName);
            String roomId = groupRoomService.extractRoomId(room);
            boolean isMember = groupRoomService.isRoomMember(room, username);
            boolean isPending = room.getList("pendingRequests", String.class) != null
                && room.getList("pendingRequests", String.class).contains(username != null ? username.trim() : "");
            StringBuilder json = new StringBuilder();
            json.append("{")
                    .append("\"success\":true,")
                    .append("\"roomId\":\"").append(escapeJson(roomId)).append("\",")
                    .append("\"roomName\":\"").append(escapeJson(room.getString("roomName"))).append("\",")
                    .append("\"isMember\":").append(isMember).append(",")
                    .append("\"isPending\":").append(isPending).append(",")
                    .append("\"message\":\"").append(escapeJson(isMember ? "You can enter the room now." : "Join request sent to the room creator.")).append("\"")
                    .append("}");

            PrintWriter out = response.getWriter();
            out.write(json.toString());
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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
