package backend.services;

import backend.database.MongoConnection;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.conversions.Bson;
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
        String now = LocalDateTime.now().toString();

        Document room = new Document()
                .append("roomName", normalizedRoomName)
                .append("roomNameLower", normalizedLower)
                .append("creator", creator.trim())
                .append("members", new ArrayList<>(participantSet))
                .append("pendingRequests", new ArrayList<String>())
            .append("lastReadBy", buildLastReadBy(new ArrayList<>(participantSet), now))
            .append("adminOnlyMode", false)
                .append("lastMessage", "")
            .append("lastMessageTime", now)
            .append("createdAt", now);

        rooms.insertOne(room);
        Document inserted = rooms.find(new Document("roomNameLower", normalizedLower)).first();
        return inserted != null ? inserted : room;
    }

    public Document joinRoom(String username, String roomName) {
        return requestJoinRoom(username, roomName);
    }

    public Document requestJoinRoom(String username, String roomName) {
        if (isBlank(username) || isBlank(roomName)) {
            throw new IllegalArgumentException("Username and room name are required");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();
        Document room = rooms.find(new Document("roomNameLower", normalizedLower)).first();
        if (room == null) {
            throw new IllegalStateException("Room not found");
        }

        String cleanUsername = username.trim();
        if (isRoomMember(room, cleanUsername)) {
            return room;
        }

        if (isCreator(room, cleanUsername)) {
            rooms.updateOne(
                new Document("roomNameLower", normalizedLower),
                Updates.combine(
                    Updates.addToSet("members", cleanUsername),
                    Updates.set("lastReadBy." + cleanUsername, LocalDateTime.now().toString())
                )
            );
            return rooms.find(new Document("roomNameLower", normalizedLower)).first();
        }

        rooms.updateOne(
            new Document("roomNameLower", normalizedLower),
            new Document("$addToSet", new Document("pendingRequests", cleanUsername))
        );

        return rooms.find(new Document("roomNameLower", normalizedLower)).first();
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

    public boolean isCreator(Document room, String username) {
        if (room == null || isBlank(username)) {
            return false;
        }
        String creator = room.getString("creator");
        return creator != null && username.trim().equals(creator.trim());
    }

    public List<String> getPendingRequests(String roomName, String requester) {
        Document room = requireCreatorAccess(roomName, requester);
        List<String> pending = room.getList("pendingRequests", String.class);
        return pending == null ? new ArrayList<>() : new ArrayList<>(pending);
    }

    public int getPendingRequestCount(String roomName, String requester) {
        return getPendingRequests(roomName, requester).size();
    }

    public Document approveJoinRequest(String roomName, String creator, String usernameToApprove) {
        if (isBlank(roomName) || isBlank(creator) || isBlank(usernameToApprove)) {
            throw new IllegalArgumentException("roomName, creator and username are required");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();
        String cleanUsername = usernameToApprove.trim();
        Document room = requireCreatorAccess(roomName, creator);
        List<String> pending = room.getList("pendingRequests", String.class);

        if (pending == null || !pending.contains(cleanUsername)) {
            throw new IllegalStateException("Join request not found");
        }

        UpdateResult result = rooms.updateOne(
            Filters.eq("roomNameLower", normalizedLower),
            Updates.combine(
                Updates.pull("pendingRequests", cleanUsername),
                Updates.addToSet("members", cleanUsername),
                Updates.set("lastReadBy." + cleanUsername, LocalDateTime.now().toString())
            )
        );

        if (result.getMatchedCount() <= 0) {
            throw new IllegalStateException("Unable to approve join request");
        }

        return rooms.find(Filters.eq("roomNameLower", normalizedLower)).first();
    }

    public Document declineJoinRequest(String roomName, String creator, String usernameToDecline) {
        if (isBlank(roomName) || isBlank(creator) || isBlank(usernameToDecline)) {
            throw new IllegalArgumentException("roomName, creator and username are required");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();
        String cleanUsername = usernameToDecline.trim();
        Document room = requireCreatorAccess(roomName, creator);
        List<String> pending = room.getList("pendingRequests", String.class);

        if (pending == null || !pending.contains(cleanUsername)) {
            throw new IllegalStateException("Join request not found");
        }

        UpdateResult result = rooms.updateOne(
            Filters.eq("roomNameLower", normalizedLower),
            Updates.pull("pendingRequests", cleanUsername)
        );

        if (result.getMatchedCount() <= 0) {
            throw new IllegalStateException("Unable to decline join request");
        }

        return rooms.find(Filters.eq("roomNameLower", normalizedLower)).first();
    }

    public Document removeMember(String roomName, String creator, String usernameToRemove) {
        if (isBlank(roomName) || isBlank(creator) || isBlank(usernameToRemove)) {
            throw new IllegalArgumentException("roomName, creator and username are required");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();
        String cleanUsername = usernameToRemove.trim();
        Document room = requireCreatorAccess(roomName, creator);

        if (isCreator(room, cleanUsername)) {
            throw new IllegalStateException("Room creator cannot be removed");
        }

        List<String> members = room.getList("members", String.class);
        if (members == null || !members.contains(cleanUsername)) {
            throw new IllegalStateException("Member not found");
        }

        UpdateResult result = rooms.updateOne(
            Filters.eq("roomNameLower", normalizedLower),
            Updates.combine(
                Updates.pull("members", cleanUsername),
                Updates.pull("pendingRequests", cleanUsername),
                Updates.unset("lastReadBy." + cleanUsername)
            )
        );

        if (result.getMatchedCount() <= 0) {
            throw new IllegalStateException("Unable to remove member");
        }

        return rooms.find(Filters.eq("roomNameLower", normalizedLower)).first();
    }

    public Document setAdminOnlyMode(String roomName, String creator, boolean enabled) {
        if (isBlank(roomName) || isBlank(creator)) {
            throw new IllegalArgumentException("roomName and creator are required");
        }

        MongoCollection<Document> rooms = getRoomsCollection();
        Document room = requireCreatorAccess(roomName, creator);
        String normalizedLower = room.getString("roomNameLower");

        UpdateResult result = rooms.updateOne(
            Filters.eq("roomNameLower", normalizedLower),
            Updates.set("adminOnlyMode", enabled)
        );

        if (result.getMatchedCount() <= 0) {
            throw new IllegalStateException("Unable to update admin-only mode");
        }

        return rooms.find(Filters.eq("roomNameLower", normalizedLower)).first();
    }

    public boolean isAdminOnlyMode(Document room) {
        if (room == null) {
            return false;
        }
        return room.getBoolean("adminOnlyMode", false);
    }

    private Document requireCreatorAccess(String roomName, String requester) {
        if (isBlank(roomName) || isBlank(requester)) {
            throw new IllegalArgumentException("roomName and requester are required");
        }

        Document room = findRoomByName(roomName);
        if (room == null) {
            throw new IllegalStateException("Room not found");
        }
        if (!isCreator(room, requester)) {
            throw new IllegalStateException("Only the room creator can manage join requests");
        }
        return room;
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

    public void markRoomAsRead(String roomName, String username) {
        if (isBlank(roomName) || isBlank(username)) {
            return;
        }

        String normalizedRoomName = roomName.trim().toLowerCase();
        String cleanUsername = username.trim();
        Document room = findRoomByName(roomName);
        if (room == null || !isRoomMember(room, cleanUsername)) {
            return;
        }

        getRoomsCollection().updateOne(
            Filters.eq("roomNameLower", normalizedRoomName),
            Updates.set("lastReadBy." + cleanUsername, LocalDateTime.now().toString())
        );
    }

    public long getUnreadCountForRoom(String roomName, String username) {
        if (isBlank(roomName) || isBlank(username)) {
            return 0;
        }

        String cleanUsername = username.trim();
        Document room = findRoomByName(roomName);
        if (room == null || !isRoomMember(room, cleanUsername)) {
            return 0;
        }

        Document lastReadBy = room.get("lastReadBy", Document.class);
        String lastReadAt = lastReadBy != null ? lastReadBy.getString(cleanUsername) : null;

        if (isBlank(lastReadAt)) {
            String now = LocalDateTime.now().toString();
            getRoomsCollection().updateOne(
                Filters.eq("roomNameLower", roomName.trim().toLowerCase()),
                Updates.set("lastReadBy." + cleanUsername, now)
            );
            return 0;
        }

        List<Bson> filters = new ArrayList<>();
        filters.add(Filters.eq("roomNameLower", roomName.trim().toLowerCase()));
        filters.add(Filters.ne("sender", cleanUsername));
        if (!isBlank(lastReadAt)) {
            filters.add(Filters.gt("timestamp", lastReadAt));
        }

        return getRoomMessagesCollection().countDocuments(Filters.and(filters));
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

    public boolean deleteRoomMessage(String roomName, String messageId, String requester) {
        if (isBlank(roomName) || isBlank(messageId) || isBlank(requester)) {
            return false;
        }

        MongoCollection<Document> roomMessages = getRoomMessagesCollection();
        Document existing;
        try {
            existing = roomMessages.find(Filters.and(
                    Filters.eq("_id", new ObjectId(messageId)),
                    Filters.eq("roomNameLower", roomName.trim().toLowerCase()),
                    Filters.eq("sender", requester.trim())
            )).first();
        } catch (Exception ex) {
            return false;
        }

        if (existing == null) {
            return false;
        }

        DeleteResult result = roomMessages.deleteOne(Filters.eq("_id", new ObjectId(messageId)));
        if (result.getDeletedCount() <= 0) {
            return false;
        }

        refreshRoomSummary(roomName);
        return true;
    }

    public Document updateRoomMessage(String roomName, String messageId, String requester, String updatedMessage) {
        if (isBlank(roomName) || isBlank(messageId) || isBlank(requester) || isBlank(updatedMessage)) {
            return null;
        }

        MongoCollection<Document> roomMessages = getRoomMessagesCollection();
        Document existing;
        try {
            existing = roomMessages.find(Filters.and(
                Filters.eq("_id", new ObjectId(messageId)),
                Filters.eq("roomNameLower", roomName.trim().toLowerCase()),
                Filters.eq("sender", requester.trim())
            )).first();
        } catch (Exception ex) {
            return null;
        }

        if (existing == null) {
            return null;
        }

        String editedAt = LocalDateTime.now().toString();
        UpdateResult result = roomMessages.updateOne(
            Filters.eq("_id", new ObjectId(messageId)),
            Updates.combine(
                Updates.set("message", updatedMessage.trim()),
                Updates.set("edited", true),
                Updates.set("editedAt", editedAt)
            )
        );

        if (result.getModifiedCount() <= 0) {
            return null;
        }

        existing.put("message", updatedMessage.trim());
        existing.put("edited", true);
        existing.put("editedAt", editedAt);
        refreshRoomSummary(roomName);
        return existing;
    }

    private void refreshRoomSummary(String roomName) {
        if (isBlank(roomName)) {
            return;
        }

        MongoCollection<Document> roomMessages = getRoomMessagesCollection();
        MongoCollection<Document> rooms = getRoomsCollection();
        String normalizedLower = roomName.trim().toLowerCase();

        Document latest = roomMessages.find(new Document("roomNameLower", normalizedLower))
                .sort(Sorts.descending("timestamp"))
                .first();

        Document update = new Document();
        if (latest != null) {
            update.append("lastMessage", latest.getString("message") == null ? "" : latest.getString("message"));
            update.append("lastMessageTime", latest.getString("timestamp") == null ? LocalDateTime.now().toString() : latest.getString("timestamp"));
        } else {
            update.append("lastMessage", "");
            update.append("lastMessageTime", LocalDateTime.now().toString());
        }

        rooms.updateOne(new Document("roomNameLower", normalizedLower), new Document("$set", update));
    }

    private MongoCollection<Document> getRoomsCollection() {
        MongoDatabase db = MongoConnection.getDatabase();
        return db.getCollection("group_rooms");
    }

    private MongoCollection<Document> getRoomMessagesCollection() {
        MongoDatabase db = MongoConnection.getDatabase();
        return db.getCollection("group_room_messages");
    }

    private Document buildLastReadBy(List<String> usernames, String timestamp) {
        Document lastReadBy = new Document();
        if (usernames == null || usernames.isEmpty()) {
            return lastReadBy;
        }

        String safeTimestamp = isBlank(timestamp) ? LocalDateTime.now().toString() : timestamp;
        for (String username : usernames) {
            if (!isBlank(username)) {
                lastReadBy.append(username.trim(), safeTimestamp);
            }
        }
        return lastReadBy;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
