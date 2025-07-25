<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Customer Reviews</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .review-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            transition: transform 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-5px);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .review-order {
            color: var(--primary-color);
            font-weight: 600;
        }

        .review-date {
            color: var(--gray-600);
            font-size: var(--font-size-sm);
        }

        .review-rating {
            color: var(--warning-color);
            margin: 0.5rem 0;
        }

        .review-comment {
            color: var(--gray-700);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .review-user {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray-600);
            font-size: var(--font-size-sm);
        }

        .verified-badge {
            color: var(--success-color);
            font-size: var(--font-size-sm);
            margin-top: 0.5rem;
        }

        .empty-reviews {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
        }

        .empty-reviews i {
            font-size: 3rem;
            color: var(--gray-400);
            margin-bottom: 1rem;
        }

        .empty-reviews p {
            color: var(--gray-600);
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<header class="navbar">
    <div class="container">
        <nav>
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/views/index.jsp" class="logo"><i class="fas fa-feather"></i> Inkspire</a>
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
                        <form action="${pageContext.request.contextPath}/UserServlet" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="logout">
                            <button type="submit" class="btn btn-danger"><i class="fas fa-sign-out-alt"></i> Logout</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>

<!-- Reviews Section -->
<main>
    <div class="container">
        <section>
            <div class="section-header">
                <h2><i class="fas fa-star"></i> Customer Reviews</h2>
                <p>Read what our customers have to say about their orders</p>
            </div>
            <c:if test="${empty reviews}">
                <div class="empty-reviews">
                    <i class="fas fa-comments"></i>
                    <p>No reviews available yet.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                        <i class="fas fa-book"></i> Browse Books
                    </a>
                </div>
            </c:if>
            <c:if test="${not empty reviews}">
                <div class="reviews-grid">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="review-header">
                                <span class="review-order">Order #${review.orderNumber}</span>
                                <span class="review-date">
                                    <i class="far fa-calendar-alt"></i> 
                                    <fmt:formatDate value="${review.date}" pattern="MMM dd, yyyy" />
                                </span>
                            </div>
                            <div class="review-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star${i <= review.rating ? '' : '-regular'}"></i>
                                </c:forEach>
                            </div>
                            <div class="review-comment">
                                <p>${review.comment}</p>
                            </div>
                            <div class="review-user">
                                <i class="fas fa-user"></i>
                                <span>${review.username}</span>
                            </div>
                            <div class="verified-badge">
                                <i class="fas fa-check-circle"></i> Verified Purchase
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
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