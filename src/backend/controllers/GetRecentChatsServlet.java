package backend.controllers;

import backend.services.ConversationService;
import backend.services.GroupRoomService;
import backend.services.UserService;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/get-recent-chats")
public class GetRecentChatsServlet extends HttpServlet {

    private final ConversationService conversationService = new ConversationService();
    private final GroupRoomService groupRoomService = new GroupRoomService();
    private final UserService userService = new UserService();

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

            Map<String, RecentChatEntry> recentEntries = new LinkedHashMap<>();

            for (Document conversation : conversations) {
                @SuppressWarnings("unchecked")
                List<String> participants = (List<String>) conversation.get("participants");
                String otherParticipant = conversationService.getOtherParticipant(participants, username);

                if (otherParticipant == null || otherParticipant.trim().isEmpty()) {
                    continue;
                }

                String normalizedOtherParticipant = otherParticipant.trim();
                if (normalizedOtherParticipant.equals(username.trim()) || !userService.userExists(normalizedOtherParticipant)) {
                    continue;
                }

                String conversationId = conversationService.extractConversationId(conversation);
                Document latestMessage = conversationService.getLatestMessage(conversationId);
                String lastMessage = resolveConversationPreview(conversation, latestMessage);
                String lastMessageTime = resolveConversationTime(conversation, latestMessage);
                long unreadCount = conversationService.getUnreadCount(conversationId, username);
                String profilePic = userService.getUserProfilePic(normalizedOtherParticipant);

                putRecentEntry(recentEntries, "direct:" + normalizedOtherParticipant.toLowerCase(), RecentChatEntry.userChat(
                        conversationId,
                        normalizedOtherParticipant,
                        lastMessage,
                        lastMessageTime,
                        unreadCount,
                    profilePic
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

                putRecentEntry(recentEntries, "group:" + roomName.trim().toLowerCase(), RecentChatEntry.groupRoom(
                        roomId,
                        roomName,
                        lastMessage,
                        lastMessageTime,
                        unreadCount
                ));
            }

            List<RecentChatEntry> recentList = new ArrayList<>(recentEntries.values());
            recentList.removeIf(entry -> !shouldIncludeRecentEntry(entry));
            recentList.sort(Comparator.comparing(entry -> parseTimestamp(entry.lastMessageTime), Comparator.reverseOrder()));
            if (recentList.size() > 10) {
                recentList = new ArrayList<>(recentList.subList(0, 10));
            }

            // Format the response as JSON
            StringBuilder jsonResponse = new StringBuilder("[");
            boolean first = true;

            for (RecentChatEntry entry : recentList) {
                if (!first) {
                    jsonResponse.append(",");
                }

                jsonResponse.append("{")
                    .append("\"conversationId\":\"").append(escapeJson(entry.conversationId)).append("\",")
                    .append("\"username\":\"").append(escapeJson(entry.username)).append("\",")
                    .append("\"name\":\"").append(escapeJson(entry.username)).append("\",")
                    .append("\"lastMessage\":\"").append(escapeJson(entry.lastMessage)).append("\",")
                    .append("\"lastMessageTime\":\"").append(escapeJson(entry.lastMessageTime)).append("\",")
                    .append("\"profilePic\":\"").append(escapeJson(entry.profilePic)).append("\",")
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

    private void putRecentEntry(Map<String, RecentChatEntry> entries, String key, RecentChatEntry candidate) {
        if (key == null || key.trim().isEmpty() || candidate == null) {
            return;
        }

        RecentChatEntry existing = entries.get(key);
        if (existing == null) {
            entries.put(key, candidate);
            return;
        }

        entries.put(key, mergeRecentEntry(existing, candidate));
    }

    private RecentChatEntry mergeRecentEntry(RecentChatEntry existing, RecentChatEntry candidate) {
        LocalDateTime existingTime = parseTimestamp(existing.lastMessageTime);
        LocalDateTime candidateTime = parseTimestamp(candidate.lastMessageTime);
        RecentChatEntry newer = candidateTime.isAfter(existingTime) ? candidate : existing;
        RecentChatEntry older = newer == candidate ? existing : candidate;

        String lastMessage = choosePreview(newer.lastMessage, older.lastMessage);
        String lastMessageTime = !isBlank(newer.lastMessageTime) ? newer.lastMessageTime : older.lastMessageTime;
        String profilePic = !isBlank(newer.profilePic) ? newer.profilePic : older.profilePic;
        long unreadCount = Math.max(existing.unreadCount, candidate.unreadCount);

        return new RecentChatEntry(
            newer.conversationId,
            newer.username,
            lastMessage,
            lastMessageTime,
            profilePic,
            unreadCount,
            newer.isGroupRoom
        );
    }

    private String resolveConversationPreview(Document conversation, Document latestMessage) {
        String summary = conversation != null && conversation.getString("lastMessage") != null ? conversation.getString("lastMessage").trim() : "";
        String latest = latestMessage != null && latestMessage.getString("message") != null ? latestMessage.getString("message").trim() : "";
        return choosePreview(summary, latest);
    }

    private String resolveConversationTime(Document conversation, Document latestMessage) {
        String summaryTime = conversation != null && conversation.getString("lastMessageTime") != null ? conversation.getString("lastMessageTime").trim() : "";
        if (!summaryTime.isEmpty()) {
            return summaryTime;
        }

        String latestTime = latestMessage != null && latestMessage.getString("timestamp") != null ? latestMessage.getString("timestamp").trim() : "";
        if (!latestTime.isEmpty()) {
            return latestTime;
        }

        return conversation != null && conversation.getString("createdAt") != null ? conversation.getString("createdAt") : "";
    }

    private String choosePreview(String primary, String fallback) {
        String cleanPrimary = primary == null ? "" : primary.trim();
        String cleanFallback = fallback == null ? "" : fallback.trim();

        if (isRealPreview(cleanPrimary)) {
            return cleanPrimary;
        }
        if (isRealPreview(cleanFallback)) {
            return cleanFallback;
        }
        return !cleanPrimary.isEmpty() ? cleanPrimary : cleanFallback;
    }

    private boolean isRealPreview(String value) {
        return value != null && !value.isBlank() && !"No messages yet".equalsIgnoreCase(value.trim());
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean shouldIncludeRecentEntry(RecentChatEntry entry) {
        if (entry == null) {
            return false;
        }

        if (entry.unreadCount > 0) {
            return true;
        }

        return isRealPreview(entry.lastMessage);
    }

    private static class RecentChatEntry {
        final String conversationId;
        final String username;
        final String lastMessage;
        final String lastMessageTime;
        final String profilePic;
        final long unreadCount;
        final boolean isGroupRoom;

        private RecentChatEntry(String conversationId, String username, String lastMessage, String lastMessageTime, String profilePic, long unreadCount, boolean isGroupRoom) {
            this.conversationId = conversationId == null ? "" : conversationId;
            this.username = username == null ? "" : username;
            this.lastMessage = lastMessage == null ? "" : lastMessage;
            this.lastMessageTime = lastMessageTime == null ? "" : lastMessageTime;
            this.profilePic = profilePic == null ? "" : profilePic;
            this.unreadCount = unreadCount;
            this.isGroupRoom = isGroupRoom;
        }

        static RecentChatEntry userChat(String conversationId, String username, String lastMessage, String lastMessageTime, long unreadCount, String profilePic) {
            return new RecentChatEntry(conversationId, username, lastMessage, lastMessageTime, profilePic, unreadCount, false);
        }

        static RecentChatEntry groupRoom(String roomId, String roomName, String lastMessage, String lastMessageTime, long unreadCount) {
            return new RecentChatEntry(roomId, roomName, lastMessage, lastMessageTime, "", unreadCount, true);
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