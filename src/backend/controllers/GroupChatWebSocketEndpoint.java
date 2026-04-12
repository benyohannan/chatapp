package backend.controllers;

import backend.services.GroupRoomService;
import org.bson.Document;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.CloseReason;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/group-chat")
public class GroupChatWebSocketEndpoint {

    private static final Map<String, Set<Session>> roomSessions = new ConcurrentHashMap<>();
    private final GroupRoomService groupRoomService = new GroupRoomService();

    @OnOpen
    public void onOpen(Session session) throws IOException {
        String roomName = getParam(session, "roomName");
        String username = getParam(session, "username");

        if (roomName == null || username == null || roomName.isBlank() || username.isBlank()) {
            session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, "Missing room or username"));
            return;
        }

        Document room = groupRoomService.findRoomByName(roomName);
        if (room == null || !groupRoomService.isRoomMember(room, username)) {
            session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Not a member of this room"));
            return;
        }

        session.getUserProperties().put("roomName", roomName);
        session.getUserProperties().put("username", username);
        roomSessions.computeIfAbsent(roomName.toLowerCase(), key -> ConcurrentHashMap.newKeySet()).add(session);
        System.out.println("Group WebSocket connected: room=" + roomName + ", user=" + username + ", session=" + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        String type = value(message, "type");
        if (!"chat".equals(type)) {
            return;
        }

        String roomName = value(message, "roomName");
        String sender = value(message, "sender");
        String text = value(message, "message");
        String timestamp = value(message, "timestamp");
        String messageId = value(message, "messageId");
        String clientMessageId = value(message, "clientMessageId");

        if (roomName == null || sender == null || text == null) {
            return;
        }

        String payload = "{" 
                + "\"type\":\"chat\"," 
                + "\"roomName\":\"" + esc(roomName) + "\"," 
                + "\"sender\":\"" + esc(sender) + "\"," 
                + "\"message\":\"" + esc(text) + "\"," 
                + "\"messageId\":\"" + esc(messageId == null ? "" : messageId) + "\"," 
                + "\"clientMessageId\":\"" + esc(clientMessageId == null ? "" : clientMessageId) + "\"," 
                + "\"timestamp\":\"" + esc(timestamp == null ? "" : timestamp) + "\"" 
                + "}";

        Set<Session> sessions = roomSessions.get(roomName.toLowerCase());
        if (sessions == null) {
            return;
        }

        for (Session target : sessions) {
            if (target != null && target.isOpen()) {
                target.getAsyncRemote().sendText(payload);
            }
        }
    }

    @OnClose
    public void onClose(Session session) {
        String roomName = (String) session.getUserProperties().get("roomName");
        if (roomName != null) {
            Set<Session> sessions = roomSessions.get(roomName.toLowerCase());
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    roomSessions.remove(roomName.toLowerCase());
                }
            }
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Group WebSocket error for session " + (session != null ? session.getId() : "unknown") + ": " + throwable.getMessage());
        throwable.printStackTrace();
    }

    private String getParam(Session session, String key) {
        if (session == null || session.getRequestURI() == null || session.getRequestURI().getQuery() == null) {
            return null;
        }
        String query = session.getRequestURI().getQuery();
        for (String part : query.split("&")) {
            String[] keyValue = part.split("=", 2);
            if (keyValue.length == 2 && key.equals(keyValue[0])) {
                return URLDecoder.decode(keyValue[1], StandardCharsets.UTF_8);
            }
        }
        return null;
    }

    private String value(String json, String key) {
        String pattern = "\"" + key + "\"";
        int keyIndex = json.indexOf(pattern);
        if (keyIndex < 0) return null;
        int colon = json.indexOf(':', keyIndex + pattern.length());
        if (colon < 0) return null;
        int start = json.indexOf('"', colon + 1);
        if (start < 0) return null;
        int end = start + 1;
        boolean escaped = false;
        while (end < json.length()) {
            char ch = json.charAt(end);
            if (ch == '"' && !escaped) break;
            escaped = ch == '\\' && !escaped;
            if (ch != '\\') escaped = false;
            end++;
        }
        if (end >= json.length()) return null;
        return json.substring(start + 1, end)
                .replace("\\\"", "\"")
                .replace("\\n", "\n")
                .replace("\\r", "\r")
                .replace("\\\\", "\\");
    }

    private String esc(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
