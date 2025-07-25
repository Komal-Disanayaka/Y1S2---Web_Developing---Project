<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - My Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<!-- Navigation Bar -->
<header class="navbar">
    <div class="container">
        <nav>
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/views/index.jsp" class="logo"><i class="fas fa-feather"></i> Inkspire</a>
            </div>
            <div class="nav-center">
                <div class="search-bar">
                    <select>
                        <option>All</option>
                        <option>Title</option>
                        <option>Author</option>
                    </select>
                    <input type="text" placeholder="Search for books by title/author">
                    <button class="btn btn-primary"><i class="fas fa-search"></i></button>
                </div>
            </div>
            <div class="nav-right">
                <a href="${pageContext.request.contextPath}/books" class="btn"><i class="fas fa-book"></i> Browse Books</a>
                <a href="${pageContext.request.contextPath}/CartServlet" class="btn"><i class="fas fa-shopping-cart"></i> Cart</a>
                <a href="${pageContext.request.contextPath}/OrderServlet" class="btn"><i class="fas fa-clipboard-list"></i> My Orders</a>
                <form action="${pageContext.request.contextPath}/UserServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>
        </nav>
    </div>
</header>

<!-- Account Section -->
<section class="hero" style="min-height: 200px; padding: 3rem 0;">
    <div class="container">
        <h1 style="margin-bottom: 0.25rem;">Hi, ${sessionScope.user.username}</h1>
        <h2 style="margin-top: 0.25rem;">Welcome to your account</h2>
        <p>Manage your personal information and preferences here.</p>
    </div>
</section>

<main style="padding: 3rem 0; background-color: var(--gray-100);">
    <div class="container">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <!-- User is logged in - show account information -->
                <div class="account-cards" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 2rem; max-width: 1200px; margin: 0 auto;">
                    <!-- Admin Dashboard Card (Only visible for admins) -->
                    <c:if test="${sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/AdminServlet" class="card" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1.5rem; text-decoration: none; color: inherit; transition: transform 0.2s ease, box-shadow 0.2s ease; cursor: pointer; display: block; grid-column: 1 / -1;" onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 4px 8px rgba(0,0,0,0.15)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.1)'">
                            <div class="card-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                                <i class="fas fa-user-shield" style="font-size: 2rem; color: #9C27B0;"></i>
                                <h3 style="margin: 0; font-size: 1.5rem;">Admin Dashboard</h3>
                            </div>
                            <div class="card-body" style="text-align: center;">
                                <span class="btn btn-outline-primary" style="width: 100%; height: 120px; display: flex; align-items: center; justify-content: center; padding: 0; position: relative; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf3 100%);">
                                    <i class="fas fa-tachometer-alt" style="font-size: 3.5rem; position: absolute; left: 50%; transform: translateX(-50%); background: linear-gradient(45deg, #9C27B0, #E91E63); -webkit-background-clip: text; -webkit-text-fill-color: transparent; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-book" style="font-size: 1.5rem; position: absolute; bottom: 20px; left: 25%; color: #2196F3; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-users" style="font-size: 1.5rem; position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); color: #4CAF50; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-shopping-cart" style="font-size: 1.5rem; position: absolute; bottom: 20px; right: 25%; color: #FF9800; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                </span>
                                <p style="margin-top: 1rem; color: #666;">Manage books, orders, and more</p>
                            </div>
                        </a>
                    </c:if>

                    <!-- Account Info Card -->
                    <div class="card" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1.5rem;">
                        <div class="card-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;">
                            <i class="fas fa-user-circle" style="font-size: 2rem; color: var(--primary-color);"></i>
                            <h3 style="margin: 0;">Account Information</h3>
                        </div>
                        <div class="card-body">
                            <div class="info-item" style="margin-bottom: 1rem;">
                                <label style="display: block; color: var(--gray-600); margin-bottom: 0.25rem;">Username</label>
                                <p style="margin: 0; font-weight: 500;">${sessionScope.user.username}</p>
                            </div>
                            <div class="info-item">
                                <label style="display: block; color: var(--gray-600); margin-bottom: 0.25rem;">Email</label>
                                <p style="margin: 0; font-weight: 500;">${sessionScope.user.email}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Orders Card -->
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 2rem;">
                        <a href="${pageContext.request.contextPath}/OrderServlet" class="card" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1.5rem; text-decoration: none; color: inherit; transition: transform 0.2s ease, box-shadow 0.2s ease; cursor: pointer; display: block;" onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 4px 8px rgba(0,0,0,0.15)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.1)'">
                            <div class="card-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                                <i class="fas fa-clipboard-list" style="font-size: 1.5rem; color: var(--primary-color);"></i>
                                <h3 style="margin: 0; font-size: 1.2rem;">View My Orders</h3>
                            </div>
                            <div class="card-body" style="text-align: center;">
                                <span class="btn btn-outline-primary" style="width: 100%; height: 120px; display: flex; align-items: center; justify-content: center; padding: 0; position: relative; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf3 100%);">
                                    <i class="fas fa-clipboard-check" style="font-size: 3.5rem; position: absolute; left: 50%; transform: translateX(-50%); background: linear-gradient(45deg, #2196F3, #00BCD4); -webkit-background-clip: text; -webkit-text-fill-color: transparent; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-box" style="font-size: 1.5rem; position: absolute; bottom: 20px; left: 30%; color: #FF9800; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-truck" style="font-size: 1.5rem; position: absolute; bottom: 20px; right: 30%; color: #4CAF50; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                </span>
                            </div>
                        </a>

                        <!-- Cart Card -->
                        <a href="${pageContext.request.contextPath}/CartServlet" class="card" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1.5rem; text-decoration: none; color: inherit; transition: transform 0.2s ease, box-shadow 0.2s ease; cursor: pointer; display: block;" onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 4px 8px rgba(0,0,0,0.15)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.1)'">
                            <div class="card-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                                <i class="fas fa-shopping-cart" style="font-size: 1.5rem; color: var(--primary-color);"></i>
                                <h3 style="margin: 0; font-size: 1.2rem;">View My Cart</h3>
                            </div>
                            <div class="card-body" style="text-align: center;">
                                <span class="btn btn-outline-primary" style="width: 100%; height: 120px; display: flex; align-items: center; justify-content: center; padding: 0; position: relative; background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf3 100%);">
                                    <i class="fas fa-shopping-basket" style="font-size: 3.5rem; position: absolute; left: 50%; transform: translateX(-50%); background: linear-gradient(45deg, #FF5722, #FF9800); -webkit-background-clip: text; -webkit-text-fill-color: transparent; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-book" style="font-size: 1.5rem; position: absolute; bottom: 20px; left: 30%; color: #673AB7; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                    <i class="fas fa-tag" style="font-size: 1.5rem; position: absolute; bottom: 20px; right: 30%; color: #E91E63; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.1));"></i>
                                </span>
                            </div>
                        </a>
                    </div>

                    <!-- Edit Profile Card -->
                    <div class="card" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1.5rem;">
                        <div class="card-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;">
                            <i class="fas fa-edit" style="font-size: 2rem; color: var(--primary-color);"></i>
                            <h3 style="margin: 0;">Edit Profile</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                                <input type="hidden" name="action" value="updateProfile">
                                <div class="form-group" style="margin-bottom: 1rem;">
                                    <label for="newUsername">New Username</label>
                                    <input type="text" id="newUsername" name="newUsername" class="form-control" 
                                           placeholder="Enter new username">
                                </div>
                                <div class="form-group" style="margin-bottom: 1rem;">
                                    <label for="newEmail">New Email</label>
                                    <input type="email" id="newEmail" name="newEmail" class="form-control" 
                                           placeholder="Enter new email">
                                </div>
                                <div class="form-group" style="margin-bottom: 1.5rem;">
                                    <label for="currentPassword">Current Password</label>
                                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" 
                                           placeholder="Enter current password" required>
                                </div>
                                <button type="submit" class="btn btn-primary" style="width: 100%;">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Change Password Card -->
                    <div class="card" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1.5rem;">
                        <div class="card-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;">
                            <i class="fas fa-key" style="font-size: 2rem; color: var(--primary-color);"></i>
                            <h3 style="margin: 0;">Change Password</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                                <input type="hidden" name="action" value="changePassword">
                                <div class="form-group" style="margin-bottom: 1rem;">
                                    <label for="currentPasswordChange">Current Password</label>
                                    <input type="password" id="currentPasswordChange" name="currentPassword" class="form-control" 
                                           placeholder="Enter current password" required>
                                </div>
                                <div class="form-group" style="margin-bottom: 1rem;">
                                    <label for="newPassword">New Password</label>
                                    <input type="password" id="newPassword" name="newPassword" class="form-control" 
                                           placeholder="Enter new password" required>
                                </div>
                                <div class="form-group" style="margin-bottom: 1.5rem;">
                                    <label for="confirmNewPassword">Confirm New Password</label>
                                    <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control" 
                                           placeholder="Confirm new password" required>
                                </div>
                                <button type="submit" class="btn btn-primary" style="width: 100%;">
                                    <i class="fas fa-key"></i> Change Password
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- User is not logged in - show login and register forms -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; max-width: 1200px; margin: 0 auto;">
                    <!-- Login Section -->
                    <div class="form-container">
                        <h3><i class="fas fa-sign-in-alt"></i> Login</h3>
                        <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                            <input type="hidden" name="action" value="login">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" id="username" name="username" class="form-control" required 
                                       placeholder="Enter your username">
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" class="form-control" required 
                                       placeholder="Enter your password">
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <label style="display: flex; align-items: center; gap: 0.5rem;">
                                    <input type="checkbox" name="remember"> Remember me
                                </label>
                                <a href="#" style="color: var(--primary-color);">Forgot Password?</a>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </button>
                        </form>
                    </div>

                    <!-- Register Section -->
                    <div class="form-container">
                        <h3><i class="fas fa-user-plus"></i> Create Account</h3>
                        <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                            <input type="hidden" name="action" value="register">
                            <div class="form-group">
                                <label for="regUsername">Username</label>
                                <input type="text" id="regUsername" name="username" class="form-control" required 
                                       placeholder="Choose a username">
                            </div>
                            <div class="form-group">
                                <label for="regEmail">Email Address</label>
                                <input type="email" id="regEmail" name="email" class="form-control" required 
                                       placeholder="Enter your email">
                            </div>
                            <div class="form-group">
                                <label for="regPassword">Password</label>
                                <input type="password" id="regPassword" name="password" class="form-control" required 
                                       placeholder="Create a password">
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required 
                                       placeholder="Confirm your password">
                            </div>
                            <div style="margin-bottom: 1rem;">
                                <label style="display: flex; align-items: start; gap: 0.5rem;">
                                    <input type="checkbox" name="terms" required style="margin-top: 0.25rem;">
                                    <span style="font-size: 0.9rem;">I agree to the <a href="#" style="color: var(--primary-color);">Terms of Service</a> and <a href="#" style="color: var(--primary-color);">Privacy Policy</a></span>
                                </label>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                <i class="fas fa-user-plus"></i> Create Account
                            </button>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-column">
            <h4>About Inkspire</h4>
            <p>Your one-stop destination for all your reading needs. We offer a wide selection of books across various genres.</p>
            <div class="address" style="margin-top: 1rem;">
                <h4>Our Location</h4>
                <p style="color: var(--gray-600);"><i class="fas fa-map-marker-alt"></i> No. 123/Z/A/2/1, Main Street, Pittugala, Malabe, Colombo 10115, Sri Lanka</p>
            </div>
        </div>
        <div class="footer-column">
            <h4>Quick Links</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/views/index.jsp">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/books">Browse Books</a></li>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h4>Connect With Us</h4>
            <ul class="footer-links">
                <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                <li><a href="#"><i class="fab fa-twitter"></i> Twitter</a></li>
                <li><a href="#"><i class="fab fa-instagram"></i> Instagram</a></li>
                <li><a href="#"><i class="fab fa-pinterest"></i> Pinterest</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>© 2025 Y1S2 IT Group 70, SLIIT. Inkspire Bookstore. All rights reserved.</p>
    </div>
</footer>

<script>
    // Add scroll effect to navbar
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Password match validation
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const password = document.getElementById('regPassword').value;
        const confirmPassword = this.value;
        
        if (password !== confirmPassword) {
            this.setCustomValidity('Passwords do not match');
        } else {
            this.setCustomValidity('');
        }
    });
</script>
</body>
</html> 