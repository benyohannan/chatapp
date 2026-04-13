package backend.services;

import backend.database.MongoConnection;
import backend.models.User;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.FindIterable;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class UserService {

    public void saveUser(User user) {

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");

        Document doc = new Document("firstName", user.getFirstName())
                .append("lastName", user.getLastName())
                .append("username", user.getUsername())
                .append("email", user.getEmail())
                .append("password", user.getPassword())
                .append("status", "offline");

        users.insertOne(doc);

        System.out.println("✅ User saved to MongoDB");
    }
// New method to get all users
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");

        FindIterable<Document> docs = users.find();
        for (Document doc : docs) {
            User user = new User(
                doc.getString("firstName"),
                doc.getString("lastName"),
                doc.getString("username"),
                doc.getString("email"),
                doc.getString("password")
            );
            userList.add(user);
        }
        return userList;
    }

    public List<Document> getRecentChats(String username) {
        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> chats = db.getCollection("chats");

        // Query to find recent chats for the user
        FindIterable<Document> results = chats.find(new Document("participants", username))
            .sort(new Document("lastMessageTime", -1)) // Sort by most recent
            .limit(10); // Limit to 10 recent chats

        List<Document> recentChats = new ArrayList<>();
        for (Document doc : results) {
            recentChats.add(doc);
        }
        return recentChats;
    }

    public List<String> searchUsersByUsername(String query, String excludeUsername, int limit) {
        List<String> usernames = new ArrayList<>();
        if (query == null || query.trim().isEmpty()) {
            return usernames;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");

        String safeQuery = Pattern.quote(query.trim());
        Pattern regex = Pattern.compile("^" + safeQuery, Pattern.CASE_INSENSITIVE);

        Bson filter;
        if (excludeUsername != null && !excludeUsername.trim().isEmpty()) {
            filter = new Document("$and", List.of(
                Filters.regex("username", regex),
                Filters.ne("username", excludeUsername.trim())
            ));
        } else {
            filter = Filters.regex("username", regex);
        }

        FindIterable<Document> docs = users.find(filter)
            .projection(Projections.include("username"))
            .limit(Math.max(limit, 1));

        for (Document doc : docs) {
            String username = doc.getString("username");
            if (username != null && !username.isBlank()) {
                usernames.add(username);
            }
        }

        return usernames;
    }
}