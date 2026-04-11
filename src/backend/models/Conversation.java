package backend.models;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Conversation {

    private String id;
    private List<String> participants;
    private String lastMessage;
    private LocalDateTime lastMessageTime;
    private boolean isGroupChat;

    // Constructors
    public Conversation() {
        this.participants = new ArrayList<>();
    }

    public Conversation(List<String> participants, boolean isGroupChat) {
        this.participants = participants;
        this.isGroupChat = isGroupChat;
        this.lastMessageTime = LocalDateTime.now();
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public List<String> getParticipants() {
        return participants;
    }

    public void setParticipants(List<String> participants) {
        this.participants = participants;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }

    public LocalDateTime getLastMessageTime() {
        return lastMessageTime;
    }

    public void setLastMessageTime(LocalDateTime lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }

    public boolean isGroupChat() {
        return isGroupChat;
    }

    public void setGroupChat(boolean groupChat) {
        isGroupChat = groupChat;
    }
}
