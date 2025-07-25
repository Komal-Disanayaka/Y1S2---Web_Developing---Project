<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="30">
    <title>Order Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Admin-specific styles for the order details view */
        .order-details-container {
            padding: 20px;
        }
        .order-header {
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        .order-items {
            margin-bottom: 20px;
        }
        .order-summary {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
        }
        .action-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }
        .btn-home {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-home:hover {
            background-color: #45a049;
            color: white;
        }
    </style>
</head>
<body>
    <div class="order-details-container">
        <div class="order-header">
            <h2>Order Details</h2>
            <p><strong>Order Number:</strong> ${order.orderNumber}</p>
            <p><strong>Date:</strong> <fmt:formatDate value="${order.date}" pattern="MMM dd, yyyy HH:mm" /></p>
            <p><strong>Status:</strong> <span class="badge bg-${order.orderStatus == 'Completed' ? 'success' : order.orderStatus == 'Processing' ? 'primary' : order.orderStatus == 'Cancelled' ? 'danger' : 'warning'}">${order.orderStatus}</span></p>
        </div>

        <div class="order-items">
            <h3>Order Items</h3>
            <table class="table table-striped">
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
            </table>
        </div>

        <div class="order-summary">
            <h3>Order Summary</h3>
            <p><strong>Total Items:</strong> ${order.books.size()}</p>
            <p><strong>Total Amount:</strong> LKR ${order.total}</p>
        </div>
        
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/views/index.jsp" class="btn-home">
                <i class="fas fa-home"></i> Back to Home
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 