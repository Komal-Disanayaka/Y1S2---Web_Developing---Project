package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.Review;
import model.User;
import service.OrderService;
import service.ReviewService;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());
    private ReviewService reviewService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        reviewService = new ReviewService(getServletContext());
        orderService = new OrderService(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || "viewAll".equals(action)) {
            List<Review> reviews = reviewService.getAllReviews();
            LOGGER.log(Level.INFO, "Retrieved {0} reviews", reviews.size());
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/views/reviews.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "showAddReview":
                String orderNumber = request.getParameter("orderNumber");
                Order order = orderService.getOrderByNumber(orderNumber);
                if (order != null) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/views/addOrderReview.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                }
                break;
            case "getReviews":
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                List<Review> reviews = reviewService.getReviews(bookId);
                request.setAttribute("reviews", reviews);
                request.getRequestDispatcher("/views/reviewsCarousel.jsp").forward(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("addOrderReview".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/views/login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            String orderNumber = request.getParameter("orderNumber");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            Review review = new Review();
            review.setUsername(user.getUsername());
            review.setOrderNumber(orderNumber);
            review.setRating(rating);
            review.setComment(comment);
            review.setDate(new Date());

            try {
                reviewService.addReview(review);
                // Update order to mark it as reviewed
                Order order = orderService.getOrderByNumber(orderNumber);
                if (order != null) {
                    order.setReviewed(true);
                    orderService.updateOrder(order);
                }
                response.sendRedirect(request.getContextPath() + "/OrderServlet");
            } catch (Exception e) {
                request.setAttribute("error", "Failed to add review. Please try again.");
                request.getRequestDispatcher("/views/addOrderReview.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
}