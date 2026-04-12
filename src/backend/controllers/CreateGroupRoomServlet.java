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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/create-group-room")
public class CreateGroupRoomServlet extends HttpServlet {

    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String creator = request.getParameter("creator");
        String roomName = request.getParameter("roomName");
        String membersParam = request.getParameter("members");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<String> members = new ArrayList<>();
        if (membersParam != null && !membersParam.trim().isEmpty()) {
            for (String part : membersParam.split(",")) {
                String name = part.trim();
                if (!name.isEmpty()) {
                    members.add(name);
                }
            }
        }

        try {
            Document room = groupRoomService.createRoom(creator, roomName, members);
            String roomId = groupRoomService.extractRoomId(room);
            StringBuilder json = new StringBuilder();
            json.append("{")
                .append("\"success\":true,")
                .append("\"roomId\":\"").append(escapeJson(roomId)).append("\",")
                .append("\"roomName\":\"").append(escapeJson(roomName != null ? roomName.trim() : "")).append("\"")
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
