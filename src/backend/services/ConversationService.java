package backend.services;

import backend.database.MongoConnection;
import org.bson.Document;
import org.bson.types.ObjectId;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.FindIterable;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.result.UpdateResult;
import com.mongodb.client.result.DeleteResult;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
            ensureParticipantBadgeCount(conversations, doc);
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
            ensureParticipantBadgeCount(conversations, existing);
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
            .append("participantBadgeCount", new Document(user1, 0).append(user2, 0))
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

    public Document findConversation(String user1, String user2) {
        if (user1 == null || user1.isBlank() || user2 == null || user2.isBlank()) {
            return null;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> conversations = db.getCollection("conversations");
        return conversations.find(new Document("participants", new Document("$all", List.of(user1, user2)))
            .append("isGroupChat", false)).first();
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
    public String saveMessage(String conversationId, String sender, String receiver, String message, String clientMessageId) {
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> messages = db.getCollection("messages");
        MongoCollection<Document> conversations = db.getCollection("conversations");

        // Save the message
        ObjectId messageObjectId = new ObjectId();
        Document messageDoc = new Document()
            .append("_id", messageObjectId)
            .append("conversationId", conversationId)
            .append("sender", sender)
            .append("receiver", receiver)
            .append("message", message)
            .append("clientMessageId", clientMessageId)
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
        Document conversation = conversations.find(updateQuery).first();
        Document participantBadgeCount = buildParticipantBadgeCount(conversation, sender, receiver);

        Document updateData = new Document("$set", new Document()
            .append("lastMessage", message)
            .append("lastMessageTime", LocalDateTime.now().toString())
            .append("participantBadgeCount", participantBadgeCount));

        conversations.updateOne(updateQuery, updateData);

        return messageObjectId.toHexString();
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

    public long getUnreadCount(String conversationId, String username) {
        if (conversationId == null || conversationId.isBlank() || username == null || username.isBlank()) {
            return 0;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> conversations = db.getCollection("conversations");
        Document conversation = findConversationById(conversations, conversationId);
        if (conversation != null) {
            ensureParticipantBadgeCount(conversations, conversation);
            Object badgeValue = conversation.getEmbedded(List.of("participantBadgeCount", username), Object.class);
            if (badgeValue instanceof Number) {
                return ((Number) badgeValue).longValue();
            }
        }

        MongoCollection<Document> messages = db.getCollection("messages");

        return messages.countDocuments(Filters.and(
            Filters.eq("conversationId", conversationId),
            Filters.eq("receiver", username),
            Filters.eq("isRead", false)
        ));
    }

    public long markConversationAsRead(String conversationId, String username) {
        if (conversationId == null || conversationId.isBlank() || username == null || username.isBlank()) {
            return 0;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> messages = db.getCollection("messages");
        MongoCollection<Document> conversations = db.getCollection("conversations");

        UpdateResult result = messages.updateMany(
            Filters.and(
                Filters.eq("conversationId", conversationId),
                Filters.eq("receiver", username),
                Filters.eq("isRead", false)
            ),
            Updates.set("isRead", true)
        );

        conversations.updateOne(
            buildConversationIdFilter(conversationId),
            Updates.set("participantBadgeCount." + username, 0)
        );

        return result.getModifiedCount();
    }

    public boolean deleteMessage(String conversationId, String messageId, String requester) {
        return deleteMessageDocument(conversationId, messageId, requester) != null;
    }

    public Document deleteMessageDocument(String conversationId, String messageId, String requester) {
        if (conversationId == null || conversationId.isBlank() || messageId == null || messageId.isBlank()
            || requester == null || requester.isBlank()) {
            return null;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> messages = db.getCollection("messages");

        Document existing;
        try {
            existing = messages.find(Filters.and(
                Filters.eq("_id", new ObjectId(messageId)),
                Filters.eq("conversationId", conversationId),
                Filters.eq("sender", requester)
            )).first();
        } catch (Exception ex) {
            return null;
        }

        if (existing == null) {
            return null;
        }

        DeleteResult result = messages.deleteOne(Filters.eq("_id", new ObjectId(messageId)));
        if (result.getDeletedCount() <= 0) {
            return null;
        }

        refreshConversationSummary(conversationId);
        return existing;
    }

    public Document updateMessage(String conversationId, String messageId, String requester, String updatedMessage) {
        if (conversationId == null || conversationId.isBlank() || messageId == null || messageId.isBlank()
            || requester == null || requester.isBlank() || updatedMessage == null || updatedMessage.isBlank()) {
            return null;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> messages = db.getCollection("messages");

        Document existing;
        try {
            existing = messages.find(Filters.and(
                Filters.eq("_id", new ObjectId(messageId)),
                Filters.eq("conversationId", conversationId),
                Filters.eq("sender", requester)
            )).first();
        } catch (Exception ex) {
            return null;
        }

        if (existing == null) {
            return null;
        }

        String updatedAt = LocalDateTime.now().toString();
        UpdateResult result = messages.updateOne(
            Filters.eq("_id", new ObjectId(messageId)),
            Updates.combine(
                Updates.set("message", updatedMessage),
                Updates.set("edited", true),
                Updates.set("editedAt", updatedAt)
            )
        );

        if (result.getModifiedCount() <= 0) {
            return null;
        }

        existing.put("message", updatedMessage);
        existing.put("edited", true);
        existing.put("editedAt", updatedAt);

        refreshConversationSummary(conversationId);
        return existing;
    }

    private void refreshConversationSummary(String conversationId) {
        if (conversationId == null || conversationId.isBlank()) {
            return;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> conversations = db.getCollection("conversations");
        MongoCollection<Document> messages = db.getCollection("messages");

        Document conversation = findConversationById(conversations, conversationId);
        if (conversation == null) {
            return;
        }

        Document latest = messages.find(Filters.eq("conversationId", conversationId))
            .sort(Sorts.descending("timestamp"))
            .first();

        Document updateFields = new Document();
        if (latest != null) {
            updateFields.append("lastMessage", latest.getString("message") == null ? "" : latest.getString("message"));
            updateFields.append("lastMessageTime", latest.getString("timestamp") == null ? LocalDateTime.now().toString() : latest.getString("timestamp"));
        } else {
            updateFields.append("lastMessage", "");
            updateFields.append("lastMessageTime", LocalDateTime.now().toString());
        }

        Document badgeCounts = new Document();
        @SuppressWarnings("unchecked")
        List<String> participants = (List<String>) conversation.get("participants");
        if (participants != null) {
            for (String participant : participants) {
                if (participant != null && !participant.isBlank()) {
                    long unread = messages.countDocuments(Filters.and(
                        Filters.eq("conversationId", conversationId),
                        Filters.eq("receiver", participant),
                        Filters.eq("isRead", false)
                    ));
                    badgeCounts.append(participant, unread);
                }
            }
        }

        updateFields.append("participantBadgeCount", badgeCounts);
        conversations.updateOne(buildConversationIdFilter(conversationId), new Document("$set", updateFields));
    }

    private Document buildParticipantBadgeCount(Document conversation, String sender, String receiver) {
        Map<String, Integer> counts = new LinkedHashMap<>();

        if (conversation != null) {
            @SuppressWarnings("unchecked")
            List<String> participants = (List<String>) conversation.get("participants");
            if (participants != null) {
                for (String participant : participants) {
                    if (participant != null && !participant.isBlank()) {
                        counts.put(participant, 0);
                    }
                }
            }

            Object rawBadgeMap = conversation.get("participantBadgeCount");
            if (rawBadgeMap instanceof Document) {
                Document badgeDoc = (Document) rawBadgeMap;
                for (String key : badgeDoc.keySet()) {
                    Object value = badgeDoc.get(key);
                    counts.put(key, value instanceof Number ? ((Number) value).intValue() : 0);
                }
            }
        }

        if (sender != null && !sender.isBlank()) {
            counts.put(sender, counts.getOrDefault(sender, 0) + 1);
        }
        if (receiver != null && !receiver.isBlank()) {
            counts.put(receiver, counts.getOrDefault(receiver, 0) + 1);
        }

        return new Document(counts);
    }

    private void ensureParticipantBadgeCount(MongoCollection<Document> conversations, Document conversation) {
        if (conversation == null) {
            return;
        }

        Object existingBadgeMap = conversation.get("participantBadgeCount");
        if (existingBadgeMap instanceof Document) {
            return;
        }

        @SuppressWarnings("unchecked")
        List<String> participants = (List<String>) conversation.get("participants");
        if (participants == null || participants.isEmpty()) {
            return;
        }

        boolean hasLastMessage = conversation.getString("lastMessage") != null
            && !conversation.getString("lastMessage").isBlank();

        Document badgeDoc = new Document();
        for (String participant : participants) {
            if (participant != null && !participant.isBlank()) {
                badgeDoc.append(participant, hasLastMessage ? 1 : 0);
            }
        }

        conversation.put("participantBadgeCount", badgeDoc);
        conversations.updateOne(
            buildConversationIdFilter(extractConversationId(conversation)),
            Updates.set("participantBadgeCount", badgeDoc)
        );
    }

    private Document findConversationById(MongoCollection<Document> conversations, String conversationId) {
        return conversations.find(buildConversationIdFilter(conversationId)).first();
    }

    private Document buildConversationIdFilter(String conversationId) {
        try {
            return new Document("_id", new ObjectId(conversationId));
        } catch (Exception ex) {
            return new Document("_id", conversationId);
        }
    }
}
