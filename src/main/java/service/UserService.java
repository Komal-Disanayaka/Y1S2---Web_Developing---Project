package service;

import model.User;
import jakarta.servlet.ServletContext;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    private static String FILE_PATH;
    private List<User> users;
    private int nextId = 1; // For assigning new IDs

    public UserService(ServletContext context) {
        users = new ArrayList<>();
        // Get the real path of the web application
        String realPath = context.getRealPath("/");
        // Create data directory if it doesn't exist
        File dataDir = new File(realPath + "data");
        if (!dataDir.exists()) {
            dataDir.mkdirs();
        }
        // Set the file path
        FILE_PATH = dataDir.getAbsolutePath() + File.separator + "users.txt";
        File file = new File(FILE_PATH);
        System.out.println("User data file absolute path: " + file.getAbsolutePath());
        loadUsers();
    }

    public User login(String username, String password) {
        for (User user : users) {
            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null;
    }

    public boolean register(String username, String password, String email) {
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return false;
            }
        }
        User newUser = new User(nextId++, username, password, email, false); // Assign new ID
        users.add(newUser);
        saveUsers();
        return true;
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        for (User user : users) {
            if (user.getId() == userId) {
                if (user.getPassword().equals(currentPassword)) {
                    user.setPassword(newPassword);
                    saveUsers();
                    return true;
                } else {
                    return false; // Current password incorrect
                }
            }
        }
        return false; // User not found
    }

    public boolean isAdmin(String username) {
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return user.isAdmin();
            }
        }
        return false;
    }

    private void loadUsers() {
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            // Add default admin with ID 1
            users.add(new User(nextId++, "admin", "admin123", "admin@bookstore.com", true));
            saveUsers();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int maxId = 0;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) { // id,username,password,email,isAdmin
                    int id = Integer.parseInt(parts[0]);
                    String username = parts[1];
                    String password = parts[2];
                    String email = parts[3];
                    boolean isAdmin = Boolean.parseBoolean(parts[4]);
                    users.add(new User(id, username, password, email, isAdmin));
                    if (id > maxId) {
                        maxId = id;
                    }
                } else if (parts.length == 4) { // Legacy: username,password,email,isAdmin
                    // Assign a new ID for old format for forward compatibility,
                    // though this means IDs might change on first load if mixed formats exist.
                    // Best to migrate users.txt fully.
                    int id = nextId++; // Or some other temporary ID assignment strategy
                    String username = parts[0];
                    String password = parts[1];
                    String email = parts[2];
                    boolean isAdmin = Boolean.parseBoolean(parts[3]);
                    users.add(new User(id, username, password, email, isAdmin));
                    if (id > maxId) { // Update maxId for the newly assigned ID
                        maxId = id;
                    }
                }
            }
            nextId = maxId + 1; // Ensure nextId is greater than any loaded ID
        } catch (IOException | NumberFormatException e) {
            e.printStackTrace();
            // Consider what to do if file is corrupt or unreadable
            // For now, if loading fails, we might start with an empty list or default admin
            if (users.isEmpty()) {
                if (file.exists()) file.delete(); // Attempt to delete corrupted file to allow recreation
                file.getParentFile().mkdirs();
                users.clear(); // Clear any partially loaded users
                nextId = 1; // Reset nextId
                users.add(new User(nextId++, "admin", "admin123", "admin@bookstore.com", true));
                saveUsers();
            }
        }
    }

    private void saveUsers() {
        File file = new File(FILE_PATH);
        try {
            // Ensure the directory exists
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                if (!parentDir.mkdirs()) {
                    throw new IOException("Failed to create directory: " + parentDir.getAbsolutePath());
                }
            }
            
            // Create a temporary file for atomic write
            File tempFile = new File(FILE_PATH + ".tmp");
            try (PrintWriter writer = new PrintWriter(new FileWriter(tempFile))) {
                for (User user : users) {
                    String line = user.getId() + "," + user.getUsername() + "," +
                            user.getPassword() + "," + user.getEmail() + "," + user.isAdmin();
                    writer.println(line);
                    System.out.println("Writing user: " + line);
                }
            }
            
            // If the original file exists, delete it
            if (file.exists()) {
                file.delete();
            }
            
            // Rename the temporary file to the original file
            if (!tempFile.renameTo(file)) {
                throw new IOException("Failed to rename temporary file to " + FILE_PATH);
            }
            
            System.out.println("Successfully saved " + users.size() + " users to: " + file.getAbsolutePath());
        } catch (IOException e) {
            System.err.println("Error saving users to file: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean verifyPassword(int userId, String password) {
        for (User user : users) {
            if (user.getId() == userId) {
                return user.getPassword().equals(password);
            }
        }
        return false;
    }

    public boolean updateProfile(int userId, String newUsername, String newEmail) {
        System.out.println("Updating profile for user ID: " + userId);
        System.out.println("New username: " + newUsername);
        System.out.println("New email: " + newEmail);
        
        // Check if new username is already taken by another user
        for (User user : users) {
            if (user.getId() != userId && user.getUsername().equals(newUsername)) {
                System.out.println("Username already taken by another user");
                return false;
            }
        }

        // Update the user's profile
        for (User user : users) {
            if (user.getId() == userId) {
                System.out.println("Found user to update. Current data:");
                System.out.println("Current username: " + user.getUsername());
                System.out.println("Current email: " + user.getEmail());
                
                user.setUsername(newUsername);
                user.setEmail(newEmail);
                System.out.println("Updated user data:");
                System.out.println("New username: " + user.getUsername());
                System.out.println("New email: " + user.getEmail());
                
                saveUsers();
                return true;
            }
        }
        System.out.println("User not found with ID: " + userId);
        return false;
    }

    public List<User> getAllUsers() {
        // Return a copy of the current users list without reloading
        return new ArrayList<>(users);
    }

    public boolean deleteUser(int userId) {
        System.out.println("Attempting to delete user with ID: " + userId);
        
        // Don't allow deleting the admin user
        for (User user : users) {
            if (user.getId() == userId && user.isAdmin()) {
                System.out.println("Cannot delete admin user");
                return false;
            }
        }
        
        // Remove user and save changes
        boolean removed = users.removeIf(user -> user.getId() == userId);
        if (removed) {
            System.out.println("User removed from memory, saving to file...");
            // Write directly to file without reloading
            File file = new File(FILE_PATH);
            try {
                // Create a temporary file for atomic write
                File tempFile = new File(FILE_PATH + ".tmp");
                try (PrintWriter writer = new PrintWriter(new FileWriter(tempFile))) {
                    for (User user : users) {
                        String line = user.getId() + "," + user.getUsername() + "," +
                                user.getPassword() + "," + user.getEmail() + "," + user.isAdmin();
                        writer.println(line);
                        System.out.println("Writing user: " + line);
                    }
                }
                
                // If the original file exists, delete it
                if (file.exists()) {
                    file.delete();
                }
                
                // Rename the temporary file to the original file
                if (!tempFile.renameTo(file)) {
                    throw new IOException("Failed to rename temporary file to " + FILE_PATH);
                }
                
                System.out.println("Successfully saved " + users.size() + " users to: " + file.getAbsolutePath());
            } catch (IOException e) {
                System.err.println("Error saving users to file: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
            System.out.println("User deletion completed successfully");
        } else {
            System.out.println("User not found with ID: " + userId);
        }
        return removed;
    }
}