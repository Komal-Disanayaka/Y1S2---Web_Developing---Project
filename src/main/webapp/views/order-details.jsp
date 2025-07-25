<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - Order Details</title>
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

<!-- Order Details Section -->
<main>
    <div class="container">
        <section class="order-details-section">
            <div class="section-header" style="text-align: center; margin-bottom: 2rem;">
                <h1><i class="fas fa-receipt"></i> Order Details</h1>
                <p>Order #${order.id}</p>
            </div>

            <div class="order-status" style="background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); padding: 2rem; margin-bottom: 2rem;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h2 style="margin-bottom: 0.5rem;">Order Status</h2>
                        <p style="color: var(--gray-600);">Placed on ${order.orderDate}</p>
                    </div>
                    <div class="status-badge" style="background: var(--success-color); color: white; padding: 0.5rem 1rem; border-radius: var(--border-radius-sm); font-weight: 600;">
                        ${order.status}
                    </div>
                </div>
            </div>

            <div class="order-container" style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">
                <!-- Order Items -->
                <div class="order-items" style="background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); padding: 2rem;">
                    <h2 style="margin-bottom: 1.5rem;">Order Items</h2>
                    <div class="items-list">
                        <c:forEach var="item" items="${order.items}">
                            <div class="order-item" style="display: flex; gap: 1rem; padding: 1rem; border-bottom: 1px solid var(--gray-200);">
                                <img src="${pageContext.request.contextPath}/bookphotos/${item.book.photo}" 
                                     alt="${item.book.title}"
                                     style="width: 80px; height: 120px; object-fit: cover; border-radius: var(--border-radius-sm);"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default-book.jpg'">
                                <div style="flex: 1;">
                                    <h3 style="margin: 0 0 0.5rem 0;">${item.book.title}</h3>
                                    <p style="color: var(--gray-600); margin: 0 0 0.5rem 0;">by ${item.book.author}</p>
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <span style="font-weight: 600;">LKR ${item.book.price}</span>
                                        <span style="color: var(--gray-600);">Qty: ${item.quantity}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="order-summary" style="background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); padding: 2rem; height: fit-content;">
                    <h2 style="margin-bottom: 1.5rem;">Order Summary</h2>
                    
                    <div class="summary-details" style="margin-bottom: 1.5rem;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                            <span>Subtotal</span>
                            <span>LKR ${order.totalAmount}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                            <span>Shipping</span>
                            <span>LKR 0.00</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding-top: 1rem; border-top: 1px solid var(--gray-200); font-weight: 600; font-size: 1.25rem;">
                            <span>Total</span>
                            <span style="color: var(--primary-color);">LKR ${order.totalAmount}</span>
                        </div>
                    </div>

                    <div class="shipping-info" style="margin-bottom: 1.5rem;">
                        <h3 style="margin-bottom: 1rem;">Shipping Information</h3>
                        <p style="margin: 0 0 0.5rem 0;">${order.shippingAddress}</p>
                        <p style="margin: 0; color: var(--gray-600);">${order.shippingCity}, ${order.shippingState} ${order.shippingZip}</p>
                    </div>

                    <div class="payment-info">
                        <h3 style="margin-bottom: 1rem;">Payment Information</h3>
                        <p style="margin: 0 0 0.5rem 0;">Payment Method: ${order.paymentMethod}</p>
                        <p style="margin: 0; color: var(--gray-600);">Transaction ID: ${order.transactionId}</p>
                    </div>
                </div>
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
        <p>© 2025 Inkspire. All rights reserved.</p>
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