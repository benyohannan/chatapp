package backend.controllers;

import backend.services.ConversationService;
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
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/get-recent-chats")
public class GetRecentChatsServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();
    private final GroupRoomService groupRoomService = new GroupRoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");

        if (username == null || username.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Username is required\"}");
            return;
        }

        try {
            // Fetch recent conversations and group rooms
            List<Document> conversations = conversationService.getRecentConversations(username);
            List<Document> groupRooms = groupRoomService.getRoomsForUser(username);

            // Combine and sort by timestamp
            List<ChatItem> allChats = new ArrayList<>();

            // Add user conversations
            for (Document conversation : conversations) {
                @SuppressWarnings("unchecked")
                List<String> participants = (List<String>) conversation.get("participants");
                String otherParticipant = conversationService.getOtherParticipant(participants, username);

                if (otherParticipant != null) {
                    String lastMessageTime = conversation.getString("lastMessageTime") != null ? 
                        conversation.getString("lastMessageTime") : "";
                    allChats.add(new ChatItem(
                        otherParticipant,
                        conversation.getString("lastMessage") != null ? conversation.getString("lastMessage") : "",
                        lastMessageTime,
                        false
                    ));
                }
            }

            // Add group rooms
            for (Document room : groupRooms) {
                String roomName = room.getString("roomName") != null ? room.getString("roomName") : "";
                String lastMessageTime = room.getString("lastMessageTime") != null ? 
                    room.getString("lastMessageTime") : "";
                allChats.add(new ChatItem(
                    roomName,
                    room.getString("lastMessage") != null ? room.getString("lastMessage") : "",
                    lastMessageTime,
                    true
                ));
            }

            // Sort by timestamp descending
            allChats.sort((a, b) -> compareTimestamps(b.timestamp, a.timestamp));

            // Limit to 10 most recent
            if (allChats.size() > 10) {
                allChats = allChats.subList(0, 10);
            }

            // Format the response as JSON
            StringBuilder jsonResponse = new StringBuilder("[");
            boolean first = true;

            for (ChatItem chat : allChats) {
                if (!first) jsonResponse.append(",");
                
                jsonResponse.append("{")
                    .append("\"name\":\"").append(escapeJson(chat.name)).append("\",")
                    .append("\"lastMessage\":\"").append(escapeJson(chat.lastMessage)).append("\",")
                    .append("\"lastMessageTime\":\"").append(escapeJson(chat.timestamp)).append("\",")
                    .append("\"isGroupRoom\":").append(chat.isGroupRoom)
                    .append("}");
                
                first = false;
            }

            jsonResponse.append("]");

            // Return JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            out.write(jsonResponse.toString());
            out.flush();

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private int compareTimestamps(String ts1, String ts2) {
        try {
            LocalDateTime dt1 = LocalDateTime.parse(ts1);
            LocalDateTime dt2 = LocalDateTime.parse(ts2);
            return dt1.compareTo(dt2);
        } catch (Exception e) {
            return 0;
        }
    }

    private static class ChatItem {
        String name;
        String lastMessage;
        String timestamp;
        boolean isGroupRoom;

        ChatItem(String name, String lastMessage, String timestamp, boolean isGroupRoom) {
            this.name = name;
            this.lastMessage = lastMessage;
            this.timestamp = timestamp;
            this.isGroupRoom = isGroupRoom;
        }
    }

    // Helper method to escape special characters for JSON
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}
