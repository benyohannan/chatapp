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
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

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

            List<RecentChatEntry> recentEntries = new ArrayList<>();

            for (Document conversation : conversations) {
                @SuppressWarnings("unchecked")
                List<String> participants = (List<String>) conversation.get("participants");
                String otherParticipant = conversationService.getOtherParticipant(participants, username);

                if (otherParticipant == null || otherParticipant.trim().isEmpty()) {
                    continue;
                }

                String conversationId = conversationService.extractConversationId(conversation);
                String lastMessage = conversation.getString("lastMessage") != null ? conversation.getString("lastMessage") : "";
                String lastMessageTime = conversation.getString("lastMessageTime") != null ? conversation.getString("lastMessageTime") : "";
                long unreadCount = conversationService.getUnreadCount(conversationId, username);

                recentEntries.add(RecentChatEntry.userChat(
                        conversationId,
                        otherParticipant,
                        lastMessage,
                        lastMessageTime,
                        unreadCount
                ));
            }

            for (Document room : groupRooms) {
                String roomName = room.getString("roomName") != null ? room.getString("roomName") : "";
                if (roomName.trim().isEmpty()) {
                    continue;
                }

                String lastMessage = room.getString("lastMessage") != null ? room.getString("lastMessage") : "";
                String lastMessageTime = room.getString("lastMessageTime") != null ? room.getString("lastMessageTime") : "";
                String roomId = groupRoomService.extractRoomId(room);
                long unreadCount = groupRoomService.getUnreadCountForRoom(roomName, username);

                recentEntries.add(RecentChatEntry.groupRoom(
                        roomId,
                        roomName,
                        lastMessage,
                    lastMessageTime,
                    unreadCount
                ));
            }

            recentEntries.sort(Comparator.comparing(entry -> parseTimestamp(entry.lastMessageTime), Comparator.reverseOrder()));
            if (recentEntries.size() > 10) {
                recentEntries = new ArrayList<>(recentEntries.subList(0, 10));
            }

            // Format the response as JSON
            StringBuilder jsonResponse = new StringBuilder("[");
            boolean first = true;

            for (RecentChatEntry entry : recentEntries) {
                if (!first) {
                    jsonResponse.append(",");
                }

                jsonResponse.append("{")
                    .append("\"conversationId\":\"").append(escapeJson(entry.conversationId)).append("\",")
                    .append("\"username\":\"").append(escapeJson(entry.username)).append("\",")
                    .append("\"name\":\"").append(escapeJson(entry.username)).append("\",")
                    .append("\"lastMessage\":\"").append(escapeJson(entry.lastMessage)).append("\",")
                    .append("\"lastMessageTime\":\"").append(escapeJson(entry.lastMessageTime)).append("\",")
                    .append("\"unreadCount\":").append(entry.unreadCount).append(",")
                    .append("\"isGroupRoom\":").append(entry.isGroupRoom).append(",")
                    .append("\"isGroupChat\":").append(entry.isGroupRoom)
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

    private LocalDateTime parseTimestamp(String value) {
        if (value == null || value.trim().isEmpty()) {
            return LocalDateTime.MIN;
        }
        try {
            return LocalDateTime.parse(value.trim());
        } catch (Exception e) {
            return LocalDateTime.MIN;
        }
    }

    private static class RecentChatEntry {
        final String conversationId;
        final String username;
        final String lastMessage;
        final String lastMessageTime;
        final long unreadCount;
        final boolean isGroupRoom;

        private RecentChatEntry(String conversationId, String username, String lastMessage, String lastMessageTime, long unreadCount, boolean isGroupRoom) {
            this.conversationId = conversationId == null ? "" : conversationId;
            this.username = username == null ? "" : username;
            this.lastMessage = lastMessage == null ? "" : lastMessage;
            this.lastMessageTime = lastMessageTime == null ? "" : lastMessageTime;
            this.unreadCount = unreadCount;
            this.isGroupRoom = isGroupRoom;
        }

        static RecentChatEntry userChat(String conversationId, String username, String lastMessage, String lastMessageTime, long unreadCount) {
            return new RecentChatEntry(conversationId, username, lastMessage, lastMessageTime, unreadCount, false);
        }

        static RecentChatEntry groupRoom(String roomId, String roomName, String lastMessage, String lastMessageTime, long unreadCount) {
            return new RecentChatEntry(roomId, roomName, lastMessage, lastMessageTime, unreadCount, true);
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
