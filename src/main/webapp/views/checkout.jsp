<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - Checkout</title>
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

<!-- Checkout Section -->
<main>
    <div class="container">
        <section class="checkout-section">
            <div class="section-header" style="text-align: center; margin-bottom: 2rem;">
                <h1><i class="fas fa-shopping-bag"></i> Checkout</h1>
                <p>Complete your purchase</p>
            </div>

            <div class="checkout-container" style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">
                <!-- Shipping Information -->
                <div class="checkout-form" style="background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); padding: 2rem;">
                    <h2 style="margin-bottom: 1.5rem;">Shipping Information</h2>
                    <form action="${pageContext.request.contextPath}/OrderServlet" method="post" id="checkoutForm">
                        <input type="hidden" name="action" value="placeOrder">
                        
                        <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div class="form-group">
                                <label for="firstName">First Name</label>
                                <input type="text" id="firstName" name="firstName" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last Name</label>
                                <input type="text" id="lastName" name="lastName" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="address">Street Address</label>
                            <input type="text" id="address" name="address" class="form-control" required>
                        </div>

                        <div class="form-row" style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div class="form-group">
                                <label for="city">City</label>
                                <input type="text" id="city" name="city" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="state">State</label>
                                <input type="text" id="state" name="state" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="zip">ZIP Code</label>
                                <input type="text" id="zip" name="zip" class="form-control" required>
                            </div>
                        </div>

                        <h2 style="margin: 2rem 0 1.5rem;">Payment Information</h2>
                        <div class="form-group">
                            <label for="cardNumber">Card Number</label>
                            <div class="input-group">
                                <span class="input-icon"><i class="fas fa-credit-card"></i></span>
                                <input type="text" id="cardNumber" name="cardNumber" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div class="form-group">
                                <label for="expiry">Expiry Date</label>
                                <input type="text" id="expiry" name="expiry" placeholder="MM/YY" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="cvv">CVV</label>
                                <input type="text" id="cvv" name="cvv" class="form-control" required>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Order Summary -->
                <div class="order-summary" style="background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); padding: 2rem; height: fit-content;">
                    <h2 style="margin-bottom: 1.5rem;">Order Summary</h2>
                    
                    <div class="summary-items" style="margin-bottom: 1.5rem;">
                        <c:forEach var="book" items="${cart.books}">
                            <div class="summary-item" style="display: flex; justify-content: space-between; margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--gray-200);">
                                <div style="display: flex; gap: 1rem;">
                                    <img src="${pageContext.request.contextPath}/bookphotos/${book.photo}" 
                                         alt="${book.title}"
                                         style="width: 50px; height: 75px; object-fit: cover; border-radius: var(--border-radius-sm);"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/default-book.jpg'">
                                    <div>
                                        <h4 style="margin: 0; font-size: 1rem;">${book.title}</h4>
                                        <p style="margin: 0.25rem 0; color: var(--gray-600);">Qty: ${cart.getQuantity(book.id)}</p>
                                    </div>
                                </div>
                                <div style="font-weight: 600;">
                                    LKR ${book.price * cart.getQuantity(book.id)}
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="summary-total" style="border-top: 1px solid var(--gray-200); padding-top: 1rem;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                            <span>Subtotal:</span>
                            <span>LKR ${cart.totalPrice}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                            <span>Shipping:</span>
                            <span>LKR 0.00</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 600; color: var(--primary-color);">
                            <span>Total:</span>
                            <span>LKR ${cart.totalPrice}</span>
                        </div>
                    </div>

                    <button type="submit" form="checkoutForm" class="btn btn-primary" style="width: 100%;">
                        <i class="fas fa-lock"></i> Place Order
                    </button>
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

    // Format credit card number
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        value = value.replace(/(.{4})/g, '$1 ').trim();
        e.target.value = value;
    });

    // Format expiry date
    document.getElementById('expiry').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length >= 2) {
            value = value.slice(0,2) + '/' + value.slice(2);
        }
        e.target.value = value;
    });

    // Format CVV
    document.getElementById('cvv').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        e.target.value = value.slice(0,3);
    });
</script>
</body>
</html>