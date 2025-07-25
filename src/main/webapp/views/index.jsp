<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    // Redirect to IndexServlet if accessed directly
    if (request.getAttribute("books") == null) {
        response.sendRedirect(request.getContextPath() + "/index");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
            padding: 2rem 0;
        }
        
        .book-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            overflow: hidden;
        }
        
        .book-card:hover {
            transform: translateY(-5px);
        }
        
        .book-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }
        
        .book-card-content {
            padding: 1.5rem;
        }
        
        .book-card h3 {
            margin: 0 0 0.5rem 0;
            font-size: 1.2rem;
            color: var(--gray-800);
        }
        
        .book-card .author {
            color: var(--gray-600);
            margin-bottom: 1rem;
        }
        
        .book-card .rating {
            color: #ffc107;
            margin-bottom: 1rem;
        }
        
        .book-card .price {
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .section-header h2 {
            color: var(--gray-800);
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .section-header p {
            color: var(--gray-600);
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<header class="navbar">
    <div class="container">
        <nav>
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/index" class="logo"><i class="fas fa-feather"></i> Inkspire</a>
            </div>
            <div class="nav-center">
                <form action="${pageContext.request.contextPath}/books" method="get" class="search-bar">
                    <input type="hidden" name="action" value="search">
                    <select name="searchType">
                        <option value="all">All</option>
                        <option value="title">Title</option>
                        <option value="author">Author</option>
                    </select>
                    <input type="text" name="query" placeholder="Search for books by title/author">
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

<!-- Hero Section -->
<section class="hero">
    <div class="container">
        <h1>Discover Your Next Great Read</h1>
        <p>Explore our vast collection of books, from timeless classics to contemporary bestsellers. Your next adventure awaits!</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                <i class="fas fa-book-open"></i> Explore Books
            </a>
            <a href="${pageContext.request.contextPath}/views/myaccount.jsp" class="btn btn-outline">
                <i class="fas fa-user"></i> Join Now
            </a>
        </div>
    </div>
</section>

<main>
    <div class="container">
        <!-- Featured Books Section -->
        <section class="books-grid-section" style="margin: 4rem 0;">
            <div class="section-header">
                <h2>Featured Books</h2>
                <p>Handpicked selections from our most popular and highly-rated books</p>
            </div>
            <div class="books-grid">
                <c:forEach var="book" items="${books}">
                    <div class="book-card">
                        <img src="${pageContext.request.contextPath}/bookphotos/${book.photo}" 
                             alt="${book.title}"
                             onerror="this.src='${pageContext.request.contextPath}/assets/images/default-book.jpg'">
                        <div class="book-card-content">
                            <h3>${book.title}</h3>
                            <p class="author">${book.author}</p>
                            <div class="rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star${i <= book.rating ? '' : i <= book.rating + 0.5 ? '-half-alt' : '-regular'}"></i>
                                </c:forEach>
                                <span>${book.rating}</span>
                            </div>
                            <p class="price">LKR ${book.price}</p>
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-primary">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Top Reviews Section -->
        <section class="top-reviews" style="margin-top: 4rem; padding: 2rem 0;">
            <div class="section-header" style="text-align: center; margin-bottom: 2rem;">
                <h2><i class="fas fa-star"></i> Top Reviews</h2>
                <p>What our customers are saying</p>
            </div>

            <div class="reviews-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
                <c:forEach var="review" items="${topReviews}">
                    <div class="review-card" style="background: white; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 1.5rem; transition: transform 0.3s ease;">
                        <div class="review-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                            <span class="review-order" style="color: var(--primary-color); font-weight: 600;">
                                Order #${review.orderNumber}
                            </span>
                            <span class="review-date" style="color: var(--gray-600); font-size: 0.9rem;">
                                <i class="far fa-calendar-alt"></i> 
                                <fmt:formatDate value="${review.date}" pattern="MMM dd, yyyy" />
                            </span>
                        </div>
                        <div class="review-rating" style="color: #ffc107; margin: 0.5rem 0;">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star${i <= review.rating ? '' : '-regular'}"></i>
                            </c:forEach>
                        </div>
                        <div class="review-comment" style="color: var(--gray-700); line-height: 1.6; margin: 1rem 0;">
                            <p style="margin: 0;">${review.comment}</p>
                        </div>
                        <div class="review-footer" style="display: flex; justify-content: space-between; align-items: center; margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--gray-200);">
                            <div class="review-user" style="display: flex; align-items: center; gap: 0.5rem;">
                                <i class="fas fa-user" style="color: var(--gray-500);"></i>
                                <span style="color: var(--gray-600);">${review.username}</span>
                            </div>
                            <div class="verified-badge" style="color: var(--success-color); font-size: 0.9rem;">
                                <i class="fas fa-check-circle"></i> Verified Purchase
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="section-footer" style="text-align: center; margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/ReviewServlet?action=viewAll" 
                   class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-comments"></i> View All Reviews
                </a>
            </div>
        </section>
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
                <li><a href="${pageContext.request.contextPath}/ReviewServlet?action=viewAll">Reviews</a></li>
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
</script>
</body>
</html>