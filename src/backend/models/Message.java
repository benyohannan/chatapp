package backend.models;

import java.time.LocalDateTime;

public class Message {

    private String id;
    private String conversationId;
    private String sender;
    private String receiver;
    private String message;
    private LocalDateTime timestamp;
    private boolean isRead;

    // Constructors
    public Message() {}

    public Message(String conversationId, String sender, String receiver, String message) {
        this.conversationId = conversationId;
        this.sender = sender;
        this.receiver = receiver;
        this.message = message;
        this.timestamp = LocalDateTime.now();
        this.isRead = false;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getConversationId() {
        return conversationId;
    }

    public void setConversationId(String conversationId) {
        this.conversationId = conversationId;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }
}
