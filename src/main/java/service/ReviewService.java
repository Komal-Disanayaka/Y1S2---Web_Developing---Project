package service;

import model.Review;
import jakarta.servlet.ServletContext;

import java.io.*;
import java.util.LinkedList;
import java.util.List;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReviewService {
    private static final Logger LOGGER = Logger.getLogger(ReviewService.class.getName());
    private static final String REVIEWS_FILE = "data" + File.separator + "reviews.txt";
    private final String reviewsFilePath;
    private List<Review> reviews;

    public ReviewService(ServletContext context) {
        reviews = new LinkedList<>();
        String realPath = context.getRealPath("/");
        reviewsFilePath = realPath + REVIEWS_FILE;
        File file = new File(reviewsFilePath);
        LOGGER.info("Review data file absolute path: " + file.getAbsolutePath());
        
        // Ensure the directory exists
        if (!file.getParentFile().exists()) {
            boolean created = file.getParentFile().mkdirs();
            if (!created) {
                LOGGER.warning("Failed to create directory: " + file.getParentFile().getAbsolutePath());
            }
        }
        
        loadReviews();
    }

    public void addReview(Review review) {
        LOGGER.info("Adding new review for order: " + review.getOrderNumber());
        reviews.add(review);
        saveReviews();
    }

    public List<Review> getReviews(int bookId) {
        List<Review> bookReviews = new LinkedList<>();
        for (Review review : reviews) {
            if (review.getBookId() == bookId) {
                bookReviews.add(review);
            }
        }
        return bookReviews;
    }

    public List<Review> getAllReviews() {
        LOGGER.info("Getting all reviews. Current count: " + reviews.size());
        return new LinkedList<>(reviews);
    }

    public List<Review> getTopReviews(int limit) {
        LOGGER.info("Getting top " + limit + " reviews");
        return reviews.stream()
                .sorted((r1, r2) -> Double.compare(r2.getRating(), r1.getRating())) // Sort by rating descending
                .limit(limit)
                .collect(java.util.stream.Collectors.toList());
    }

    private void loadReviews() {
        File file = new File(reviewsFilePath);
        if (!file.exists()) {
            LOGGER.info("Reviews file does not exist. Creating new file.");
            try {
                file.createNewFile();
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Failed to create reviews file", e);
            }
            return;
        }

        reviews.clear();
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                try {
                    String[] parts = line.split("\\|");
                    if (parts.length >= 5) {
                        Review review = new Review();
                        review.setUsername(parts[0]);
                        review.setOrderNumber(parts[1]);
                        review.setRating(Double.parseDouble(parts[2]));
                        review.setComment(parts[3]);
                        review.setDate(new Date(Long.parseLong(parts[4])));
                        reviews.add(review);
                        LOGGER.info("Loaded review from line " + lineNumber + " for order: " + review.getOrderNumber());
                    } else {
                        LOGGER.warning("Invalid review format at line " + lineNumber + ": " + line);
                    }
                } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) {
                    LOGGER.log(Level.WARNING, "Error parsing review at line " + lineNumber + ": " + line, e);
                }
            }
            LOGGER.info("Loaded " + reviews.size() + " reviews from file");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading reviews from " + reviewsFilePath, e);
        }
    }

    private void saveReviews() {
        File file = new File(reviewsFilePath);
        try (PrintWriter writer = new PrintWriter(new FileWriter(file))) {
            int count = 0;
            for (Review review : reviews) {
                writer.println(review.getUsername() + "|" +
                           review.getOrderNumber() + "|" +
                           review.getRating() + "|" +
                           review.getComment() + "|" +
                           review.getDate().getTime());
                count++;
            }
            LOGGER.info("Saved " + count + " reviews to file: " + reviewsFilePath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error saving reviews to " + reviewsFilePath, e);
        }
    }
}