<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - Book Details</title>
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
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/views/myaccount.jsp" class="btn"><i class="fas fa-user"></i> My Account</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/views/myaccount.jsp" class="btn"><i class="fas fa-user"></i> ${sessionScope.user.username}</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>

<main>
    <div class="container">
        <div class="book-details-container" style="padding: 2rem; background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); margin: 2rem 0;">
            <div class="book-details-grid" style="display: grid; grid-template-columns: 300px 1fr; gap: 2rem;">
                <!-- Book Image -->
                <div class="book-image">
                    <img src="${pageContext.request.contextPath}/bookphotos/${book.photo}" 
                         alt="${book.title}"
                         style="width: 100%; height: 450px; object-fit: cover; border-radius: var(--border-radius-md); box-shadow: var(--shadow-md);"
                         onerror="this.src='${pageContext.request.contextPath}/assets/images/default-book.jpg'">
                </div>
                
                <!-- Book Information -->
                <div class="book-info">
                    <h1 style="font-size: 2rem; margin-bottom: 0.5rem;">${book.title}</h1>
                    <p style="font-size: 1.2rem; color: var(--gray-600); margin-bottom: 1rem;">by ${book.author}</p>
                    
                    <div class="price" style="font-size: 1.5rem; font-weight: 600; color: var(--primary-color); margin-bottom: 1.5rem;">
                        LKR ${book.price}
                    </div>
                    
                    <div class="book-details-info" style="background: var(--gray-100); padding: 1.5rem; border-radius: var(--border-radius-md); margin-bottom: 2rem;">
                        <div class="info-row" style="display: flex; margin-bottom: 1rem;">
                            <div class="info-label" style="width: 120px; font-weight: 600; color: var(--gray-700);">ISBN:</div>
                            <div class="info-value" style="font-family: monospace;">${book.isbn}</div>
                        </div>
                        <div class="info-row" style="display: flex;">
                            <div class="info-label" style="width: 120px; font-weight: 600; color: var(--gray-700);">Rating:</div>
                            <div class="info-value" style="display: flex; align-items: center; gap: 0.5rem;">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star" style="color: ${i <= book.rating ? '#ffc107' : '#e4e5e9'}; font-size: 1.2rem;"></i>
                                    </c:forEach>
                                </div>
                                <span style="color: var(--gray-600); margin-left: 0.5rem;">${book.rating} / 5</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="description" style="margin-bottom: 2rem;">
                        <h3 style="font-size: 1.2rem; margin-bottom: 0.5rem;">Description</h3>
                        <p style="color: var(--gray-600); line-height: 1.6;">${book.description}</p>
                    </div>
                    
                    <div class="actions" style="display: flex; justify-content: center; gap: 1rem;">
                        <button onclick="addToCart(${book.id})" class="btn" style="width: 200px; background-color: #28a745; border-color: #28a745; color: white; transition: all 0.3s ease;">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                        </button>
                        <a href="${pageContext.request.contextPath}/books" class="btn" style="width: 200px; background-color: var(--primary-color); border-color: var(--primary-color); color: white; transition: all 0.3s ease;">
                            <i class="fas fa-arrow-left"></i> Back to Books
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-column">
            <h4>About BookStore</h4>
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
    // Function to add book to cart
    function addToCart(bookId) {
        fetch('${pageContext.request.contextPath}/CartServlet?action=add&bookId=' + bookId, {
            method: 'POST',
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Book added to cart successfully!');
            } else {
                alert('Failed to add book to cart. Please try again.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred. Please try again.');
        });
    }

    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
</script>

<style>
    .actions button:hover {
        background-color: #218838;
        border-color: #218838;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    
    .actions a.btn:hover {
        background-color: white;
        border-color: var(--primary-color);
        color: var(--primary-color);
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
</style>

</body>
</html> 