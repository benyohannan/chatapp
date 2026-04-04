package backend.services;

import backend.database.MongoConnection;
import backend.models.User;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import org.bson.Document;

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
}