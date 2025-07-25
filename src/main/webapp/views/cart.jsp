    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inkspire - Shopping Cart</title>
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

<!-- Cart Section -->
<main>
    <div class="container">
        <section class="cart-section">
            <div class="section-header" style="text-align: center; margin-bottom: 2rem;">
                <h1><i class="fas fa-shopping-cart"></i> Shopping Cart</h1>
                <p>Review and manage your selected items</p>
            </div>

            <div class="cart-container" style="background: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); padding: 2rem; margin-bottom: 2rem;">
                <c:choose>
                    <c:when test="${empty cart.books}">
                        <div class="empty-cart" style="text-align: center; padding: 3rem;">
                            <i class="fas fa-shopping-cart fa-4x" style="color: var(--gray-400); margin-bottom: 1rem;"></i>
                            <h2>Your cart is empty</h2>
                            <p style="color: var(--gray-600); margin: 1rem 0;">Looks like you haven't added any books to your cart yet.</p>
                            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                                <i class="fas fa-book"></i> Browse Books
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="cart-items">
                            <c:forEach var="book" items="${cart.books}">
                                <div class="cart-item" style="display: flex; align-items: center; padding: 1rem; border-bottom: 1px solid var(--gray-200); gap: 1rem;">
                                    <img src="${pageContext.request.contextPath}/bookphotos/${book.photo}" 
                                         alt="${book.title}"
                                         style="width: 100px; height: 150px; object-fit: cover; border-radius: var(--border-radius-md);"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/default-book.jpg'">
                                    
                                    <div class="item-details" style="flex: 1;">
                                        <h3 style="margin: 0;">${book.title}</h3>
                                        <p class="author" style="color: var(--gray-600); margin: 0.5rem 0;">by ${book.author}</p>
                                        <div class="price" style="font-weight: 600; color: var(--primary-color);">
                                            LKR ${book.price}
                                        </div>
                                    </div>

                                    <div class="quantity-controls" style="display: flex; align-items: center; gap: 0.5rem;">
                                        <form action="${pageContext.request.contextPath}/CartServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="bookId" value="${book.id}">
                                            <div class="quantity-wrapper" style="display: flex; align-items: center; gap: 0.5rem;">
                                                <button type="submit" name="quantity" value="${cart.getQuantity(book.id) - 1}" 
                                                        class="btn btn-outline" style="padding: 0.5rem;">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                                <span style="min-width: 40px; text-align: center;">${cart.getQuantity(book.id)}</span>
                                                <button type="submit" name="quantity" value="${cart.getQuantity(book.id) + 1}" 
                                                        class="btn btn-outline" style="padding: 0.5rem;">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                        </form>
                                        
                                        <form action="${pageContext.request.contextPath}/CartServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="bookId" value="${book.id}">
                                            <button type="submit" class="btn btn-danger" style="padding: 0.5rem;">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="cart-summary" style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid var(--gray-200);">
                            <div>
                                <p style="margin: 0;">Total Items: <span style="font-weight: 600;">
                                    <c:set var="totalItems" value="0" />
                                    <c:forEach var="book" items="${cart.books}">
                                        <c:set var="totalItems" value="${totalItems + cart.getQuantity(book.id)}" />
                                    </c:forEach>
                                    ${totalItems}
                                </span></p>
                                <p style="font-size: 1.25rem; margin: 0.5rem 0;">Total: <span style="font-weight: 600; color: var(--primary-color);">LKR ${cart.totalPrice}</span></p>
                            </div>
                            <div class="cart-actions" style="display: flex; justify-content: center; gap: 1rem; margin-top: 1rem;">
                                <a href="${pageContext.request.contextPath}/books" class="btn" style="width: 160px; min-height: 40px; line-height: 20px; background-color: #6c7cff; border-color: #6c7cff; color: white; display: flex; align-items: center; justify-content: center; padding: 8px 16px; font-size: 14px; transition: all 0.3s ease;">
                                    <i class="fas fa-arrow-left" style="margin-right: 8px;"></i> Continue Shopping
                                </a>
                                <form action="${pageContext.request.contextPath}/CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="checkout">
                                    <button type="submit" class="btn" style="width: 160px; min-height: 40px; line-height: 20px; background-color: #28a745; border-color: #28a745; color: white; display: flex; align-items: center; justify-content: center; padding: 8px 16px; font-size: 14px; transition: all 0.3s ease;">
                                        <i class="fas fa-shopping-cart" style="margin-right: 8px;"></i> Proceed to Checkout
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
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

<style>
    .cart-actions .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .cart-actions a.btn:hover {
        background-color: #5666ff;
        border-color: #5666ff;
    }
    .cart-actions button.btn:hover {
        background-color: #218838;
        border-color: #218838;
    }
</style>
</body>
</html>