package model;

import java.util.Date;

public class Review {
    private String username;
    private String orderNumber;
    private double rating;
    private String comment;
    private Date date;
    private int bookId; // Optional, only used for book reviews

    // Default constructor
    public Review() {
    }

    // Constructor for order reviews
    public Review(String username, String orderNumber, double rating, String comment) {
        this.username = username;
        this.orderNumber = orderNumber;
        this.rating = rating;
        this.comment = comment;
        this.date = new Date();
    }

    // Constructor for book reviews
    public Review(int bookId, String username, String comment, double rating) {
        this.bookId = bookId;
        this.username = username;
        this.comment = comment;
        this.rating = rating;
        this.date = new Date();
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
}