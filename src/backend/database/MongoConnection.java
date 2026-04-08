package backend.database;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import backend.models.User;
import java.util.Optional;
import io.github.cdimascio.dotenv.Dotenv;

public class MongoConnection {

    private static MongoDatabase database;

    public static MongoDatabase getDatabase() {

        if (database == null) {

            // Load environment variables from .env file
            Dotenv dotenv = Dotenv.configure().directory("e:/tomcat/apache-tomcat-10.1.53/webapps/chatapp").load();
            String uri = Optional.ofNullable(dotenv.get("MONGO_URI"))
                    .orElseThrow(() -> new IllegalStateException("Environment variable MONGO_URI is not set in .env file"));

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

    public User findUserByEmail(String email) {
        MongoCollection<Document> users = getDatabase().getCollection("users");
        Document query = new Document("email", email);
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