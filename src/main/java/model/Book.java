package model;

public class Book{

    private int id;
    private String title;
    private String author;
    private double price;
    private double rating;
    private String photo;
    private int stockQuantity;
    private String description;
    private String isbn;
    private String category;

    public Book() {
    }

    public Book(int id, String title, String author, double price, String isbn, String description, String category, String photo, double rating) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.isbn = isbn;
        this.description = description;
        this.category = category;
        this.photo = photo;
        this.rating = rating;
        this.stockQuantity = 0;
    }

    public Book(int id, String title, String author, double price, double rating, String photo) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.rating = rating;
        this.photo = photo;
        this.stockQuantity = 0;
        this.description = "";
        this.isbn = "";
    }

    public Book(int id, String title, String author, double price, double rating, String photo, int stockQuantity) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.rating = rating;
        this.photo = photo;
        this.stockQuantity = stockQuantity;
        this.description = "";
        this.isbn = "";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getPrice() {
        return price;

    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", price=" + price +
                ", rating=" + rating +
                ", photo='" + photo + '\'' +
                ", stockQuantity=" + stockQuantity +
                ", description='" + description + '\'' +
                ", isbn='" + isbn + '\'' +
                ", category='" + category + '\'' +
                '}';
    }
}