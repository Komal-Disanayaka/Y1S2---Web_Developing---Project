package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Book;
import model.Order;
import model.User;
import service.BookService;
import service.OrderService;
import service.UserService;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024
)
public class AdminServlet extends HttpServlet {
    private BookService bookService;
    private OrderService orderService;
    private UserService userService;
    private static final String UPLOAD_DIRECTORY = "bookphotos";

    @Override
    public void init() throws ServletException {
        bookService = new BookService(getServletContext());
        orderService = new OrderService(getServletContext());
        userService = new UserService(getServletContext());
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !((User)session.getAttribute("user")).isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("getOrderDetails".equals(action)) {
            String orderNumber = request.getParameter("orderNumber");
            Order order = orderService.getOrderByNumber(orderNumber);
            if (order != null) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/views/orderDetails.jsp").forward(request, response);
                return;
            }
        }

        if ("deleteUser".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean deleted = userService.deleteUser(userId);
                if (deleted) {
                    request.getSession().setAttribute("message", "User deleted successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to delete user. Cannot delete admin user.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid user ID");
            }
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
            return;
        }

        List<Book> books = bookService.getAllBooks();
        List<Order> orders = orderService.getAllOrders();
        List<User> users = userService.getAllUsers();

        request.setAttribute("books", books);
        request.setAttribute("orders", orders);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/adminDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !((User)session.getAttribute("user")).isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "addBook":
                addBook(request, response);
                break;
            case "editBook":
                editBook(request, response);
                break;
            case "deleteBook":
                deleteBook(request, response);
                break;
            case "updateOrderStatus":
                updateOrderStatus(request, response);
                break;
            case "deleteOrder":
                deleteOrder(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/AdminServlet");
        }
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            double price = Double.parseDouble(request.getParameter("price"));
            String isbn = request.getParameter("isbn");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            double rating = Double.parseDouble(request.getParameter("rating"));

            Part photoPart = request.getPart("photo");
            String fileName = photoPart.getSubmittedFileName();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;


            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            photoPart.write(uploadPath + File.separator + uniqueFileName);


            Book book = new Book(
                    bookService.getNextId(),
                    title,
                    author,
                    price,
                    isbn,
                    description,
                    category,
                    uniqueFileName,
                    rating
            );

            bookService.addBook(book);
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding book: " + e.getMessage());
        }
    }

    private void editBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            double price = Double.parseDouble(request.getParameter("price"));
            double rating = Double.parseDouble(request.getParameter("rating"));
            String description = request.getParameter("description");

            Book existingBook = bookService.getBookById(id);
            if (existingBook != null) {
                Book updatedBook = new Book(id, title, author, price, rating, existingBook.getPhoto());
                updatedBook.setDescription(description);
                bookService.updateBook(updatedBook);
                response.sendRedirect(request.getContextPath() + "/AdminServlet");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating book: " + e.getMessage());
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            bookService.removeBook(bookId);
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
        } catch (Exception e) {
            request.setAttribute("error", "Failed to delete book: " + e.getMessage());
            request.getRequestDispatcher("/views/adminDashboard.jsp").forward(request, response);
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String orderNumber = request.getParameter("orderNumber");
            String status = request.getParameter("status");
            orderService.updateOrderStatus(orderNumber, status);
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
        } catch (Exception e) {
            request.setAttribute("error", "Failed to update order status: " + e.getMessage());
            request.getRequestDispatcher("/views/adminDashboard.jsp").forward(request, response);
        }
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String orderNumber = request.getParameter("orderNumber");
            orderService.deleteOrder(orderNumber);
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
        } catch (Exception e) {
            request.setAttribute("error", "Failed to delete order: " + e.getMessage());
            request.getRequestDispatcher("/views/adminDashboard.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "";
    }
}