package service;

import model.Book;
import model.Cart;
import jakarta.servlet.ServletContext;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

public class CartService {
    private String CART_FILE_PATH;
    private static Map<String, Cart> userCarts = new HashMap<>();
    private BookService bookService;

    public CartService(ServletContext context, BookService bookService) {
        this.bookService = bookService;
        String realPath = context.getRealPath("/");
        CART_FILE_PATH = realPath + "data" + File.separator + "cart.txt";
        File file = new File(CART_FILE_PATH);
        System.out.println("Cart data file absolute path: " + file.getAbsolutePath());
        loadAllCarts();
    }

    public Cart getCart(String username) {
        if (!userCarts.containsKey(username)) {
            userCarts.put(username, new Cart());
        }
        return userCarts.get(username);
    }

    public void addToCart(String username, Book book) {
        Cart cart = getCart(username);
        cart.addBook(book);
        saveAllCarts();
    }

    public void updateQuantity(String username, int bookId, int quantity) {
        Cart cart = getCart(username);
        cart.updateQuantity(bookId, quantity);
        saveAllCarts();
    }

    public void removeFromCart(String username, int bookId) {
        Cart cart = getCart(username);
        cart.removeBook(bookId);
        saveAllCarts();
    }

    public void clearCart(String username) {
        Cart cart = getCart(username);
        cart.getBooks().clear();
        saveAllCarts();
    }

    public BookService getBookService() {
        return bookService;
    }

    private void loadCart(String username) {
        // This logic needs refinement if loading all carts at once
        // See loadAllCarts for the combined approach
    }

    private void loadAllCarts() {
        File file = new File(CART_FILE_PATH);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            return;
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            String currentUsername = null;
            Cart currentCart = null;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("USER:")) {
                    currentUsername = line.substring(5);
                    currentCart = new Cart();
                    userCarts.put(currentUsername, currentCart);
                } else if (currentUsername != null && line.startsWith("BOOK:")) {
                    try {
                        int bookId = Integer.parseInt(line.substring(5).split(",")[0]);
                        Book book = bookService.getBookById(bookId);
                        if (book != null && currentCart != null) {
                            currentCart.addBook(book);
                        }
                    } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) {
                        System.err.println("Skipping malformed book entry in cart file: " + line);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading all carts: " + e.getMessage());
        }
    }

    private void saveAllCarts() {
        File file = new File(CART_FILE_PATH);
        try {
            // Ensure the directory exists
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                if (!parentDir.mkdirs()) {
                    throw new IOException("Failed to create directory: " + parentDir.getAbsolutePath());
                }
            }
            
            // Try to create the file if it doesn't exist
            if (!file.exists()) {
                if (!file.createNewFile()) {
                    throw new IOException("Failed to create file: " + file.getAbsolutePath());
                }
            }
            
            // Write to the file
            try (PrintWriter writer = new PrintWriter(new FileWriter(file))) {
                for (Map.Entry<String, Cart> entry : userCarts.entrySet()) {
                    String username = entry.getKey();
                    Cart cart = entry.getValue();
                    if (!cart.getBooks().isEmpty()) {
                        writer.println("USER:" + username);
                        for (Book book : cart.getBooks()) {
                            writer.println("BOOK:" + book.getId());
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error saving cart data: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to save cart data. Please try again later.", e);
        }
    }
}