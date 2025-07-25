<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<!-- Navi -->
<header class="navbar">
    <div class="container">
        <nav>
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/views/index.jsp" class="logo"><i class="fas fa-feather"></i> Inkspire</a>
            </div>
            <div class="nav-center">
                <form action="${pageContext.request.contextPath}/books" method="get" class="search-bar">
                    <input type="hidden" name="action" value="search">
                    <select name="searchType">
                        <option value="all" ${param.searchType == 'all' ? 'selected' : ''}>All</option>
                        <option value="title" ${param.searchType == 'title' ? 'selected' : ''}>Title</option>
                        <option value="author" ${param.searchType == 'author' ? 'selected' : ''}>Author</option>
                    </select>
                    <input type="text" name="query" placeholder="Search for books by title/author" value="${param.query}">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                </form>
            </div>
            <div class="nav-right">
                <a href="${pageContext.request.contextPath}/books" class="btn"><i class="fas fa-book"></i> Browse Books</a>
                <a href="${pageContext.request.contextPath}/CartServlet" class="btn"><i class="fas fa-shopping-cart"></i> Cart</a>
                <a href="${pageContext.request.contextPath}/views/myaccount.jsp" class="btn"><i class="fas fa-user"></i> My Account</a>
            </div>
        </nav>
    </div>
</header>

<!-- Login Sec -->
<main>
    <div class="container">
        <section>
            <div class="form-container">
                <h3><i class="fas fa-sign-in-alt"></i> Login to Your Account</h3>
                <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                    <input type="hidden" name="action" value="login">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="form-control" placeholder="Enter your username" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg">Login</button>
                </form>
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/views/register.jsp">Register here</a>.</p>
            </div>
        </section>
    </div>
</main>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-column">
            <h4>About BookStore</h4>
            <p>Your one-stop destination for all your reading needs. We offer a wide selection of books across various genres.</p>
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
        <p>© 2025 BookStore. All rights reserved.</p>
    </div>
</footer>

<script>

    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
</script>
</body>
</html>