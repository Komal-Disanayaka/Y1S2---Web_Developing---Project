<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Bookstore - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .admin-card {
            transition: transform 0.2s;
            margin-bottom: 2rem;
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .admin-card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: none;
            padding: 1.5rem;
            border-radius: 15px 15px 0 0 !important;
        }
        .card-header h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-body {
            padding: 1.5rem;
        }
        .btn-admin {
            padding: 0.5rem 1.5rem;
            border-radius: 8px;
        }
        .table {
            margin-bottom: 0;
        }
        .table th {
            border-top: none;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<header class="navbar">
    <div class="container">
        <nav style="display: flex; justify-content: space-between; align-items: center;">
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/views/index.jsp" class="logo"><i class="fas fa-feather"></i> Inkspire</a>
            </div>
            <div class="nav-center" style="flex: 1; text-align: center;">
                <h2 style="margin: 0; color: #2c3e50;">Admin Dashboard</h2>
            </div>
            <div class="nav-right" style="display: flex; gap: 1rem; justify-content: flex-end;">
                <a href="${pageContext.request.contextPath}/views/index.jsp" class="btn"><i class="fas fa-home"></i> Home</a>
                <a href="${pageContext.request.contextPath}/views/myaccount.jsp" class="btn"><i class="fas fa-user"></i> My Account</a>
                <form action="${pageContext.request.contextPath}/UserServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>
        </nav>
    </div>
</header>

<div class="container mt-4">
    <div class="row">
        <!-- Add New Book Card -->
        <div class="col-md-4">
            <div class="card admin-card">
                <div class="card-header">
                    <h3><i class="fas fa-plus-circle text-success"></i> Add New Book</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="addBook">
                        <div class="form-group mb-3">
                            <label for="title"><i class="fas fa-book"></i> Title:</label>
                            <input type="text" id="title" name="title" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="isbn"><i class="fas fa-barcode"></i> ISBN:</label>
                            <input type="text" id="isbn" name="isbn" class="form-control" pattern="[0-9]{13}" title="Please enter a valid 13-digit ISBN number" required>
                            <small class="form-text text-muted">Enter a 13-digit ISBN number</small>
                        </div>
                        <div class="form-group mb-3">
                            <label for="author"><i class="fas fa-user-edit"></i> Author:</label>
                            <input type="text" id="author" name="author" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="price"><i class="fas fa-tag"></i> Price:</label>
                            <input type="number" id="price" name="price" class="form-control" step="0.01" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="rating"><i class="fas fa-star"></i> Rating:</label>
                            <input type="number" id="rating" name="rating" class="form-control" step="0.1" min="0" max="5" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="description"><i class="fas fa-align-left"></i> Description:</label>
                            <textarea id="description" name="description" class="form-control" rows="4" required></textarea>
                        </div>
                        <div class="form-group mb-3">
                            <label for="photo"><i class="fas fa-image"></i> Book Photo:</label>
                            <input type="file" id="photo" name="photo" class="form-control" accept="image/*" required>
                            <small class="form-text text-muted">Supported formats: JPG, PNG, GIF (Max size: 5MB)</small>
                        </div>
                        <button type="submit" class="btn btn-success btn-admin w-100">
                            <i class="fas fa-plus-circle"></i> Add Book
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Book List Card -->
        <div class="col-md-4">
            <div class="card admin-card">
                <div class="card-header">
                    <h3><i class="fas fa-books text-primary"></i> Book List</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <c:if test="${not empty books}">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Price</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="book" items="${books}">
                                    <tr>
                                        <td>${book.title}</td>
                                        <td>LKR ${book.price}</td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" onclick="editBookFromData(this)"
                                                    data-book-id="${book.id}"
                                                    data-book-title="${book.title}"
                                                    data-book-author="${book.author}"
                                                    data-book-price="${book.price}"
                                                    data-book-rating="${book.rating}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="deleteBook">
                                                <input type="hidden" name="bookId" value="${book.id}">
                                                <button type="submit" class="btn btn-sm btn-danger">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <c:if test="${empty books}">
                            <div class="text-center py-4">
                                <i class="fas fa-books fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No books available</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Management Card -->
        <div class="col-md-4">
            <div class="card admin-card">
                <div class="card-header">
                    <h3><i class="fas fa-shopping-cart text-warning"></i> Order Management</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <c:if test="${not empty orders}">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Order #</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>${order.orderNumber}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" class="status-form">
                                                <input type="hidden" name="action" value="updateOrderStatus">
                                                <input type="hidden" name="orderNumber" value="${order.orderNumber}">
                                                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                                    <option value="Pending" <c:if test="${order.orderStatus == 'Pending'}">selected</c:if>>Pending</option>
                                                    <option value="Processing" <c:if test="${order.orderStatus == 'Processing'}">selected</c:if>>Processing</option>
                                                    <option value="Completed" <c:if test="${order.orderStatus == 'Completed'}">selected</c:if>>Completed</option>
                                                    <option value="Cancelled" <c:if test="${order.orderStatus == 'Cancelled'}">selected</c:if>>Cancelled</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-info" onclick="viewOrderDetails('${order.orderNumber}')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="deleteOrder">
                                                <input type="hidden" name="orderNumber" value="${order.orderNumber}">
                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <c:if test="${empty orders}">
                            <div class="text-center py-4">
                                <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No orders available</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- User Management Section -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card admin-card">
                <div class="card-header">
                    <h3><i class="fas fa-users text-info"></i> User Management</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <c:if test="${not empty users}">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <span class="badge ${user.admin ? 'bg-danger' : 'bg-primary'}">
                                                    ${user.admin ? 'Admin' : 'User'}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${!user.admin}">
                                                    <form action="${pageContext.request.contextPath}/AdminServlet" method="get" style="display: inline;">
                                                        <input type="hidden" name="action" value="deleteUser">
                                                        <input type="hidden" name="userId" value="${user.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this user?')">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <c:if test="${empty users}">
                            <div class="text-center py-4">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No users available</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Book Modal -->
<div class="modal fade" id="editBookModal" tabindex="-1" aria-labelledby="editBookModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editBookModalLabel">Edit Book</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="editBook">
                    <input type="hidden" name="id" id="editBookId">
                    <div class="form-group mb-3">
                        <label for="editTitle">Title:</label>
                        <input type="text" id="editTitle" name="title" class="form-control" required>
                    </div>
                    <div class="form-group mb-3">
                        <label for="editAuthor">Author:</label>
                        <input type="text" id="editAuthor" name="author" class="form-control" required>
                    </div>
                    <div class="form-group mb-3">
                        <label for="editPrice">Price:</label>
                        <input type="number" id="editPrice" name="price" class="form-control" step="0.01" required>
                    </div>
                    <div class="form-group mb-3">
                        <label for="editRating">Rating:</label>
                        <input type="number" id="editRating" name="rating" class="form-control" step="0.1" min="0" max="5" required>
                    </div>
                    <div class="form-group mb-3">
                        <label for="editDescription">Description:</label>
                        <textarea id="editDescription" name="description" class="form-control" rows="4" required></textarea>
                    </div>
                    <div class="form-group mb-3">
                        <label for="editPhoto">Book Photo:</label>
                        <input type="file" id="editPhoto" name="photo" class="form-control" accept="image/*">
                        <small class="form-text text-muted">Leave empty to keep the current photo</small>
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Order Details Modal -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="orderDetailsContent">
                <!-- Order details will be loaded here -->
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editBookFromData(button) {
        const id = button.getAttribute('data-book-id');
        const title = button.getAttribute('data-book-title');
        const author = button.getAttribute('data-book-author');
        const price = button.getAttribute('data-book-price');
        const rating = button.getAttribute('data-book-rating');

        document.getElementById('editBookId').value = id;
        document.getElementById('editTitle').value = title;
        document.getElementById('editAuthor').value = author;
        document.getElementById('editPrice').value = price;
        document.getElementById('editRating').value = rating;

        var editModal = new bootstrap.Modal(document.getElementById('editBookModal'));
        editModal.show();
    }

    function editBook(id, title, author, price, rating) {
        document.getElementById('editBookId').value = id;
        document.getElementById('editTitle').value = title;
        document.getElementById('editAuthor').value = author;
        document.getElementById('editPrice').value = price;
        document.getElementById('editRating').value = rating;

        var editModal = new bootstrap.Modal(document.getElementById('editBookModal'));
        editModal.show();
    }

    function viewOrderDetails(orderNumber) {
        // Fetch order details via AJAX
        fetch('${pageContext.request.contextPath}/AdminServlet?action=getOrderDetails&orderNumber=' + orderNumber)
            .then(response => response.text())
            .then(html => {
                // Create a temporary container to parse the HTML
                const tempContainer = document.createElement('div');
                tempContainer.innerHTML = html;

                // Remove the navigation bar
                const navbar = tempContainer.querySelector('.navbar');
                if (navbar) {
                    navbar.remove();
                }

                // Remove the My Orders button
                const myOrdersBtn = tempContainer.querySelector('a[href*="OrderServlet"]');
                if (myOrdersBtn) {
                    myOrdersBtn.remove();
                }

                // Remove the Browse Books button
                const browseBooksBtn = tempContainer.querySelector('a[href*="books"]');
                if (browseBooksBtn) {
                    browseBooksBtn.remove();
                }

                // Update the modal content with the cleaned HTML
                document.getElementById('orderDetailsContent').innerHTML = tempContainer.innerHTML;

                // Show the modal
                var orderModal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
                orderModal.show();
            })
            .catch(error => {
                console.error('Error fetching order details:', error);
                alert('Failed to load order details. Please try again.');
            });
    }
</script>
</body>
</html>