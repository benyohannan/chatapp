package backend.services;

import backend.database.MongoConnection;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.FindIterable;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ConversationService {

    /**
     * Fetch recent conversations for a user, sorted by latest message time
     */
    public List<Document> getRecentConversations(String username) {
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> conversations = db.getCollection("conversations");

        // Query to find conversations that include the current user
        FindIterable<Document> results = conversations.find(new Document("participants", username))
            .sort(new Document("lastMessageTime", -1)); // Sort by most recent

        List<Document> recentConversations = new ArrayList<>();
        for (Document doc : results) {
            recentConversations.add(doc);
        }
        return recentConversations;
    }

    /**
     * Get the other participant in a 1-on-1 conversation
     */
    public String getOtherParticipant(List<String> participants, String currentUser) {
        for (String participant : participants) {
            if (!participant.equals(currentUser)) {
                return participant;
            }
        }
        return null;
    }

    /**
     * Create or get a conversation between two users
     */
    public Document createOrGetConversation(String user1, String user2) {
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> conversations = db.getCollection("conversations");

        // Find existing conversation
        Document query = new Document("participants", new Document("$all", List.of(user1, user2)))
            .append("isGroupChat", false);
        Document existing = conversations.find(query).first();

        if (existing != null) {
            return existing;
        }

        // Create new conversation
        Document newConversation = new Document()
            .append("participants", new ArrayList<String>() {
                {
                    add(user1);
                    add(user2);
                }
            })
            .append("lastMessage", "")
            .append("lastMessageTime", LocalDateTime.now().toString())
            .append("isGroupChat", false)
            .append("createdAt", LocalDateTime.now().toString());

        conversations.insertOne(newConversation);
        if (!newConversation.containsKey("_id")) {
            Document inserted = conversations.find(query).first();
            if (inserted != null) {
                return inserted;
            }
        }
        return newConversation;
    }

    public String extractConversationId(Document conversation) {
        if (conversation == null) {
            return null;
        }

        Object idObj = conversation.get("_id");
        if (idObj instanceof ObjectId) {
            return ((ObjectId) idObj).toHexString();
        }
        if (idObj != null) {
            return idObj.toString();
        }
        return null;
    }

    /**
     * Save a new message to the database
     */
    public void saveMessage(String conversationId, String sender, String receiver, String message) {
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> messages = db.getCollection("messages");
        MongoCollection<Document> conversations = db.getCollection("conversations");

        // Save the message
        Document messageDoc = new Document()
            .append("conversationId", conversationId)
            .append("sender", sender)
            .append("receiver", receiver)
            .append("message", message)
            .append("timestamp", LocalDateTime.now().toString())
            .append("isRead", false);

        messages.insertOne(messageDoc);

        // Update the conversation's last message and time
        Document updateQuery;
        try {
            updateQuery = new Document("_id", new ObjectId(conversationId));
        } catch (Exception ex) {
            updateQuery = new Document("_id", conversationId);
        }
        Document updateData = new Document("$set", new Document()
            .append("lastMessage", message)
            .append("lastMessageTime", LocalDateTime.now().toString()));

        conversations.updateOne(updateQuery, updateData);
    }

    /**
     * Get all messages for a conversation
     */
    public List<Document> getConversationMessages(String conversationId) {
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> messages = db.getCollection("messages");

        FindIterable<Document> results = messages.find(new Document("conversationId", conversationId))
            .sort(new Document("timestamp", 1)); // Sort by oldest first

        List<Document> messageList = new ArrayList<>();
        for (Document doc : results) {
            messageList.add(doc);
        }
        return messageList;
    }
}
