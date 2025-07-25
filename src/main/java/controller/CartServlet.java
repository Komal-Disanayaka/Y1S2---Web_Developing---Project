package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.User;
import service.BookService;
import service.CartService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private CartService cartService;
    private BookService bookService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        bookService = new BookService(getServletContext());
        cartService = new CartService(getServletContext(), bookService);
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("cart", cartService.getCart(user.getUsername()));
        request.getRequestDispatcher("/views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        Map<String, Object> responseData = new HashMap<>();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                responseData.put("success", false);
                responseData.put("message", "Please login to add items to cart");
                response.getWriter().write(gson.toJson(responseData));
                return;
            }

            User user = (User) session.getAttribute("user");
            String action = request.getParameter("action");

            if ("add".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                Book book = bookService.getBookById(bookId);
                if (book != null) {
                    cartService.addToCart(user.getUsername(), book);
                    responseData.put("success", true);
                    responseData.put("message", "Book added to cart successfully");
                    responseData.put("cartCount", cartService.getCart(user.getUsername()).getBooks().size());
                } else {
                    responseData.put("success", false);
                    responseData.put("message", "Book not found");
                }
            } else if ("update".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartService.updateQuantity(user.getUsername(), bookId, quantity);
                responseData.put("success", true);
                responseData.put("message", "Cart updated successfully");
            } else if ("remove".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                cartService.removeFromCart(user.getUsername(), bookId);
                responseData.put("success", true);
                responseData.put("message", "Book removed from cart");
            } else if ("checkout".equals(action)) {
                request.setAttribute("cart", cartService.getCart(user.getUsername()));
                request.getRequestDispatcher("/views/checkout.jsp").forward(request, response);
                return;
            } else {
                responseData.put("success", false);
                responseData.put("message", "Invalid action");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseData.put("success", false);
            responseData.put("message", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.getWriter().write(gson.toJson(responseData));
    }
}