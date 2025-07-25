<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Reviews - Inkspire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 2rem 0;
        }

        .review-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-5px);
        }

        .review-header {
            background: var(--primary-color);
            color: white;
            padding: 1.5rem;
            position: relative;
        }

        .review-header h3 {
            margin: 0;
            font-size: 1.1rem;
        }

        .review-date {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .review-rating {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem;
            border-radius: var(--border-radius-full);
        }

        .review-rating i {
            color: #ffc107;
        }

        .review-content {
            padding: 1.5rem;
        }

        .review-text {
            color: var(--gray-700);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .review-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
            font-size: 0.9rem;
            color: var(--gray-600);
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
    </style>
</head>
<body>
<!-- Navigation Bar -->
<header class="navbar">
    <div class="container">
        <nav>
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/index" class="logo">
                    <i class="fas fa-feather"></i> Inkspire
                </a>
            </div>
            <div class="nav-right">
                <a href="${pageContext.request.contextPath}/books" class="btn">
                    <i class="fas fa-book"></i> Browse Books
                </a>
                <a href="${pageContext.request.contextPath}/CartServlet" class="btn">
                    <i class="fas fa-shopping-cart"></i> Cart
                </a>
                <a href="${pageContext.request.contextPath}/OrderServlet" class="btn">
                    <i class="fas fa-shopping-bag"></i> My Orders
                </a>
            </div>
        </nav>
    </div>
</header>

<main>
    <div class="container">
        <section>
            <div class="section-header">
                <h2><i class="fas fa-star"></i> Customer Reviews</h2>
                <p>See what our customers are saying about their shopping experience</p>
            </div>

            <c:if test="${empty reviews}">
                <div class="empty-reviews">
                    <i class="fas fa-comments"></i>
                    <p>No reviews yet. Be the first to share your experience!</p>
                </div>
            </c:if>

            <c:if test="${not empty reviews}">
                <div class="reviews-grid">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="review-header">
                                <h3>Order #${review.orderNumber}</h3>
                                <div class="review-date">
                                    <i class="far fa-calendar-alt"></i>
                                    <fmt:formatDate value="${review.date}" pattern="MMM dd, yyyy"/>
                                </div>
                                <div class="review-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star${i <= review.rating ? '' : '-regular'}"></i>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="review-content">
                                <p class="review-text">${review.comment}</p>
                                <div class="review-meta">
                                    <span><i class="fas fa-user"></i> ${review.username}</span>
                                    <span><i class="fas fa-check-circle"></i> Verified Order</span>
                                </div>
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
        <p>&copy; 2025 Inkspire. All rights reserved.</p>
    </div>
</footer>
</body>
</html> 