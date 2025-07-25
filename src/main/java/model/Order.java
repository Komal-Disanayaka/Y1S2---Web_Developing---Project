package model;

import java.io.Serializable;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;
    private String orderNumber;
    private String username;
    private List<OrderBook> books;
    private double total;
    private Date date;
    private String orderStatus;
    private boolean reviewed;

    // Inner class to represent books in an order
    public static class OrderBook implements Serializable {
        private static final long serialVersionUID = 1L;
        private int bookId;
        private int quantity;
        private String bookTitle;
        private String bookAuthor;
        private double bookPrice;
        private String bookPhoto;
        private transient Book book;  // Keep this as transient for runtime use only

        public OrderBook() {
            this.quantity = 1;  // Default quantity
        }

        public OrderBook(int bookId, int quantity) {
            this.bookId = bookId;
            this.quantity = quantity;
        }

        public int getBookId() {
            return bookId;
        }

        public void setBookId(int bookId) {
            this.bookId = bookId;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public Book getBook() {
            return book;
        }

        public void setBook(Book book) {
            this.book = book;
            if (book != null) {
                this.bookId = book.getId();
                this.bookTitle = book.getTitle();
                this.bookAuthor = book.getAuthor();
                this.bookPrice = book.getPrice();
                this.bookPhoto = book.getPhoto();
            }
        }

        public String getBookTitle() {
            return bookTitle;
        }

        public String getBookAuthor() {
            return bookAuthor;
        }

        public double getBookPrice() {
            return bookPrice;
        }

        public String getBookPhoto() {
            return bookPhoto;
        }

        public double getSubtotal() {
            return bookPrice * quantity;
        }
    }

    public Order() {
        this.date = new Date();
        this.orderStatus = "Pending";
        this.books = new LinkedList<>();
        this.reviewed = false;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public List<OrderBook> getBooks() {
        return books;
    }

    public void setBooks(List<OrderBook> books) {
        this.books = books;
    }

    public void addBook(OrderBook book) {
        if (books == null) {
            books = new LinkedList<>();
        }
        books.add(book);
        calculateTotal();
    }

    public void removeBook(OrderBook book) {
        if (books != null) {
            books.remove(book);
            calculateTotal();
        }
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public void calculateTotal() {
        this.total = 0.0;
        if (books != null) {
            for (OrderBook book : books) {
                this.total += book.getSubtotal();
            }
        }
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public boolean isReviewed() {
        return reviewed;
    }

    public void setReviewed(boolean reviewed) {
        this.reviewed = reviewed;
    }
}