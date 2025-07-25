<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Order Review - Inkspire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .review-form {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
        }

        .rating-input {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 0.5rem;
            margin: 1rem 0;
        }

        .rating-input input {
            display: none;
        }

        .rating-input label {
            cursor: pointer;
            font-size: 2rem;
            color: #ddd;
        }

        .rating-input label:hover,
        .rating-input label:hover ~ label,
        .rating-input input:checked ~ label {
            color: #ffc107;
        }

        .order-summary {
            background: var(--gray-50);
            padding: 1rem;
            border-radius: var(--border-radius-md);
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        textarea {
            width: 100%;
            min-height: 150px;
            padding: 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--border-radius-md);
            resize: vertical;
        }

        .btn-submit {
            width: 100%;
            padding: 1rem;
            font-size: 1.1rem;
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
                <h2><i class="fas fa-star"></i> Add Order Review</h2>
                <p>Share your experience with this order</p>
            </div>

            <div class="review-form">
                <div class="order-summary">
                    <h3>Order #${order.orderNumber}</h3>
                    <p><strong>Status:</strong> ${order.orderStatus}</p>
                    <p><strong>Date:</strong> ${order.date}</p>
                    <p><strong>Total:</strong> LKR ${order.total}</p>
                </div>

                <form action="${pageContext.request.contextPath}/ReviewServlet" method="post">
                    <input type="hidden" name="action" value="addOrderReview">
                    <input type="hidden" name="orderNumber" value="${order.orderNumber}">

                    <div class="form-group">
                        <label>Rate your order experience:</label>
                        <div class="rating-input">
                            <input type="radio" id="star5" name="rating" value="5" required>
                            <label for="star5" title="5 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4" title="4 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3" title="3 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2" title="2 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1" title="1 star"><i class="fas fa-star"></i></label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="comment">Your Review:</label>
                        <textarea id="comment" name="comment" required
                                placeholder="Tell us about your order experience (delivery time, packaging, customer service, etc.)"
                        ></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-submit">
                        <i class="fas fa-paper-plane"></i> Submit Review
                    </button>
                </form>
            </div>
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