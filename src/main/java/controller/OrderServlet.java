package controller;

// Servlet classes import pandrom
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.Order.OrderBook;
import model.User;
import service.BookService;
import service.CartService;
import service.OrderService;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


// Intha servlet URL /OrderServlet-ku map pannirukom
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(OrderServlet.class.getName()); // Logger use pannrom error log panna
    private OrderService orderService; //declare
    private CartService cartService;
    private BookService bookService;

    // Servlet start aagumbothu initialize panra method
    @Override
    public void init() throws ServletException {
        bookService = new BookService(getServletContext()); // create
        cartService = new CartService(getServletContext(), bookService);
        orderService = new OrderService(getServletContext());
    }

    // GET request handle pannra method
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Session check panrom
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        // Logged-in user-oda data eduthukrom
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        // User order-a view panna try panra scenario
        try {
            if ("view".equals(action)) {
                String orderNumber = request.getParameter("orderNumber");
                if (orderNumber == null || orderNumber.trim().isEmpty()) {
                    throw new ServletException("Order number is required");
                }
                
                Order order = orderService.getOrderByNumber(orderNumber);
                if (order == null) {
                    throw new ServletException("Order not found");
                }

                // Different user order-a view panna try panna
                if (!order.getUsername().equals(user.getUsername())) {
                    throw new ServletException("Unauthorized access to order");
                }

                // Order details request-la set panni, orderDetails.jsp-ku forward panrom
                request.setAttribute("order", order);
                request.getRequestDispatcher("/views/orderDetails.jsp").forward(request, response);
                return;
            }
            
            // List all orders for the user
            List<Order> orders = orderService.getUserOrders(user.getUsername());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/views/orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Yethavathu error na log panni error.jsp-ku forward panrom
            LOGGER.log(Level.SEVERE, "Error processing order request", e);
            request.setAttribute("error", "An error occurred while processing your request: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    // POST request handle pannra method
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Session check panrom, illena login page-ku redirect
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user"); // User details eduthukrom
        String action = request.getParameter("action");
        
        try {
            if ("placeOrder".equals(action)) {
                // Cart-la irukkura books-ah eduthuttu, order items list prepare panrom
                List<OrderBook> orderItems = cartService.getCart(user.getUsername()).getBooks().stream()
                    .map(book -> {
                        OrderBook item = new OrderBook();
                        item.setBookId(book.getId());
                        item.setQuantity(1); // Default quantity
                        return item;
                    })
                    .toList();

                // Cart empty-na error throw pannrom
                if (orderItems.isEmpty()) {
                    throw new ServletException("Your cart is empty. Please add some books before placing an order.");
                }
                
                // Create the order and get the order number
                Order order = orderService.createOrder(user.getUsername(), orderItems);
                cartService.clearCart(user.getUsername());
                
                // Redirect to the order details page
                response.sendRedirect(request.getContextPath() + "/OrderServlet?action=view&orderNumber=" + order.getOrderNumber());
            } else {
                response.sendRedirect(request.getContextPath() + "/OrderServlet");
            }
            // Error vandha log pannitu error page-ku redirect panrom
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing order request", e);
            request.setAttribute("error", "An error occurred while processing your request: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
