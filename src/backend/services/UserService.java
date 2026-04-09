package backend.services;

import backend.database.MongoConnection;
import backend.models.User;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.FindIterable;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

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
}