package controller;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Book;
import service.BookService;

import java.io.IOException;
import java.util.List;

@WebServlet("/books/*")
public class BookServlet extends HttpServlet {

    private BookService bookService;

    @Override
    public void init() throws ServletException {
        bookService = new BookService(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            String action = request.getParameter("action");

            if ("search".equals(action)) {
                String query = request.getParameter("query");
                String searchType = request.getParameter("searchType");
                List<Book> books = bookService.searchBooks(query, searchType);
                request.setAttribute("books", books);
                request.setAttribute("searchQuery", query);
                request.setAttribute("searchType", searchType);

            } else if ("sort".equals(action)) {
                String sortBy = request.getParameter("sortBy");
                List<Book> books = bookService.getAllBooks();

                if ("price".equals(sortBy)) {
                    books = bookService.sortBooksByPrice(true); // true for ascending
                } else if ("rating".equals(sortBy)) {
                    books = bookService.sortBooksByRating(true); // true for ascending
                }

                request.setAttribute("books", books);
                request.setAttribute("sortBy", sortBy);
            } else {
                List<Book> books = bookService.getAllBooks();
                request.setAttribute("books", books);
            }

            request.getRequestDispatcher("/views/bookList.jsp").forward(request, response);
        } else {
            try {
                int bookId = Integer.parseInt(pathInfo.substring(1));
                Book book = bookService.getBookById(bookId);
                if (book != null) {
                    request.setAttribute("book", book);
                    request.getRequestDispatcher("/views/bookDetails.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}