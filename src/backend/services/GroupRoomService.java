package backend.services;

import backend.database.MongoConnection;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class GroupRoomService {

    public Document findRoomByName(String roomName) {
        if (isBlank(roomName)) {
            return null;
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        return rooms.find(new Document("roomNameLower", roomName.trim().toLowerCase())).first();
    }

    public List<Document> searchRooms(String query, String currentUser) {
        List<Document> roomList = new ArrayList<>();
        if (isBlank(query)) {
            return roomList;
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        String safeQuery = query.trim().toLowerCase();
        FindIterable<Document> results = rooms.find(new Document("roomNameLower", new Document("$regex", "^" + java.util.regex.Pattern.quote(safeQuery))))
                .sort(new Document("lastMessageTime", -1));

        for (Document doc : results) {
            roomList.add(doc);
        }
        return roomList;
    }

    public List<Document> getRoomsForUser(String username) {
        List<Document> roomList = new ArrayList<>();
        if (isBlank(username)) {
            return roomList;
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        FindIterable<Document> results = rooms.find(new Document("members", username)).sort(new Document("lastMessageTime", -1));
        for (Document doc : results) {
            roomList.add(doc);
        }
        return roomList;
    }

    public Document createRoom(String creator, String roomName, List<String> members) {
        if (isBlank(creator)) {
            throw new IllegalArgumentException("Creator is required");
        }
        if (isBlank(roomName)) {
            throw new IllegalArgumentException("Room name is required");
        }
        if (members == null || members.isEmpty()) {
            throw new IllegalArgumentException("Select at least one member");
        }

        String normalizedRoomName = roomName.trim();
        String normalizedLower = normalizedRoomName.toLowerCase();
        Document existing = findRoomByName(normalizedRoomName);
        if (existing != null) {
            throw new IllegalStateException("Room name already exists");
        }

        Set<String> participantSet = new LinkedHashSet<>();
        participantSet.add(creator.trim());
        for (String member : members) {
            if (!isBlank(member)) {
                participantSet.add(member.trim());
            }
        }

        if (participantSet.size() < 2) {
            throw new IllegalArgumentException("Add at least one other member");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        Document room = new Document()
                .append("roomName", normalizedRoomName)
                .append("roomNameLower", normalizedLower)
                .append("creator", creator.trim())
                .append("members", new ArrayList<>(participantSet))
                .append("lastMessage", "")
                .append("lastMessageTime", LocalDateTime.now().toString())
                .append("createdAt", LocalDateTime.now().toString());

        rooms.insertOne(room);
        Document inserted = rooms.find(new Document("roomNameLower", normalizedLower)).first();
        return inserted != null ? inserted : room;
    }

    public Document joinRoom(String username, String roomName) {
        if (isBlank(username) || isBlank(roomName)) {
            throw new IllegalArgumentException("Username and room name are required");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();
        Document room = rooms.find(new Document("roomNameLower", normalizedLower)).first();
        if (room == null) {
            throw new IllegalStateException("Room not found");
        }

        if (!isRoomMember(room, username)) {
            rooms.updateOne(
                    new Document("roomNameLower", normalizedLower),
                    new Document("$addToSet", new Document("members", username.trim()))
            );
            room = rooms.find(new Document("roomNameLower", normalizedLower)).first();
        }

        return room;
    }

    public String extractRoomId(Document room) {
        if (room == null) {
            return null;
        }
        Object idObj = room.get("_id");
        if (idObj instanceof ObjectId) {
            return ((ObjectId) idObj).toHexString();
        }
        return idObj != null ? idObj.toString() : null;
    }

    public boolean isRoomMember(Document room, String username) {
        if (room == null || isBlank(username)) {
            return false;
        }
        @SuppressWarnings("unchecked")
        List<String> members = (List<String>) room.get("members");
        if (members == null) {
            return false;
        }
        for (String member : members) {
            if (username.trim().equals(member)) {
                return true;
            }
        }
        return false;
    }

    public List<Document> getMessagesForRoom(String roomName) {
        List<Document> messages = new ArrayList<>();
        if (isBlank(roomName)) {
            return messages;
        }

        MongoCollection<Document> roomMessages = getRoomMessagesCollection();
        FindIterable<Document> results = roomMessages.find(new Document("roomNameLower", roomName.trim().toLowerCase())).sort(new Document("timestamp", 1));
        for (Document doc : results) {
            messages.add(doc);
        }
        return messages;
    }

    public String saveRoomMessage(String roomName, String sender, String message, String clientMessageId) {
        if (isBlank(roomName) || isBlank(sender) || isBlank(message)) {
            throw new IllegalArgumentException("Room name, sender and message are required");
        }

        MongoCollection<Document> roomMessages = getRoomMessagesCollection();
        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();
        ObjectId messageObjectId = new ObjectId();

        Document messageDoc = new Document()
                .append("_id", messageObjectId)
                .append("roomName", roomName.trim())
                .append("roomNameLower", normalizedLower)
                .append("sender", sender.trim())
                .append("message", message.trim())
                .append("clientMessageId", clientMessageId)
                .append("timestamp", LocalDateTime.now().toString())
                .append("isRead", false);

        roomMessages.insertOne(messageDoc);
        rooms.updateOne(
                new Document("roomNameLower", normalizedLower),
                new Document("$set", new Document("lastMessage", message.trim())
                        .append("lastMessageTime", LocalDateTime.now().toString()))
        );
        return messageObjectId.toHexString();
    }

    private MongoCollection<Document> getRoomsCollection() {
        MongoDatabase db = MongoConnection.getDatabase();
        return db.getCollection("group_rooms");
    }

    private MongoCollection<Document> getRoomMessagesCollection() {
        MongoDatabase db = MongoConnection.getDatabase();
        return db.getCollection("group_room_messages");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
