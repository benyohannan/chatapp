package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/decline-join-request")
public class DeclineJoinRequestServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String roomName = request.getParameter("roomName");
        String creator = request.getParameter("creator");
        String username = request.getParameter("username");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Document room = groupRoomService.declineJoinRequest(roomName, creator, username);
            int pendingCount = room.getList("pendingRequests", String.class) == null
                ? 0
                : room.getList("pendingRequests", String.class).size();

            response.getWriter().write("{"
                + "\"success\":true,"
                + "\"roomName\":\"" + escapeJson(room.getString("roomName")) + "\","
                + "\"declinedUser\":\"" + escapeJson(username) + "\","
                + "\"pendingCount\":" + pendingCount
                + "}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
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
