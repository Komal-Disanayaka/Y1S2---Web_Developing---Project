<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<!-- Navigation Bar -->
<header class="navbar">
    <div class="container">
        <h1 class="logo"><i class="fas fa-book-reader"></i> BookStore</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/views/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/views/login.jsp">Login</a>
            <a href="${pageContext.request.contextPath}/views/register.jsp">Register</a>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">Browse Books</a>
        </nav>
    </div>
</header>

<!-- Register Section -->
<main>
    <div class="container">
        <section>
            <div class="form-container">
                <h3><i class="fas fa-user-plus"></i> Create an Account</h3>
                <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="form-control" placeholder="Choose a username" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg">Register</button>
                </form>
                <p>Already have an account? <a href="${pageContext.request.contextPath}/views/login.jsp">Login here</a>.</p>
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
    // Add scroll effect to navbar
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