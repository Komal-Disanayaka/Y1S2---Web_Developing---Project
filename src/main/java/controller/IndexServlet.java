package controller;

// Servlet-ku thevaiyana classes import pandrom
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Review;
import service.BookService;
import service.ReviewService;

import java.io.IOException;
import java.util.List;


// Servlet-ku thevaiyana classes import pandrom
@WebServlet(urlPatterns = {"", "/index"})
public class IndexServlet extends HttpServlet {
    private BookService bookService;
    private ReviewService reviewService;

    // Servlet initialize aagumbothu intha method call aagum
    @Override
    public void init() throws ServletException {
        bookService = new BookService(getServletContext()); //initialize
        reviewService = new ReviewService(getServletContext());
    }

    // GET request varumbothu intha method execute aagum
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Ellaa books-um vangarathukku service call panrom
        List<Book> books = bookService.getAllBooks();
        // Books list-ah request object-la set panrom, JSP-ku pass pannathukku
        request.setAttribute("books", books);

        // Get top 3 reviews
        List<Review> topReviews = reviewService.getTopReviews(3);
        // Reviews-um request-la set pannrom
        request.setAttribute("topReviews", topReviews);

        // Data ready-a irukku, JSP-ku forward panrom to show in UI
        request.getRequestDispatcher("/views/index.jsp").forward(request, response);
    }
} 
