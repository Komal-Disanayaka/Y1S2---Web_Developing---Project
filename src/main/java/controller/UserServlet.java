package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserService;

import java.io.IOException;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect("views/login.jsp");
        } else {
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userService.login(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("isAdmin", user.isAdmin());

                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/AdminServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/books");
                }
            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        } else if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");

            if (userService.register(username, password, email)) {
                response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            } else {
                request.setAttribute("error", "Registration failed. Username might already exist.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            }
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        } else if ("changePassword".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/views/login.jsp?error=sessionExpired");
                return;
            }

            User user = (User) session.getAttribute("user");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");

            if (newPassword == null || !newPassword.equals(confirmNewPassword)) {
                session.setAttribute("passwordChangeError", "New passwords do not match.");
                response.sendRedirect(request.getContextPath() + "/views/myaccount.jsp");
                return;
            }

            boolean passwordChanged = userService.changePassword(user.getId(), currentPassword, newPassword);

            if (passwordChanged) {
                session.setAttribute("passwordChangeSuccess", "Password changed successfully.");
            } else {
                session.setAttribute("passwordChangeError", "Failed to change password. Please check your current password.");
            }
            response.sendRedirect(request.getContextPath() + "/views/myaccount.jsp");
        } else if ("updateProfile".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/views/login.jsp?error=sessionExpired");
                return;
            }

            User user = (User) session.getAttribute("user");
            String newUsername = request.getParameter("newUsername");
            String newEmail = request.getParameter("newEmail");
            String currentPassword = request.getParameter("currentPassword");

            // Verify current password before making changes
            if (!userService.verifyPassword(user.getId(), currentPassword)) {
                session.setAttribute("profileUpdateError", "Current password is incorrect.");
                response.sendRedirect(request.getContextPath() + "/views/myaccount.jsp");
                return;
            }

            // Update profile
            boolean updated = userService.updateProfile(user.getId(), newUsername, newEmail);
            if (updated) {
                // Update session with new user data
                user.setUsername(newUsername);
                user.setEmail(newEmail);
                session.setAttribute("user", user);
                session.setAttribute("profileUpdateSuccess", "Profile updated successfully.");
            } else {
                session.setAttribute("profileUpdateError", "Failed to update profile. Username might already exist.");
            }
            response.sendRedirect(request.getContextPath() + "/views/myaccount.jsp");
        }
    }
}