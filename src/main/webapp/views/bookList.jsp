<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Browse Books</title>
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

<!-- Browse Books Section -->
<main>
    <div class="container">
        <div class="section-header">
            <h2>Browse Books</h2>
            <p>Explore our collection of books and find your next favorite read</p>
        </div>
        
        <!-- Search and Sort Section -->
        <div class="search-sort-container" style="background-color: white; border-radius: var(--border-radius-lg); padding: var(--spacing-lg); margin-bottom: var(--spacing-xl); box-shadow: var(--shadow-md);">
            <div class="row" style="display: flex; align-items: center; gap: var(--spacing-lg);">
                <!-- Search Bar -->
                <div class="search-container" style="flex: 1;">
                    <form action="${pageContext.request.contextPath}/books" method="get" class="search-form" style="display: flex; gap: var(--spacing-sm);">
                        <input type="hidden" name="action" value="search">
                        <div class="form-group" style="flex: 1; margin-bottom: 0;">
                            <input type="text" name="query" class="form-control" placeholder="Search by title or author..." value="${param.query}">
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </form>
                </div>
                
                <!-- Sort Options -->
                <div class="sort-container" style="min-width: 200px;">
                    <form action="${pageContext.request.contextPath}/books" method="get">
                        <input type="hidden" name="action" value="sort">
                        <div class="form-group" style="margin-bottom: 0; display: flex; align-items: center; gap: var(--spacing-sm);">
                            <label for="sortBy" style="white-space: nowrap;">Sort by:</label>
                            <select name="sortBy" id="sortBy" class="form-control" onchange="this.form.submit()">
                                <option value="title" ${param.sortBy == 'title' ? 'selected' : ''}>Title</option>
                                <option value="author" ${param.sortBy == 'author' ? 'selected' : ''}>Author</option>
                                <option value="price" ${param.sortBy == 'price' ? 'selected' : ''}>Price</option>
                                <option value="rating" ${param.sortBy == 'rating' ? 'selected' : ''}>Rating</option>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Books Grid -->
        <div class="books-grid">
            <c:choose>
                <c:when test="${empty books}">
                    <div class="no-results" style="text-align: center; padding: var(--spacing-2xl); background-color: white; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md);">
                        <i class="fas fa-book fa-3x" style="color: var(--gray-400); margin-bottom: var(--spacing-md);"></i>
                        <h3 style="margin-bottom: var(--spacing-sm);">No books found</h3>
                        <p style="color: var(--gray-600);">We couldn't find any books matching your search criteria.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="book" items="${books}">
                        <div class="book-card">
                            <img src="${pageContext.request.contextPath}/bookphotos/${book.photo}" 
                                 alt="${book.title}" 
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/default-book.jpg'">
                            <div class="book-card-content">
                                <h3>${book.title}</h3>
                                <p class="author">${book.author}</p>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                    <span>${book.rating}</span>
                                </div>
                                <p class="price">LKR ${book.price}</p>
                                <div class="book-card-buttons" style="display: flex; justify-content: center;">
                                    <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-primary" style="width: 100%;">
                                        <i class="fas fa-eye"></i> View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
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
function addToCart(bookId) {
    fetch('${pageContext.request.contextPath}/CartServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=add&bookId=' + bookId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update cart count
            const cartCountElement = document.getElementById('cartCount');
            if (cartCountElement) {
                cartCountElement.textContent = data.cartCount;
            }
            
            // Show success message
            alert('Book added to cart successfully!');
        } else {
            alert('Failed to add book to cart: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while adding the book to cart.');
    });
}

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