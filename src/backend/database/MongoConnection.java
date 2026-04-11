package backend.database;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import backend.models.User;

public class MongoConnection {

    private static MongoDatabase database;

    public static MongoDatabase getDatabase() {

        if (database == null) {

            String uri = "mongodb+srv://chatuser:chat123@cluster0.suv4mw3.mongodb.net/chatapp";

            MongoClient client = MongoClients.create(uri);
            database = client.getDatabase("chatapp");

            System.out.println("✅ Connected to MongoDB Atlas");
        }

        return database;
    }

    public void saveUser(User user) {
        MongoCollection<Document> users = getDatabase().getCollection("users");
        Document doc = new Document("firstName", user.getFirstName())
                .append("lastName", user.getLastName())
                .append("username", user.getUsername())
                .append("email", user.getEmail())
                .append("password", user.getPassword());
        users.insertOne(doc);
    }

    public User findUserByUsername(String username) {
        MongoCollection<Document> users = getDatabase().getCollection("users");
        Document query = new Document("username", username);
        Document result = users.find(query).first();

        if (result != null) {
            return new User(
                    result.getString("firstName"),
                    result.getString("lastName"),
                    result.getString("username"),
                    result.getString("email"),
                    result.getString("password")
            );
        }
        return null;
    }
}