<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="30">
    <title>BookStore - My Orders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modern.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .orders-list {
            display: grid;
            gap: 2rem;
            margin-top: 2rem;
        }

        .order-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        .order-header {
            background: var(--gray-100);
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--gray-200);
        }

        .order-header h3 {
            color: var(--primary-color);
            margin: 0;
            font-size: var(--font-size-xl);
        }

        .order-date {
            color: var(--gray-600);
            font-size: var(--font-size-sm);
        }

        .order-status {
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius-full);
            font-size: var(--font-size-sm);
            font-weight: 500;
        }

        .order-status.pending {
            background: var(--warning-light);
            color: var(--warning-dark);
        }

        .order-status.processing {
            background: var(--info-light);
            color: var(--info-dark);
        }

        .order-status.completed {
            background: var(--success-light);
            color: var(--success-dark);
        }

        .order-status.cancelled {
            background: var(--danger-light);
            color: var(--danger-dark);
        }

        .order-details {
            padding: 1.5rem;
        }

        .order-actions {
            padding: 1.5rem;
            border-top: 1px solid var(--gray-200);
            text-align: right;
        }

        .empty-orders {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
        }

        .empty-orders i {
            font-size: 3rem;
            color: var(--gray-400);
            margin-bottom: 1rem;
        }

        .empty-orders p {
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

<!-- Orders Section -->
<main>
    <div class="container">
        <section>
            <div class="section-header">
                <h2><i class="fas fa-shopping-bag"></i> My Orders</h2>
                <p>View and track your order history</p>
            </div>
            <c:if test="${empty orders}">
                <div class="empty-orders">
                    <i class="fas fa-box-open"></i>
                    <p>You haven't placed any orders yet.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                        <i class="fas fa-book"></i> Browse Books
                    </a>
                </div>
            </c:if>
            <c:if test="${not empty orders}">
                <div class="orders-list">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <h3>Order #${order.orderNumber}</h3>
                                <span class="order-date"><i class="far fa-calendar-alt"></i> <fmt:formatDate value="${order.date}" pattern="MMM dd, yyyy HH:mm" /></span>
                                <span class="order-status ${order.orderStatus.toLowerCase()}">${order.orderStatus}</span>
                            </div>
                            <div class="order-details">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Book</th>
                                            <th>Author</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.books}">
                                            <tr>
                                                <td>${item.bookTitle}</td>
                                                <td>${item.bookAuthor}</td>
                                                <td>LKR ${item.bookPrice}</td>
                                                <td>${item.quantity}</td>
                                                <td>LKR ${item.subtotal}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                            <td><strong>LKR ${order.total}</strong></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="order-actions">
                                <a href="${pageContext.request.contextPath}/OrderServlet?action=view&orderNumber=${order.orderNumber}" class="btn btn-primary">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                                <c:if test="${order.orderStatus eq 'Completed' && not order.reviewed}">
                                    <a href="${pageContext.request.contextPath}/ReviewServlet?action=showAddReview&orderNumber=${order.orderNumber}" 
                                       class="btn btn-success">
                                        <i class="fas fa-star"></i> Add Review
                                    </a>
                                </c:if>
                                <c:if test="${order.reviewed}">
                                    <span class="badge badge-success">
                                        <i class="fas fa-check"></i> Reviewed
                                    </span>
                                </c:if>
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