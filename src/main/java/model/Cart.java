package model;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class Cart {
    private Map<Integer, Integer> bookQuantities; // bookId -> quantity
    private List<Book> books;

    public Cart() {
        this.books = new LinkedList<>();
        this.bookQuantities = new HashMap<>();
    }

    public void addBook(Book book) {
        if (!books.contains(book)) {
            books.add(book);
            bookQuantities.put(book.getId(), 1);
        } else {
            int currentQuantity = bookQuantities.getOrDefault(book.getId(), 0);
            bookQuantities.put(book.getId(), currentQuantity + 1);
        }
    }

    public void updateQuantity(int bookId, int quantity) {
        if (quantity <= 0) {
            removeBook(bookId);
        } else {
            bookQuantities.put(bookId, quantity);
        }
    }

    public void removeBook(int bookId) {
        books.removeIf(book -> book.getId() == bookId);
        bookQuantities.remove(bookId);
    }

    public List<Book> getBooks() {
        return books;
    }

    public int getQuantity(int bookId) {
        return bookQuantities.getOrDefault(bookId, 0);
    }

    public double getTotalPrice() {
        return books.stream()
                .mapToDouble(book -> book.getPrice() * getQuantity(book.getId()))
                .sum();
    }
}