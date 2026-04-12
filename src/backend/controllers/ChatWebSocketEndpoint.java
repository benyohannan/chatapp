package backend.controllers;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/chat")
public class ChatWebSocketEndpoint {

    private static final Map<String, Session> userSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        String username = getUsernameFromQuery(session);
        if (username != null && !username.isBlank()) {
            session.getUserProperties().put("username", username);
            userSessions.put(username, session);
            System.out.println("WebSocket connected for user: " + username + ", session: " + session.getId());
        } else {
            System.out.println("WebSocket connected without username, session: " + session.getId());
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        String type = jsonValue(message, "type");
        if (type == null) {
            return;
        }

        if ("auth".equals(type)) {
            String username = jsonValue(message, "username");
            if (username != null && !username.isBlank()) {
                session.getUserProperties().put("username", username);
                userSessions.put(username, session);
                System.out.println("WebSocket auth mapped user: " + username + ", session: " + session.getId());
            }
            return;
        }

        if ("chat".equals(type)) {
            String sender = jsonValue(message, "sender");
            String receiver = jsonValue(message, "receiver");
            String text = jsonValue(message, "message");
            String timestamp = jsonValue(message, "timestamp");
            String messageId = jsonValue(message, "messageId");
            String clientMessageId = jsonValue(message, "clientMessageId");

            if (sender == null || receiver == null || text == null) {
                return;
            }

            String payload = "{"
                + "\"type\":\"chat\"," 
                + "\"sender\":\"" + escapeJson(sender) + "\"," 
                + "\"receiver\":\"" + escapeJson(receiver) + "\"," 
                + "\"message\":\"" + escapeJson(text) + "\"," 
                + "\"messageId\":\"" + escapeJson(messageId == null ? "" : messageId) + "\"," 
                + "\"clientMessageId\":\"" + escapeJson(clientMessageId == null ? "" : clientMessageId) + "\"," 
                + "\"timestamp\":\"" + escapeJson(timestamp == null ? "" : timestamp) + "\""
                + "}";

            Session target = userSessions.get(receiver);
            if (target != null && target.isOpen()) {
                target.getAsyncRemote().sendText(payload);
            }
        }
    }

    @OnClose
    public void onClose(Session session) {
        Object usernameObj = session.getUserProperties().get("username");
        if (usernameObj != null) {
            userSessions.remove(usernameObj.toString());
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error for session " + (session != null ? session.getId() : "unknown") + ": " + throwable.getMessage());
        throwable.printStackTrace();
    }

    private String jsonValue(String json, String key) {
        String pattern = "\"" + key + "\"";
        int keyIndex = json.indexOf(pattern);
        if (keyIndex < 0) {
            return null;
        }

        int colon = json.indexOf(':', keyIndex + pattern.length());
        if (colon < 0) {
            return null;
        }

        int startQuote = json.indexOf('"', colon + 1);
        if (startQuote < 0) {
            return null;
        }

        int endQuote = startQuote + 1;
        boolean escaped = false;
        while (endQuote < json.length()) {
            char ch = json.charAt(endQuote);
            if (ch == '"' && !escaped) {
                break;
            }
            escaped = ch == '\\' && !escaped;
            if (ch != '\\') {
                escaped = false;
            }
            endQuote++;
        }

        if (endQuote >= json.length()) {
            return null;
        }

        return json.substring(startQuote + 1, endQuote)
            .replace("\\\"", "\"")
            .replace("\\n", "\n")
            .replace("\\r", "\r")
            .replace("\\\\", "\\");
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r");
    }

    private String getUsernameFromQuery(Session session) {
        if (session == null || session.getRequestURI() == null || session.getRequestURI().getQuery() == null) {
            return null;
        }

        String query = session.getRequestURI().getQuery();
        for (String part : query.split("&")) {
            String[] keyValue = part.split("=", 2);
            if (keyValue.length == 2 && "username".equals(keyValue[0])) {
                return URLDecoder.decode(keyValue[1], StandardCharsets.UTF_8);
            }
        }
        return null;
    }
}
